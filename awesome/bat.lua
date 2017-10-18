local io = io
local math = math
local tonumber = tonumber
local string = string
local naughty = require("naughty")

function batteryInfo()
    for i=0,1 do
        local dir = "/sys/class/power_supply/BAT" .. tostring(i) .. "/"
        local f_status = io.popen("cat " .. dir .. "status 2>/dev/null")
        local c_status = f_status:read()
        f_status:close()

        if c_status and c_status ~= "" then
            local prefix = "energy"
            local f_now  = io.popen("cat " .. dir .. prefix .. "_now 2>/dev/null")
            local c_now_str  = f_now:read()
            f_now:close()

            if not c_now_str or c_now_str == "" then
                prefix = "charge"
                local f_now  = io.popen("cat " .. dir .. prefix .. "_now")
                c_now_str  = f_now:read()
                f_now:close()
            end

            local f_full = io.popen("cat " .. dir .. prefix .. "_full")
            local c_full_str = f_full:read()
            f_full:close()

            local c_now  = tonumber(c_now_str)
            local c_full = tonumber(c_full_str)

            local charging = (c_status == "Charging" or c_status == "Full")

            if c_now ~= nil and c_full ~= nil then
                local percent = math.floor((c_now/c_full) * 100)
                return percent, charging
            end
        end
    end
    return nil, charging
end
