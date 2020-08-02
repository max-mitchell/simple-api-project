class CreateSimpleObject < ActiveRecord::Migration[6.0]
  def change
    create_table :simple_objects, id: :uuid do |t|
      t.json :data
      t.timestamps
    end
  end
end
