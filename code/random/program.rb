require 'parser/current'

def plusone_map_each(arr)
  arr.map { |e| e + 1 }
end

def plusone_map_do(arr)
  arr.map do |e|
    e + 1
  end
end

def plusone_each(arr)
  result = Array.new
  arr.each { |x| result << x + 1 }
  result
end

def plusone_range_inline(arr)
  result = Array.new
  (0..arr.length - 1).each { |n| result << arr[n] + 1 }
  result
end

def plusone_range_variable(arr)
  result = Array.new
  len = arr.length - 1
  (0..len).each { |n| result << arr[n] + 1 }
  result
end

p plusone_range_variable([1, 2, 3])
