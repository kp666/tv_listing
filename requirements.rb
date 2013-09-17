require 'open-uri'
require 'json'
require 'xmlsimple'
require 'chronic'
require 'pry'
require 'faraday'
require 'pp'
require 'active_record'
yaml = YAML.load(File.open('config/database.yml').read)
env = ENV['RAILS_ENV'] || "development"
ActiveRecord::Base.establish_connection(yaml[env])
require_relative 'models/category'
require_relative 'models/daily_show'
