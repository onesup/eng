class AddNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :address, :string
    add_column :users, :address_detail, :string
    add_column :users, :code6, :string
    add_column :users, :poster_code, :string
    add_column :users, :phone, :string, :null => false
    add_column :users, :birthday, :datetime
    add_column :users, :access_logs_count, :integer
    add_column :users, :agree_option, :string
  end
end
