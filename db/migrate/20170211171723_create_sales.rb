class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer :price
      t.text :headline
      t.text :content
      t.integer :user_id
    end
  end
end
