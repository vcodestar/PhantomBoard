class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.integer :user_id
      t.string :username
      t.integer :flags

      t.timestamps
    end
  end
end
