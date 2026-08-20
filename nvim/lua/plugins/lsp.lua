return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
	},

	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup()

		-- =========================
		-- DIAGNOSTICS (VISUAL STYLE)
		-- =========================
		vim.diagnostic.config({
			virtual_text = {
				spacing = 2,
				prefix = "",
			},
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				border = "rounded",
				source = true,
			},
		})

		-- =========================
		-- LSP ATTACH
		-- =========================
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					vim.keymap.set(mode or "n", keys, func, {
						buffer = event.buf,
						desc = "LSP: " .. desc,
					})
				end

				local client = vim.lsp.get_client_by_id(event.data.client_id)

				map("K", vim.lsp.buf.hover, "Hover Documentation")

				map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

				map("<leader>rw", function()
					local word = vim.fn.expand("<cword>")
					vim.cmd("%s/\\<" .. word .. "\\//gc")
				end, "[R]ename [W]ord (buffer)")

				map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

				map("gl", vim.diagnostic.open_float, "Open Diagnostics")
				map("[d", function()
					vim.diagnostic.jump({ count = -1 })
				end, "Prev Diagnostic")
				map("]d", function()
					vim.diagnostic.jump({ count = 1 })
				end, "Next Diagnostic")

				if client and client:supports_method("textDocument/formatting") then
					map("<leader>f", function()
						vim.lsp.buf.format({ bufnr = event.buf })
					end, "[F]ormat buffer")
				end

				if client and client:supports_method("textDocument/documentHighlight") then
					local group = vim.api.nvim_create_augroup("user-lsp-highlight", { clear = false })

					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = group,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = group,
						callback = vim.lsp.buf.clear_references,
					})

				vim.api.nvim_create_autocmd("LspDetach", {
					group = vim.api.nvim_create_augroup("user-lsp-detach", { clear = true }),
					callback = function(event2)
						vim.lsp.buf.clear_references()
						vim.api.nvim_clear_autocmds({
							group = "user-lsp-highlight",
							buffer = event2.buf,
						})
						end,
					})
				end

				if client and client:supports_method("textDocument/inlayHint") then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		-- =========================
		-- SERVERS
		-- =========================
		local servers = {
			lua_ls = {
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if
							path ~= vim.fn.stdpath("config")
							and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
						then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							version = "LuaJIT",
							path = { "lua/?.lua", "lua/?/init.lua" },
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							checkThirdParty = false,
							library = vim.tbl_extend("force", vim.api.nvim_get_runtime_file("", true), {
								"${3rd}/luv/library",
								"${3rd}/busted/library",
								"/usr/share/hypr/stubs",
							}),
						},
					})
				end,
				settings = { Lua = {} },
			},

		clangd = {},
		jdtls = {},
		ts_ls = {},
	}

		local ensure_installed = vim.tbl_keys(servers)
		vim.list_extend(ensure_installed, { "stylua", "prettier" })

		require("mason-tool-installer").setup({
			ensure_installed = ensure_installed,
		})

		for name, server in pairs(servers) do
			vim.lsp.config(name, server)
			vim.lsp.enable(name)
		end
	end,
}
