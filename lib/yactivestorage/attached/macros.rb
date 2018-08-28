module Yactivestorage::Attached::Macros
  def has_one_attached(name, dependent: :purge_later)
    define_method(name) do
      instance_variable_get("@yactivestorage_attached_#{name}") ||
        instance_variable_set("@yactivestorage_attached_#{name}", Yactivestorage::Attached::One.new(name, self))
    end
    
    if dependent == :purge_later
      before_destroy { public_send(name).purge_later }
    end
  end

  def has_many_attached(name, dependent: :purge_later)
    define_method(name) do
      instance_variable_get("@yactivestorage_attached_#{name}") ||
        instance_variable_set("@yactivestorage_attached_#{name}", Yactivestorage::Attached::Many.new(name, self))
    end

    if dependent == :purge_later
      before_destroy { public_send(name).purge_later }
    end
  end
end
