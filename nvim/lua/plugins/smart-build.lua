---@diagnostic disable: need-check-nil, deprecated
-- smart-build.lua
-- ~/.config/nvim/lua/smart-build.lua

local M = {}

-- ─── Defaults ────────────────────────────────────────────────────────────────

local defaults = {
	terminal_size = 0,
	auto_save = true,
}

-- ─── Build systems ───────────────────────────────────────────────────────────

local BUILD_SYSTEMS = {
	{ marker = ".nvim-build", label = "Local override", cmd = nil, _local = true },

	-- C++
	{
		marker = "CMakeLists.txt",
		label = "CMake (C++)",
		cmd = function(root)
			local exe = "./build/" .. vim.fn.fnamemodify(root, ":t")
			local cache = root .. "/build/CMakeCache.txt"

			if not vim.uv.fs_stat(cache) then
				return "cmake -S . -B build && cmake --build build && " .. exe
			end

			return "cmake --build build && " .. exe
		end,
	},

	{
		marker = "Makefile",
		label = "Make (C++)",
		cmd = "make && ./a.out",
	},

	-- Java
	{
		marker = "pom.xml",
		label = "Maven (Java)",
		cmd = "mvn compile exec:java",
	},
	{
		marker = "build.gradle.kts",
		label = "Gradle KTS (Java)",
		cmd = "./gradlew run",
	},
	{
		marker = "build.gradle",
		label = "Gradle (Java)",
		cmd = "./gradlew run",
	},

	-- Python
	{
		marker = "pyproject.toml",
		label = "Python (Poetry)",
		cmd = "poetry run python main.py",
	},
	{
		marker = "requirements.txt",
		label = "Python (pip)",
		cmd = "python main.py",
	},
	{
		marker = "setup.py",
		label = "Python (setup.py)",
		cmd = "python setup.py build && python main.py",
	},
	{
		marker = "main.py",
		label = "Python (single)",
		cmd = "python main.py",
	},

	-- Node.js / TypeScript
	{
		marker = "tsconfig.json",
		label = "TypeScript (ts-node)",
		cmd = function(root)
			local entry = root .. "/src/index.ts"
			if vim.uv.fs_stat(entry) then
				return "npx tsc && node src/index.js"
			end
			return "npx tsc && node index.js"
		end,
	},
	{
		marker = "package.json",
		label = "Node.js (npm)",
		cmd = function(root)
			local pkg = io.open(root .. "/package.json", "r")
			if pkg then
				local content = pkg:read("*a")
				pkg:close()
				-- prefer "dev" script, fallback to "start"
				if content:find('"dev"') then
					return "npm run dev"
				elseif content:find('"start"') then
					return "npm start"
				end
			end
			return "node index.js"
		end,
	},
}

-- ─── Helpers ────────────────────────────────────────────────────────────────

local function fs_stat(path)
	return vim.uv.fs_stat(path)
end

local function find_project_root()
	local dir = vim.fn.expand("%:p:h")

	while dir and dir ~= "/" do
		for _, bs in ipairs(BUILD_SYSTEMS) do
			local full = dir .. "/" .. bs.marker

			if bs.marker:find("*") then
				if #vim.fn.glob(full, false, true) > 0 then
					return dir, bs
				end
			elseif fs_stat(full) then
				return dir, bs
			end
		end

		local parent = vim.fn.fnamemodify(dir, ":h")
		if parent == dir then
			break
		end
		dir = parent
	end

	return nil, nil
end

local function notify(msg, level)
	vim.notify("[smart-build] " .. msg, level or vim.log.levels.INFO)
end

-- terminal persistente
local term_win = nil

local function run(cmd, cwd, _)
	if vim.bo.buftype == "terminal" then
		vim.fn.chansend(vim.b.terminal_job_id, cmd .. "\n")
		return
	end

	-- close old terminal window if still open
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		vim.api.nvim_win_close(term_win, true)
	end

	-- botright forces a full-width horizontal split at the very bottom
	vim.cmd("botright 12new")
	term_win = vim.api.nvim_get_current_win()

	vim.fn.termopen(cmd, {
		cwd = cwd,
		on_exit = function()
			-- scroll to top so output is visible, not [Process exited 0]
			vim.schedule(function()
				if vim.api.nvim_win_is_valid(term_win) then
					vim.api.nvim_win_set_cursor(term_win, { 1, 0 })
				end
			end)
		end,
	})

	vim.cmd("startinsert")
end
-- ─── Core ───────────────────────────────────────────────────────────────────

local config = {}

