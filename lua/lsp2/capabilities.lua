#!/bin/bash

local f = require("utils.functional")
local helpers = require("helpers")
local logger = helpers.initLogger("lsp")
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true

capabilities.textDocument.codeAction = {
	dynamicRegistration = false,
	codeActionLiteralSupport = {
		codeActionKind = {
			valueSet = {
				"",
				"quickfix",
				"refactor",
				"refactor.extract",
				"refactor.inline",
				"refactor.rewrite",
				"source",
				"source.organizeImports",
			},
		},
	},
}

local log_capabilities = function(capabilities)
	local reduce = function(filter)
		local result = {}
		for k, _ in pairs(capabilities) do
			table.insert(
				result,
				f.map(function(v)
					return { v = capabilities[v] }
				end)(f.filter(f.contains(k))(filter))
			)
		end
		return f.flatten(result)
	end

	logger:info(reduce(capabilities))
end
