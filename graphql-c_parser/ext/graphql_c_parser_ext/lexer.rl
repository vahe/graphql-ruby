%%{
  machine graphql_c_lexer;

  IDENTIFIER =    [_A-Za-z][_0-9A-Za-z]*;
  NEWLINE =       [\c\r\n];
  BLANK   =       [, \t]+;
  COMMENT =       '#' [^\n\r]*;
  INT =           '-'? ('0'|[1-9][0-9]*);
  EXPONENT =      ('e' | 'E') ('+' | '-')? [0-9]+;
  FLOAT =         INT ('.'[0-9]+ EXPONENT? | EXPONENT);
  ON =            'on';
  FRAGMENT =      'fragment';
  TRUE_LITERAL =  'true';
  FALSE_LITERAL = 'false';
  NULL_LITERAL =  'null';
  QUERY =         'query';
  MUTATION =      'mutation';
  SUBSCRIPTION =  'subscription';
  SCHEMA =        'schema';
  SCALAR =        'scalar';
  TYPE_LITERAL =  'type';
  EXTEND =        'extend';
  IMPLEMENTS =    'implements';
  INTERFACE =     'interface';
  UNION =         'union';
  ENUM =          'enum';
  INPUT =         'input';
  DIRECTIVE =     'directive';
  REPEATABLE =    'repeatable';
  LCURLY =        '{';
  RCURLY =        '}';
  LPAREN =        '(';
  RPAREN =        ')';
  LBRACKET =      '[';
  RBRACKET =      ']';
  COLON =         ':';
  # Could limit to hex here, but “bad unicode escape” on 0XXF is probably a
  # more helpful error than “unknown char”
  UNICODE_ESCAPE = "\\u" ([0-9A-Za-z]{4} | LCURLY [0-9A-Za-z]+ RCURLY);
  VAR_SIGN =      '$';
  DIR_SIGN =      '@';
  ELLIPSIS =      '...';
  EQUALS =        '=';
  BANG =          '!';
  PIPE =          '|';
  AMP =           '&';

  QUOTED_STRING = ('"' ((('\\"' | ^'"') - "\\" - "\n" - "\r") | UNICODE_ESCAPE | '\\' [\\/bfnrt])* '"');
  # catch-all for anything else. must be at the bottom for precedence.
  UNKNOWN_CHAR =         /./;

  BLOCK_STRING = ('"""' ('\\"""' | ^'"' | '"'{1,2} ^'"')* '"'{0,2} '"""');

  main := |*
    INT           => { emit(INT, ts, te, meta); };
    FLOAT         => { emit(FLOAT, ts, te, meta); };
    ON            => { emit(ON, ts, te, meta); };
    FRAGMENT      => { emit(FRAGMENT, ts, te, meta); };
    TRUE_LITERAL  => { emit(TRUE_LITERAL, ts, te, meta); };
    FALSE_LITERAL => { emit(FALSE_LITERAL, ts, te, meta); };
    NULL_LITERAL  => { emit(NULL_LITERAL, ts, te, meta); };
    QUERY         => { emit(QUERY, ts, te, meta); };
    MUTATION      => { emit(MUTATION, ts, te, meta); };
    SUBSCRIPTION  => { emit(SUBSCRIPTION, ts, te, meta); };
    SCHEMA        => { emit(SCHEMA, ts, te, meta); };
    SCALAR        => { emit(SCALAR, ts, te, meta); };
    TYPE_LITERAL  => { emit(TYPE_LITERAL, ts, te, meta); };
    EXTEND        => { emit(EXTEND, ts, te, meta); };
    IMPLEMENTS    => { emit(IMPLEMENTS, ts, te, meta); };
    INTERFACE     => { emit(INTERFACE, ts, te, meta); };
    UNION         => { emit(UNION, ts, te, meta); };
    ENUM          => { emit(ENUM, ts, te, meta); };
    INPUT         => { emit(INPUT, ts, te, meta); };
    DIRECTIVE     => { emit(DIRECTIVE, ts, te, meta); };
    REPEATABLE    => { emit(REPEATABLE, ts, te, meta); };
    RCURLY        => { emit(RCURLY, ts, te, meta); };
    LCURLY        => { emit(LCURLY, ts, te, meta); };
    RPAREN        => { emit(RPAREN, ts, te, meta); };
    LPAREN        => { emit(LPAREN, ts, te, meta); };
    RBRACKET      => { emit(RBRACKET, ts, te, meta); };
    LBRACKET      => { emit(LBRACKET, ts, te, meta); };
    COLON         => { emit(COLON, ts, te, meta); };
    BLOCK_STRING  => { emit(BLOCK_STRING, ts, te, meta); };
    QUOTED_STRING => { emit(QUOTED_STRING, ts, te, meta); };
    VAR_SIGN      => { emit(VAR_SIGN, ts, te, meta); };
    DIR_SIGN      => { emit(DIR_SIGN, ts, te, meta); };
    ELLIPSIS      => { emit(ELLIPSIS, ts, te, meta); };
    EQUALS        => { emit(EQUALS, ts, te, meta); };
    BANG          => { emit(BANG, ts, te, meta); };
    PIPE          => { emit(PIPE, ts, te, meta); };
    AMP           => { emit(AMP, ts, te, meta); };
    IDENTIFIER    => { emit(IDENTIFIER, ts, te, meta); };
    COMMENT       => { emit(COMMENT, ts, te, meta); };
    NEWLINE => {
      meta->line += 1;
      meta->col = 1;
      meta->preceeded_by_number = 0;
    };

    BLANK   => {
      meta->col += te - ts;
      meta->preceeded_by_number = 0;
    };

    UNKNOWN_CHAR => { emit(UNKNOWN_CHAR, ts, te, meta); };
  *|;
}%%

