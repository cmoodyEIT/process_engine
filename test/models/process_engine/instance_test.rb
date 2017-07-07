require 'test_helper'

# Thing and ActiveProcess are defined in test helper
module ProcessEngine
  class InstanceTest < ActiveSupport::TestCase
    test "active_record type id" do
      active_process = ActiveProcess.new thing_id: thing_id = Thing.create.id
      assert_equal thing_id, active_process.thing_id
    end
    test "active_record type" do
      active_process = ActiveProcess.new thing: thing = Thing.create
      assert_equal thing, active_process.thing
    end
  end
end
