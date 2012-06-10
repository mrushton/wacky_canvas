class CreateWackyCanvasSessions < ActiveRecord::Migration
  def change
    create_table :wacky_canvas_sessions do |t|
      t.string :remember_token
      t.timestamps
    end
  end
end
