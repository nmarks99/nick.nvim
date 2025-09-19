-- ==============================
--            Extras
-- ==============================
-- Extra custom functionality


-- --------------------------
-- Terminal
-- See `:help terminal
-- Settings for built in terminal including floating
-- toggleable terminal and useful keymaps
-- --------------------------
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
        border = 'rounded', -- default border
    })

    -- Optional buffer options
    if opts.buf_options then
        for k, v in pairs(opts.buf_options) do
            -- vim.api.nvim_buf_set_option(buf, k, v)
            vim.api.nvim_set_option_value(k, v, { buf = buf })
        end
    end

    return { buf = buf, win = win }
end

local function toggle_terminal()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = open_floating_window({ buf = state.floating.buf })
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
vim.keymap.set({ 'n', 't' }, '<A-t>', toggle_terminal)



-- --------------------------
-- EPICS
-- --------------------------
-- Substitutions file formatter

local function strip_whitespace(str)
    local cleaned = str:gsub("^%s+", ""):gsub("%s+$", "")
    return cleaned
end

local function max_table(t1, t2)
    assert(#t1 == #t2, "tables must be the same length")
    local tout = {}
    for i = 1, #t1 do
        tout[i] = t1[i] > t2[i] and t1[i] or t2[i]
    end
    return tout
end

local function parse(text)
    -- get start and end indices of data sections
    local lines = {}
    for line in text:gmatch("[^\r\n]+") do
        table.insert(lines, strip_whitespace(line))
    end

    local data_lines = {}
    local col_widths = {}
    local i_data = 0
    local in_data_block = false
    for i, line in ipairs(lines) do
        data_lines[i] = false
        if in_data_block then
            if strip_whitespace(line) == "}" then
                in_data_block = false
                data_lines[i] = false
            else
                data_lines[i] = true
                local col_widths_i = {}
                for field in line:gmatch("[^,{}]+") do
                    local len = #strip_whitespace(field)
                    table.insert(col_widths_i, len)
                end
                if col_widths[i_data] then
                    col_widths[i_data] = max_table(col_widths_i, col_widths[i_data])
                else
                    col_widths[i_data] = col_widths_i
                end
            end
        end

        if line:find("pattern") then
            -- only if line doesn't start with "#" (comment)
            if line:match("^%s*#") == nil then
                in_data_block = true
                i_data = i_data + 1
            end
        end
    end

    return {
        lines = lines,
        data_lines = data_lines,
        col_widths = col_widths
    }
end

local function format(subs_file_content)
    local subs = parse(subs_file_content)
    local formatted_text = ""

    local i_data = 1
    local in_data_block = false
    for i, line in ipairs(subs.lines) do
        if subs.data_lines[i] then
            in_data_block = true

            -- get all the fields and strip the leading/trailing whitespace
            local fields = {}
            for f in line:gmatch("[^,{}]+") do
                table.insert(fields, strip_whitespace(f))
            end

            -- build the formatting string for this line
            formatted_text = formatted_text .. "{"
            for j, field in ipairs(fields) do
                local pad = string.rep(" ", subs.col_widths[i_data][j] - #field)
                formatted_text = formatted_text .. pad .. field
                if j == #fields then
                    formatted_text = formatted_text .. "}"
                else
                    formatted_text = formatted_text .. ",  "
                end
            end
            formatted_text = formatted_text .. "\n"
        else
            -- if this isn't a data line, just add the line as is
            formatted_text = formatted_text .. line
            -- update the indices and flags, add new lines as needed
            local new_lines = 0
            if in_data_block then
                i_data = i_data + 1
                if i ~= #subs.lines then
                    new_lines = new_lines + 1
                end
            end
            if i ~= #subs.lines then
                new_lines = new_lines + 1
            end
            formatted_text = formatted_text .. string.rep("\n", new_lines)
            in_data_block = false
        end
    end

    return formatted_text
end

local function format_subs()
    local buf = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(buf)

    -- do nothing if it isn't a substitutions file
    if not filename:match("%.substitutions") then
        print("Not a substitutions file")
        return
    end

    -- get the current buffer lines and combine to a single string
    local buf_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local buf_contents = table.concat(buf_lines, "\n")

    -- Format the substitutions file
    local formatted_text = format(buf_contents)
    local formatted_lines = {}

    -- split the formatted content to a table, preserving intentionally blank lines
    for line in (formatted_text .. "\n"):gmatch("([^\n]*)\n") do
        table.insert(formatted_lines, line)
    end

    -- set the buffer equal to the formatted lines
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted_lines)
end

vim.api.nvim_create_user_command("FormatSubstitutions", format_subs, {})
