return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.val = {
			[[                                                     ]],
			[[  ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓ ]],
			[[  ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒ ]],
			[[ ▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░ ]],
			[[ ▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██  ]],
			[[ ▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒ ]],
			[[ ░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░ ]],
			[[ ░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░ ]],
			[[    ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░    ]],
			[[          ░    ░  ░    ░ ░        ░   ░         ░    ]],
			[[                                 ░                   ]],

			[[                                                     ]],
		}

		local dir_button = dashboard.button("d", "  Open directory")
		dir_button.on_press = function()
			local path = vim.fn.input("Dir: ", vim.fn.getcwd(), "dir")
			if path == "" or path == nil then
				return
			end

			local ok, telescope = pcall(require, "telescope.builtin")
			if ok then
				telescope.find_files({ cwd = path })
			else
				vim.cmd("Ex " .. path)
			end
		end

		-- Buttons Section
		dashboard.section.buttons.val = {
			dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
			dashboard.button("r", "  Recent", ":Telescope oldfiles <CR>"),
			dashboard.button("g", "  Find text", ":Telescope live_grep <CR>"),
			dir_button,
			dashboard.button("c", "  Config", ":e $MYVIMRC <CR>"),
			dashboard.button("q", "  Quit", ":qa<CR>"),
		}

		-- Footer Section
		dashboard.section.footer.val = { "neovim configured" }

		-- Apply Config
		alpha.setup(dashboard.opts)

		-- Disable folding on the dashboard buffer
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "alpha",
			callback = function()
				vim.opt_local.foldenable = false
			end,
		})
	end,
}
