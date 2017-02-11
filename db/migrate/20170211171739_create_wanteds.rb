class CreateWanteds < ActiveRecord::Migration
  def change
    create_table :wanteds do |t|
      t.string :content
      t.integer :user_id
    end
  end
end
