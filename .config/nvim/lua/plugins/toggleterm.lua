-- Asegúrate de tener 'toggleterm.nvim' instalado.
-- Puedes usar un gestor de plugins como 'packer.nvim' para instalarlo.

return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			local toggleterm = require("toggleterm")

			-- Configuración básica de toggleterm
			toggleterm.setup({
				size = 20, -- Tamaño predeterminado (en líneas)
				open_mapping = [[<C-\>]], -- Mapeo por defecto (no utilizado en esta configuración)
				hide_numbers = true,
				shade_filetypes = {},
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				insert_mappings = true,
				persist_size = true,
				direction = "float", -- Todas las terminales son flotantes
				close_on_exit = true,
				shell = vim.o.shell,
				float_opts = {
					border = "rounded", -- Bordes redondeados para un aspecto moderno
					winblend = 3, -- Transparencia ligera
					highlights = {
						border = "Normal",
						background = "Normal",
					},
				},
			})

			local Terminal = require("toggleterm.terminal").Terminal

			-- Crear una tabla global para almacenar las terminales flotantes
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
					on_open = function(term)
						-- Salir del modo terminal con ESC
						vim.api.nvim_buf_set_keymap(
							term.bufnr,
							"t",
							"<ESC>",
							[[<C-\><C-n>]],
							{ noremap = true, silent = true }
						)
						-- Salir del modo terminal con 'jk'
						vim.api.nvim_buf_set_keymap(
							term.bufnr,
							"t",
							"jk",
							[[<C-\><C-n>]],
							{ noremap = true, silent = true }
						)
					end,
				})
			end

			-- Función para cerrar todas las terminales
			_G.close_all_terminals = function()
				for i = 1, 9 do
					if _G.terminals[i]:is_open() then
						_G.terminals[i]:close()
					end
				end
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
					_G.close_all_terminals()
					_G.terminals[index]:open()
				end
			end

			-- Función para mostrar una terminal específica sin alternarla
			_G.show_terminal = function(index)
				if index < 1 or index > 9 then
					vim.notify("Toggleterm: El índice de terminal debe estar entre 1 y 9", vim.log.levels.ERROR)
					return
				end
				_G.close_all_terminals()
				_G.terminals[index]:open()
			end

			-- Función para cerrar todas las terminales ocultas
			_G.close_hidden_terminals = function()
				_G.close_all_terminals()
			end

			-- Mapeos de teclas
			local opts = { noremap = true, silent = true }
			local keymap = vim.api.nvim_set_keymap

			-- Definir el espacio como líder para los terminales
			vim.g.mapleader = " "

			-- Keymaps para alternar terminales flotantes del 1 al 9
			for i = 1, 9 do
				keymap("n", "<leader>t" .. i, string.format("<cmd>lua toggle_terminal(%d)<CR>", i), opts)
			end

			-- Keymap para cerrar todas las terminales ocultas
			keymap("n", "<leader>Tc", "<cmd>lua close_hidden_terminals()<CR>", opts)

			-- Keymaps para mostrar terminales flotantes del 1 al 9
			for i = 1, 9 do
				keymap("n", "<leader>T" .. i, string.format("<cmd>lua show_terminal(%d)<CR>", i), opts)
			end

			-- Keymaps para navegar entre ventanas fácilmente
			keymap("n", "<C-j>", "<C-W>j", opts)
			keymap("n", "<C-k>", "<C-W>k", opts)
			keymap("n", "<C-h>", "<C-W>h", opts)
			keymap("n", "<C-l>", "<C-W>l", opts)

			-- Salir de la terminal con ESC o 'jk'
			function _G.set_terminal_keymaps()
				local opts = { noremap = true, silent = true }
				vim.api.nvim_buf_set_keymap(0, "t", "<ESC>", [[<C-\><C-n>]], opts)
				vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
			end

			-- Autocomando para establecer los mapeos dentro de las terminales
			vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
		end,
	},
}
