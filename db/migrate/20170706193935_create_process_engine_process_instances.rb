class CreateProcessEngineProcessInstances < ActiveRecord::Migration[5.1]
  def change
    create_table :process_engine_process_instances do |t|
      t.string  :type
      t.boolean :complete
      t.jsonb   :current_state, null: false, default: '{}'
      t.timestamps
    end
    add_index :process_engine_process_instances, :current_state, using: :gin
  end
end
