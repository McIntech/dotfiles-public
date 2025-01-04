-- Archivo: ~/.config/nvim/lua/plugins.lua

return {
  -- Otros plugins existentes ...

  -- Plugin: render-markdown.nvim (Renderizado avanzado de Markdown)
  {
      "MeanderingProgrammer/render-markdown.nvim",
      dependencies = {
          "nvim-treesitter/nvim-treesitter", -- Resaltado de sintaxis avanzado
          "echasnovski/mini.nvim",           -- Si usas la suite completa de mini.nvim
          -- "echasnovski/mini.icons",        -- Si usas plugins standalone de mini.nvim
          -- "nvim-tree/nvim-web-devicons",   -- Si prefieres usar nvim-web-devicons
      },
      -- Configuración específica del plugin
      opts = {
          -- Puedes añadir aquí tus configuraciones personalizadas
          -- Por ejemplo:
          -- theme = "dark",
          -- line_numbers = true,
      },
  },

  -- Otros plugins existentes ...
}
