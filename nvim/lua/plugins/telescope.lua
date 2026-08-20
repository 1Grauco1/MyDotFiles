return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",

		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},

		{ "nvim-telescope/telescope-ui-select.nvim" },

		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},

	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		telescope.setup({
			defaults = {
				hidden = true,
				mappings = {
					i = {
						["<C-u>"] = false,
						["<C-d>"] = false,
					},
				},
			},
			extensions = {
				["ui-select"] = require("telescope.themes").get_dropdown(),
			},
		})

		-- extensions
		pcall(telescope.load_extension, "fzf")
		pcall(telescope.load_extension, "ui-select")

		-- LSP mappings (buffer-local, not duplicated in which-key)
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("telescope-lsp", { clear = true }),
			callback = function(event)
				local opts = { buffer = event.buf }

				vim.keymap.set("n", "grr", builtin.lsp_references, opts)
				vim.keymap.set("n", "grd", builtin.lsp_definitions, opts)
				vim.keymap.set("n", "gri", builtin.lsp_implementations, opts)
				vim.keymap.set("n", "grt", builtin.lsp_type_definitions, opts)
			end,
		})
	end,
}
