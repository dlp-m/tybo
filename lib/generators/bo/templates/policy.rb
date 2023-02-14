module Bo
  module <%= options[:namespace].camelize %>
    class <%= class_name %>Policy < Bo::<%= options[:namespace].camelize %>Policy
    end
  end
end
