require "yaml"

module Bisu
  class Config
    def self.parse(file_name)
      unless file_name
        Logger.error("Config file not provided")
        return nil
      end

      unless File.exists?(file_name)
        Logger.error("Could not find config file #{file_name}")
        return nil
      end

      begin
        deep_sym(YAML::load_file(file_name))
      rescue Exception => e
        Logger.error("Could not parse config file #{file_name}: #{e}")
        return nil
      end
    end

    def self.deep_sym(obj)
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
