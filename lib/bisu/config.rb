require "yaml"

module Bisu
  class Config
    def initialize(file:)
      raise ArgumentError.new("file: expected String, got #{file.class}") unless file.is_a? String
      raise ArgumentError.new("File '#{file}' does not exist")            unless File.exists?(file)

      @hash = deep_sym(YAML::load_file(file))
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
