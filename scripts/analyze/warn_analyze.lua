local log_directory = arg[1] 
local output_file = arg[2]    
local warn_counts = {}      
local warn_messages = {}      

local function count_warnings_in_file(log_file)
    print("Processing file: " .. log_file)
    local file_handle = io.open(log_file, "r")
    if not file_handle then
        print("Error: Unable to open file " .. log_file)
        return
    end

    for line in file_handle:lines() do
        local warn_message = line:match("WARN (.*)")
        if warn_message then
            warn_counts[warn_message] = (warn_counts[warn_message] or 0) + 1
            if not warn_messages[warn_message] then
                table.insert(warn_messages, warn_message)  
            end
        end
    end

    file_handle:close()
end

local handle = io.popen('dir "' .. log_directory .. '\\application.log.*" /b')  
if handle then
    for log_file in handle:lines() do
        count_warnings_in_file(log_directory .. '\\' .. log_file)  
    end
    handle:close()
else
    print("Error: Unable to list files in directory " .. log_directory)
end

local output = io.open(output_file, "w")
output:write("Warning Message,Count\n")

for message, count in pairs(warn_counts) do
    output:write(string.format("%s,%d\n", message, count))
end

output:close()
print("Warning analysis report written to " .. output_file)



-- lua54 scripts/analyze/warn_analyze.lua "backup_logs" "reports/warn_report.csv"