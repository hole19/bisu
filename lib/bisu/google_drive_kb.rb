require 'bisu/knowledge_base'
require "net/https"
require "xmlsimple"

module Bisu
  class GoogleDriveKB < Bisu::KnowledgeBase
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

      unless data.code.to_i == 200
        raise "Cannot access sheet at #{uri} - HTTP #{data.code}"
      end

      begin
        XmlSimple.xml_in(data.body, 'KeyAttr' => 'name')
      rescue
        raise "Cannot parse. Expected XML at #{uri}"
      end
    end

    def raw_data(sheet_id)
      Logger.info("Downloading Knowledge Base...")
      sheet = feed_data("https://spreadsheets.google.com/feeds/worksheets/#{sheet_id}/public/full")
      feed_data(sheet["entry"][0]["link"][0]["href"])
    end

    def parse(raw_data, key_column)
      Logger.info("Parsing Knowledge Base...")

      remove = ["id", "updated", "category", "title", "content", "link", key_column]

      kb_keys = {}
      raw_data["entry"].each do |entry|
        hash = entry.select { |d| !remove.include?(d) }
        hash = hash.each.map { |k, v| v.first == {} ? [k, nil] : [k, v.first] }

        unless (key = entry[key_column]) && key = key.first
          raise "Cannot find key column '#{key_column}'"
        end

        kb_keys[key] = Hash[hash]
      end

      kb = { languages: kb_keys.values.first.keys, keys: kb_keys }

      Logger.info("Knowledge Base parsed successfully!")
      Logger.info("Found #{kb[:keys].count} keys in #{kb[:languages].count} languages.")

      kb
    end
  end
end
