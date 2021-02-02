function string:split(delimiter)
    local result = { }
    local from  = 1
    local delim_from, delim_to = string.find( self, delimiter, from  )
    while delim_from do
      table.insert( result, string.sub( self, from , delim_from-1 ) )
      from  = delim_to + 1
      delim_from, delim_to = string.find( self, delimiter, from  )
    end
    table.insert( result, string.sub( self, from  ) )
    return result
end

function table_length(collection)
    local count = 0
    for _ in pairs(collection) do count = count + 1 end
    return count
end

function get_passports(lines)
    local passport_properties = nil
    local passports = {}

    -- Analyse file lines
    for _,line in ipairs(lines) do
    
        if line == nil or line == '' then
            passport_properties = nil
        else
            if passport_properties == nil then
                passport_properties = {}
                passports[#passports + 1] = passport_properties;
            end
            local groups = line:split(" ")

            for _, group in ipairs(groups) do
                local key_value = group:split(":")
                passport_properties[key_value[1]] = key_value[2]
            end
        end
    end

    return passports
end

function validate_passport(passport)
    local byr = tonumber(passport["byr"])
    if byr < 1920 or byr > 2002 or string.len(passport["byr"]) ~= 4 then
        return false
    end

    local iyr = tonumber(passport["iyr"])
    if iyr < 2010 or iyr > 2020 or string.len(passport["iyr"]) ~= 4 then
        return false
    end

    local eyr = tonumber(passport["eyr"])
    if eyr < 2020 or eyr > 2030 or string.len(passport["eyr"]) ~= 4 then
        return false
    end

    if not (passport["hgt"]:match("in$") or passport["hgt"]:match("cm$")) then
        return false
    end

    local size = tonumber(passport["hgt"]:sub(1, #passport["hgt"] - 2))

    if passport["hgt"]:match("in$") and (size < 59 or size > 76) then
        return false
    end

    if passport["hgt"]:match("cm$") and (size < 150 or size > 193) then
        return false
    end

    if not passport["hcl"]:match("^#[a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]$") then
        return  false
    end

    local ecl_values = { amb = true, blu = true, brn = true, gry = true,
                         grn = true, hzl = true, oth = true }

    if not ecl_values[passport["ecl"]] then
        return false
    end

    if not passport["pid"]:match("^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$") then
        return  false
    end

    return true
end

function count_valid(passports)
    local count = 0

    for _, passport in ipairs(passports) do
        local expected_properties = 7;
        if passport["cid"] then
            expected_properties = expected_properties + 1 
        end

        if table_length(passport) == expected_properties and validate_passport(passport) then
            count = count + 1
        end
    end

    return count
end
