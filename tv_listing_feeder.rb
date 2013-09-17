$:<< "."
require 'requirements'
Time.zone="UTC"
Chronic.time_class = Time.zone
conn = Faraday.new(:url => 'http://tvintl.msn.com') do |faraday|
  faraday.request :url_encoded # form-encode POST params
  faraday.response :logger # log requests to STDOUT
  faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
end
response = conn.get '/DiscoveryWS/GetGridData.ashx', {channels: 'all', format: 'xml', mkt: 'hi-in', timezoneOffset: 330}

def process_data(response)
  xml = response.body
  hash = XmlSimple.xml_in(xml)

  data = hash["GuideData"].first
  categories = data["RLevelCat"].first["Category"]
  Category.delete_all
  categories.each do |c|
   cat = Category.new( :msn_id => c["Id"], :name => c["Name"])
   cat[:id] =   c["Id"].to_i
   cat.save rescue p "failed to create category:" + c["Name"]
  end
  pp Category.all
  channels = hash["GuideData"].first["channels"].first["ch"]
  channels.each do |channel|
    shows = channel["show"]
    shows.each do |show|
      d = DailyShow.create(
          :aff => show["Aff"],
          :channel_no => channel["ChNo"],
          :channel_id => show["CId"],
          :program_id => show["PId"],
          :title => show["Title"],
          :channel_name => show["CLetter"],
          :start_time => Chronic.parse(show["STime"]),
          :duration => show["duration"].to_i,
          :rep => show["Rep"],
          :new => show["New"],
          :logo => show["Logo"],
          :prem => show["Prem"],
          :finish_time => Chronic.parse(show["STime"]) + show["duration"].to_i.minutes
      )
      category_ids = show["Categories"].first["Category"].map{|ids| ids["Id"].to_i} rescue []
      d.category_ids = Category.where(:id =>category_ids).pluck(:id)
      d.save
    end
  end
end
process_data(response) if response.status.to_i == 200



