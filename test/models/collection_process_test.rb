require 'test_helper'

class TestProcessTest < ActiveSupport::TestCase
  test "text has_and_belongs_to_many processes" do
    collection_process = CollectionProcess.create
    test_process       = collection_process.test_processes.create
    assert_equal collection_process, test_process.collection_processes.first
  end
end
