class CreateApartments < ActiveRecord::Migration
  def change
    create_table :apartments do |t|
      t.integer :price
      t.string :content
      t.integer :user_id
    end
  end
end
