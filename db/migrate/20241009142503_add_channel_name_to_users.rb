class AddChannelNameToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :channel_name, :string, limit: 100
  end
end
