return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },

			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },

			tsx = { "prettier" },
			jsx = { "prettier" },

			json = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			markdown = { "prettier" },

			python = { "isort", "black" },

			sh = { "shfmt" },
			bash = { "shfmt" },

			cpp = { "clang_format" },
			c = { "clang_format" },

			java = { "google_java_format" },
		},

		formatters = {
			clang_format = {
				prepend_args = {
					"-style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: Never}",
				},
			},
		},

		format_on_save = {
			timeout_ms = 2000,
			lsp_fallback = true,
		},

		notify_on_error = true,
	},

	config = function(_, opts)
		require("conform").setup(opts)
	end,
}
