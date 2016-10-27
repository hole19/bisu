module Bisu
  class Config
    def initialize(hash:)
      @hash = deep_sym(hash)
      validate_structure!(@hash)
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

    VALID_STRUCTURE = {
      type: Hash,
      keys: {
        type: { type: String },
        sheet_id: { type: String },
        keys_column: { type: String },
        in: { type: Array, elements: {
          type: String
        } },
        out_path: { type: String },
        out: { type: Array, elements: {
          type: Hash,
          keys: {
            locale: { type: String },
            kb_language: { type: String },
            path: { type: String, mandatory: false }
          }
        } }
      }
    }

    def validate_structure!(value, structure=VALID_STRUCTURE, error_prefix=["value"])
      if value == nil && structure.key?(:mandatory) && !structure[:mandatory]
        return
      end

      prepend_error = "Invalid structure! #{error_prefix.join}:"

      unless value.is_a? structure[:type]
        raise ArgumentError.new("#{prepend_error} Expected #{structure[:type]}, got #{value.class}")
      end

      case value
      when Array
        value.each_with_index do |elem, i|
          validate_structure!(elem, structure[:elements], error_prefix + ["[#{i}]"])
        end
      when Hash
        mandatory_keys = structure[:keys].map { |k,s| k unless s.key?(:mandatory) && !s[:mandatory] }.compact

        unless (missing = mandatory_keys - value.keys).empty?
          raise ArgumentError.new("#{prepend_error} Missing keys: #{missing.join(', ')}")
        end

        structure[:keys].each do |key, structure|
          validate_structure!(value[key], structure, error_prefix + ["[:#{key}]"])
        end
      end
    end
  end
end
