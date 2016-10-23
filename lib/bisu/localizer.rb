require 'fileutils'

module Bisu
  class Localizer
    def initialize(dictionary, type)
      @dict = dictionary
      @type = type.downcase.to_sym

      unless [:ios, :android, :ror].include?(@type)
        Logger.error("Unknown type #{@type}")
        raise "Unknown type #{@type}"
      end
    end

    def localize(text, language, locale, default_language=nil)
      t = text
      t = t.gsub("$specialKLanguage$", language)
      t = t.gsub("$specialKLocale$", locale)
      t = t.gsub("$specialKComment1$", "This file was automatically generated based on a translation template.")
      t = t.gsub("$specialKComment2$", "Remember to CHANGE THE TEMPLATE and not this file!")

      if l = localization_params(t)
        if localized = @dict.localize(l[:loc_key], language) || @dict.localize(l[:loc_key], default_language)
          l[:loc_vars].each do |param, value|
            if localized.match("%{#{param}}")
              localized = localized.gsub("%{#{param}}", value)
            else
              Logger.error("Parameter #{param} not found in translation for #{l[:loc_key]} in #{language}")
            end
          end
          t = t.gsub(l[:match], process(localized))
        end
      end

      t.scan(/\$(k[^\$\{]+)(?:\{(.+)\})?\$/) { |match| Logger.warn("Could not find translation for #{match[0]} in #{language}") }
      t.scan(/%{[^}]+}/) { |match| Logger.error("Could not find translation param for #{match} in #{language}") }

      t
    end

    private

    def localization_params(text)
      return nil unless matches = text.match(/\$(k[^\$\{]+)(?:\{(.+)\})?\$/)

      loc_vars = if matches[2]
        vars = matches[2].split(",").map(&:strip)
        vars = vars.map do |var|
          key, value = var.split(":", 2).map(&:strip)
          [key.to_sym, value]
        end
        Hash[vars]
      end

      { match:    matches[0],
        loc_key:  matches[1],
        loc_vars: loc_vars || {} }
    end

    def process(text)
      if @type.eql?(:android)
        text = text.gsub(/[']/, "\\\\\\\\'")
        text = text.gsub("...", "…")
        text = text.gsub("& ", "&amp; ")
        text = text.gsub("@", "\\\\@")

      elsif @type.eql?(:ios)
        text = text.gsub(/\"/, "\\\\\"")
      end

      text
    end
  end
end
