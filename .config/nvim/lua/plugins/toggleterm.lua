return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			local toggleterm = require("toggleterm")

			-- Configuración básica de toggleterm
			toggleterm.setup({
				size = 20,
				open_mapping = [[<C-\>]],
				hide_numbers = true,
				shade_filetypes = {},
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				insert_mappings = true,
				persist_size = true,
				direction = "float",
				close_on_exit = true,
				shell = "/bin/zsh",
				float_opts = {
					border = "rounded",
					winblend = 3,
					highlights = {
						border = "Normal",
						background = "Normal",
					},
				},
			})

			local Terminal = require("toggleterm.terminal").Terminal

			-- Crear una tabla global para almacenar terminales flotantes
			_G.terminals = {}
			for i = 1, 9 do
				_G.terminals[i] = Terminal:new({
					count = i,
					direction = "float",
					float_opts = {
						border = "rounded",
						width = math.floor(vim.o.columns * 0.8),
						height = math.floor(vim.o.lines * 0.8),
					},
				})
			end

			-- Función para alternar una terminal específica
			_G.toggle_terminal = function(index)
				if index < 1 or index > 9 then
					vim.notify("Toggleterm: El índice de terminal debe estar entre 1 y 9", vim.log.levels.ERROR)
					return
				end

				if _G.terminals[index]:is_open() then
					_G.terminals[index]:close()
				else
					_G.terminals[index]:open()
				end
			end

			-- Mapeos de teclas
			local opts = { noremap = true, silent = true }
			local keymap = vim.api.nvim_set_keymap

			-- Keymaps para alternar terminales flotantes del 1 al 9
			for i = 1, 9 do
				keymap("n", "<leader>t" .. i, string.format("<cmd>lua toggle_terminal(%d)<CR>", i), opts)
			end

			-- Salir de la terminal con ESC o 'jk'
			function _G.set_terminal_keymaps()
				local opts = { noremap = true, silent = true }
				vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
			end

			-- Autocomando para establecer los mapeos dentro de las terminales
			vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
		end,
	},
}
