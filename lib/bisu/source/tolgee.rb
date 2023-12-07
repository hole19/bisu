require 'net/https'
require 'json'
require 'zip'

module Bisu
  module Source
    class Tolgee
      def initialize(api_key, custom_host = nil)
        @api_key = api_key
        @host = custom_host || "app.tolgee.io"
      end

      def to_i18
        Logger.info("Downloading dictionary from Tolgee...")

        hash = {}
        export do |language, language_data|
          hash[language] = language_data
        end

        Logger.info("Found #{hash.count} languages.")

        hash
      end

      private

      def export
        uri = URI("https://#{@host}/v2/projects/export?format=JSON&structureDelimiter=")

        request = Net::HTTP::Get.new(uri)
        request['X-API-Key'] = @api_key

        response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          http.request(request)
        end

        raise "Bisu::Source::Tolgee: Http Error #{response.body}" unless response.is_a?(Net::HTTPSuccess)

        # Create a temporary directory to extract the zip file
        temp_dir = Dir.mktmpdir

        # Extract the zip archive
        Zip::File.open_buffer(response.body) do |zip_file|
          zip_file.each do |entry|
            language = File.basename(entry.name, '.*') # Extract language from file name
            language_data = JSON.parse(entry.get_input_stream.read)

            yield language, language_data
          end
        end

        # Clean up the temporary directory
        FileUtils.remove_entry(temp_dir)
      end
    end
  end
end
