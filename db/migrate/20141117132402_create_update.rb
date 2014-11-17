class CreateUpdate < ActiveRecord::Migration
  def change
    create_table :updates do |t|
    	t.datetime :time
    end
  end
end
