require "singleton"
require "colorize"

module Bisu
  module Logger
    extend self

    def info(msg)
      log :info, msg
    end

    def warn(msg)
      log :warn, msg
    end

    def error(msg)
      log :error, msg
    end

    def clean_summary
      @levels.each { |k, _| @levels[k] = 0 }
    end

    def summary
      @levels
    end

    def print_summary
      if @levels[:warn] > 0 || @levels[:error] > 0
        info ""
        info "Finished with:"
        info "  #{@levels[:warn]} warnings" if @levels[:warn]  > 0
        info "  #{@levels[:error]} errors"  if @levels[:error] > 0
        info ""
      end
    end

    def silent_mode=(value)
      @silent_mode = value
    end

    private

    @levels = { info: 0, warn: 0, error: 0 }
    @silent_mode = false

    def log(level, msg)
      unless @levels.keys.include?(level)
        return log(:error, "Unknown log level: #{level}")
      end

      @levels[level] += 1

      msg = "[#{level.upcase}] #{msg}"
      msg = msg.yellow if level.eql?(:warn)
      msg = msg.red    if level.eql?(:error)

      puts msg unless @silent_mode
    end
  end
end
