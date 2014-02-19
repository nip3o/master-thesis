
module Humm
  class Meep
    attr_accessor :age

    def self.plusone_map_each(arr)
      arr.map { |e| e + 1 }
    end

    def self.kaka(arr)
      plusone_map_each(arr + [100])
    end

    def dog_age
      @age * 7
    end
  end
end

module Injector
  def self.helper(callee, callr, obj, ret, *args)
    instance_vars = obj.instance_variables
    values = instance_vars.map { |var| obj.instance_variable_get var }

    inst = instance_vars.zip(values)
    puts "Method '#{callee}' called from #{callr} with args #{args.inspect}, #{inst} => #{ret}"
  end

  def self.do_injection(real_klass, method)
    old_method = real_klass.send(:instance_method, method)

    real_klass.send(:define_method, method) do |*args|
      ret = old_method.bind(self).(*args)
      Injector::helper(__callee__, caller(), self, ret, *args)
      ret
    end
  end

  def self.inject(klass, method)
    if klass.instance_methods.include? method
      self.do_injection(klass, method)
    elsif klass.singleton_class.instance_methods.include? method
      self.do_injection(klass.singleton_class, method)
    else
      raise ArgumentError, "Class '#{klass.name}' has no method '#{method}'"
    end
  end
end

p Humm::Meep.kaka([3, 4, 1])
p Humm::Meep.new.age
puts '#' * 80

Injector.do_injection(Humm::Meep.singleton_class, :kaka)
Injector.inject(Humm::Meep, :plusone_map_each)
Injector.inject(Humm::Meep, :dog_age)

p Humm::Meep.kaka([3, 4, 1])

dog = Humm::Meep.new
dog.age = 3

p dog.dog_age
