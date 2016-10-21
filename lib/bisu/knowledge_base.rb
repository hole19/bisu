module Bisu
  class KnowledgeBase
    def initialize(keys)
      unless keys.is_a?(Hash)
        raise "Bad KB format: expected Hash"
      end

      keys.each do |key,v|
        unless v.is_a?(Hash)
          raise "Bad KB format: expected Hash value for key '#{key}'"
        end

        v.each do |lang,v|
          unless v.is_a?(String)
            raise "Bad KB format: expected String value for key '#{key}', language '#{lang}'"
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
