require 'minitest/autorun'
require 'bisu/logger'

class BisuLoggerTest < Minitest::Test

  def test_print_summary
    Bisu::Logger.clean_summary
    Bisu::Logger.silent_mode = true

    1.times { Bisu::Logger.info  "info"  }
    2.times { Bisu::Logger.warn  "warn"  }
    3.times { Bisu::Logger.error "error" }

    Bisu::Logger.silent_mode = false

    sum = Bisu::Logger.summary

    assert_equal sum[:info],  1
    assert_equal sum[:warn],  2
    assert_equal sum[:error], 3
  end
end
