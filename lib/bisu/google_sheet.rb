require "net/https"
require "xmlsimple"

module Bisu
  class GoogleSheet
    def initialize(sheet_id, keys_column_title)
      @sheet_id = sheet_id
      @key_column = keys_column_title
    end

    def to_i18
      raw = raw_data(@sheet_id)

      Logger.info("Parsing Google Sheet...")

      non_language_columns = ["id", "updated", "category", "title", "content", "link", @key_column]

      kb = {}
      raw["entry"].each do |entry|
        unless (key = entry[@key_column]) && key = key.first
          raise "Cannot find key column '#{@key_column}'"
        end

        entry.select { |c| !non_language_columns.include?(c) }.each do |lang, texts|
          kb[lang] ||= {}
          kb[lang][key] = texts.first unless texts.first == {}
        end
      end

      Logger.info("Google Sheet parsed successfully!")
      Logger.info("Found #{kb.count} keys in #{kb.values.first.keys.count} languages.")

      kb
    end

    private

    def xml_data(uri, headers=nil)
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
      Logger.info("Downloading Google Sheet...")
      sheet = xml_data("https://spreadsheets.google.com/feeds/worksheets/#{sheet_id}/public/full")
      url   = sheet["entry"][0]["link"][0]["href"]
      xml_data(url)
    end
  end
end
