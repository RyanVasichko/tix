class ShoppingCartController < ApplicationController
  def show
    Current.user = User.includes(reserved_seats: [{ section: { show: :artist } }]).find(Current.user.id)
  end
end
