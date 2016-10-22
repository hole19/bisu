module Bisu
  class Dictionary
    def initialize(keys)
      unless keys.is_a?(Hash)
        raise ArgumentError.new("keys: expected Hash")
      end

      keys.each do |key,v|
        unless v.is_a?(Hash)
          raise ArgumentError.new("keys['#{key}']: expected Hash")
        end

        v.each do |lang,v|
          unless v.is_a?(String) || v.nil?
            raise ArgumentError.new("keys['#{key}']['#{lang}']: expected String")
          end
        end
      end

      @keys = keys
    end

    def has_language?(language)
      languages.include?(language)
    end

    def localize(key, language)
      if locals = @keys[key]
        locals[language]
      else
        nil
      end
    end

    private

    def languages
      @languages ||= begin
        @keys.map { |_,v| v.keys }.flatten.uniq
      end
    end
  end
end
