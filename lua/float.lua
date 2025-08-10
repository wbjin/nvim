-- lua/float.lua
local M = {}

local state = { win = nil, buf = nil, chan = nil }

local function is_open()
    return state.win and vim.api.nvim_win_is_valid(state.win)
end

local function buf_is_valid()
  return state.buf and vim.api.nvim_buf_is_valid(state.buf)
end


local function center_config()
    local width  = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines   * 0.8)
    local row    = math.max(0, math.floor((vim.o.lines - height) / 2 - 1))
    local col    = math.floor((vim.o.columns - width) / 2)
    return {
        relative = "editor",
        style    = "minimal",
        border   = "rounded",
        width = width,
        height = height,
        row = row,
        col = col,
    }
end

local function open_float()
    if not buf_is_valid() then
        state.buf = vim.api.nvim_create_buf(false, true) -- [listed=false, scratch]
        vim.bo[state.buf].bufhidden = "hide"
        vim.bo[state.buf].filetype  = "floatterm"
        pcall(function() vim.bo[state.buf].scrollback = 100000 end)
    end

    state.win = vim.api.nvim_open_win(state.buf, true, center_config())
    vim.wo[state.win].number = false
    vim.wo[state.win].relativenumber = false
    vim.wo[state.win].winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder"

    vim.api.nvim_buf_call(state.buf,
        function()
            local jid = vim.b.terminal_job_id
            local running = jid and vim.fn.jobwait({ jid }, 0)[1] == -1
            if not running then
                state.chan = vim.fn.termopen(vim.o.shell, { on_exit = function() end, })
            end
        end
    )
    vim.cmd.startinsert()
end

function M.toggle()
    if is_open() then
        vim.api.nvim_win_close(state.win, true)
        state.win = nil
    else
        open_float()
    end
end

return M
