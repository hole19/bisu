require 'bisu/logger'
require 'bisu/config'
require 'bisu/knowledge_base'
require 'bisu/translator'

module Bisu
  extend self

  def run
    if config = Bisu::Config.parse("translatable.yml")
      kbase = Bisu::GoogleDriveKB.new(config[:sheet_id], config[:keys_column])
      translator = Bisu::Translator.new(kbase, config[:type])

      config[:in].each do |in_path|
        config[:out].each do |out|
          localize(translator, out[:locale], out[:kb_language], in_path, out[:path] || config[:out_path])
        end
      end
    end

    Bisu::Logger.print_summary
  end

  private

  def localize(translator, locale, language, in_path, out_path)
    in_name = File.basename(in_path)
    out_name = in_name.gsub(/\.translatable$/, "")

    unless in_name.match /\.translatable$/
      Logger.error("Expected .translatable file. Got '#{in_name}'")
      return false
    end

    out_path = out_path % { locale: locale, out_name: out_name }

    translator.translate(language, locale, in_path, out_path)
  end

end
