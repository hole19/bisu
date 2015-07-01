require "net/https"
require "xmlsimple"

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


  class GoogleDriveKB < KnowledgeBase
    def initialize(sheet_id, keys_column_title)
      raw = raw_data(sheet_id)
      kb  = parse(raw, keys_column_title)
      super(kb)
    end

    private

    def feed_data(uri, headers=nil)
      uri = URI.parse(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      data = http.get(uri.path, headers)
      XmlSimple.xml_in(data.body, 'KeyAttr' => 'name')
    end

    def raw_data(sheet_id)
      Logger.info("Downloading Knowledge Base...")
      sheet = feed_data("https://spreadsheets.google.com/feeds/worksheets/#{sheet_id}/public/full")
      feed_data(sheet["entry"][0]["link"][0]["href"])
    end

    def parse(raw_data, key)
      Logger.info("Parsing Knowledge Base...")

      remove = ["id", "updated", "category", "title", "content", "link", key]

      kb_keys = {}
      raw_data["entry"].each do |entry|
        hash = entry.select { |d| !remove.include?(d) }
        hash = hash.each.map { |k, v| v.first == {} ? [k, nil] : [k, v.first] }
        kb_keys[entry[key].first] = Hash[hash]
      end

      kb = { languages: kb_keys.values.first.keys, keys: kb_keys }

      Logger.info("Knowledge Base parsed successfully!")
      Logger.info("Found #{kb[:keys].count} keys in #{kb[:languages].count} languages.")

      kb
    end
  end

end
