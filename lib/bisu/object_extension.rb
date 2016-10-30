Object.class_eval do
  def deep_symbolize
    case self
    when Array
      self.map { |v| v.deep_symbolize }
    when Hash
      self.inject({}) { |memo, (k,v)| memo[k.to_sym] = v.deep_symbolize; memo }
    else
      self
    end
  end

  def validate_structure!(structure, error_prefix=[])
    return if self == nil && structure[:optional]

    prepend_error = error_prefix.empty? ? "" : (["self"] + error_prefix + [": "]).join

    unless self.is_a? structure[:type]
      raise ArgumentError.new("#{prepend_error}Expected #{structure[:type]}, got #{self.class}")
    end

    return unless structure[:elements]

    case self
    when Array
      self.each_with_index do |e, i|
        e.validate_structure!(structure[:elements], error_prefix + ["[#{i}]"])
      end
    when Hash
      mandatory_keys = structure[:elements].map { |k,s| k unless s[:optional] }.compact

      unless (missing = mandatory_keys - self.keys).empty?
        raise ArgumentError.new("#{prepend_error}Missing keys: #{missing.join(', ')}")
      end

      structure[:elements].each do |key, structure|
        self[key].validate_structure!(structure, error_prefix + ["[:#{key}]"])
      end
    end
  end
end
