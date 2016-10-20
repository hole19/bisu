module Bisu
  class KnowledgeBase
    def initialize(kb)
      raise "Bad KB format (expected Hash)"             unless kb.is_a?(Hash)
      raise "Bad KB format (expected :languages Array)" unless kb.key?(:languages) && kb[:languages].is_a?(Array)
      raise "Bad KB format (expected :keys Hash)"       unless kb.key?(:keys)      && kb[:keys].is_a?(Hash)
      @kb = kb
    end

    def has_language?(language)
      @kb[:languages].include?(language)
    end

    def localize(key, language)
      if locals = @kb[:keys][key]
        locals[language]
      else
        nil
      end
    end
  end
end
