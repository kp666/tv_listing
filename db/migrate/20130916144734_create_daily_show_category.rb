class CreateDailyShowCategory < ActiveRecord::Migration
  def change
    create_table :categories_daily_shows, :id => false do |t|
      t.references :daily_show, :null => false
      t.references :category, :null => false
    end
  end
end
