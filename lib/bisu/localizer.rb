module Bisu
  class Localizer
    def initialize(dictionary, type)
      @dict = dictionary
      @type = type.to_s.downcase.to_sym

      unless [:ios, :android, :ror].include?(@type)
        Logger.error("Unknown type #{@type}")
        raise "Unknown type #{@type}"
      end
    end

    def localize(text, language, locale, fallback_languages=[])
      t = text
      t = t.gsub("$specialKLanguage$", language)
      t = t.gsub("$specialKLocale$", locale)
      t = t.gsub("$specialKComment1$", "This file was automatically generated based on a translation template.")
      t = t.gsub("$specialKComment2$", "Remember to CHANGE THE TEMPLATE and not this file!")

      to_localize(t).map do |l|
        if localized = localize_key(l[:key], [language] + fallback_languages)
          localized = process(localized, l[:is_formatted_string])

          l[:params].each do |param, value|
            if localized.match("%{#{param}}")
              localized = localized.gsub("%{#{param}}", value)
            else
              Logger.error("Parameter #{param} not found in translation for #{l[:key]} in #{language}")
            end
          end

          unless t.gsub!(l[:match], localized)
            Logger.warn("Could not find translation for #{l[:match]} in #{language}")
          end

          unless @type.eql?(:ror) || l[:ignore_params] == true
            localized.scan(/%{[^}]+}/) { |match| Logger.error("Could not find translation param for #{match} for #{l[:key]} in #{language}") }
          end
        else
          Logger.warn("Could not find translation for #{l[:match]} in #{language}")
        end
      end

      t
    end

    def localize_key(key, ordered_languages)
      ordered_languages.each do |language|
        if localized = @dict.localize(language, key)
          return localized
        end
      end

      nil
    end

    private

    def to_localize(text)
      all_matches = text.to_enum(:scan, /\$([^\$\{\/]+)(?:\{(.+)\})?(\/\/[A-Za-z-]+)*\$/).map { Regexp.last_match }
      all_matches.map do |match|
        params = if match[2]
          params = match[2].split(",").map(&:strip).map do |param|
            key, value = param.split(":", 2).map(&:strip)
            [key.to_sym, value]
          end
          Hash[params]
        end

        {
          match:  match[0],
          key:    match[1],
          params: params || {},
          ignore_params: text.include?("//ignore-params"),
          is_formatted_string: text.include?("//formatted-string"),
        }
      end
    end

    def process(text, is_formatted_string)
      text = text.gsub("\n", "\\n")
      text = text.gsub(/\"/, "\\\\\"")

      case @type
      when :android
        text = text.gsub(/[']/, "\\\\\\\\'")
        text = text.gsub("...", "…")
        text = text.gsub("&", "&amp;")
        text = text.gsub("@", "\\\\@")
        text = text.gsub(/%(?!{)/, "\\\\%%")
      when :ios
        text = text.gsub(/%(?!{)/, "%%") if is_formatted_string
      end

      text
    end
  end
end
