class CreateBooksGroups < ActiveRecord::Migration
  def change
    create_table :books_groups do |t|

      t.timestamps null: false
    end
  end
end
