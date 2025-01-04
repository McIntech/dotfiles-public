-- Archivo: ~/.config/nvim/lua/plugins.lua

return {
	-- 1. Obsidian.nvim
	{
			"epwalsh/obsidian.nvim",
			version = "*", -- Usa la última versión estable en lugar del último commit
			lazy = true, -- Carga perezosa para optimizar el tiempo de inicio
			-- Carga solo para archivos Markdown dentro de los vaults específicos
			event = {
					"BufReadPre " .. vim.fn.expand("~/vaults/personal/*.md"),
					"BufNewFile " .. vim.fn.expand("~/vaults/personal/*.md"),
					"BufReadPre " .. vim.fn.expand("~/vaults/work/*.md"),
					"BufNewFile " .. vim.fn.expand("~/vaults/work/*.md"),
			},
			dependencies = {
					"nvim-lua/plenary.nvim", -- Requerido por obsidian.nvim
					"nvim-telescope/telescope.nvim", -- Integración opcional con Telescope
			},
			opts = {
					-- Define múltiples workspaces (vaults) de Obsidian
					workspaces = {
							{
									name = "personal",
									path = "~/vaults/personal", -- Ruta absoluta a tu vault personal
							},
							{
									name = "work",
									path = "~/vaults/work", -- Ruta absoluta a tu vault de trabajo
							},
							-- Puedes añadir más workspaces según necesites
					},

					-- Opciones de integración con Telescope
					telescope = {
							-- Configuración específica para Telescope, si es necesario
							-- Por ejemplo, puedes personalizar los pickers relacionados con Obsidian
					},

					-- Opciones para la creación de nuevas notas
					notes_subdir = "Notes", -- Subdirectorio dentro de cada workspace para las notas

					-- Opciones para las notas diarias
					daily_notes = {
							folder = "Daily", -- Carpeta para las notas diarias
							date_format = "%Y-%m-%d", -- Formato de fecha para las notas diarias
					},

					-- Integración con nvim-cmp para autocompletado
					completion = {
							nvim_cmp = true, -- Habilita la integración con nvim-cmp
					},

					-- Comportamiento al seguir URLs externas
					follow_url_fallback = "open", -- Puede ser "open" (abrir en navegador predeterminado) o "browser"

					-- Otras opciones de configuración disponibles:
					-- Por ejemplo, puedes habilitar la previsualización de notas, backlinks, etc.
			},
	},

	-- 2. Telescope.nvim (Fuzzy finder potente)
	{
			"nvim-telescope/telescope.nvim",
			branch = "0.1.x",
			dependencies = { "nvim-lua/plenary.nvim" },
			lazy = true, -- Carga perezosa
			config = function()
					require("telescope").setup({
							defaults = {
									vimgrep_arguments = {
											"rg",
											"--color=never",
											"--no-heading",
											"--with-filename",
											"--line-number",
											"--column",
											"--smart-case",
									},
									prompt_prefix = "> ",
									selection_caret = "> ",
									entry_prefix = "  ",
									initial_mode = "insert",
									selection_strategy = "reset",
									sorting_strategy = "descending",
									layout_strategy = "horizontal",
									layout_config = {
											horizontal = { mirror = false },
											vertical = { mirror = false },
									},
									file_sorter = require("telescope.sorters").get_fuzzy_file,
									file_ignore_patterns = { "node_modules", ".git" },
									generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
									path_display = { "truncate" },
									winblend = 0,
									border = {},
									borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
									color_devicons = true,
									use_less = true,
									set_env = { ["COLORTERM"] = "truecolor" },
									file_previewer = require("telescope.previewers").vim_buffer_cat.new,
									grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
									qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
							},
							pickers = {
									-- Personaliza los pickers aquí si lo deseas
							},
							extensions = {
									-- Carga extensiones si las tienes
							},
					})
			end,
	},

	-- 3. nvim-treesitter (Resaltado de sintaxis avanzado)
	{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			lazy = true,
			config = function()
					require("nvim-treesitter.configs").setup({
							ensure_installed = {
									"markdown",
									"markdown_inline",
									"lua",
									"python",
									"javascript",
									-- Añade otros lenguajes que uses
							},
							highlight = {
									enable = true,
									additional_vim_regex_highlighting = false,
							},
							indent = {
									enable = true,
							},
					})
			end,
	},

	-- 4. nvim-cmp (Autocompletado)
	{
			"hrsh7th/nvim-cmp",
			dependencies = {
					"hrsh7th/cmp-nvim-lsp",
					"L3MON4D3/LuaSnip",
					"saadparwaiz1/cmp_luasnip",
			},
			lazy = true,
			config = function()
					local cmp = require("cmp")
					cmp.setup({
							snippet = {
									expand = function(args)
											require("luasnip").lsp_expand(args.body)
									end,
							},
							mapping = cmp.mapping.preset.insert({
									["<C-b>"] = cmp.mapping.scroll_docs(-4),
									["<C-f>"] = cmp.mapping.scroll_docs(4),
									["<C-Space>"] = cmp.mapping.complete(),
									["<C-e>"] = cmp.mapping.abort(),
									["<CR>"] = cmp.mapping.confirm({ select = true }),
							}),
							sources = cmp.config.sources({
									{ name = "nvim_lsp" },
									{ name = "luasnip" },
							}, {
									{ name = "buffer" },
							}),
					})

					-- Configuración específica para comandos y otros contextos
					cmp.setup.cmdline(":", {
							sources = cmp.config.sources({
									{ name = "path" },
							}, {
									{ name = "cmdline" },
							}),
					})
			end,
	},

	-- 5. LuaSnip (Snippets)
	{
			"L3MON4D3/LuaSnip",
			dependencies = { "rafamadriz/friendly-snippets" },
			lazy = true,
			config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
			end,
	},

	-- 6. friendly-snippets (Colección de snippets)
	{
			"rafamadriz/friendly-snippets",
			lazy = true,
	},

	-- 7. vim-surround (Edición rápida de elementos rodeados)
	{
			"tpope/vim-surround",
			keys = { "c", "d", "y" }, -- Carga perezosa al usar estos comandos
	},

	-- 8. glow.nvim (Previsualización de Markdown dentro de Neovim)
	{
			"ellisonleao/glow.nvim",
			cmd = "Glow",
			config = function()
					require("glow").setup({
							border = "rounded", -- Tipo de borde para la ventana flotante
							width = 120, -- Ancho de la ventana
							height = 30, -- Altura de la ventana
					})
			end,
	},

	-- 9. markdown-preview.nvim (Previsualización en navegador)
	{
			"iamcco/markdown-preview.nvim",
			ft = { "markdown" }, -- Carga perezosa al abrir archivos Markdown
			build = function()
					-- Ejecutar la instalación y luego instalar 'tslib'
					vim.fn["mkdp#util#install"]()
					vim.fn.system({ "npm", "install", "tslib" })
			end,
			config = function()
					vim.g.mkdp_filetypes = { "markdown" }
			end,
	},

	-- 10. zen-mode.nvim (Modo Zen para escritura sin distracciones)
	{
			"folke/zen-mode.nvim",
			cmd = "ZenMode",
			config = function()
					require("zen-mode").setup({
							window = {
									backdrop = 0.95, -- Opacidad del fondo
									width = 120, -- Ancho de la ventana
									height = 1, -- Altura de la ventana (1 = 100%)
									options = {
											number = false,
											relativenumber = false,
											signcolumn = "no",
											cursorline = false,
											cursorcolumn = false,
									},
							},
					})
			end,
	},
}
