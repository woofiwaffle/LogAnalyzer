local log_file = arg[1]
local info_count = 0
local warn_count = 0
local error_count = 0

for line in io.lines(log_file) do
    if line:find("INFO") then
        info_count = info_count + 1
    elseif line:find("WARN") then
        warn_count = warn_count + 1
    elseif line:find("ERROR") then
        error_count = error_count + 1
    end
end

print(info_count .. "," .. warn_count .. "," .. error_count)
