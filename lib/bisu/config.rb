module Bisu
  class Config
    def initialize(hash:)
      @hash = hash.deep_symbolize
      @hash.validate_structure!(EXPECTED_HASH)
    end

    def to_h
      @hash
    end

    private

    EXPECTED_HASH = {
      type: Hash,
      elements: {
        type: { type: String },
        sheet_id: { type: String },
        keys_column: { type: String },
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
  end
end
