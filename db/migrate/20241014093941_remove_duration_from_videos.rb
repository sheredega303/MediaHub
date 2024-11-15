class RemoveDurationFromVideos < ActiveRecord::Migration[7.2]
  def change
    remove_column :videos, :duration, :integer
  end
end
