require 'test_helper'

module ProcessEngine
  class InstanceTest < ActiveSupport::TestCase
    klass = <<-EOF
    class ActiveProcess < ProcessEngine::Instance
      has_columns(thing: {type: :thing})
    end
    EOF
    test "active_record type id" do
      FlyingTable.with(things: {name: :string}) do
        eval klass
        active_process = ActiveProcess.new thing_id: thing_id = Thing.create.id
        assert_equal thing_id, active_process.thing_id
      end
    end
    test "active_record type" do
      FlyingTable.with(things: {name: :string}) do
        eval klass
        active_process = ActiveProcess.new thing: thing = Thing.create
        assert_equal thing, active_process.thing
      end
    end
  end
end
