local function enable_trasparency()
    vim.api.nvim_set_hl(0, "Normal" , { bg = "none" })
end
return {
    {
        "rebelot/kanagawa.nvim",
	config = function()
	    vim.cmd.colorscheme "kanagawa"
	    enable_trasparency()
	end
    },
    {
	"nvim-lualine/lualine.nvim",
	dependencies = {
	    "nvim-tree/nvim-web-devicons",
	},
	opts = {
	    themes = 'kanagawa' ,
	}
    },
}
