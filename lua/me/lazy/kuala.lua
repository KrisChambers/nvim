return {
  {
    "mistweaverco/kulala.nvim",
    keys = {
      { "<leader>Rs", desc = "Send request" },
      { "<leader>Ra", desc = "Send all requests" },
      { "<leader>Rb", desc = "Open scratchpad" },
    },
    ft = { "http", "rest" },
    opts = {
        certificates = {
              ["ets-training.aeso.ca"] = {
                cert = "/home/kris/Socivolta/certs/AESO_REMI_TRAIN.crt",
                key = "/home/kris/Socivolta/certs/AESO_REMI_TRAIN.pem"
              },
              ["ets.aeso.ca"] = {
                cert = "/home/kris/Socivolta/certs/AESO_DAN.crt",
                key = "/home/kris/Socivolta/certs/AESO_DAN.pem"
              },
            },
      -- your configuration comes here
      global_keymaps = true,
      global_keymaps_prefix = "<leader>R",
      kulala_keymaps_prefix = "",
    },
  },
}
