require("lint").linters_by_ft = {
  html = { "tidy" },
  ansible = { "ansible_lint" },
  bash = { "shellcheck" },
  sh = { "shellcheck" },
  lua = { "luacheck" },
  markdown = { "vale" },
  tex = { "chktex" },
}

vim.api.nvim_create_user_command("Lint", function()
  require("lint").try_lint()
end, {})

-- Tool                    	 Linter name
-- Set via makeprg         	 compiler
-- ansible-lint            	 ansible_lint
-- cfn-lint                	 cfn_lint
-- checkstyle              	 checkstyle
-- chktex                  	 chktex
-- clang-tidy              	 clangtidy
-- clazy                   	 clazy
-- clj-kondo               	 clj-kondo
-- cmakelint               	 cmakelint
-- codespell               	 codespell
-- cppcheck                	 cppcheck
-- cpplint                 	 cpplint
-- credo                   	 credo
-- cspell                  	 cspell
-- ESLint                  	 eslint
-- fennel                  	 fennel
-- Flake8                  	 flake8
-- flawfinder              	 flawfinder
-- Golangci-lint           	 golangcilint
-- glslc                   	 glslc
-- DirectX Shader Compiler 	 dxc
-- hadolint                	 hadolint
-- hlint                   	 hlint
-- HTML Tidy               	 tidy
-- Inko                    	 inko
-- jshint                  	 jshint
-- ktlint                  	 ktlint
-- lacheck                 	 lacheck
-- Languagetool            	 languagetool
-- luacheck                	 luacheck
-- markdownlint            	 markdownlint
-- mlint                   	 mlint
-- Mypy                    	 mypy
-- Nix                     	 nix
-- phpcs                   	 phpcs
-- proselint               	 proselint
-- pycodestyle             	 pycodestyle
-- pydocstyle              	 pydocstyle
-- Pylint                  	 pylint
-- Revive                  	 revive
-- rflint                  	 rflint
-- robocop                 	 robocop
-- rstcheck                	 rstcheck
-- rstlint                 	 rstlint
-- Ruby                    	 ruby
-- RuboCop                 	 rubocop
-- Selene                  	 selene
-- ShellCheck              	 shellcheck
-- StandardRB              	 standardrb
-- statix check            	 statix
-- stylelint               	 stylelint
-- Vale                    	 vale
-- vint                    	 vint
-- vulture                 	 vulture
-- yamllint                	 yamllint
