require 'net/https'
require 'json'

module Bisu
  module Source
    class Bisu
      def initialize(api_key, host)
        @api_key = api_key
        @host = host
      end

      def to_i18
        Logger.info("Downloading dictionary from Bisu Platform...")

        hash = export

        Logger.info("Found #{hash.count} languages.")

        hash
      end

      private

      def export
        uri = URI("https://#{@host}/api/v1/export?languages=all&mode=flat")

        request = Net::HTTP::Get.new(uri)
        request['Authorization'] = "Bearer #{@api_key}"
        request['Accept'] = 'application/json'

        response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
          http.request(request)
        end

        raise "Bisu::Source::Bisu: Http Error #{response.body}" unless response.is_a?(Net::HTTPSuccess)

        JSON.parse(response.body).fetch("data")
      end
    end
  end
end
