local loaded_clients = {}

local function trigger_workspace_diagnostics(client, bufnr, workspace_files)
  if vim.tbl_contains(loaded_clients, client.id) then
    return
  end
  table.insert(loaded_clients, client.id)

  if not vim.tbl_get(client.server_capabilities, 'textDocumentSync', 'openClose') then
    return
  end

  for _, path in ipairs(workspace_files) do
    if path == vim.api.nvim_buf_get_name(bufnr) then
      goto continue
    end

    local filetype = vim.filetype.match({ filename = path })

    if not vim.tbl_contains(client.config.filetypes, filetype) then
      goto continue
    end

    local params = {
      textDocument = {
        uri = vim.uri_from_fname(path),
        version = 0,
        text = vim.fn.join(vim.fn.readfile(path), "\n"),
        languageId = filetype
      }
    }
    client.notify('textDocument/didOpen', params)

    ::continue::
  end
end

local function get_tracked_files()
    local new_line = "\n"
    local git_ls_content = vim.fn.system("git ls-files")

    return vim.fn.split(git_ls_content, new_line)
end

local function map(iterable, func)
    return vim.tbl_map(func, iterable)
end

local workspace_files = vim.tbl_map(function (path)
    return vim.fn.fnamemodify(path, ":p")
end, get_tracked_files())


return {
    trigger_workspace_diagnostics = function(client, bufnr)
        trigger_workspace_diagnostics(client, bufnr, workspace_files)
    end

}
