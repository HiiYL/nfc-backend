class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :status
      t.string :student_id
      t.string :card_no
      t.timestamps
    end
  end
end
