
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

def inject(mod, klass, method)
  injector_class = Class.new(klass) do
    def self._inject(method)
      self.singleton_class.send(:alias_method, '_old_' + method, method)
      self.singleton_class.send(:define_method, method) do |*args|
        puts "Method '#{__callee__}' called from #{caller} with args #{args.inspect}"
        self.send('_old_' + method, *args)
      end
    end
  end

  class_name = klass.name.split('::').last
  suppress_warnings do
    mod.const_set(class_name, injector_class)
  end
  injector_class._inject(method)
end

p Humm::Meep.kaka([3, 4, 1])
puts '#' * 40

inject(Humm, Humm::Meep, 'kaka')
inject(Humm, Humm::Meep, 'plusone_map_each')

p Humm::Meep.kaka([3, 4, 1])
