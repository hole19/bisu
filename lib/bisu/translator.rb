require 'fileutils'

module Bisu
  class Translator
    def initialize(knowledge_base, type)
      @kb   = knowledge_base
      @type = type.downcase.to_sym

      unless [:ios, :android].include?(@type)
        Logger.error("Unknown type #{@type}")
        raise
      end
    end

    def translate(language, in_path, out_folder)
      unless @kb.has_language?(language)
        Logger.error("Unknown language #{language}")
        return false
      end

      in_name  = File.basename(in_path)
      out_name = in_name.gsub(/\.translatable$/, "")
      out_path = "#{out_folder}#{out_name}"
      
      unless in_name.match /\.translatable$/
        Logger.error("Expected .translatable file. Got '#{in_name}'")
        return false
      end

      return false unless in_file  = open_file(in_path,  "r", true)
      return false unless out_file = open_file(out_path, "w", false)

      Logger.info("Translating #{in_path} to #{language} > #{out_path}...")

      in_file.each_line do |line|
        out_file.write(localize(line, language))
      end

      out_file.flush
      out_file.close
      in_file.close

      true
    end

    private

    def open_file(file_name, method, must_exist)
      if !File.file?(File.expand_path(file_name))
        if must_exist
          Logger.error("File #{file_name} not found!")
          return nil
        else
          FileUtils.mkdir_p(File.dirname(file_name))
        end
      end

      File.open(File.expand_path(file_name), method)
    end

    def localize(text, language)
      t = text
      t = t.gsub("$specialKLanguage$", language.upcase)
      t = t.gsub("$specialKComment1$", "This file was automatically generated based on a translation template.")
      t = t.gsub("$specialKComment2$", "Remember to CHANGE THE TEMPLATE and not this file!")

      t = t.gsub(/\$(k[^\$]+)\$/) do |match|
        if localized = @kb.localize("#{$1}", language)
          process(localized)
        else
          match
        end
      end

      t.scan(/\$k[^\$]+\$/) { |match| Logger.warn("Could not find translation for #{match} in #{language}") }

      t
    end

    def process(text)
      if @type.eql?(:android)
        text = text.gsub(/[']/, "\\\\'")
        text = text.gsub("...", "…")
        text = text.gsub("& ", "&amp; ")
      
      elsif @type.eql?(:ios)
        text = text.gsub(/\"/, "\\\\\"")
      end
    end
  end
end
