local fn = vim.fn
local cache_plug = fn.stdpath('data') .. '/site/pack/packer/start/impatient.nvim'

if fn.empty(fn.glob(cache_plug)) == 0 then
  require 'impatient'
end
