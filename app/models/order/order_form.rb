class Order::OrderForm
  include ActiveModel::Model

  define_model_callbacks :create, only: :before

  attr_accessor :order_total_in_cents,
                :payment_method_id,
                :save_payment_method,
                :seat_ids,
                :order,
                :user,
                :new_payment_method

  delegate :total_in_cents, :tickets, :order_total, to: :order

  validates :payment_method_id, presence: true

  def self.for_user(user)
    order =
      user.orders.build do |order|
        user.reserved_seats.each { |seat| order.tickets << Order::Ticket.build_for_seat(seat) }
        order.calculate_order_total
      end

    user.order_form_type.new(order).tap { |order| order.user = user }
  end

  def initialize(initializer = {})
    if initializer.is_a?(Order)
      @order = initializer
    else
      super(initializer)

      @order =
        user.orders.build do |order|
          seat_ids.each do |seat_id|
            seat = user.reserved_seats.includes(section: :show).find(seat_id)
            order.tickets << Order::Ticket.build_for_seat(seat)
          end

          order.calculate_order_total

          if order.total_in_cents != order_total_in_cents.to_d
            order.errors.add(:base, "One or more of your ticket reservations have expired")
          end
        end
    end
  end

  def save
    return false unless valid?

    ApplicationRecord.transaction do
      run_callbacks :create do
        @order.save!
        unless @order.process_payment(payment_method_id, save_payment_method: new_payment_method == "1" && save_payment_method)
          raise ActiveRecord::Rollback
        end
        @order.seats.each { |s| s.cancel_reservation! }
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

  def to_model
    order
  end

  def to_key
    nil
  end
end
