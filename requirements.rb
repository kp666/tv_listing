require 'open-uri'
require 'json'
require 'xmlsimple'
require 'chronic'
require 'pry'
require 'faraday'
require 'pp'
require 'active_record'
require "execjs"
yaml = YAML.load(File.open('config/database.yml').read)
env = ENV['RAILS_ENV'] || "development"
ActiveRecord::Base.establish_connection(yaml[env])
require_relative 'models/category'
require_relative 'models/daily_show'
require_relative 'models/show'
require_relative 'models/schedule'
class Hash
  def deep_transform_keys!(&block)
    keys.each do |key|
      value = delete(key)
      self[yield(key)] = value.is_a?(Hash) ? value.deep_transform_keys!(&block) : value
    end
    self
  end
  def deep_symbolize_keys!
    deep_transform_keys!{ |key| key.to_sym rescue key }
  end
end


