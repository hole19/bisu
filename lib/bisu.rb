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
      config       = Bisu::Config.new(hash: YAML::load(config_file))
      google_sheet = Bisu::GoogleSheet.new(config.dictionary[:sheet_id], config.dictionary[:keys_column])
      dictionary   = Bisu::Dictionary.new(google_sheet.to_i18)
      localizer    = Bisu::Localizer.new(dictionary, config.type)

      config.localize_files do |in_path, out_path, language, locale|
        unless dictionary.has_language?(language)
          Logger.error("Unknown language #{language}")
          return false
        end

        localize_file(localizer, locale, language, options[:default_language], in_path, out_path)
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

  def localize_file(localizer, locale, language, default_language, in_path, out_path)
    Logger.info("Translating #{in_path} to #{language} > #{out_path}...")

    return false unless in_file  = open_file(in_path,  "r", true)
    return false unless out_file = open_file(out_path, "w", false)

    in_file.each_line do |line|
      out_file.write(localizer.localize(line, language, locale, default_language))
    end

    out_file.flush
    out_file.close
    in_file.close

    true
  end
end
