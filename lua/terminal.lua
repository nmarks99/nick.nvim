
local state = {
    floating = {
        buf = -1,
        win = -1,
    }
}
local function open_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.7)
    local height = opts.height or math.floor(vim.o.lines * 0.7)

    -- Calculate centered position
    local row = math.floor((vim.o.lines - height) / 2 - 1)
    local col = math.floor((vim.o.columns - width) / 2)

    -- Create a buffer
    local buf = nil
    if (vim.api.nvim_buf_is_valid(opts.buf)) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true) -- no file, scratch buffer
    end

    -- Open floating window
    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'rounded',  -- default border
    })

    -- Optional buffer options
    if opts.buf_options then
        for k, v in pairs(opts.buf_options) do
            -- vim.api.nvim_buf_set_option(buf, k, v)
            vim.api.nvim_set_option_value(k, v, {buf = buf})
        end
    end

    return {buf = buf, win = win}
end

local function toggle_terminal()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = open_floating_window({buf = state.floating.buf})
        if vim.bo[state.floating.buf].buftype ~= 'terminal' then
            vim.cmd.terminal()
            vim.cmd.startinsert()
        end
        vim.cmd.startinsert()
    else
        vim.api.nvim_win_hide(state.floating.win)
    end
end

vim.api.nvim_create_user_command("FloatingTerminal", toggle_terminal, {})
vim.keymap.set({'n', 't'}, '<A-t>', toggle_terminal)
