class AddIndexToUsers < ActiveRecord::Migration
  def change
  	  add_index :users, :name, :unique => true
  	  add_index :users, :status
  	  add_index :users, :card_no
  end
end
