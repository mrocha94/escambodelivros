class AddTituloToAdvertisement < ActiveRecord::Migration
  def change
    change_table :advertisements do |t|
      t.string :titulo
    end
  end
end
