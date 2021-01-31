class MaskGroup

    def initialize(mask, values)
        @mask = mask
        @values = values
      end

    def mask=(value)
      @mask = value
    end
    
    def mask
      return @mask
    end
    
    def values
      return @values
    end

    def apply(all_memory)
        mask_or = @mask.gsub("X", "0").to_i(2)
        mask_and = @mask.gsub("X", "1").to_i(2)

        @values.each { |item|
            all_memory[item.memory] = (item.value | mask_or) & mask_and
        }
    end

    def apply_v2(all_memory)

        mask_or = @mask.gsub("X", "0").to_i(2)

        get_sub_masks(@mask.gsub("0", "Z").gsub("1", "Z")).each { |mask_and_string|
            
            @values.each { |item|
                mask_or2 = mask_and_string.gsub("Z", "0").to_i(2)
                mask_and = mask_and_string.gsub("Z", "1").to_i(2)
                memory_address = (item.memory.to_i | mask_or | mask_or2) & mask_and

                all_memory[memory_address.to_s] = item.value

            }
        }

    end

    def get_sub_masks(mask) 
        if(mask.length == 1) 
            if (mask == "X")
                return ["0", "1"]
            else
                return [mask]
            end
        end

        values = []

        get_sub_masks(mask[1..-1]).each { |item|
            if (mask[0] == "X")
                values.push("0" + item, "1" + item)
            else
                values.push(mask[0] + item)
            end
        }

        return values
    end

end

class MemoryValue

    def initialize(memory, value)
        @memory = memory
        @value = value
      end

    def memory
      return @memory
    end
    
    def value
      return @value
    end

end

lines = File.readlines("data.txt")

current_mask = ""
values = []
groups = []

lines.each { |line|
    if (line.start_with?("mask"))
        current_mask = line[/mask = (.*)/, 1]
        values = []
        groups.push(MaskGroup.new(current_mask, values))

    else
        values.push(MemoryValue.new(line[/mem\[(\d*)\].*/, 1], line[/mem\[\d*\] = (\d*)/, 1].to_i))
    end
}

all_memory = Hash.new

groups.each { |item|
    item.apply(all_memory)
}

sum = 0
all_memory.each { |key, value|
    sum += value
}

puts "result : #{sum}"


all_memory2 = Hash.new

groups.each { |item|
    item.apply_v2(all_memory2)
}

sum2 = 0
all_memory2.each { |key, value|
    sum2 += value
}

puts "result : #{sum2}"
