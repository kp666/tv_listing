$:<< "."
require 'requirements'
require 'pry'
Time.zone="UTC"
Chronic.time_class = Time.zone
app_config = YAML.load_file("config/app.yml").deep_symbolize_keys!

def process_show(daily_show, api_info)
  response = @conn.get api_info[:search][:url], api_info[:search][:params].merge(:title => daily_show.title)
  return unless response.status.to_i == 200
  return if response.body.to_s.blank?
  hash = ExecJS.eval(JSON.load response.body)
  hash.deep_symbolize_keys!
  shows = hash[:shows]
  shows.each do |show|
    show.deep_symbolize_keys!
    s= Show.where(program_id: show[:ProgramID]).first_or_create
    s.update_attributes(
        title: show[:Title],
        lead_actors: show[:LeadActors],
        description: show[:Description],
        directors: show[:Directors],
        episode_title: show[:EpisodeTitle],
        lead_host: show[:LeadHost],
        hosts: show[:Hosts],
        actors: show[:Actors],
        mpaa: show[:MPAA],
        star_rating: show[:StarRating],
        year: show[:Year]

    )

    schedules = show[:Schedule]
    schedules.each do |schedule|
      schedule.deep_symbolize_keys!
      sch= Schedule.create(
          channel_id: schedule[:ChanID],
          affiliate: schedule[:Affiliate],
          channel_name: schedule[:CallLetters],
          duration: schedule[:Duration],
          channel_no: schedule[:Channel],
          start_time: (Time.at(schedule[:StartTime].to_f/1000.00) rescue schedule[:StartTime].to_f/1000.00),
          repeat: schedule[:Repeat].to_s,
          new: schedule[:New].to_s,
          tv_rating: schedule[:TVRating],
          series_id: schedule[:SeriesID],
          show_id: s.id

      )
    end


  end
end

def process_data(response, api_info)
  return if  response.body.to_s.blank?
  xml = response.body
  hash = XmlSimple.xml_in(xml)
  data = hash["GuideData"].first
  categories = data["RLevelCat"].first["Category"]
  Category.delete_all
  categories.each do |c|
    cat = Category.new(:msn_id => c["Id"], :name => c["Name"])
    cat[:id] = c["Id"].to_i
    cat.save rescue p "failed to create category:" + c["Name"]
  end
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
          :new => show["New"].to_s,
          :logo => show["Logo"],
          :prem => show["Prem"],
          :finish_time => Chronic.parse(show["STime"]) + show["duration"].to_i.minutes
      )
      category_ids = show["Categories"].first["Category"].map { |ids| ids["Id"].to_i } rescue []
      d.category_ids = Category.where(:id => category_ids).pluck(:id)
      d.save
      process_show(d, api_info)
    end
  end
end

app_config[:msn_api].each do |api_info|
  api_info.deep_symbolize_keys!
  @conn = Faraday.new(:url => api_info[:site]) do |faraday|
    faraday.request :url_encoded # form-encode POST params
    faraday.response :logger # log requests to STDOUT
    faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
  end
  response = @conn.get api_info[:get][:url], api_info[:get][:params]
  if response.status.to_i == 200
    process_data(response, api_info)
  else
    p response.inspect
  end


end





