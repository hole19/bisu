require "net/https"
require "csv"

module Bisu
  module Source
    class GoogleSheet
      def initialize(url)
        @url = url
      end

      def to_i18
        Logger.info("Downloading Google Sheet from #{@url}...")

        csv = get_csv(@url)

        hash = {}

        languages = csv.headers[1..]
        languages.each { |lang| hash[lang] = {} }

        csv.each do |row|
          languages.each do |lang|
            hash[lang][row["key"]] = row[lang] unless row[lang].nil?
          end
        end

        Logger.info("Google Sheet parsed successfully!")
        Logger.info("Found #{languages.count} languages.")

        hash
      end

      private

      def get_csv(url)
        data = get(url)

        begin
          CSV.parse(data, headers: true)
        rescue StandardError => e
          raise "Bisu::Source::GoogleSheet: Cannot parse. Expected CSV at #{url}: #{e}"
        end
      end

      def get(url, max_redirects = 1)
        raise "Bisu::Source::GoogleSheet: Too may redirects" if max_redirects == -1

        uri = URI(url)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)

        return get(response['location'], max_redirects - 1) if response.is_a? Net::HTTPRedirection

        raise "Bisu::Source::GoogleSheet: Http Error #{response.body}" if response.code.to_i >= 400

        response.body
      end
    end
  end
end
