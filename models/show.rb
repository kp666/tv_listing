class Show < ActiveRecord::Base
  has_many :schedules
  has_many :daily_shows, :foreign_key => :program_id
  validates_uniqueness_of :program_id
end