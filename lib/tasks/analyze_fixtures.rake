namespace :db do
  namespace :fixtures do
    desc 'Analyze active storage attachments'
    task :analyze => :environment do
      SeatingChart.all.each do |seating_chart|
        seating_chart.venue_layout.analyze unless seating_chart.venue_layout.analyzed?
      end
    end
  end
end

Rake::Task["db:fixtures:load"].enhance do
  Rake::Task["db:fixtures:analyze"].execute
end