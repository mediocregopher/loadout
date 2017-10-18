local io = io
local math = math
local tonumber = tonumber
local tostring = tostring
local string = string
local naughty = require("naughty")

function volumeInfo()
    volmin = 0
    volmax = 65536
    local f = io.popen("pacmd dump |grep set-sink-volume|grep analog-stereo")
    local g = io.popen("pacmd dump |grep set-sink-mute|grep analog-stereo")
    local v = f:read()
    local mute = g:read()
    if mute ~= nil and string.find(mute, "no") then
        volume = math.floor(tonumber(string.sub(v, string.find(v, 'x')-1)) * 100 / volmax)
    else
        volume = "off"
    end
    f:close()
    g:close()
    return "vol:"..volume.."   "
end

function muteAll()
    local outh = io.popen("pactl list short sources | awk '{print $1}'")
    while true do
        local i = outh:read()
        if i == nil then break end
        io.popen("pactl set-source-mute " .. i .. " 1"):close()
    end
    outh:close()
end

function unmuted()
    local outh = io.popen("pactl list sources | grep 'Mute: no'")
    local any = outh:read()
    outh:close()
    return any ~= nil
end
