class AddColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :website, :string
    add_column :users, :introduction, :string
    add_column :users, :phone_number, :string
    add_column :users, :gender, :integer
  end
end
