require "bloomberg_quote/version"
require "open-uri"
require "nokogiri"
require "json"

module BloombergQuote
  class Quote
    def initialize(symbol)
      @symbol = symbol
      pull_data
    end

    def valid?
      return false unless @data
      @data.size > 0
    end

    def data
      @data.nil? ? {} : @data
    end

    private
      def pull_data
        return if @symbol.empty?

        case @symbol
        when /:IND\Z/
          pull_index_data
        when /:CUR\Z/
          pull_currency_data
        end
      end

      def pull_index_data
        @data = {}

        fetch_page
        return unless @doc.css('div.ticker_header > span.price').text.
          gsub(',','') =~ /(\d+\.?(?:\d+))/
        @data["Price"] = $1.to_f

        json = parse_json
        @data["Previous Close"] = json["prev_close"].to_f
        @data["Open"] = json["data_values"][0][1].to_f
      end

      def pull_currency_data
        @data = {}

        fetch_page
        return unless @doc.css('div.ticker_header_currency > span.price').
          text =~ /(\d+\.?(?:\d+))/
        @data["Price"] = $1.to_f

        json = parse_json
        @data["Previous Close"] = json["prev_close"].to_f
        @data["Open"] = json["data_values"][0][1].to_f
      end

      def parse_json
        inline_scripts = @doc.xpath('//script[not(@src)]').map(&:text)
        inline_scripts.find do |js|
          js =~ /BLOOMBERG\.global_var\.chartData\s+?=\s+?(.+?);/
        end
        JSON.parse($1)
      end

      def fetch_page
        @doc = Nokogiri::HTML(open_url)
      end

      def open_url
        open(quote_url)
      end

      def quote_url
        "http://www.bloomberg.com/quote/#{@symbol}"
      end
    end
end
