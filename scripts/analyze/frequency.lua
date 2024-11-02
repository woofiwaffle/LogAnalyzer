local log_directory = arg[1] 
local report_file = arg[2]    
local counts = {INFO = 0, WARN = 0, ERROR = 0}

local function count_log_levels(log_file)
    print("Processing file: " .. log_file)  
    local file_handle = io.open(log_file, "r")
    if not file_handle then
        print("Error: Unable to open file " .. log_file)  
        return
    end
    
    for line in file_handle:lines() do
        if line:find("INFO") then
            counts.INFO = counts.INFO + 1
        elseif line:find("WARN") then
            counts.WARN = counts.WARN + 1
        elseif line:find("ERROR") then
            counts.ERROR = counts.ERROR + 1
        end
    end
    
    file_handle:close()  
end

local handle = io.popen('dir "' .. log_directory .. '\\application.log.*" /b') 
if handle then
    for file in handle:lines() do
        count_log_levels(log_directory .. '\\' .. file)  
    end
    handle:close()  
else
    print("Error: Unable to list files in directory " .. log_directory)
end

local output = io.open(report_file, "w")
output:write("Level,Count\n")
for level, count in pairs(counts) do
    output:write(string.format("%s,%d\n", level, count))
end
output:close()

print("Frequency report written to " .. report_file)



-- lua54 scripts/analyze/frequency.lua "backup_logs" "reports/frequency_report.csv"