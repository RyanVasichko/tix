class Show::ReservedSeatingShow < Show
  include SeatingChartable

  has_many :sections, class_name: 'Show::ReservedSeatingSection', inverse_of: :show
  has_many :seats, through: :sections
  has_many :tickets, class_name: "Order::ReservedSeatingTicket", inverse_of: :show
end