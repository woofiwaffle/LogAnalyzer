local log_file = arg[1]

if not log_file or log_file == "" then
    print("Error: No log file provided.")
    os.exit(1)
end

local file = io.open(log_file, "r")
if not file then
    print("Error: Cannot open log file.")
    os.exit(1)
end
file:close()

local info_count = 0
local warn_count = 0
local error_count = 0

for line in io.lines(log_file) do
    if line:match("%S") then
        if line:find("INFO", 1, true) or line:find("info", 1, true) then
            info_count = info_count + 1
        elseif line:find("WARN", 1, true) or line:find("warn", 1, true) then
            warn_count = warn_count + 1
        elseif line:find("ERROR", 1, true) or line:find("error", 1, true) then
            error_count = error_count + 1
        end
    end
end

if info_count == 0 and warn_count == 0 and error_count == 0 then
    print("Warning: No log entries found or file is empty.")
end

print(info_count .. "," .. warn_count .. "," .. error_count)