require 'bisu/logger'
require 'bisu/config'
require 'bisu/knowledge_base'
require 'bisu/translator'

module Bisu
  def self.run
    if config = Bisu::Config.parse("translatable.yml")
      kbase = Bisu::GoogleDriveKB.new(config[:sheet_id], config[:keys_column])
      trans = Bisu::Translator.new(kbase, config[:type])

      config[:in].each do |in_path|
        config[:out].each do |out|
          trans.translate(out[:language], in_path, out[:folder])
        end
      end
    end

    Bisu::Logger.print_summary
  end
end
