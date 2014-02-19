
def suppress_warnings
  original_verbosity = $VERBOSE
  $VERBOSE = nil
  result = yield
  $VERBOSE = original_verbosity
  return result
end


module Humm
  class Meep
    def self.plusone_map_each(arr)
      arr.map { |e| e + 1 }
    end

    def self.kaka(arr)
      plusone_map_each(arr + [100])
    end
  end
end

module Injector
  def self.helper(callee, callr, *args)
    puts "Method '#{callee}' called from #{callr} with args #{args.inspect}"
  end

  def self.inject(klass, method)
    old_method_name = '_old_' + method
    klass.singleton_class.send(:alias_method, old_method_name, method)
    klass.singleton_class.send(:define_method, method) do |*args|
      Injector::helper(__callee__, caller, *args)
      self.send(old_method_name, *args)
    end
  end
end

p Humm::Meep.kaka([3, 4, 1])
puts '#' * 40

Injector.inject(Humm::Meep, 'kaka')
Injector.inject(Humm::Meep, 'plusone_map_each')

p Humm::Meep.kaka([3, 4, 1])
