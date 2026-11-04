// Grammar for free-form log files: each line is a stream of tokens. The rules follow Neovim's
// runtime syntax/log.vim plus the additions from the old nvimpager syntax/log.vim (Lua dump
// references, nerd-font level glyphs, domains). No token has a precedence on purpose: tree-sitter
// checks precedence before length, so one would beat longer matches and split hashes and words.
// The longest match wins, and on a tie the rule defined first, so the order of the rules matters.
// Rebuild: cd parsers/tree-sitter-log && tree-sitter generate && tree-sitter build -o ../../parser/log.so
// nvcat has its own runtimepath, so it needs these links once per machine:
//   ln -s ~/.config/nvim/parser/log.so ~/.local/share/nvim/site/parser/log.so
//   ln -s ~/.config/nvim/queries/log ~/.local/share/nvim/site/queries/log

const MONTH = "(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)";
const DAY = "(Mon|Tue|Wed|Thu|Fri|Sat|Sun)";
const HEX = "[0-9a-fA-F]";

// "error" matches ERROR, Error and error, as the runtime's `syntax case ignore` does
const ci = (word) => word.replace(/[a-z]/g, (c) => `[${c}${c.toUpperCase()}]`);
const words = (list) => list.map(ci).join("|");

// A level word; exact words are case-sensitive, prefixed ones are like LOG_ERROR
const level = (list, { exact = [], glyphs = [], prefixed = [] } = {}) => {
  const parts = [words(list), ...exact, ...glyphs];
  if (prefixed.length > 0) parts.push(`[A-Z]+_(${prefixed.join("|")})`);
  return token(new RegExp(parts.join("|")));
};

