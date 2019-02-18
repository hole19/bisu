require 'net/https'
require 'json'

module Bisu
  module Source
    class Url
      def initialize(url)
        @url = url
      end

      def to_i18
        Logger.info("Downloading dictionary from #{@url}...")

        file = get(@url)
        hash = JSON.parse(file)

        Logger.info("Found #{hash.count} languages.")

        hash
      end

      private

      def get(url)
        uri = URI(url)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)

        raise "Bisu::Source::Url: Http Error #{response.body}" if response.code.to_i >= 400

        response.body
      end
    end
  end
end
