desc "Compress 1 day old impressions in to Statistic"
task :compress_impressions => :environment do
  events = Ahoy::Event.where("time > ?", 1.day.ago).distinct.pluck(:visit_id, :properties).group_by { |v| v[1] }

  events.each do |event|
    Statistic.create(timeframe: :daily, on_date: Date.today, value: event[1].size, properties: event[1].first[1])

    if event[1].first[1]["id"]
      Post.find(event[1].first[1]["id"]).increment!(:impressions_count, event[1].size)
    end
  end

  visits = Ahoy::Visit.where("started_at < ?", 1.month.ago)
  events = Ahoy::Event.where("time < ?", 1.month.ago)

  events.destroy_all
  visits.destroy_all
end