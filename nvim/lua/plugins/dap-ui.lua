return {
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},

		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()

			dap.listeners.after.event_initialized["dapui"] = function() end
			dap.listeners.before.event_terminated["dapui"] = function() end
			dap.listeners.before.event_exited["dapui"] = function() end

			vim.keymap.set("n", "<Leader>du", dapui.toggle)
		end,
	},
}
