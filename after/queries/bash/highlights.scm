;; extends

; specialKeyword highlighting for package.json
(command_name
  (word) @bash.specialKeyword
  (#any-of? @bash.specialKeyword
    "yarn" "next" "tsc" "vitest" "cross-env" "node" "wrangler" "npx" "git" "eslint" "prettier" "jest" "webpack"
  )
)

(command
  argument:
  (word) @bash.specialKeyword
  (#any-of? @bash.specialKeyword
    "yarn" "next" "tsc" "vitest" "cross-env" "node" "wrangler" "npx" "git" "eslint" "prettier" "jest" "webpack"
))

; argumentFlag for options
(command
  argument: (word) @bash.argumentFlag (#match? @bash.argumentFlag "^(-|--)")
)
