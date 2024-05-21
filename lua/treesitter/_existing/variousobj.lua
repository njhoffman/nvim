
local variousobjs = require('various-textobjs')
-- 韛\n韛\n韛\n韛\n韛\Ln韛\n韛
-- stylua: ignore
local various_obj = {
  'Bracket',                 'mdFencedCodeBlock',
  'anyQuote',                'mdlink',                  -- x  iu    韛URL                x  aE    韛Markdown emphasis
  'chainMember',             'multiCommentedLines',     -- o  iu    韛URL                x  iE    韛Markdown emphasis
  'closedFold',              'nearEoL',                 -- x  aL    韛Line               o  aE    韛Markdown emphasis
  'column',                  'notebookCell',            -- x  iL    韛Line               o  iE    韛Markdown emphasis
  'cssColor',                'number',                  -- o  aL    韛Line               x  ]}    韛To next closing bracket
  'cssSelector',             'pyTripleQuotes',          -- o  iL    韛Line               o  ]}    韛To next closing bracket
  'diagnostic',              'restOfIndentation',       -- x  ?     韛Diagnostic         x  aG    韛Greedy outer indentation
  'doubleSquareBrackets',    'restOfParagraph',         -- o  ?     韛Diagnostic         x  iG    韛Greedy outer indentation
  'entireBuffer',            'restOfWindow',            -- x  id    韛Diagnostic         o  aG    韛Greedy outer indentation
  'greedyOuterIndentation',  'setup',                   -- o  id    韛Diagnostic         o  iG    韛Greedy outer indentation
  'htmlAttribute',           'shellPipe',               -- x  ie    韛Entire buffer      x  [{    韛To previous closing bracket
  'indentation',             'subword',                 -- o  ie    韛Entire buffer      o  [{    韛To previous closing bracket
  'key',                     'toNextClosingBracket',    -- x  a-    韛HTML attribute     o  a-    韛HTML attribute
  'lastChange',              'toNextQuotationMark',     -- x  aX    韛HTML attribute     o  aX    韛HTML attribute
  'lineCharacterwise',       'url',                     -- x  i-    韛HTML attribute     o  i-    韛HTML attribute
  'mdEmphasis',              'value',                   -- x  iX    韛HTML attribute     o  iX    韛HTML attribute
  'visibleInWindow'
}
