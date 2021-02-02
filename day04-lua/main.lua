require("passport")

function lines_from(file)
    lines = {}
    for line in io.lines(file) do 
        lines[#lines + 1] = line
    end
    return lines
end


local file = 'data'
local lines = lines_from(file)
local passports = get_passports(lines)

print("Result: " .. count_valid(passports))
