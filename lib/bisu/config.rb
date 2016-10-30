module Bisu
  class Config
    def initialize(hash:)
      @hash = hash.deep_symbolize
      @hash.validate_structure!(EXPECTED_HASH)
    end

    def to_h
      @hash
    end

    def dictionary
      @hash[:dictionary]
    end

    def type
      @hash[:type]
    end

    def localize_files
      @hash[:in].each do |in_path|
        @hash[:out].each do |out|
          out_path = out_path_for(out[:path] || @hash[:out_path], in_path, out[:locale])
          yield(in_path, out_path, out[:kb_language], out[:locale])
        end
      end
    end

    private

    EXPECTED_HASH = {
      type: Hash,
      elements: {
        type: { type: String },
        dictionary: { type: Hash, elements: {
          sheet_id: { type: String },
          keys_column: { type: String }
        } },
        in: { type: Array, elements: {
          type: String
        } },
        out_path: { type: String },
        out: { type: Array, elements: {
          type: Hash,
          elements: {
            locale: { type: String },
            kb_language: { type: String },
            path: { type: String, optional: true }
          }
        } }
      }
    }

    def out_path_for(template, in_path, locale)
      in_name  = File.basename(in_path)
      out_name = in_name.gsub(/\.translatable$/, "")
      template % { locale: locale, android_locale: locale.gsub("-", "-r"), out_name: out_name }
    end
  end
end
