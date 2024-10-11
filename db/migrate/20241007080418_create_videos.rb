class CreateVideos < ActiveRecord::Migration[7.2]
  def change
    create_table :videos do |t|
      t.string :title, null: false, limit: 255
      t.text :description
      t.string :age_rating, null: false, default: "G"
      t.integer :duration, null: false, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
