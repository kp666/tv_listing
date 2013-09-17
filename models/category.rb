class Category < ActiveRecord::Base
  has_and_belongs_to_many :daily_shows
  set_primary_key  :id
end