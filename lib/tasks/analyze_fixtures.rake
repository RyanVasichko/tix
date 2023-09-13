namespace :db do
  namespace :fixtures do
    desc 'Analyze active storage attachments'
    task :analyze => :environment do
      SeatingChart.all.each do |seating_chart|
        seating_chart.venue_layout.analyze unless seating_chart.venue_layout.analyzed?
      end
    end

    desc "Populate show sections' seats"
    task :create_show_sections => :environment do
      Show::Section.all.each do |section|
        section.send :build_seats
        # section.seats.each { |seat| seat.save! }
        section.save!
      end
    end
  end
end

Rake::Task["db:fixtures:load"].enhance do
  Rake::Task["db:fixtures:analyze"].execute
  Rake::Task["db:fixtures:create_show_sections"].execute
end