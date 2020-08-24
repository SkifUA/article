class AddTypesCountToStories < ActiveRecord::Migration[6.0]
  def change
    change_table :stories do |t|
      t.integer :types_count, default: 0
    end
  end
end
