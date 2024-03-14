class Shows::GeneralAdmission < Show
  has_many :sections, inverse_of: :show, class_name: "Show::Sections::GeneralAdmission"
  has_many :tickets, class_name: "Order::Tickets::GeneralAdmission", inverse_of: :show
end
