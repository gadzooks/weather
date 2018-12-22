# To use this module :
# 1. define constant MY_ATTRIBUTES in your class
# 2. setup attr_writer for all those attributes
module InitializeFromHash

  def setup_instance_variables(input)
    if !defined? self.class::MY_ATTRIBUTES
      raise "Internal Error : Need MY_ATTRIBUTES declared before using this module"
    end

    unless input.blank?
      self.class::MY_ATTRIBUTES.each do |ivar|
        method_name = "#{ivar}="
        value = input[ivar.to_s] || input[ivar.to_sym]
        # we pass true to respond_to? to include private and protected methods
        # too
        if !value.blank? && self.respond_to?(method_name, true)
          send(method_name, value)
        end
      end
    end
  end

end
