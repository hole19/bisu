require "yaml"

module Bisu
  class Config
    def initialize(file:)
      raise ArgumentError.new("file: expected File, got #{file.class}") unless file.is_a? File
      @hash = deep_sym(YAML::load(file))
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
