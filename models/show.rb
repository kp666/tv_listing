class Show < ActiveRecord::Base
  has_many :schedules
  has_many :daily_shows, :foreign_key => :program_id
end