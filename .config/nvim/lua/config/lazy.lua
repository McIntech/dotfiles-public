-- Función para asegurar la instalación de lazy.nvim
local function ensure_lazy_installed()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- Última versión estable
      lazypath,
    })
    vim.notify("lazy.nvim instalado en " .. lazypath, vim.log.levels.INFO)
  end
  vim.opt.rtp:prepend(lazypath)
end

-- Asegurar que lazy.nvim esté instalado
ensure_lazy_installed()

-- Configuración de lazy.nvim
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  vim.notify("Error al cargar lazy.nvim", vim.log.levels.ERROR)
  return
end

lazy.setup({
  spec = {
    -- Configuración principal de LazyVim
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = {
        colorscheme = "solarized-osaka",
        news = {
          lazyvim = true,
          neovim = true,
        },
      },
    },
    -- Módulos adicionales
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.util.mini-hipatterns" },
    -- Plugins personalizados
    { import = "plugins" },
  },
  defaults = {
    -- Cargar plugins personalizados durante el inicio
    lazy = false,
    -- Usar siempre la última versión de los plugins
    version = false,
  },
  dev = {
    -- Ruta para desarrollo de plugins
    path = "~/.ghq/github.com",
  },
  checker = {
    -- Habilitar chequeo automático de actualizaciones
    enabled = true,
  },
  performance = {
    cache = {
      -- Habilitar caché para mejorar el rendimiento
      enabled = true,
    },
    rtp = {
      -- Deshabilitar plugins de runtime innecesarios
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    custom_keys = {
      -- Definir teclas personalizadas en la interfaz de usuario
      ["<localleader>d"] = function(plugin)
        dd(plugin)
      end,
    },
  },
  debug = false, -- Desactivar modo debug
})
