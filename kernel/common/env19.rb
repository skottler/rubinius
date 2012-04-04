module Rubinius
  class EnvironmentVariables
    def []=(key, value)
      key = StringValue(key)
      if value.nil?
        unsetenv(key)
      else
        if setenv(key, StringValue(value), 1) != 0
          Errno.handle("setenv")
        end
      end
      value
    end

    alias_method :store, :[]=

    def keep_if(&block)
      return to_enum(:keep_if) unless block_given?
      reject! {|k, v| !block.call(k, v) }
      self
    end

    def set_encoding(value)
      return unless value.kind_of? String
      value.force_encoding Encoding.find("locale")
    end

    private :set_encoding
  end
end
