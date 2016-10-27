require 'optparse'
require 'yaml'

require 'bisu/logger'
require 'bisu/object_extension'
require 'bisu/config'
require 'bisu/google_sheet'
require 'bisu/dictionary'
require 'bisu/localizer'
require 'bisu/version'

module Bisu
  extend self

  def run(options)
    options = command_line_options(options)

    if config_file = open_file("translatable.yml", "r", true)
      config = Bisu::Config.new(hash: YAML::load(config_file))
      config = config.to_h

      google_sheet = Bisu::GoogleSheet.new(config[:sheet_id], config[:keys_column])
      dictionary   = Bisu::Dictionary.new(google_sheet.to_hash)
      localizer    = Bisu::Localizer.new(dictionary, config[:type])

      config[:in].each do |in_path|
        config[:out].each do |out|
          unless dictionary.has_language?(out[:kb_language])
            Logger.error("Unknown language #{out[:kb_language]}")
            return false
          end

          localize_file(localizer, out[:locale], out[:kb_language], options[:default_language], in_path, out[:path] || config[:out_path])
        end
      end
    end

    Bisu::Logger.print_summary
  end

  private

  def command_line_options(options)
    opts_hash = {}

    opts_parser = OptionParser.new do |opts|
      opts.on("-d LANGUAGE", "--default LANGUAGE", "Language to use when there is no available translation") do |language|
        opts_hash[:default_language] = language
      end

      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end

      opts.on_tail("-v", "--version", "Show version") do
        puts Bisu::VERSION
        exit
      end
    end
    opts_parser.parse!(options)

    opts_hash
  end

  def localize_file(localizer, locale, language, default_language, in_path, out_path)
    in_name = File.basename(in_path)
    out_name = in_name.gsub(/\.translatable$/, "")

    unless in_name.match /\.translatable$/
      Logger.error("Expected .translatable file. Got '#{in_name}'")
      return false
    end

    out_path = out_path % { locale: locale, android_locale: locale.gsub("-", "-r"), out_name: out_name }

    return false unless in_file  = open_file(in_path,  "r", true)
    return false unless out_file = open_file(out_path, "w", false)

    Logger.info("Translating #{in_path} to #{language} > #{out_path}...")

    in_file.each_line do |line|
      out_file.write(localizer.localize(line, language, locale, default_language))
    end

    out_file.flush
    out_file.close
    in_file.close

    true
  end

  def open_file(file_name, method, should_exist)
    if !File.file?(File.expand_path(file_name))
      if should_exist
        Logger.error("File #{file_name} not found!")
        return nil
      else
        FileUtils.mkdir_p(File.dirname(file_name))
      end
    end

    File.open(File.expand_path(file_name), method)
  end
end
