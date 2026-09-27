return {
    'nvim-telescope/telescope.nvim', version = '*',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
    local builtin = require("telescope.builtin")

    require("telescope").setup({
        pickers = {
            find_files = {
                hidden = true,
            },
        },
    })

    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope Buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
end
}
