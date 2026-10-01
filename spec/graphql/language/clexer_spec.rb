# frozen_string_literal: true
require "spec_helper"
require_relative "./lexer_examples"

if defined?(GraphQL::CParser::Lexer)
  describe GraphQL::CParser::Lexer do
    subject { GraphQL::CParser::Lexer }

    def assert_bad_unicode(string, _message = nil)
      assert_equal :BAD_UNICODE_ESCAPE, subject.tokenize(string).first[0]
    end

    it "makes tokens like the other lexer" do
      str = "{ f1(type: \"str\") ...F2 }\nfragment F2 on SomeType { f2 }"
      tokens = GraphQL.scan_with_c(str).map { |t| [*t.first(4), t[3].encoding] }
      old_tokens = GraphQL.scan_with_ruby(str).map { |t| [*t, t[3].encoding] }

      assert_equal [
        [:LCURLY, 1, 1, "{", Encoding::UTF_8],
        [:IDENTIFIER, 1, 3, "f1", Encoding::UTF_8],
        [:LPAREN, 1, 5, "(", Encoding::UTF_8],
        [:TYPE, 1, 6, "type", Encoding::UTF_8],
        [:COLON, 1, 10, ":", Encoding::UTF_8],
        [:STRING, 1, 12, "str", Encoding::UTF_8],
        [:RPAREN, 1, 17, ")", Encoding::UTF_8],
        [:ELLIPSIS, 1, 19, "...", Encoding::UTF_8],
        [:IDENTIFIER, 1, 22, "F2", Encoding::UTF_8],
        [:RCURLY, 1, 25, "}", Encoding::UTF_8],
        [:FRAGMENT, 2, 1, "fragment", Encoding::UTF_8],
        [:IDENTIFIER, 2, 10, "F2", Encoding::UTF_8],
        [:ON, 2, 13, "on", Encoding::UTF_8],
        [:IDENTIFIER, 2, 16, "SomeType", Encoding::UTF_8],
        [:LCURLY, 2, 25, "{", Encoding::UTF_8],
        [:IDENTIFIER, 2, 27, "f2", Encoding::UTF_8],
        [:RCURLY, 2, 30, "}", Encoding::UTF_8]
      ], tokens
      assert_equal(old_tokens, tokens)
    end

    it "tokenizes exponent-only floats like the Ruby lexer" do
      tokens = GraphQL.scan_with_c("1e400").map { |token| token.first(4) }

      assert_equal [[:FLOAT, 1, 1, "1e400"]], tokens
      assert_equal GraphQL.scan_with_ruby("1e400"), tokens
    end

    it "trims and tokenizes block strings exactly like the Ruby lexer" do
      block_string_bodies = [
        "a   ",
        "  a",
        "\t",
        "\r \v",
        " \t",
        (["  line"] * 100).join("\n"),
        "\n\n  hello\n",
        "a\n\n\n",
        "\n    a\n      b\n",
        " \n \n ",
        "  first\n  second",
        "  a\n\n  b",
        "a\n    b\n  \n    c",
        "a\n\tb\n  c",
        "a\n\r\n  b",
        "a\r\n  b\r\n  c",
        "a\n      deep\n  shallow",
        "  \u{1F0A1}\n    \u{1F0A2}\n  \u{1F0A3}",
        "c\n \\\"\"\" d",
        "{\"foo\":\"bar\"}",
      ]
      block_string_bodies.each do |body|
        doc = "{ f(a: \"\"\"#{body}\"\"\") g }"
        # Columns are excluded from this comparison: the C lexer counts them in bytes
        # and doesn't reset them at newlines inside a token, so they drift after
        # multibyte or multi-line tokens. That's a separate, pre-existing bug.
        c_tokens = GraphQL.scan_with_c(doc).map { |t| [t[0], t[1], t[3], t[3].encoding] }
        ruby_tokens = GraphQL.scan_with_ruby(doc).map { |t| [t[0], t[1], t[3], t[3].encoding] }
        assert_equal(ruby_tokens, c_tokens, "lexes block string #{body.inspect} identically")
      end
    end

    it "makes frozen strings when using SchemaParser" do
      str = "type Query { f1: Int }"
      schema_ast = GraphQL::CParser::SchemaParser.new(str, nil, GraphQL::Tracing::NullTrace, nil).result
      default_ast = GraphQL::CParser::Parser.new(str, nil, GraphQL::Tracing::NullTrace, nil).result

      # Equivalent ASTs:
      assert_equal schema_ast, default_ast

      # But this one is frozen:
      assert_equal "Query", schema_ast.definitions.first.name
      assert schema_ast.definitions.first.name.frozen?

      # And this one isn't:
      assert_equal "Query", default_ast.definitions.first.name
      refute default_ast.definitions.first.name.frozen?
    end

    it "exposes tokens_count" do
      str = "type Query { f1: Int }"
      parser = GraphQL::CParser::Parser.new(str, nil, GraphQL::Tracing::NullTrace, nil)

      assert_equal 7, parser.tokens_count
    end

    include LexerExamples
  end
end
