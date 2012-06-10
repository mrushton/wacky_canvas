class CreateWackyCanvasViews < ActiveRecord::Migration
  def change
    create_table :wacky_canvas_views do |t|
      t.integer :user_id, :limit => 8
      t.string :oauth_token
      t.integer :expires
      t.string :gender
      t.string :locale
      t.string :country
      t.integer :min_age
      t.integer :max_age
      t.string :error
      t.string :error_reason
      t.string :error_description
      t.integer :session_id
      t.timestamps
    end
  end
end
