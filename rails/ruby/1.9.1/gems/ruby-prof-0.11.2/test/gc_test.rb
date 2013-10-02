#!/usr/bin/env ruby
# encoding: UTF-8

require File.expand_path('../test_helper', __FILE__)

class GcTest < Test::Unit::TestCase
  def setup
    # Need to use wall time for this test due to the sleep calls
    RubyProf::measure_mode = RubyProf::WALL_TIME
  end

  def run_profile
    RubyProf.profile do
      RubyProf::C1.hello
    end
  end

  def test_gc
    result = run_profile

    thread = result.threads.first
    method = thread.methods.first
    call_info = method.call_infos.first

    result = nil

    1000.times do
      GC.start
      Array.new(1000)
    end

    puts thread.methods
    puts method.full_name
  end
end
