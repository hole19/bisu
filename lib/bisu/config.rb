module Bisu
  class Config
    def initialize(hash:)
      raise ArgumentError.new("hash: expected Hash, got #{hash.class}") unless hash.is_a? Hash
      @hash = deep_sym(hash)
    end

    def to_h
      @hash
    end

    private

    def deep_sym(obj)
      if obj.is_a?(Array)
        obj.map { |v| deep_sym(v) }
      elsif obj.is_a?(Hash)
        obj.inject({}) { |memo, (k,v)| memo[k.to_sym] = deep_sym(v); memo }
      else
        obj
      end
    end
  end
end
