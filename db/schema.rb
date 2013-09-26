# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130925072914) do

  create_table "categories", :id => false, :force => true do |t|
    t.integer "id",     :null => false
    t.integer "msn_id"
    t.string  "name"
  end

  add_index "categories", ["id"], :name => "index_categories_on_id", :unique => true

  create_table "categories_daily_shows", :id => false, :force => true do |t|
    t.integer "daily_show_id", :null => false
    t.integer "category_id",   :null => false
  end

  create_table "daily_shows", :force => true do |t|
    t.string   "aff"
    t.integer  "channel_no"
    t.integer  "channel_id"
    t.integer  "program_id"
    t.string   "title"
    t.string   "channel_name"
    t.datetime "start_time"
    t.integer  "duration"
    t.string   "rep"
    t.string   "new"
    t.string   "logo"
    t.string   "prem"
    t.datetime "finish_time"
  end

  create_table "schedules", :force => true do |t|
    t.integer  "channel_id"
    t.string   "affiliate"
    t.string   "channel_name"
    t.integer  "duration"
    t.datetime "start_time"
    t.string   "repeat"
    t.string   "new"
    t.string   "tv_rating"
    t.integer  "channel_no"
    t.integer  "series_id"
    t.integer  "show_id"
  end

  create_table "shows", :force => true do |t|
    t.string  "title"
    t.integer "program_id"
    t.string  "lead_actors"
    t.text    "description"
    t.string  "directors"
    t.string  "episode_title"
    t.string  "other_credits"
    t.string  "lead_host"
    t.string  "hosts"
    t.string  "actors"
    t.string  "mpaa"
    t.string  "star_rating"
    t.string  "year"
  end

  add_index "shows", ["program_id"], :name => "index_shows_on_program_id", :unique => true

end
