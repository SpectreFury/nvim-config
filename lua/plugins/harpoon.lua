return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {},
	keys = {
		{
			"<leader>a",
			function()
				require("harpoon"):list():add()
			end,
			mode = "",
			desc = "Harpoon Add",
		},
		{
			"<leader>e",
			function()
				local harpoon = require("harpoon")
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end,
			mode = "",
			desc = "Harpoon List",
		},
		{
			"<A-1>",
			function()
				require("harpoon"):list():select(1)
			end,
			mode = "",
		},
		{
			"<A-2>",
			function()
				require("harpoon"):list():select(2)
			end,
			mode = "",
		},
		{
			"<A-3>",
			function()
				require("harpoon"):list():select(3)
			end,
			mode = "",
		},
		{
			"<A-4>",
			function()
				require("harpoon"):list():select(4)
			end,
			mode = "",
		},
	},
}
