class CreateSchedules < ActiveRecord::Migration
  def change

    create_table :schedules do |t|
      t.integer :channel_id
      t.string :affiliate
      t.string :channel_name
      t.integer :duration
      t.datetime :start_time
      t.string :repeat
      t.string :new
       t.string :tv_rating
      t.integer :channel_no
      t.integer :series_id
      t.integer :show_id
    end
  end
end