%% write data;

#include <ruby.h>
#include <ruby/encoding.h>

#define INIT_STATIC_TOKEN_VARIABLE(token_name) \
  static VALUE GraphQLTokenString##token_name;

INIT_STATIC_TOKEN_VARIABLE(ON)
INIT_STATIC_TOKEN_VARIABLE(FRAGMENT)
INIT_STATIC_TOKEN_VARIABLE(QUERY)
INIT_STATIC_TOKEN_VARIABLE(MUTATION)
INIT_STATIC_TOKEN_VARIABLE(SUBSCRIPTION)
INIT_STATIC_TOKEN_VARIABLE(REPEATABLE)
INIT_STATIC_TOKEN_VARIABLE(RCURLY)
INIT_STATIC_TOKEN_VARIABLE(LCURLY)
INIT_STATIC_TOKEN_VARIABLE(RBRACKET)
INIT_STATIC_TOKEN_VARIABLE(LBRACKET)
INIT_STATIC_TOKEN_VARIABLE(RPAREN)
INIT_STATIC_TOKEN_VARIABLE(LPAREN)
INIT_STATIC_TOKEN_VARIABLE(COLON)
INIT_STATIC_TOKEN_VARIABLE(VAR_SIGN)
INIT_STATIC_TOKEN_VARIABLE(DIR_SIGN)
INIT_STATIC_TOKEN_VARIABLE(ELLIPSIS)
INIT_STATIC_TOKEN_VARIABLE(EQUALS)
INIT_STATIC_TOKEN_VARIABLE(BANG)
INIT_STATIC_TOKEN_VARIABLE(PIPE)
INIT_STATIC_TOKEN_VARIABLE(AMP)
INIT_STATIC_TOKEN_VARIABLE(SCHEMA)
INIT_STATIC_TOKEN_VARIABLE(SCALAR)
INIT_STATIC_TOKEN_VARIABLE(EXTEND)
INIT_STATIC_TOKEN_VARIABLE(IMPLEMENTS)
INIT_STATIC_TOKEN_VARIABLE(INTERFACE)
INIT_STATIC_TOKEN_VARIABLE(UNION)
INIT_STATIC_TOKEN_VARIABLE(ENUM)
INIT_STATIC_TOKEN_VARIABLE(DIRECTIVE)
INIT_STATIC_TOKEN_VARIABLE(INPUT)

static VALUE GraphQL_type_str;
static VALUE GraphQL_true_str;
static VALUE GraphQL_false_str;
static VALUE GraphQL_null_str;
typedef enum TokenType {
  AMP,
  BANG,
  COLON,
  DIRECTIVE,
  DIR_SIGN,
  ENUM,
  ELLIPSIS,
  EQUALS,
  EXTEND,
  FALSE_LITERAL,
  FLOAT,
  FRAGMENT,
  IDENTIFIER,
  INPUT,
  IMPLEMENTS,
  INT,
  INTERFACE,
  LBRACKET,
  LCURLY,
  LPAREN,
  MUTATION,
  NULL_LITERAL,
  ON,
  PIPE,
  QUERY,
  RBRACKET,
  RCURLY,
  REPEATABLE,
  RPAREN,
  SCALAR,
  SCHEMA,
  STRING,
  SUBSCRIPTION,
  TRUE_LITERAL,
  TYPE_LITERAL,
  UNION,
  VAR_SIGN,
  BLOCK_STRING,
  QUOTED_STRING,
  UNKNOWN_CHAR,
  COMMENT,
  BAD_UNICODE_ESCAPE
} TokenType;

