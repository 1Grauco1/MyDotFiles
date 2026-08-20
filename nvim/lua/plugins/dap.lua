return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
		},

		config = function()
			local dap = require("dap")

			-- MASON
			require("mason").setup()

			require("mason-nvim-dap").setup({
				ensure_installed = { "codelldb" },
				automatic_installation = true,
			})

			-- ADAPTER
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
					args = { "--port", "${port}" },
				},
			}

			-- C / C++
			dap.configurations.cpp = {
				{
					name = "Launch",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
				},
			}

			dap.configurations.c = dap.configurations.cpp

			-- KEYMAPS
			vim.keymap.set("n", "<F7>", dap.continue, { desc = "DAP: Continue" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP: Step over" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP: Step into" })
			vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP: Step out" })
			vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle breakpoint" })
		end,
	},
}
