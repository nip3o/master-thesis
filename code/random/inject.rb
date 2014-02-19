
class Meep
  def self.plusone_map_each(arr)
    arr.map { |e| e + 1 }
  end

  def self.kaka(arr)
    plusone_map_each(arr)
  end
end

class Meep
  def self._inject(method)
    self.singleton_class.send(:alias_method, '_old_' + method, method)
    self.singleton_class.send(:define_method, method) do |*args|
      puts "Method '#{__callee__}' called from #{caller} with args #{args.inspect}"
      self.send('_old_' + method, *args)
    end
  end
end

p Meep::kaka([3, 4, 1])
puts '#' * 40
Meep::_inject('plusone_map_each')
Meep::_inject('kaka')
p Meep::kaka([3, 4, 1])
