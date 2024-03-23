module User::Stripeable
  extend ActiveSupport::Concern

  def stripe_customer
    if stripe_customer_id.nil?
      @stripe_customer = Stripe::Customer.create(email: email, name: "#{first_name} #{last_name}")
      update!(stripe_customer_id: @stripe_customer.id)
    end
    @stripe_customer ||= Stripe::Customer.retrieve(stripe_customer_id)
  end

  def stripe_payment_methods
    return [] unless stripe_customer_id.present?

    @stripe_payment_methods ||= Stripe::Customer.list_payment_methods(stripe_customer_id, { type: "card" })
  end
end
