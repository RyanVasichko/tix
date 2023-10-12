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

  delegate :total_in_cents, :tickets, :order_total, :shipping_address, :shipping_address_attributes=, :merch, to: :order

  validates :payment_method_id, presence: true
  validate :shipping_address_valid?, if: -> { merch.any? }

  def self.for_user(user)
    order = user.orders.build_for_user(user)

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

      seats = user.reserved_seats.includes(section: :show).where(id: seat_ids)
      self.order.tickets.build_for_seats(seats)

      merch = user.shopping_cart.merch.includes(:merch).where(merch_id: merch_ids)
      self.order.merch.build_for_shopping_cart_merch(merch)

      self.order.calculate_order_total

      if self.order.total_in_cents != order_total_in_cents.to_d
        self.order.errors.add(:base, "One or more of your ticket reservations have expired")
      end
    end
  end

  def save
    return false unless valid?

    ApplicationRecord.transaction do
      run_callbacks :create do
        @order.save!
        unless @order.process_payment(
                 payment_method_id,
                 save_payment_method: new_payment_method == "1" && save_payment_method
               )
          raise ActiveRecord::Rollback
        end
        @order.seats.each { |s| s.cancel_reservation! }
        @user.shopping_cart.merch.each(&:destroy!)
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