function M.build()
	if config.auto_save and vim.bo.modified then
		vim.cmd("write")
	end

	local root, bs = find_project_root()

	-- ── Single-file fallback ─────────────────────────────────────────
	if not root then
		local file = vim.fn.expand("%:p")
		local ft = vim.bo.filetype
		local ext = vim.fn.expand("%:e")

		local ft_map = {
			cxx = "cpp",
			cc = "cpp",
			hpp = "cpp",
			python3 = "python",
			ts = "typescript",
			tsx = "typescript",
		}
		ft = ft_map[ft] or ft

		if ft == "" then
			local ext_map = {
				cpp = "cpp",
				cc = "cpp",
				cxx = "cpp",
				py = "python",
				java = "java",
				ts = "typescript",
				tsx = "typescript",
			}
			ft = ext_map[ext]
		end

		local cmd_map = {
			cpp = "g++ " .. file .. " -std=c++17 -O2 -o /tmp/out && /tmp/out",
			java = "javac " .. file .. " && java -cp " .. vim.fn.fnamemodify(file, ":h") .. " " .. vim.fn.fnamemodify(
				file,
				":t:r"
			),
			python = "python " .. file,
			typescript = "npx tsc " .. file .. " && node " .. vim.fn.fnamemodify(file, ":r") .. ".js",
		}

		local cmd = cmd_map[ft]
		if cmd then
			notify("Single file → " .. cmd)
			run(cmd, vim.fn.getcwd(), config.terminal_size)
			return
		end

		notify("Nenhum build system encontrado.", vim.log.levels.WARN)
		return
	end
	-- ────────────────────────────────────────────────────────────────

	-- .nvim-build
	if bs._local then
		local f = io.open(root .. "/.nvim-build", "r")
		if f then
			local line = f:read("*l")
			f:close()
			if line and vim.trim(line) ~= "" then
				bs = { label = "Local (.nvim-build)", cmd = vim.trim(line) }
			else
				notify(".nvim-build vazio.", vim.log.levels.WARN)
				return
			end
		end
	end

	local cmd = type(bs.cmd) == "function" and bs.cmd(root) or bs.cmd
	notify(string.format("%s → %s", bs.label, cmd))
	run(cmd, root, config.terminal_size)
end

function M.run_project()
	local root, bs = find_project_root()
	if not root then
		notify("Nenhum sistema encontrado.", vim.log.levels.WARN)
		return
	end

	local run_cmds = {
		["Maven (Java)"] = "mvn exec:java",
		["Gradle KTS (Java)"] = "./gradlew run",
		["Gradle (Java)"] = "./gradlew run",
		["CMake (C++)"] = "./build/" .. vim.fn.fnamemodify(root, ":t"),
		["Make (C++)"] = "./a.out",
		["Python (Poetry)"] = "poetry run python main.py",
		["Python (pip)"] = "python main.py",
		["Python (setup.py)"] = "python main.py",
		["Python (single)"] = "python main.py",
		["TypeScript (ts-node)"] = "npx tsc && node index.js",
		["Node.js (npm)"] = "node index.js",
	}

	local cmd = run_cmds[bs.label]
	if not cmd then
		notify("Run não definido para " .. bs.label, vim.log.levels.WARN)
		return
	end

	run(cmd, root, config.terminal_size)
end

function M.detect()
	local root, bs = find_project_root()
	if not root then
		notify("Nenhum build system encontrado.", vim.log.levels.WARN)
		return
	end

	local label = bs._local and "Local (.nvim-build)" or bs.label
	local cmd = type(bs.cmd) == "function" and bs.cmd(root) or bs.cmd

	notify(string.format("Sistema: %s | Raiz: %s | Cmd: %s", label, root, cmd or "dinâmico"))
end

-- ─── Setup ──────────────────────────────────────────────────────────────────

function M.setup(opts)
	config = vim.tbl_deep_extend("force", defaults, opts or {})

	vim.keymap.set("n", "<F7>", M.build, { desc = "SmartBuild: build" })
	vim.keymap.set("n", "<F8>", M.run_project, { desc = "SmartBuild: run" })
	vim.keymap.set("n", "<leader>sd", M.detect, { desc = "SmartBuild: detect" })

	vim.keymap.set("n", "<leader>so", function()
		local root, _ = find_project_root()

		vim.ui.input({ prompt = "Build command: " }, function(input)
			if input and vim.trim(input) ~= "" then
				-- remove overrides antigos
				for i = #BUILD_SYSTEMS, 1, -1 do
					if BUILD_SYSTEMS[i]._session then
						table.remove(BUILD_SYSTEMS, i)
					end
				end

				table.insert(BUILD_SYSTEMS, 1, {
					marker = root or ".",
					label = "Override (sessão)",
					cmd = vim.trim(input),
					_session = true,
				})

				notify("Override: " .. vim.trim(input))
			end
		end)
	end, { desc = "SmartBuild: override" })

	vim.api.nvim_create_user_command("Build", M.build, {})
	vim.api.nvim_create_user_command("BuildRun", M.run_project, {})
	vim.api.nvim_create_user_command("BuildDetect", M.detect, {})
end

return M
