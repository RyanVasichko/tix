module OG
  class User < Record
    def self.find_sti_class(type_name)
      case type_name
      when 'Admin'
        OG::Admin
      when 'Customer'
        OG::Customer
      else
        super
      end
    end
  end
end
