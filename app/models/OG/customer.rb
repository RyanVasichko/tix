module OG
  class Customer < User
    def self.sti_name
      "Customer"
    end
  end
end
