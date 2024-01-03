class Order::OrderForm
  include ActiveModel::Model

  define_model_callbacks :create, only: :before

  attr_accessor :order_total_in_cents,
                :payment_method_id,
                :save_payment_method,
                :seat_ids,
                :shopping_cart_ticket_ids,
                :shopping_cart_merch_ids,
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
           :shipping_fees,
           to: :order

  validates :payment_method_id, presence: true
  validate :shipping_address_valid?, if: -> { merch.any? }

  def self.for_user(user)
    order = Order.build_for_user(user)

    user.order_form_type.new(order: order, user: user, payment_method_id: "new")
  end

  def self.from_order_form(order_form_params)
    user = order_form_params[:user]
    order = user.orders.build

    seats = user.reserved_seats.includes(section: :show).find(order_form_params[:seat_ids] || [])
    order.tickets << Order::ReservedSeatingTicket.build_for_seats(seats)

    tickets = user.shopping_cart.tickets.find(order_form_params[:shopping_cart_ticket_ids] || [])
    order.tickets << Order::GeneralAdmissionTicket.build_from_shopping_cart_tickets(tickets)

    merch = user.shopping_cart.merch.includes(:merch).find(order_form_params[:shopping_cart_merch_ids] || [])
    order.merch << Order::Merch.build_from_shopping_cart_merch(merch)

    order.calculate_order_total

    if order.total_in_cents != order_form_params[:order_total_in_cents].to_d
      order.errors.add(:base, "One or more of your ticket reservations have expired")
    end

    user.order_form_type.new({ order: order }.merge(order_form_params))
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
