require 'onesky'

module Bisu
  class OneSky
    def initialize(api_key, api_secret, project_id, file_name)
      @client     = Onesky::Client.new(api_key, api_secret)
      @project_id = project_id
      @file_name  = file_name
    end

    def to_i18
      Logger.info("Downloading dictionary from OneSky...")

      proj = @client.project(@project_id)
      file = proj.export_multilingual(source_file_name: @file_name, file_format: "I18NEXT_MULTILINGUAL_JSON")

      hash = JSON.parse(file)
      hash.each do |lang, v|
        hash[lang] = v["translation"]
        hash[lang].each do |key, text|
          hash[lang][key] = hash[lang][key].join("\n") if hash[lang][key].is_a? Array
        end
      end

      Logger.info("OneSky response parsed successfully!")
      Logger.info("Found #{hash.count} languages.")

      hash
    end
  end
end
