require 'test_helper'

class TestProcessTest < ActiveSupport::TestCase
    test "text type" do
      test_process = TestProcess.new(text: 'text')
      assert_equal 'text', test_process.text
    end
    test "string type" do
      test_process = TestProcess.new(string: 'string')
      assert_equal 'string', test_process.string
    end
    test "float type" do
      test_process = TestProcess.new(float: '1')
      assert_equal 1.0, test_process.float
    end
    test "integer type" do
      test_process = TestProcess.new(integer: '1')
      assert_equal 1, test_process.integer
    end
    test "boolean type" do
      test_process = TestProcess.new(boolean: 't')
      assert_equal true, test_process.boolean
    end
    test "date type" do
      date = Date.today
      test_process = TestProcess.new(date: date.to_s)
      assert_equal date, test_process.date
    end
    test "time type" do
      time = Time.now
      test_process = TestProcess.new(time: time.to_s)
      assert_equal time, test_process.time
    end
end
