--| We are modifying hightlight colors based on data in a file. In particular the fft of whatever is being played in the audio

--- Executes a function on an interval
---
--- @param interval number How long to wait between executions of `callback`
--- @param callback function The callback to be executed
--- @return table
local function setInterval(interval, callback)
    local timer = vim.uv.new_timer()
    timer:start(interval, interval, function()
        callback()
    end)
    return timer
end

--- Trims whitespace from both ends of a string
---@param s string The string to trim
---@return string The trimmed string
local function trim(s)
    return s:match("^%s*(.-)%s*$")
end

-- We want to read the data from a file.
-- This could be a fifo (would block the server) but only 1 thing can read it at a time.
-- So it should be a simple text file.
-- So we want a single file to read lines from

--- Gets the
---@return table
local function get_contents()
    local path = "/home/kris/test"

    local file, err = io.open(path, "r");

    if not file then
        print("Error opening file (" .. path ..") : " .. (err))
        return { r=0, g=0, b=0}
    end

    -- Each line of the file acts as a delta
    local contents = {}
    for line in file:lines()
    do
        local num = tonumber(line)
        if num == nil then
            print(line)
        end

        table.insert(contents, tonumber(line))
    end

    --local r = tonumber(file:read("*l")) or 0
    --local g = tonumber(file:read("*l")) or 0
    --local b = tonumber(file:read("*l")) or 0

    -- print("r: "..r..", g:"..g..", b:"..b)

    file:close()

    return contents
end

local MyColor = {}
MyColor.__index = MyColor

--- Construct a new MyColor
---@param hex string | number Hex color code, numerical value, or if g and b defined then the red color
---@param g number The amount of green
---@param b number The amount of blue
---@return MyColor r
function MyColor.new(hex, g, b)
    local self = setmetatable({}, MyColor)

    if g and b and hex then
        self.r = hex
        self.g = g
        self.b = b
    elseif type(hex) == "string" then
        self:fromHex(hex)
    else
        local hexx = string.format("#%02x", hex)
        self:fromHex(hexx)
    end

    self.r = self.r or 0
    self.g = self.g or 0
    self.b = self.b or 0

    return self
end

---Convert a hex code to an rgb tuple
---@param hex string
function MyColor:fromHex(hex)
    --- I don't like the definition of this function but we are just cleaning things up.
    --- There should be a createColorFromHex or something or this should return a new MyColor or something
    if hex:sub(1,1) == "#" then
        hex = hex:sub(2)
    end

    -- Get the color components
    local color = hex
    local r = tonumber(color:sub(1,2), 16)
    local g = tonumber(color:sub(3,4), 16)
    local b = tonumber(color:sub(5,6), 16)

    self.r = r
    self.g = g
    self.b = b

    return self
end

--- Convert color to a hex code
---@return string
function MyColor:toHex()
    return string.format("#%02x%02x%02x", self.r, self.g,self.b)
end

local function log(r,g,b)
    print("("..r..", "..g..", "..b.." )")
end


--- Apply rgb delta
---@param dr number Delta R
---@param dg number Delta G
---@param db number Delta B
function MyColor:addDelta(dr, dg, db)
    local r = self.r * dr % 256
    local g = self.g * dg % 256
    local b = self.b * db % 256

    return MyColor.new(r,g,b)
end

--- Replace rgb value
---@param nr number new R
---@param ng number new G
---@param nb number new B
function MyColor:replace(nr, ng, nb)
    local r = nr ~= nil and nr  or self.r
    local g = ng ~= nil and ng  or self.g
    local b = nb ~= nil and nb  or self.b

    return MyColor.new(r,g,b)

end

function MyColor:print()
    log(self.r, self.g, self.b)
end

--- Convert to numerical value
---@return number
function MyColor:toNumber()
    return tonumber(self:toHex(), 16)
end

local function set_color(hl_name, color)
    vim.api.nvim_set_hl(0, hl_name, {
        fg = color:toHex()
    })
end

local function get_avg(contents, start_idx, end_idx)
    local value = 0

    for i = start_idx, end_idx do
        local v = contents[i] or 0
        value = value + v
    end

    return (value / (end_idx - start_idx))

end

local function get_max(contents, start_idx, end_idx)
    local value = 0

    for i = start_idx, end_idx do
        local v = contents[i] or 0
        value = math.max(value, v)
    end

    return value
end

local function generate_color_value(contents, center, spread)
    return get_max(contents, center-spread, center + spread)
    --return get_avg(contents, center - spread , center + spread)
end

function Start()
    local hl = vim.api.nvim_get_hl(0, { name="LineNr" })
    local fg = hl.fg
    local hl_color = MyColor.new(fg)

    Timer = setInterval(1000/25, function()
        vim.defer_fn(function()
            local contents = get_contents()

            local only_red = MyColor.new(generate_color_value(contents, 100, 75), 0, 0)
            local only_green =MyColor.new(0, generate_color_value(contents, 400, 200), 0)
            local only_blue =MyColor.new(50, 50, generate_color_value(contents, 1014, 10))

            set_color("LineNrAbove", only_green)
            set_color("LineNrBelow", only_red)
            set_color("LineNr", only_blue)
        end, 0)
    end)
end

function Stop()
    Timer:stop()
    Timer:close()
end
