class Order::OrderForm
  include ActiveModel::Model

  define_model_callbacks :create, only: :before

  attr_accessor :order_total_in_cents,
                :payment_method_id,
                :save_payment_method,
                :seat_ids,
                :merch_ids,
                :order,
                :user,
                :new_payment_method

  delegate :total_in_cents,
           :tickets,
           :order_total,
           :shipping_address,
           :shipping_address_attributes=,
           :merch,
           :convenience_fees,
           :total_fees,
           to: :order

  validates :payment_method_id, presence: true
  validate :shipping_address_valid?, if: -> { merch.any? }

  def self.for_user(user)
    order = Order.build_for_user(user)

    user
      .order_form_type
      .new(order)
      .tap do |order_form|
      order_form.user = user
      order_form.payment_method_id = "new"
    end
  end

  def initialize(initializer = {})
    if initializer.is_a?(Order)
      self.order = initializer
    else
      self.order = initializer[:user].orders.build
      super(initializer)

      # TODO: Validate that seat ids match user's reserved seats
      seats = user.reserved_seats.includes(section: :show).where(id: seat_ids)
      order.tickets << Order::ReservedSeatingTicket.build_for_seats(seats)

      # TODO: Validate that ticket ids match user's shopping cart tickets
      tickets = user.shopping_cart.tickets
      order.tickets << Order::GeneralAdmissionTicket.build_from_shopping_cart_tickets(tickets)

      # TODO: Validate that merch ids match user's shopping cart merch
      merch = user.shopping_cart.merch.includes(:merch).where(merch_id: merch_ids)
      order.merch.build_from_shopping_cart_merch(merch)

      order.calculate_order_total

      order.errors.add(:base, "One or more of your ticket reservations have expired") if order.total_in_cents != order_total_in_cents.to_d
    end
  end

  def save
    return false unless valid?

    ApplicationRecord.transaction do
      run_callbacks :create do
        @order.save!
        raise ActiveRecord::Rollback unless @order.process_payment(payment_method_id, save_payment_method: new_payment_method == "1" && save_payment_method)

        @order.seats.each { |s| s.cancel_reservation_for!(@user) }
        @user.shopping_cart.merch.each(&:destroy!)
        @user.shopping_cart.tickets.each(&:destroy!)
      end
    end

    true
  end

  def payment_methods
    @payment_methods ||= user.stripe_payment_methods
  end

  def collect_contact_information?
    false
  end

  def persisted?
    false
  end

  def shipping_address_valid?
    errors.add(:shipping_address, :blank) unless shipping_address.valid?
  end
end
