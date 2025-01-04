return {
	"folke/which-key.nvim",
	event = "VeryLazy", -- Carga which-key solo cuando es necesario
	config = function()
		require("which-key").setup({
			window = {
				position = "bottom", -- Mueve el menú al fondo
				border = "single", -- Cambia el estilo del borde
				winblend = 0, -- Transparencia (0 = opaco)
				margin = { 1, 0, 1, 0 },
				padding = { 2, 2, 2, 2 },
			},
			layout = {
				height = { min = 4, max = 25 }, -- Altura mínima y máxima
				width = { min = 20, max = 50 }, -- Ancho mínimo y máximo
				spacing = 3, -- Espaciado entre columnas
				align = "center", -- Centra las columnas
			},
		})
	end,
}
