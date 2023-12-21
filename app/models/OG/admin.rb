module OG
  class Admin < User
    def self.sti_name
      "Admin"
    end
  end
end
