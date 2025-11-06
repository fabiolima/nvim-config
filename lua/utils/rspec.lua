local service = "runner"

-- === Floating window ===
local function open_floating_window()
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.6)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " 🧪 RSpec (interactive) ",
    title_pos = "center",
  })

  vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
  vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = buf, silent = true })

  return buf, win
end

-- === Vertical split ===
local function open_or_reuse_split()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(buf)
    if name:match("RSpec Output") then
      vim.api.nvim_set_current_win(win)
      vim.cmd("startinsert")
      return buf, win
    end
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name:match("RSpec Output") then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end

  vim.cmd("vsplit | enew")
  vim.api.nvim_set_option_value("buflisted", false, { buf = 0 })
  vim.api.nvim_set_option_value("number", false, { win = 0 })
  vim.api.nvim_set_option_value("relativenumber", false, { win = 0 })
  vim.api.nvim_set_option_value("signcolumn", "no", { win = 0 })

  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_name(buf, "RSpec Output")

  return buf, vim.api.nvim_get_current_win()
end

local function run_rspec_tty(cmd, buf)
  -- para evitar terminais antigos ativos
  if vim.b[buf].term_job_id then
    pcall(vim.fn.jobstop, vim.b[buf].term_job_id)
  end

  -- muda o buffer atual para o alvo do terminal
  vim.api.nvim_set_current_buf(buf)

  -- inicia o job em modo terminal
  local job_id = vim.fn.jobstart(cmd, {
    term = true, -- substitui termopen()
    on_exit = function(_, code)
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end
        local new_name = code == 0 and "RSpec Output ✅" or "RSpec Output ❌"
        pcall(vim.api.nvim_buf_set_name, buf, new_name)
      end)
    end,
  })

  -- guarda o id pra futuras paradas
  vim.b[buf].term_job_id = job_id

  -- entra em modo insert pra permitir interação
  vim.cmd("startinsert")
end

-- === Helpers ===
local function build_cmd(target)
  return {
    "podman-compose",
    "exec",
    service,
    "bundle",
    "exec",
    "rspec",
    "--color",
    target,
  }
end

-- === Execuções ===
local function run_split(target)
  local buf = open_or_reuse_split()
  run_rspec_tty(build_cmd(target), buf)
end

local function run_floating(target)
  local buf = open_floating_window()
  run_rspec_tty(build_cmd(target), buf)
end

-- === Entry points ===
local function run_file_split()
  run_split(vim.fn.expand("%"))
end

local function run_line_split()
  run_split(string.format("%s:%d", vim.fn.expand("%"), vim.fn.line(".")))
end

local function run_file_float()
  run_floating(vim.fn.expand("%"))
end

local function run_line_float()
  run_floating(string.format("%s:%d", vim.fn.expand("%"), vim.fn.line(".")))
end

-- === Commands & Keymaps ===
vim.api.nvim_create_user_command("RSpecFile", run_file_split, {})
vim.api.nvim_create_user_command("RSpecLine", run_line_split, {})
vim.api.nvim_create_user_command("RSpecFloatFile", run_file_float, {})
vim.api.nvim_create_user_command("RSpecFloatLine", run_line_float, {})

vim.api.nvim_echo({ { "RSpec TTY runner (podman-compose) loaded ✅", "Comment" } }, false, {})
