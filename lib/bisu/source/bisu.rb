require 'net/https'
require 'json'
require 'zip'

module Bisu
  module Source
    class Bisu
      def initialize(api_key, host)
        @api_key = api_key
        @host = host
      end

      def to_i18
        Logger.info("Downloading dictionary from Bisu Platform...")

        hash = {}
        export do |language, language_data|
          hash[language] = language_data
        end

        Logger.info("Found #{hash.count} languages.")

        hash
      end

      private

      def export
        uri = URI("https://#{@host}/api/v1/export?languages=all&mode=flat")

        request = Net::HTTP::Get.new(uri)
        request['Authorization'] = "Bearer #{@api_key}"
        request['Accept'] = 'application/zip'

        response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
          http.request(request)
        end

        raise "Bisu::Source::Bisu: Http Error #{response.body}" unless response.is_a?(Net::HTTPSuccess)

        Zip::File.open_buffer(response.body) do |zip_file|
          zip_file.each do |entry|
            language = File.basename(entry.name, '.*') # Extract language from file name
            language_data = JSON.parse(entry.get_input_stream.read)

            yield language, language_data
          end
        end
      end
    end
  end
end
