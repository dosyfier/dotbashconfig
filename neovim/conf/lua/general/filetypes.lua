vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = {"*/playbooks/*.yml","*/playbooks/*.yaml","play-*.yml","play-*.yaml"},
  command = "set filetype=yaml.ansible"
})
