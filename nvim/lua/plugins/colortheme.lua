return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = {
		transparent_background = true,
		custom_highlights = function(colors)
			return {
				Normal = { bg = "NONE" },
				NormalFloat = { bg = "NONE" },
				SignColumn = { bg = "NONE" },
				VertSplit = { bg = "NONE" },
				StatusLine = { bg = "NONE" },
			}
		end,
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd.colorscheme("catppuccin")
	end,
}
