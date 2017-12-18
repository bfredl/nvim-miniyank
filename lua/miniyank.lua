local mp = require"MessagePack"
--inspect = require"inspect"
mp.set_string('binary')

local function lua2vim(t)
    if type(t) ~= "table" then
        return t
    end
    local l = vim.list()
    for _,v in ipairs(t) do
        l:add(lua2vim(v))
    end
    return l
end
local list_t = getmetatable(vim.list())
local function vim2lua(l)
    if getmetatable(l) ~= list_t then
        return l
    end
    local t = {}
    for v in l() do
        t[#t+1] = vim2lua(v)
    end
    return t
end

local function read(fn)
    local file = io.open(fn, 'rb')
    data = file:read('*all')
    res = vim.list()
    for p,item in mp .unpacker(data) do
        x = item
        res:add(lua2vim(item))
    end
    file:close()
    return res
end
local function write(fn,data)
    local file = io.open(fn, 'wb')
    for item in data() do
        file:write(mp.pack(vim2lua(item)))
    end
    file:close()
end

return {read=read,write=write}