typedef struct Meta {
  int line;
  int col;
  char *query_cstr;
  char *pe;
  VALUE tokens;
  int dedup_identifiers;
  int reject_numbers_followed_by_names;
  int preceeded_by_number;
  int max_tokens;
  int tokens_count;
} Meta;

#define STATIC_VALUE_TOKEN(token_type, content_str) \
  case token_type: \
  token_sym = ID2SYM(rb_intern(#token_type)); \
  token_content = GraphQLTokenString##token_type; \
  break;

#define DYNAMIC_VALUE_TOKEN(token_type) \
  case token_type: \
  token_sym = ID2SYM(rb_intern(#token_type)); \
  token_content = rb_utf8_str_new(ts, te - ts); \
  break;


#define GQL_BLOCK_STRING_STACK_LINES 64

// Matches Ruby's /\s/: space, \t, \n, \v, \f, \r
static int gql_has_non_whitespace(const char *p, long len) {
  long i;
  for (i = 0; i < len; i++) {
    unsigned char b = (unsigned char)p[i];
    if (b != ' ' && (b < '\t' || b > '\r')) {
      return 1;
    }
  }
  return 0;
}

// C port of GraphQL::Language::BlockString.trim_whitespace. It reads the raw
// bytes between the triple quotes once, recording line starts, and then
// copies the kept lines into an exactly-sized string. It also returns the raw
// newline count, which the lexer needs for the line numbers of later tokens.
static VALUE gql_trim_block_string(const char *str, long len, int *newlines) {
  long stack_starts[GQL_BLOCK_STRING_STACK_LINES];
  long *starts = stack_starts;
  long capacity = GQL_BLOCK_STRING_STACK_LINES;
  volatile VALUE heap_starts = 0;
  const char *endp = str + len;
  const char *p = str;
  long count = 0;
  long common_indent = -1;
  long first_kept = -1;
  long last_kept = -1;
  long i;

  while (1) {
    const char *nl = p < endp ? memchr(p, '\n', endp - p) : NULL;
    long line_len = (nl ? nl : endp) - p;
    long indent = 0;

    if (count == capacity) {
      volatile VALUE grown_store = 0;
      long *grown = rb_alloc_tmp_buffer2(&grown_store, capacity * 2, sizeof(long));
      memcpy(grown, starts, capacity * sizeof(long));
      if (heap_starts) rb_free_tmp_buffer(&heap_starts);
      heap_starts = grown_store;
      starts = grown;
      capacity *= 2;
    }
    starts[count] = p - str;

    while (indent < line_len && p[indent] == ' ') indent++;
    if (indent < line_len) {
      // Like Ruby, the first line never sets the common indent, and lines
      // with only spaces don't either (but "  \t" does).
      if (count > 0 && (common_indent < 0 || indent < common_indent)) {
        common_indent = indent;
      }
      if (gql_has_non_whitespace(p + indent, line_len - indent)) {
        if (first_kept < 0) first_kept = count;
        last_kept = count;
      }
    }
    count++;
    if (!nl) break;
    p = nl + 1;
  }
  *newlines = (int)(count - 1);

  // Ruby's early return: a single line without a leading space is kept as-is,
  // even when it is only whitespace (e.g. "\t").
  if (count == 1 && (len == 0 || str[0] != ' ')) {
    if (heap_starts) rb_free_tmp_buffer(&heap_starts);
    return rb_utf8_str_new(str, len);
  }
  if (first_kept < 0) {
    if (heap_starts) rb_free_tmp_buffer(&heap_starts);
    return rb_utf8_str_new("", 0);
  }

  #define GQL_LINE_LEN(idx) (((idx) + 1 < count ? starts[(idx) + 1] - 1 : len) - starts[idx])
  VALUE result;
  if (common_indent <= 0 || last_kept == 0) {
    // Nothing to strip: the kept lines are one contiguous span of the source.
    long span_start = starts[first_kept];
    long span_end = starts[last_kept] + GQL_LINE_LEN(last_kept);
    result = rb_utf8_str_new(str + span_start, span_end - span_start);
  } else {
    // Lines shorter than the common indent are only spaces; strip all of them.
    long out_len = last_kept - first_kept; // joining newlines
    for (i = first_kept; i <= last_kept; i++) {
      long line_len = GQL_LINE_LEN(i);
      long strip = i == 0 ? 0 : (common_indent < line_len ? common_indent : line_len);
      out_len += line_len - strip;
    }
    result = rb_utf8_str_new(NULL, out_len);
    char *dst = RSTRING_PTR(result);
    for (i = first_kept; i <= last_kept; i++) {
      long line_len = GQL_LINE_LEN(i);
      long strip = i == 0 ? 0 : (common_indent < line_len ? common_indent : line_len);
      if (i > first_kept) *dst++ = '\n';
      memcpy(dst, str + starts[i] + strip, line_len - strip);
      dst += line_len - strip;
    }
  }
  #undef GQL_LINE_LEN
  if (heap_starts) rb_free_tmp_buffer(&heap_starts);
  return result;
}

void emit(TokenType tt, char *ts, char *te, Meta *meta) {
  meta->tokens_count++;
  // -1 indicates that there is no limit:
  if (meta->max_tokens > 0 && meta->tokens_count > meta->max_tokens) {
    VALUE mGraphQL = rb_const_get_at(rb_cObject, rb_intern("GraphQL"));
    VALUE cParseError = rb_const_get_at(mGraphQL, rb_intern("ParseError"));
    VALUE exception = rb_funcall(
      cParseError, rb_intern("new"), 4,
      rb_str_new_cstr("This query is too large to execute."),
      LONG2NUM(meta->line),
      LONG2NUM(meta->col),
      rb_str_new_cstr(meta->query_cstr)
    );
    rb_exc_raise(exception);
  }
  int quotes_length = 0; // set by string tokens below
  int line_incr = 0;
  VALUE token_sym = Qnil;
  VALUE token_content = Qnil;
  int this_token_is_number = 0;
  switch(tt) {
    STATIC_VALUE_TOKEN(ON, "on")
    STATIC_VALUE_TOKEN(FRAGMENT, "fragment")
    STATIC_VALUE_TOKEN(QUERY, "query")
    STATIC_VALUE_TOKEN(MUTATION, "mutation")
    STATIC_VALUE_TOKEN(SUBSCRIPTION, "subscription")
    STATIC_VALUE_TOKEN(REPEATABLE, "repeatable")
    STATIC_VALUE_TOKEN(RCURLY, "}")
    STATIC_VALUE_TOKEN(LCURLY, "{")
    STATIC_VALUE_TOKEN(RBRACKET, "]")
    STATIC_VALUE_TOKEN(LBRACKET, "[")
    STATIC_VALUE_TOKEN(RPAREN, ")")
    STATIC_VALUE_TOKEN(LPAREN, "(")
    STATIC_VALUE_TOKEN(COLON, ":")
    STATIC_VALUE_TOKEN(VAR_SIGN, "$")
    STATIC_VALUE_TOKEN(DIR_SIGN, "@")
    STATIC_VALUE_TOKEN(ELLIPSIS, "...")
    STATIC_VALUE_TOKEN(EQUALS, "=")
    STATIC_VALUE_TOKEN(BANG, "!")
    STATIC_VALUE_TOKEN(PIPE, "|")
    STATIC_VALUE_TOKEN(AMP, "&")
    STATIC_VALUE_TOKEN(SCHEMA, "schema")
    STATIC_VALUE_TOKEN(SCALAR, "scalar")
    STATIC_VALUE_TOKEN(EXTEND, "extend")
    STATIC_VALUE_TOKEN(IMPLEMENTS, "implements")
    STATIC_VALUE_TOKEN(INTERFACE, "interface")
    STATIC_VALUE_TOKEN(UNION, "union")
    STATIC_VALUE_TOKEN(ENUM, "enum")
    STATIC_VALUE_TOKEN(DIRECTIVE, "directive")
    STATIC_VALUE_TOKEN(INPUT, "input")
    // For these, the enum name doesn't match the symbol name:
    case TYPE_LITERAL:
      token_sym = ID2SYM(rb_intern("TYPE"));
      token_content = GraphQL_type_str;
      break;
    case TRUE_LITERAL:
      token_sym = ID2SYM(rb_intern("TRUE"));
      token_content = GraphQL_true_str;
      break;
    case FALSE_LITERAL:
      token_sym = ID2SYM(rb_intern("FALSE"));
      token_content = GraphQL_false_str;
      break;
    case NULL_LITERAL:
      token_sym = ID2SYM(rb_intern("NULL"));
      token_content = GraphQL_null_str;
      break;
    case IDENTIFIER:
      if (meta->reject_numbers_followed_by_names && meta->preceeded_by_number) {
        VALUE mGraphQL = rb_const_get_at(rb_cObject, rb_intern("GraphQL"));
        VALUE mCParser = rb_const_get_at(mGraphQL, rb_intern("CParser"));
        VALUE prev_token = rb_ary_entry(meta->tokens, -1);
        VALUE exception = rb_funcall(
            mCParser, rb_intern("prepare_number_name_parse_error"), 5,
            LONG2NUM(meta->line),
            LONG2NUM(meta->col),
            rb_str_new_cstr(meta->query_cstr),
            rb_ary_entry(prev_token, 3),
            rb_utf8_str_new(ts, te - ts)
        );
        rb_exc_raise(exception);
      }
      token_sym = ID2SYM(rb_intern("IDENTIFIER"));
      if (meta->dedup_identifiers) {
        token_content = rb_enc_interned_str(ts, te - ts, rb_utf8_encoding());
      } else {
        token_content = rb_utf8_str_new(ts, te - ts);
      }
      break;
    // Can't use these while we're in backwards-compat mode:
    // DYNAMIC_VALUE_TOKEN(INT)
    // DYNAMIC_VALUE_TOKEN(FLOAT)
    case INT:
      token_sym = ID2SYM(rb_intern("INT"));
      token_content = rb_utf8_str_new(ts, te - ts);
      this_token_is_number = 1;
      break;
    case FLOAT:
      token_sym = ID2SYM(rb_intern("FLOAT"));
      token_content = rb_utf8_str_new(ts, te - ts);
      this_token_is_number = 1;
      break;
    DYNAMIC_VALUE_TOKEN(COMMENT)
    case UNKNOWN_CHAR:
      if (ts[0] == '\0') {
        return;
      } else {
        token_content = rb_utf8_str_new(ts, te - ts);
        token_sym = ID2SYM(rb_intern("UNKNOWN_CHAR"));
        break;
      }
    case QUOTED_STRING:
      quotes_length = 1;
      token_content = rb_utf8_str_new(ts + quotes_length, (te - ts - (2 * quotes_length)));
      token_sym = ID2SYM(rb_intern("STRING"));
      break;
    case BLOCK_STRING:
      token_sym = ID2SYM(rb_intern("STRING"));
      quotes_length = 3;
      token_content = gql_trim_block_string(ts + quotes_length, (te - ts - (2 * quotes_length)), &line_incr);
      break;
    // These are used only by the parser, this is never reached
    case STRING:
    case BAD_UNICODE_ESCAPE:
      break;
  }

  if (token_sym != Qnil) {
    if (tt == BLOCK_STRING) {
      // content was already trimmed in C (gql_trim_block_string)
      tt = STRING;
    } else if (tt == QUOTED_STRING) {
      VALUE mGraphQL = rb_const_get_at(rb_cObject, rb_intern("GraphQL"));
      VALUE mGraphQLLanguage = rb_const_get_at(mGraphQL, rb_intern("Language"));
      VALUE mGraphQLLanguageLexer = rb_const_get_at(mGraphQLLanguage, rb_intern("Lexer"));
      VALUE valid_string_pattern = rb_const_get_at(mGraphQLLanguageLexer, rb_intern("VALID_STRING"));
      tt = STRING;
      if (
        RB_TEST(rb_funcall(token_content, rb_intern("valid_encoding?"), 0)) &&
          RB_TEST(rb_funcall(token_content, rb_intern("match?"), 1, valid_string_pattern))
      ) {
        rb_funcall(mGraphQLLanguageLexer, rb_intern("replace_escaped_characters_in_place"), 1, token_content);
        if (!RB_TEST(rb_funcall(token_content, rb_intern("valid_encoding?"), 0))) {
          token_sym = ID2SYM(rb_intern("BAD_UNICODE_ESCAPE"));
          tt = BAD_UNICODE_ESCAPE;
        }
      } else {
        token_sym = ID2SYM(rb_intern("BAD_UNICODE_ESCAPE"));
        tt = BAD_UNICODE_ESCAPE;
      }
    }

    VALUE token = rb_ary_new_from_args(5,
      token_sym,
      rb_int2inum(meta->line),
      rb_int2inum(meta->col),
      token_content,
      INT2FIX(200 + (int)tt)
    );

    if (tt != COMMENT) {
      rb_ary_push(meta->tokens, token);
    }
    meta->preceeded_by_number = this_token_is_number;
  }
  // Bump the column counter for the next token
  meta->col += te - ts;
  meta->line += line_incr;
}

VALUE tokenize(VALUE query_rbstr, int fstring_identifiers, int reject_numbers_followed_by_names, int max_tokens) {
  int cs = 0;
  int act = 0;
  char *p = StringValuePtr(query_rbstr);
  long query_len = RSTRING_LEN(query_rbstr);
  char *pe = p + query_len;
  char *eof = pe;
  char *ts = 0;
  char *te = 0;
  VALUE tokens = rb_ary_new();
  struct Meta meta_s = {1, 1, p, pe, tokens, fstring_identifiers, reject_numbers_followed_by_names, 0, max_tokens, 0};
  Meta *meta = &meta_s;

  %% write init;
  %% write exec;

  return tokens;
}


#define SETUP_STATIC_TOKEN_VARIABLE(token_name, token_content) \
  GraphQLTokenString##token_name = rb_utf8_str_new_cstr(token_content); \
  rb_funcall(GraphQLTokenString##token_name, rb_intern("-@"), 0); \
  rb_global_variable(&GraphQLTokenString##token_name); \

#define SETUP_STATIC_STRING(var_name, str_content) \
  var_name = rb_utf8_str_new_cstr(str_content); \
  rb_global_variable(&var_name); \
  rb_str_freeze(var_name); \

void setup_static_token_variables(void) {
  SETUP_STATIC_TOKEN_VARIABLE(ON, "on")
  SETUP_STATIC_TOKEN_VARIABLE(FRAGMENT, "fragment")
  SETUP_STATIC_TOKEN_VARIABLE(QUERY, "query")
  SETUP_STATIC_TOKEN_VARIABLE(MUTATION, "mutation")
  SETUP_STATIC_TOKEN_VARIABLE(SUBSCRIPTION, "subscription")
  SETUP_STATIC_TOKEN_VARIABLE(REPEATABLE, "repeatable")
  SETUP_STATIC_TOKEN_VARIABLE(RCURLY, "}")
  SETUP_STATIC_TOKEN_VARIABLE(LCURLY, "{")
  SETUP_STATIC_TOKEN_VARIABLE(RBRACKET, "]")
  SETUP_STATIC_TOKEN_VARIABLE(LBRACKET, "[")
  SETUP_STATIC_TOKEN_VARIABLE(RPAREN, ")")
  SETUP_STATIC_TOKEN_VARIABLE(LPAREN, "(")
  SETUP_STATIC_TOKEN_VARIABLE(COLON, ":")
  SETUP_STATIC_TOKEN_VARIABLE(VAR_SIGN, "$")
  SETUP_STATIC_TOKEN_VARIABLE(DIR_SIGN, "@")
  SETUP_STATIC_TOKEN_VARIABLE(ELLIPSIS, "...")
  SETUP_STATIC_TOKEN_VARIABLE(EQUALS, "=")
  SETUP_STATIC_TOKEN_VARIABLE(BANG, "!")
  SETUP_STATIC_TOKEN_VARIABLE(PIPE, "|")
  SETUP_STATIC_TOKEN_VARIABLE(AMP, "&")
  SETUP_STATIC_TOKEN_VARIABLE(SCHEMA, "schema")
  SETUP_STATIC_TOKEN_VARIABLE(SCALAR, "scalar")
  SETUP_STATIC_TOKEN_VARIABLE(EXTEND, "extend")
  SETUP_STATIC_TOKEN_VARIABLE(IMPLEMENTS, "implements")
  SETUP_STATIC_TOKEN_VARIABLE(INTERFACE, "interface")
  SETUP_STATIC_TOKEN_VARIABLE(UNION, "union")
  SETUP_STATIC_TOKEN_VARIABLE(ENUM, "enum")
  SETUP_STATIC_TOKEN_VARIABLE(DIRECTIVE, "directive")
  SETUP_STATIC_TOKEN_VARIABLE(INPUT, "input")

  SETUP_STATIC_STRING(GraphQL_type_str, "type")
  SETUP_STATIC_STRING(GraphQL_true_str, "true")
  SETUP_STATIC_STRING(GraphQL_false_str, "false")
  SETUP_STATIC_STRING(GraphQL_null_str, "null")
}
