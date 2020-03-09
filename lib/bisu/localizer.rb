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

    def localize(text, language, locale, fallback_language=nil)
      t = text
      t = t.gsub("$specialKLanguage$", language)
      t = t.gsub("$specialKLocale$", locale)
      t = t.gsub("$specialKComment1$", "This file was automatically generated based on a translation template.")
      t = t.gsub("$specialKComment2$", "Remember to CHANGE THE TEMPLATE and not this file!")

      to_localize(t).map do |l|
        if localized = @dict.localize(language, l[:key]) || @dict.localize(fallback_language, l[:key])
          localized = process(localized)

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
        else
          Logger.warn("Could not find translation for #{l[:match]} in #{language}")
        end
      end

      unless @type.eql?(:ror)
        t.scan(/%{[^}]+}/) { |match| Logger.error("Could not find translation param for #{match} in #{language}") }
      end

      t
    end

    private

    def to_localize(text)
      all_matches = text.to_enum(:scan, /\$([^\$\{]+)(?:\{(.+)\})?\$/).map { Regexp.last_match }
      all_matches.map do |match|
        params = if match[2]
          params = match[2].split(",").map(&:strip).map do |param|
            key, value = param.split(":", 2).map(&:strip)
            [key.to_sym, value]
          end
          Hash[params]
        end

        { match:  match[0],
          key:    match[1],
          params: params || {} }
      end
    end

    def process(text)
      text = text.gsub("\n", "\\n")

      if @type.eql?(:android)
        text = text.gsub(/[']/, "\\\\\\\\'")
        text = text.gsub("...", "…")
        text = text.gsub("& ", "&amp; ")
        text = text.gsub("@", "\\\\@")
        text = text.gsub(/%(?!{)/, "\\\\%%")

      elsif @type.eql?(:ios)
        text = text.gsub(/\"/, "\\\\\"")
      end

      text
    end
  end
end
