return {
  "nvim-neo-tree/neo-tree.nvim",
  config = {
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function()
          vim.cmd([[
          setlocal relativenumber
        ]])
        end,
      },
    },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
      },
    },
  },
}
