class Category < ActiveRecord::Base
  has_and_belongs_to_many :daily_shows
  self.primary_key = 'id'
end