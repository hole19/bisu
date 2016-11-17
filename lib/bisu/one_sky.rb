require 'onesky'

module Bisu
  class OneSky
    def initialize(api_key, api_secret, project_id, file_name)
      @client     = Onesky::Client.new(api_key, api_secret)
      @project_id = project_id
      @file_name  = file_name
    end

    def to_i18
      proj = @client.project(@project_id)
      file = proj.export_multilingual(source_file_name: @file_name, file_format: "I18NEXT_MULTILINGUAL_JSON")
      hash = JSON.parse(file)
      hash.each { |k, v| hash[k] = v["translation"] }
      hash
    end
  end
end
