return {
	{
		enabled = false,
		"folke/flash.nvim",
		---@type Flash.Config
		opts = {
			search = {
				forward = true,
				multi_window = false,
				wrap = false,
				incremental = true,
			},
		},
	},

	{
		"echasnovski/mini.hipatterns",
		event = "BufReadPre",
		opts = {
			highlighters = {
				hsl_color = {
					pattern = "hsl%(%d+,? %d+%%?,? %d+%%?%)",
					group = function(_, match)
						local utils = require("solarized-osaka.hsl")
						--- @type string, string, string
						local nh, ns, nl = match:match("hsl%((%d+),? (%d+)%%?,? (%d+)%%?%)")
						--- @type number?, number?, number?
						local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)
						--- @type string
						local hex_color = utils.hslToHex(h, s, l)
						return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
					end,
				},
			},
		},
	},

	{
		"dinhhuy258/git.nvim",
		event = "BufReadPre",
		opts = {
			keymaps = {
				-- Open blame window
				blame = "<Leader>gb",
				-- Open file/folder in git repository
				browse = "<Leader>go",
			},
		},
	},

	{
		"telescope.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			"nvim-telescope/telescope-file-browser.nvim",
		},
		keys = {
			{
				"<leader>fl",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Live Grep",
			},
			{
				"<leader>fP",
				function()
					require("telescope.builtin").find_files({
						cwd = require("lazy.core.config").options.root,
					})
				end,
				desc = "Find Plugin File",
			},
			{
				"<leader>bb",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "List open buffers",
			},
			{
				"sf",
				function()
					require("telescope").extensions.file_browser.file_browser({
						path = "%:p:h",
						cwd = require("telescope.utils").buffer_dir(),
						respect_gitignore = false,
						hidden = true,
						grouped = true,
						previewer = false,
						initial_mode = "normal",
						layout_config = { height = 40 },
					})
				end,
				desc = "Open File Browser with the path of the current buffer",
			},
		},
		config = function(_, opts)
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local fb_actions = require("telescope").extensions.file_browser.actions

			-- Configuración por defecto de Telescope
			opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
				prompt_prefix = "> ",
				selection_caret = "> ",
				path_display = { "smart" },
				layout_strategy = "horizontal",
				layout_config = {
					prompt_position = "top",
					horizontal = {
						preview_width = 0.6, -- 60% del ancho para el preview
					},
					vertical = {
						mirror = false,
					},
					width = 0.9, -- 90% del ancho total de la ventana
					height = 0.8, -- 80% del alto total de la ventana
				},
				sorting_strategy = "ascending",
				winblend = 0,
				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
					},
					n = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
					},
				},
				preview = {
					treesitter = true, -- Mejora el preview con Treesitter
				},
			})

			-- Configuración específica para los pickers
			opts.pickers = vim.tbl_extend("force", opts.pickers or {}, {
				live_grep = {
					previewer = true, -- Asegura que el preview esté habilitado
					layout_strategy = "horizontal",
					layout_config = {
						prompt_position = "top",
						preview_width = 0.6,
						width = 0.9,
						height = 0.8,
					},
				},
				find_files = {
					previewer = true, -- Habilita el preview en find_files
				},
				buffers = {
					previewer = false, -- Deshabilita el preview en buffers si lo prefieres
				},
				diagnostics = {
					theme = "ivy",
					initial_mode = "normal",
					layout_config = {
						preview_cutoff = 9999,
					},
				},
			})

			-- Configuración de las extensiones
			opts.extensions = vim.tbl_extend("force", opts.extensions or {}, {
				file_browser = {
					theme = "dropdown",
					hijack_netrw = true,
					mappings = {
						["n"] = {
							["N"] = fb_actions.create,
							["h"] = fb_actions.goto_parent_dir,
							["/"] = function()
								vim.cmd("startinsert")
							end,
							["<C-u>"] = function(prompt_bufnr)
								for _ = 1, 10 do
									actions.move_selection_previous(prompt_bufnr)
								end
							end,
							["<C-d>"] = function(prompt_bufnr)
								for _ = 1, 10 do
									actions.move_selection_next(prompt_bufnr)
								end
							end,
							["<PageUp>"] = actions.preview_scrolling_up,
							["<PageDown>"] = actions.preview_scrolling_down,
						},
					},
				},
			})

			-- Inicializa Telescope con las opciones configuradas
			telescope.setup(opts)

			-- Carga las extensiones necesarias
			telescope.load_extension("fzf")
			telescope.load_extension("file_browser")
		end,
	},
}
