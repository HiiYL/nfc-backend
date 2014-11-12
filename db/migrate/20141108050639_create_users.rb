class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :status
      add_index :users, :name, :unique => true
      add_index :users, :status, :unique => true
      t.timestamps
    end
  end
end
