#include "tree_sitter/parser.h"

enum TokenType { CODE_CONTENT, TEXT_CONTENT };

void *tree_sitter_spidercode_external_scanner_create(void) { return NULL; }

void tree_sitter_spidercode_external_scanner_destroy(void *payload) {}

unsigned tree_sitter_spidercode_external_scanner_serialize(void *payload,
                                                           char *buffer) {
  return 0;
}

void tree_sitter_spidercode_external_scanner_deserialize(void *payload,
                                                         const char *buffer,
                                                         unsigned length) {}

// Scan content until we hit a %spidercode% tag at the start of a line
// Returns true if content was found, false otherwise
// Sets result_symbol to the appropriate token type
static bool scan_until_tag(TSLexer *lexer, enum TokenType token_type) {
  bool has_content = false;
  bool at_line_start = true;

  while (!lexer->eof(lexer)) {
    // At start of a line, check if it's a spidercode tag
    if (at_line_start && lexer->lookahead == '%') {
      const char *tag = "%spidercode%";

      // Mark current position as potential end of content
      lexer->mark_end(lexer);

      // Try to match the tag
      bool is_tag = true;
      for (int i = 0; tag[i] != '\0' && is_tag; i++) {
        if (lexer->lookahead != (uint32_t)tag[i]) {
          is_tag = false;
        } else {
          lexer->advance(lexer, false);
        }
      }

      // If we matched the tag, verify nothing else follows on this line
      if (is_tag && (lexer->lookahead == '\n' || lexer->eof(lexer))) {
        // Found tag! Return content accumulated so far
        lexer->result_symbol = token_type;
        return has_content;
      }

      // Not a valid tag - include scanned chars in content
      lexer->mark_end(lexer);
      has_content = true;
      at_line_start = false;

    } else if (lexer->lookahead == '\n') {
      lexer->advance(lexer, false);
      lexer->mark_end(lexer);
      has_content = true;
      at_line_start = true;

    } else {
      lexer->advance(lexer, false);
      lexer->mark_end(lexer);
      has_content = true;
      at_line_start = false;
    }
  }

  // Reached EOF - return what we have
  if (has_content) {
    lexer->result_symbol = token_type;
    return true;
  }

  return false;
}

bool tree_sitter_spidercode_external_scanner_scan(void *payload,
                                                  TSLexer *lexer,
                                                  const bool *valid_symbols) {
  // CODE_CONTENT: inside spidercode block, scan until closing tag
  if (valid_symbols[CODE_CONTENT]) {
    return scan_until_tag(lexer, CODE_CONTENT);
  }

  // TEXT_CONTENT: outside spidercode block, scan until opening tag
  if (valid_symbols[TEXT_CONTENT]) {
    return scan_until_tag(lexer, TEXT_CONTENT);
  }

  return false;
}
