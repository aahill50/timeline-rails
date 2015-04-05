class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.string :location
      t.string :category
      t.string :labels
      t.integer :month
      t.integer :day
      t.integer :year
      t.integer :user_id

      t.timestamps
    end
  end
end
