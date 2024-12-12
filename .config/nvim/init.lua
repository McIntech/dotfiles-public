if vim.loader then
	vim.loader.enable()
end

_G.dd = function(...)
	require("util.debug").dump(...)
end
vim.print = _G.dd

require("config.lazy")

-- Configura Zsh como shell
vim.opt.shell = "/bin/zsh"

-- Configura Zsh para que se ejecute como shell interactivo
vim.opt.shellcmdflag = "-ic"
