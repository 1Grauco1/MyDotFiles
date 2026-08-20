return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",

		delay = 0,
		timeout = false,

		icons = {
			group = "",
			separator = "➜",
			breadcrumb = "»",
		},

		win = {
			border = "rounded",
			padding = { 1, 2 },
			wo = {
				winblend = 10,
			},
		},

		layout = {
			width = { min = 20, max = 40 },
			spacing = 1,
		},

		sort = { "local", "order", "group", "alphanum", "mod" },

		spec = {
			{ "<leader>f", group = "file" },
			{ "<leader>g", group = "git" },
			{ "<leader>b", group = "buffer" },
			{ "<leader>w", group = "window" },
			{ "<leader>l", group = "lsp" },
			{ "<leader>t", group = "toggle" },
			{ "<leader>s", group = "smart-build" },
			{ "<leader>c", group = "code" },
		},
	},

	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		wk.add({
			-- FILE
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find file" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
			{ "<leader>fs", "<cmd>w<cr>", desc = "Save" },

			-- BUFFER
			{ "<leader>bd", "<cmd>bp | bd #<cr>", desc = "Delete" },
			{ "<leader>bn", "<cmd>bnext<cr>", desc = "Next" },
			{ "<leader>bp", "<cmd>bprev<cr>", desc = "Prev" },

			-- WINDOW
			{ "<leader>ws", "<cmd>split<cr>", desc = "Split" },
			{ "<leader>wv", "<cmd>vsplit<cr>", desc = "VSplit" },
			{ "<leader>wc", "<cmd>close<cr>", desc = "Close" },

			-- LSP
			{ "<leader>lr", vim.lsp.buf.rename, desc = "Rename" },
			{ "<leader>la", vim.lsp.buf.code_action, desc = "Action" },
			{ "<leader>ld", vim.diagnostic.open_float, desc = "Diagnostics" },
			{ "<leader>lf", vim.lsp.buf.format, desc = "Format" },

			-- TOGGLE
			{ "<leader>tn", "<cmd>set number!<cr>", desc = "Number" },
			{ "<leader>tr", "<cmd>set relativenumber!<cr>", desc = "Relative" },
			{ "<leader>tw", "<cmd>set wrap!<cr>", desc = "Wrap" },

			-- CODE
			{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code action" },
			{ "<leader>cr", vim.lsp.buf.references, desc = "References" },
		})
	end,
}
