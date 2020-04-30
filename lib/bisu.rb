require 'optparse'
require 'yaml'
require 'fileutils'

require 'bisu/logger'
require 'bisu/object_extension'
require 'bisu/config'
require 'bisu/source/google_sheet'
require 'bisu/source/one_sky'
require 'bisu/source/url'
require 'bisu/dictionary'
require 'bisu/localizer'
require 'bisu/version'

module Bisu
  extend self

  def run(options)
    options = command_line_options(options)

    if config_file = open_file("translatable.yml", "r", true)
      config       = Bisu::Config.new(hash: YAML::load(config_file))
      dictionary   = dictionary_for(config: config.dictionary, options: options)
      localizer    = Bisu::Localizer.new(dictionary, config.type)

      config.localize_files do |in_path, out_path, locale, language, fallback_language|
        unless dictionary.has_language?(language)
          Logger.error("Unknown language #{language}")
          return false
        end

        fallback_languages = ([fallback_language] + [options[:default_language]]).compact!

        localize_file(localizer, locale, language, fallback_languages, in_path, out_path)
      end
    end

    Logger.print_summary

    if options[:strict] && Logger.summary[:warn] > 0
      Logger.error("Found a warning while in strict mode")
    end
  end

  private

  def dictionary_for(config:, options:)
    source =
      if from_file_path = options[:from_file_path]
        i18n_from(path: from_file_path)
      else
        i18n_for(config: config, options: options)
      end

    Bisu::Dictionary.new(source)
  end

  def i18n_for(config:, options:)
    source =
      case config[:type]
      when "google_sheet"
        Bisu::Source::GoogleSheet.new(config[:sheet_id], config[:keys_column])
      when "one_sky"
        Bisu::Source::OneSky.new(config[:api_key], config[:api_secret], config[:project_id], config[:file_name])
      when "url"
        Bisu::Source::Url.new(config[:url])
      end

    source = source.to_i18

    save_to_path = options[:dictionary_save_path]
    if save_to_path && file = open_file(save_to_path, "w", false)
      file.write(source.to_json)
      file.flush
      file.close
    end

    source
  end

  def i18n_from(path:)
    file = open_file(path, "r", true)
    data = file.read
    file.close
    JSON.parse(data)
  end

  def command_line_options(options)
    opts_hash = {}

    opts_parser = OptionParser.new do |opts|
      opts.on("-d LANGUAGE", "--default LANGUAGE", "Language to use when there is no available translation") do |language|
        opts_hash[:default_language] = language
      end

      opts.on("--file PATH", "Loads i18n source directly from a local file") do |file|
        opts_hash[:from_file_path] = file
      end

      opts.on("--save-dictionary PATH", "Save downloaded dictionary locally at given path") do |path|
        opts_hash[:dictionary_save_path] = path
      end

      opts.on("-s", "--strict", "Fail in the presence of any warning") do
        opts_hash[:strict] = true
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

  def localize_file(localizer, locale, language, fallback_languages, in_path, out_path)
    Logger.info("Translating #{in_path} to #{language} > #{out_path}...")

    return false unless in_file  = open_file(in_path,  "r", true)
    return false unless out_file = open_file(out_path, "w", false)

    in_file.each_line do |line|
      out_file.write(localizer.localize(line, language, locale, fallback_languages))
    end

    out_file.flush
    out_file.close
    in_file.close

    true
  end
end
