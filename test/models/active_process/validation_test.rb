require 'test_helper'

# Thing and ActiveProcess are defined in test helper
module ActiveProcess
  class ValidationTest < ActiveSupport::TestCase
    test "depdencies met" do
      assert_raises(ActiveRecord::RecordInvalid){TestProcess.create!(dependent: 'failure')}
      # assert_raises(someerror){TestProcess.create(dependent: 'failure')}
    end
  end
end
