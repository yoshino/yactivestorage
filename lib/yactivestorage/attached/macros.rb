module Yactivestorage::Attached::Macros
  def has_one_attached(name)
    define_method(name) do
      instance_variable_get("@yactivestorage_attached_#{name}") ||
        instance_variable_set("@yactivestorage_attached_#{name}", Yactivestorage::Attached::One.new(name, self))
    end
  end

  def has_many_attached(name)
    define_method(name) do
      instance_variable_get("@yactivestorage_attached_#{name}") ||
        instance_variable_set("@yactivestorage_attached_#{name}", Yactivestorage::Attached::Many.new(name, self))
    end
  end
end 
