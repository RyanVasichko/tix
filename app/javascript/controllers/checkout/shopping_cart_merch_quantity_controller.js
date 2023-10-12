import { Controller } from "@hotwired/stimulus";
import { Turbo } from "@hotwired/turbo-rails";
import { patch } from "@rails/request.js";

// Connects to data-controller="checkout--shopping-cart-merch-quantity"
export default class extends Controller {
  static values = {
    updateUrl: String,
    newOrderUrl: String
  };

  connect() {}

  async updateQuantity() {
    const quantity = this.element.value;
    const response = await patch(this.updateUrlValue, { body: JSON.stringify({ quantity }) });
    if (response.redirected) {
      Turbo.visit(this.newOrderUrlValue);
    }
  }
}
