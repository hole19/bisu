require 'bisu/logger'
require 'bisu/config'
require 'bisu/google_sheet'
require 'bisu/dictionary'
require 'bisu/translator'
require 'bisu/version'
require 'optparse'

module Bisu
  extend self

  def run(opts)
    options = command_line_options(opts)

    if config = Bisu::Config.parse("translatable.yml")
      google_sheet = Bisu::GoogleSheet.new(config[:sheet_id], config[:keys_column])
      dictionary   = Bisu::Dictionary.new(google_sheet.to_hash)
      translator   = Bisu::Translator.new(dictionary, config[:type])

      config[:in].each do |in_path|
        config[:out].each do |out|
          localize(translator, out[:locale], out[:kb_language], options[:default_language], in_path, out[:path] || config[:out_path])
        end
      end
    end

    Bisu::Logger.print_summary
  end

  private

  def command_line_options(options)
    options = {}

    opts_parser = OptionParser.new do |opts|
      opts.on("-d LANGUAGE", "--default LANGUAGE", "Language to use when there is no available translation") do |language|
        options[:default_language] = language
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

    opts_parser.parse!(ARGV)
    options
  end

  def localize(translator, locale, language, default_language, in_path, out_path)
    in_name = File.basename(in_path)
    out_name = in_name.gsub(/\.translatable$/, "")

    unless in_name.match /\.translatable$/
      Logger.error("Expected .translatable file. Got '#{in_name}'")
      return false
    end

    out_path = out_path % { locale: locale, android_locale: locale.gsub("-", "-r"), out_name: out_name }

    translator.translate(language, locale, in_path, out_path, default_language)
  end

end
