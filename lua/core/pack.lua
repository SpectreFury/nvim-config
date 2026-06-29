function gh(text)
	return "https://github.com/" .. text
end

vim.pack.add({
	gh("nvim-lua/plenary.nvim"),
	gh("sainnhe/gruvbox-material"),
	gh("echasnovski/mini.icons"),
	gh("stevearc/oil.nvim"),
	gh("nvim-lualine/lualine.nvim"),
	gh("mason-org/mason.nvim"),
	gh("stevearc/conform.nvim"),
	gh("echasnovski/mini.nvim"),
	gh("saghen/blink.cmp"),
	{ src = gh("ThePrimeagen/harpoon"), version = "harpoon2" },
	gh("nvim-telescope/telescope.nvim"),
	gh("nvim-treesitter/nvim-treesitter"),
  gh("pmizio/typescript-tools.nvim"),
  gh("windwp/nvim-ts-autotag")
})

-- Gruvbox
vim.g.gruvbox_material_enable_italic = false
vim.cmd.colorscheme("gruvbox-material")

-- Mini icons
require("mini.icons").setup()

-- Oil
require("oil").setup()
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Lualine
require("lualine").setup()

-- Mason
require("mason").setup()

-- Conform
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		go = { "goimports", "golines", "gofmt" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescriptreact = { "prettierd" },
		json = { "prettierd" },
		html = { "prettierd" },
		css = { "prettierd" },
		scss = { "prettierd" },
		markdown = { "prettierd" },
		yaml = { "prettierd" },
	},
})
vim.keymap.set("n", "<S-M-F>", function()
 	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat buffer" })

-- Mini
-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require("mini.surround").setup()
require("mini.pairs").setup()

-- Blink.cmp
require("blink.cmp").setup({
	keymap = { preset = "default" },
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = { documentation = { auto_show = false } },
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
	signature = { enabled = true },
})

-- Harpoon
require("harpoon").setup()

vim.keymap.set("n", "<leader>a", function()
	require("harpoon"):list():add()
end, { desc = "Harpoon Add" })

vim.keymap.set("n", "<leader>e", function()
	local harpoon = require("harpoon")
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon List" })

vim.keymap.set("n", "<A-1>", function()
	require("harpoon"):list():select(1)
end)

vim.keymap.set("n", "<A-2>", function()
	require("harpoon"):list():select(2)
end)

vim.keymap.set("n", "<A-3>", function()
	require("harpoon"):list():select(3)
end)

vim.keymap.set("n", "<A-4>", function()
	require("harpoon"):list():select(4)
end)

-- Telescope

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fs", builtin.builtin, { desc = "[F]ind [S]elect Telescope" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [R]esume" })
vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

-- Treesitter

local parsers =
	{ "bash", "c", "diff", "html", "lua", "luadoc", "markdown", "markdown_inline", "query", "vim", "vimdoc" }

require("nvim-treesitter").install(parsers)

local function treesitter_try_attach(buf, language)
	-- check if parser exists and load it
	if not vim.treesitter.language.add(language) then
		return
	end
	-- enables syntax highlighting and other treesitter features
	vim.treesitter.start(buf, language)

	-- enables treesitter based folds
	-- for more info on folds see `:help folds`
	-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
	-- vim.wo.foldmethod = 'expr'

	-- check if treesitter indentation is available for this language, and if so enable it
	-- in case there is no indent query, the indentexpr will fallback to the vim's built in one
	local has_indent_query = vim.treesitter.query.get(language, "indent") ~= nil

	-- enables treesitter based indentation
	if has_indent_query then
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end
end

local available_parsers = require("nvim-treesitter").get_available()

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local buf, filetype = args.buf, args.match

		local language = vim.treesitter.language.get_lang(filetype)
		if not language then
			return
		end

		local installed_parsers = require("nvim-treesitter").get_installed("parsers")

		if vim.tbl_contains(installed_parsers, language) then
			-- enable the parser if it is installed
			treesitter_try_attach(buf, language)
		elseif vim.tbl_contains(available_parsers, language) then
			-- if a parser is available in `nvim-treesitter` auto install it, and enable it after the installation is done
			require("nvim-treesitter").install(language):await(function()
				treesitter_try_attach(buf, language)
			end)
		else
			-- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
			treesitter_try_attach(buf, language)
		end
	end,
})

-- Typescript

require("typescript-tools").setup {}

-- Autotag

require("nvim-ts-autotag").setup {}
