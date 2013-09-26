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

a= "{\"shows\":[{\"Title\":\"Hugo\",\"ProgramID\":\"138639\",\"Categories\":\"\",\"LeadActors\":\"\",\"Description\":\"\",\"Directors\":\"\",\"EpisodeTitle\":\"\",\"OtherCredits\":\"\",\"LeadHost\":\"\",\"Hosts\":\"\",\"Actors\":\"\",\"MPAA\":\"\",\"StarRating\":\"\",\"Year\":\"\",\"Schedule\":[{\"ChanID\":\"374\",\"Affiliate\":\"\",\"CallLetters\":\"HBO Defined\",\"Duration\":\"125\",\"StartTime\":Date.UTC(2013,8,23,16,30,0,0),\"Repeat\":false,\"New\":false,\"TVRating\":\"\",\"Channel\":\"22\",\"SeriesID\":\"727272\"},{\"ChanID\":\"374\",\"Affiliate\":\"\",\"CallLetters\":\"HBO Defined\",\"Duration\":\"130\",\"StartTime\":Date.UTC(2013,8,24,7,0,0,0),\"Repeat\":false,\"New\":false,\"TVRating\":\"\",\"Channel\":\"22\",\"SeriesID\":\"727272\"}]}],\"headend\":{\"listingsSourceId\":\"BDS.IN\",\"id\":\"Default.India\",\"name\":null,\"timezone\":\"330\",\"dstTransition\":Date.UTC(1970,0,1,0,0,0,0),\"dstOffsetCurrent\":0,\"dstOffsetNext\":0,\"zip\":null,\"isDefault\":true,\"hideChannelNumbers\":false},\"performance\":{\"start\":Date.UTC(2013,8,23,23,47,10,783),\"end\":Date.UTC(2013,8,23,23,47,10,783)}}"