module.exports = grammar({
  name: "log",

  extras: () => [/[ \t\r\f]/],

  rules: {
    // One node per line lets an edit reparse that line and reuse the rest of the tree
    source_file: ($) => repeat(choice($.line, $._newline)),
    line: ($) => prec.right(seq(repeat1($._item), optional($._newline))),
    _newline: () => /\n/,

    _item: ($) =>
      choice(
        $.timestamp,
        $.time_zone,
        $.level_error,
        $.level_warning,
        $.level_notice,
        $.level_info,
        $.level_debug,
        $.level_trace,
        $.level_success,
        $.boolean,
        $.null,
        $.lua_reference,
        $.date,
        $.duration,
        $.url,
        $.ipv4,
        $.ipv6,
        $.mac_address,
        $.uuid,
        $.hash,
        $.float,
        $.number,
        $.file_path,
        $.domain,
        $.string,
        $.xml_header,
        $.xml_doctype,
        $.xml_tag,
        $.xml_comment,
        $.xml_cdata,
        $.xml_entity,
        $.separator,
        $.operator,
        $.bracket,
        $.word,
        $._other,
      ),

    // The syslog columns "host program[pid]:" are only recognized right after a time. The host
    // must start lowercase or with a digit, so "12:09:38 INFO foo:" keeps its level.
    timestamp: ($) => prec.right(seq($.time, optional($.time_zone), optional($.sys_columns))),
    time: () => token(/\d{2}:\d{2}:\d{2}(\.\d{2,9})?([ \t]?[-+](\d{1,2}:\d{2}|\d{2,4})|Z)?/),
    sys_columns: () => token(/[a-z0-9][\w.-]* [\w.-]+(\[\d+\])?:/),
    time_zone: () => token(/UTC|GMT|EST|EDT|CST|CDT|MST|MDT|PST|PDT|CET|CEST|BST|IST|JST/),

    level_error: () =>
      level(
        [
          "fatal",
          "emerg",
          "emergency",
          "alert",
          "crit",
          "critical",
          "err",
          "error",
          "errors",
          "fail",
          "failed",
          "failure",
          "fault",
          "nack",
          "nak",
        ],
        {
          exact: ["SEVERE"],
          glyphs: ["\uf06a", "\uf00d", "\uf057"],
          prefixed: ["FATAL", "EMERG(ENCY)?", "ALERT", "CRIT(ICAL)?", "ERR(OR)?", "FAIL(URE)?"],
        },
      ),
    level_warning: () =>
      level(["warn", "warning", "bad"], {
        glyphs: ["\uf071", "\uf529"],
        prefixed: ["WARN(ING)?"],
      }),
    level_notice: () => level(["notice"], { prefixed: ["NOTICE"] }),
    level_info: () => level(["info"], { glyphs: ["\uf05a", "\uf449"], prefixed: ["INFO"] }),
    level_debug: () =>
      level(["debug"], {
        exact: ["FINE"],
        glyphs: ["\uf188", "\uf0eb", "\u{f0335}"],
        prefixed: ["DEBUG"],
      }),
    level_trace: () =>
      level(["trace", "verbose"], {
        exact: ["FINER", "FINEST"],
        glyphs: ["\uf040", "\u270e"],
        prefixed: ["TRACE"],
      }),
    level_success: () => level(["pass", "passed", "succeed", "succeeded", "success"]),

    boolean: () => token(new RegExp(words(["true", "false"]))),
    null: () => token(new RegExp(words(["null", "nil", "none"]))),

    // Lua dumps from vim.inspect: <function 2>, <table 3>, <metatable>
    lua_reference: () => token(/function \d+|table \d+|metatable/),

    date: () =>
      token(
        new RegExp(
          [
            "\\d{4}[-/]\\d{2}[-/]\\d{2}T?",
            "\\d{2}[-/]\\d{2}[-/]\\d{4}",
            `\\d{2,4}[-/]${MONTH}[-/]\\d{2,4}T?`,
            "\\d{2}[-/]\\d{2}",
            `${MONTH} {1,2}\\d{1,2}(,? \\d{4})?`,
            `\\d{1,2}[- ]${MONTH}[- ]\\d{4}`,
            // The old syntax took this at the start of a line only; valid dates are close enough
            "20\\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\\d|3[01])",
            MONTH,
            DAY,
          ].join("|"),
        ),
      ),
    duration: () => token(/((\d+d)?\d+h)?(\d+m)?\d+(\.\d+)?[mun]?s/),

    url: () => token(/https?:\/\/\S+/),
    ipv4: () => token(/\d{1,3}(\.\d{1,3}){3}(\/\d+)?/),
    ipv6: () => token(new RegExp(`${HEX}{1,4}(:${HEX}{1,4}){7}(\\/\\d+)?`)),
    mac_address: () => token(new RegExp(`${HEX}{2}([:-]${HEX}{2}){5}`)),
    uuid: () => token(new RegExp(`${HEX}{8}-${HEX}{4}-${HEX}{4}-${HEX}{4}-${HEX}{12}`)),
    hash: () =>
      token(new RegExp([32, 40, 56, 64, 96, 128].map((n) => `${HEX}{${n}}`).join("|"))),

    float: () => token(/\d+\.\d+([eE][-+]?\d+)?|\d+[eE][-+]?\d+/),
    // The runtime takes any 4+ hex characters; requiring a digit spares words like "face"
    number: () => token(/\d+|0[xX][0-9a-fA-F]+|0[bB][01]+|0[oO][0-7]+|[a-fA-F]*\d[0-9a-fA-F]*/),

    file_path: () =>
      token(
        choice(
          // A segment starts with a letter or one of _.~-, so the 4 in 3/4 is no path
          /(\.{1,2}|~)?\/[A-Za-z_.~-][^\s|,;()'"\]{}]*/,
          /[a-zA-Z]:\\[^\s|,;()'"\]{}]+/,
          /\\\\[^\s|,;()'"\]{}]+/,
          // Relative: the first segment needs a letter too
          /[\w.-]*[A-Za-z_][\w.-]*\/[^\s|,;()'"\]{}]+/,
        ),
      ),
    domain: () => token(/[\w-]+(\.[\w-]+)+/),

    // Double-quoted and backtick strings may run to the end of the line, as in the runtime
    // syntax. A single quote needs its closing quote, so "plurals' elements" is no string.
    string: () =>
      token(choice(/"([^"\\\n]|\\.)*"?/, /`([^`\\\n]|\\.)*`?/, /'([^'\\\n]|\\.)*'/)),

    xml_header: () => token(/<\?[\w-]+(\s+\w+(="[^"]*"|='[^']*')?)*\?>/),
    xml_doctype: () => token(/<!DOCTYPE[^>]*>/),
    // Attribute names start with a letter, so <table 3> and <function 2> are no tags
    xml_tag: () =>
      token(/<\/?([\w-]+:)?[A-Za-z_][\w-]*(\s+([\w-]+:)?[A-Za-z_][\w-]*(="[^"]*"|='[^']*')?)*\s*\/?>/),
    xml_comment: () => token(/<!--([^-]|-[^-]|--[^>])*-->/),
    xml_cdata: () => token(/<!\[CDATA\[.*\]\]>/),
    xml_entity: () => token(/&#?\w+;/),

    separator: () => token(/-{3,}|={3,}|#{3,}|\*{3,}|<{3,}|>{3,}|- -/),
    operator: () => /[;,?:.<=>~\/@!$%&+\-|^(){}*#]/,
    bracket: () => /[\[\]]/,

    // "don't" and "plurals'" stay one word, so their quote opens no string
    word: () => token(/\w+('\w+)*'?/),
    // Anything else (non-ASCII text, stray quotes, control bytes): never a parse error
    _other: () => token(prec(-1, /[^ \t\r\f\n]/)),
  },
});
