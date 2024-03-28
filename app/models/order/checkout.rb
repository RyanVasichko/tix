class Order::Checkout
  include ActiveModel::Attributes, ActiveModel::Model

  attribute :total_due_in_cents, :integer
  attribute :save_payment_method, :boolean, default: false

  attr_accessor :user, :order, :guest_orderer, :shipping_address, :shopping_cart_selection_ids, :payment_method_id
  delegate :purchases, :total_fees, :shipping_charges, to: :order
  delegate :stripe_payment_methods, to: :user

  validate :order_presented_to_the_user_matches_shopping_cart
  validates :payment_method_id, presence: true
  validates :shipping_address, presence: true, if: -> { order.purchases.any?(&:merch?) }
  validate :shipping_address_is_valid, if: -> { shipping_address.present? }
  validates :guest_orderer, presence: true, if: -> { user.guest? }
  validate :guest_orderer_is_valid, if: -> { guest_orderer.present? }

  def initialize(user:, **params)
    self.user = user
    super(params)

    if params.empty?
      prepare_for_new_checkout
    else
      build_order_from_items_presented_to_user
    end
  end

  def guest_orderer_attributes=(attributes)
    self.guest_orderer = Order::GuestOrderer.new(attributes.merge(shopper_uuid: user.shopper_uuid))
  end

  def shipping_address_attributes=(attributes)
    self.shipping_address = Order::ShippingAddress.new(attributes)
  end

  def create_order
    unless valid?
      self.payment_method_id = "new" unless user.stripe_payment_methods.any? { |pm| pm == payment_method_id }
      return false
    end

    ApplicationRecord.transaction do
      order.orderer = user.guest? ? guest_orderer : user
      order.shipping_address = shipping_address
      order.save!
      raise ActiveRecord::Rollback unless order.process_payment(payment_method_id, save_payment_method: save_payment_method)
      user.shopping_cart_selections.find(shopping_cart_selection_ids).each(&:destroy!)
      true
    end
  end

  def can_save_payment_method?
    !user.guest?
  end

  def total_due
    total_due_in_cents / 100.0
  end

  private

  def prepare_for_new_checkout
    self.order = Order.build_from_shopping_cart_selections(user.shopping_cart_selections)
    self.total_due_in_cents = order.balance_paid * 100

    if order.purchases.any?(&:merch?)
      self.shipping_address = user.shipping_addresses.order_by_recent_usage.first&.dup
      self.shipping_address ||= Order::ShippingAddress.new(first_name: user.first_name, last_name: user.last_name)
    end

    self.payment_method_id = user.stripe_payment_methods.first || "new"
    self.guest_orderer = Order::GuestOrderer.new if user.guest?
    self.shopping_cart_selection_ids = user.shopping_cart_selection_ids
  end

  def build_order_from_items_presented_to_user
    shopping_cart_selections = user.shopping_cart_selections.where(id: shopping_cart_selection_ids)
    self.order = Order.build_from_shopping_cart_selections(shopping_cart_selections)
  end

  def shipping_address_is_valid
    return if shipping_address.valid?

    errors.add(:shipping_address, "is invalid")
  end

  def guest_orderer_is_valid
    return if guest_orderer.valid?

    errors.add(:contact_information, "is invalid")
  end

  def order_presented_to_the_user_matches_shopping_cart
    return if total_due_in_cents == order.balance_paid * 100

    errors.add(:base, "Your shopping cart has changed since you began checkout. Please review your order and try again.")
  end
end
