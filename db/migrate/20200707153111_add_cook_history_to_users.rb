class AddCookHistoryToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :cooking_history, :string
  end
end
