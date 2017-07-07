class CreateJoinedInstances < ActiveRecord::Migration[5.1]
  def change
    create_table "process_engine_joined_instances", force: :cascade do |t|
      t.integer  "first_active_record_id"
      t.string   "first_active_record_type"
      t.integer  "second_active_record_id"
      t.string   "second_active_record_type"
      t.string   "first_active_record_class"
      t.string   "second_active_record_class"
      t.string   "belongs_to_as"
      t.string   "has_as"
      t.timestamps
    end
  end
end
