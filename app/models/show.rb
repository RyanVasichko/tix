class Show < ApplicationRecord
  belongs_to :artist
  belongs_to :seating_chart
end
