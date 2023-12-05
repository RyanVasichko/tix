class Show::GeneralAdmissionShow < Show
  has_many :sections, inverse_of: :show, class_name: "Show::GeneralAdmissionSection"
  has_many :tickets, class_name: "Order::GeneralAdmissionTicket", inverse_of: :show
end