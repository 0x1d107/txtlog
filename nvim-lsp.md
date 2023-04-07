title: Configuring LSP in NeoVim
date: 2023-04-05
tags: vim

# Configuirng Language Server Completion in NeoVim
In this tutorial we're going to configure autocompletion in NeoVim, using Language Server Protocol.

## packer.nvim
For easier further configuration we need to install Packer plugin manager by cloning the
[repository](https://github.com/wbthomason/packer.nvim) somewhere in the `packpath`.

```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

Then create `~/.config/nvim/lua/plugins.lua` where we'll specify all plugins that need to be
installed.

```lua
-- plugins.lua
vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
	--completion
	use 'neovim/nvim-lspconfig'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-vsnip'
	use 'hrsh7th/vim-vsnip'
	use "rafamadriz/friendly-snippets"
end)
```

Now add the following line at the beginning of the `~/.config/nvim/init.vim`.

```vim
lua require('plugins')
```

To reload configuration, restart neovim. Packer.nvim provides commands for package managment.
Now run `:PackerSync` to install and compile plugins specified in `plugins.lua`. Restart neovim
again to load the installed plugins. 

## nvim-cmp
To make configuration of autocompletion easier, create `~/.config/nvim/lua/completion.lua`, where
the configuration of completion server will be stored. 

```lua
local cmp = require('cmp')
cmp.setup({
    snippet = {
	expand = function(args)
    --only for vsnip
	    vim.fn['vsnip#anonymous'](args.body)
	end
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
	{name='nvim_lsp'},
	{name='vsnip'}
    })
})
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require('lspconfig')
-- example server configuration
lspconfig.clangd.setup{capabilities=capabilities}
lspconfig.jedi_language_server.setup{capabilities=capabilities}
lspconfig.rust_analyzer.setup{capabilities=capabilities}
```

Refer to [lspconfig documentation](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md) for example configuration of particular language servers.
Make sure that the language server is installed in your system. 

Don't forget to add the module to the `init.vim`

```vim
lua require('plugins')
lua require('completion')
```

Now you can restart neovim once again to apply the configuration. When editing the appropriate
filetype you'll see a popup menu with autocompletion (`Ctrl-Space` to force completion) that you can confirm by pressing `Enter`.
Select completion variant with `Ctrl-N` and `Ctrl-P`.
