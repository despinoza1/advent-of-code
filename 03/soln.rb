class Gear
  def initialize(value_str, start_idx, end_idx)
    @value = value_str.to_i
    @start_idx = start_idx
    @end_idx = end_idx
  end

  def return_value
    return @value
  end

  def return_start_idx
    return @start_idx
  end

  def return_end_idx
    return @end_idx
  end
end

def is_symbol(ch)
  return !ch.match?(/[[:digit:]]/) && ch != "."
end

def check_around(lines, line, gear, curr_row)
  start_idx = gear.return_start_idx
  end_idx = gear.return_end_idx

  # Check left
  if start_idx != 0 && is_symbol(line[start_idx-1])
    return true
  # Check right
  elsif end_idx+1 != line.size && is_symbol(line[end_idx+1])
    return true
  end

  # Check previous row
  if curr_row != 0
    prev_start = start_idx != 0 ? start_idx - 1 : start_idx
    prev_end = end_idx < line.size-1 ? end_idx + 1 : end_idx

    for i in prev_start..prev_end do
      if is_symbol(lines[curr_row-1][i])
        return true
      end
    end
  end

  # Check next row
  if curr_row < lines.size-1
    next_start = start_idx != 0 ? start_idx - 1 : start_idx
    next_end = end_idx < line.size-1 ? end_idx + 1 : end_idx

    for i in next_start..next_end do
      if is_symbol(lines[curr_row+1][i])
        return true
      end
    end
  end

  return false
end

file = File.open(ARGV[0])
lines = file.readlines.map(&:chomp)
file.close

total = 0
nums = Array.new

lines.each_index {|i|
  line = lines[i]
  puts line

  line_nums = Array.new
  start_index = -1
  end_index = -1
  line.split("").each_index {|j| 
    if line[j].match?(/[[:digit:]]/)
      if start_index == -1
        start_index = j
      end
      end_index = j

      if end_index == line.size-1
        gear = Gear.new(line[start_index..end_index], start_index, end_index)

        if check_around(lines, line, gear, i)
          total += gear.return_value
          line_nums.push(gear)
          start_index = -1
        end
      end
    else
      if start_index != -1
        gear = Gear.new(line[start_index..end_index], start_index, end_index)

        if check_around(lines, line, gear, i)
          total += gear.return_value
          line_nums.push(gear)
        end
        start_index = -1
      end
    end
  }
  nums.push(line_nums)
}

puts sprintf "Total: %d", total

total = 0

lines.each_index {|i|
  line = lines[i]

  line.split("").each_index {|j| 
    if is_symbol(line[j])
     adj_nums = Array.new

     # Left or right
     nums[i].each { |num|
      if num.return_start_idx-1 == j || num.return_end_idx+1 == j
        adj_nums.push(num.return_value)
      end
     }
     
     # Above
     if i != 0
       nums[i-1].each { |num|
        if num.return_start_idx-1 <= j && j <= num.return_end_idx+1
          adj_nums.push(num.return_value)
        end
       }
     end

     # Below
     if i != lines.size-1
       nums[i+1].each { |num|
        if num.return_start_idx-1 <= j && j <= num.return_end_idx+1
          adj_nums.push(num.return_value)
        end
       }
     end

     if adj_nums.size == 2
      total += adj_nums.reduce(1, :*)
     end
    end
  }
}

puts sprintf "Ratio: %d", total
