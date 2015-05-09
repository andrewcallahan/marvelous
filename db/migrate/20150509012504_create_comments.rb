class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :text
      t.belongs_to :character, index: true

      t.timestamps null: false
    end
    add_foreign_key :comments, :characters
  end
end
