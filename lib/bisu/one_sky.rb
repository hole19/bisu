require 'net/https'
require 'json'

module Bisu
  class OneSky
    def initialize(api_key, api_secret, project_id, file_name)
      @api_key    = api_key
      @api_secret = api_secret
      @project_id = project_id
      @file_name  = file_name
    end

    def to_i18
      Logger.info("Downloading dictionary from OneSky...")

      path = "https://platform.api.onesky.io/1/projects/#{@project_id}/translations/multilingual"
      file = get(path, source_file_name: @file_name, file_format: "I18NEXT_MULTILINGUAL_JSON")

      hash = JSON.parse(file)

      hash.each do |lang, v|
        hash[lang] = v["translation"]
        hash[lang].each do |key, text|
          hash[lang][key] = hash[lang][key].join("\\n") if hash[lang][key].is_a? Array
          hash[lang][key] = hash[lang][key].gsub("\n", "\\n") # fixes the 'stupid newline bug'
          hash[lang][key] = hash[lang][key].gsub("\\'", "'") # fixes the 'stupid single quote bug'
        end
      end

      Logger.info("OneSky response parsed successfully!")
      Logger.info("Found #{hash.count} languages.")

      hash
    end

    private

    def get(url, params)
      uri = URI(url)
      uri.query = URI.encode_www_form(authenticated_params(params))

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      raise "OneSky: Http Error #{JSON.parse(response.body)}" if response.code.to_i >= 400

      response.body
    end

    def authenticated_params(params)
      now = Time.now.to_i

      { api_key: @api_key,
        timestamp: now,
        dev_hash: Digest::MD5.hexdigest(now.to_s + @api_secret)
      }.merge(params)
    end
  end
end
