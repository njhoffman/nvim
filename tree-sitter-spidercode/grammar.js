/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

/**
 * Tree-sitter grammar for spidercode blocks.
 *
 * Recognizes %spidercode% delimited blocks where:
 * - Opening %spidercode% must be on its own line (column 0, nothing after)
 * - Closing %spidercode% must be on its own line (column 0, nothing after)
 * - Content between markers is captured as raw text for JavaScript injection
 * - Content outside markers is captured as raw text for HTML injection
 */
module.exports = grammar({
  name: "spidercode",

  extras: (_) => [],

  externals: ($) => [$.code_content, $.text_content],

  rules: {
    document: ($) => repeat($._node),

    _node: ($) => choice($.spidercode_block, $.text_content),

    spidercode_block: ($) =>
      seq($.tag_open, optional($.code_content), $.tag_close),

    // Opening tag: %spidercode% at start of line followed by newline
    tag_open: (_) => token(seq("%spidercode%", "\n")),

    // Closing tag: %spidercode% at start of line (may or may not have trailing newline)
    tag_close: (_) => token(seq("%spidercode%", optional("\n"))),

    // text_content is handled by external scanner - captures all content
    // until a %spidercode% tag is found at the start of a line
  },
});
