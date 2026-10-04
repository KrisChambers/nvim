--- @type vim.lsp.Config
return {
	settings = {
		Lua = {
            runtime = { version = "LuaJit" },
            workspace = {
                library = { vim.env.VIMRUNTIME },
                checkThirdParty = false
            },
            -- diagnostics = { globals = { 'vim' } },
		}
	}
}
