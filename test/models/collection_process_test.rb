require 'test_helper'

class TestProcessTest < ActiveSupport::TestCase
  test "has_and_belongs_to_many processes" do
    collection_process = CollectionProcess.create
    test_process       = collection_process.test_processes.create
    assert_equal collection_process, test_process.collection_processes.first
  end
  test "has_many processes and belongs_to" do
    collection_process = CollectionProcess.create
    belonging_process  = collection_process.belonging_processes.create
    assert_equal collection_process, belonging_process.collection_process
  end
  test "has_one process" do
    collection_process = CollectionProcess.create
    belonging_process  = BelongingProcess.create
    collection_process.a_process = belonging_process
    assert_equal collection_process, belonging_process.parent_process
  end

  test "build method" do
    collection_process = CollectionProcess.create
    a_process = collection_process.build_a_process
    assert_instance_of BelongingProcess, a_process
  end

  test "create method" do
    collection_process = CollectionProcess.create
    a_process = collection_process.create_a_process
    assert_instance_of BelongingProcess, a_process
  end
  test "create! method" do
    collection_process = CollectionProcess.create
    a_process = collection_process.create_a_process!
    assert_instance_of BelongingProcess, a_process
  end
  test "id= method" do
    collection_process = CollectionProcess.create
    a_process = BelongingProcess.create
    collection_process.a_process_id = a_process.id
    assert_equal a_process, collection_process.a_process
  end
  test "id method" do
    collection_process = CollectionProcess.create
    a_process = collection_process.create_a_process
    assert_equal a_process.id, collection_process.a_process_id
  end

  test "non instance has_many" do
    CollectionProcess.send(:has_many, :things)
    collection_process = CollectionProcess.create
    thing = collection_process.things.create
    assert_instance_of Thing, thing
  end
  test "non instance has_one" do
    CollectionProcess.send(:has_one, :thing)
    collection_process = CollectionProcess.create
    thing = collection_process.create_thing
    assert_instance_of Thing, thing
  end
  test "non instance belongs_to" do
    CollectionProcess.send(:belongs_to, :thing)
    collection_process = CollectionProcess.create
    thing = collection_process.create_thing
    assert_instance_of Thing, thing
  end

  test "override has_many" do
    CollectionProcess.send(:has_many, :other_things, {class_name: 'Thing', foreign_key: :static_process_id,override: true})
    cp = CollectionProcess.create
    thing = cp.other_things.create
    assert_instance_of Thing, thing
    assert_equal cp.id, thing.attributes["static_process_id"]
  end
end
