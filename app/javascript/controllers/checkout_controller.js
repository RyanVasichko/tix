import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="checkout"
export default class extends Controller {
  static targets = ["btnSubmit", "paymentMethodIdField", "newPaymentMethodField"];
  static values = {
    amount: Number,
    stripePublicKey: String
  };

  connect() {
    this.stripe = Stripe(this.stripePublicKeyValue);
    this.elements = this.stripe.elements();

    const elementsOptions = {
      mode: "payment",
      amount: this.amountValue,
      currency: "usd",
      paymentMethodCreation: "manual"
    };
    this.elements = this.stripe.elements(elementsOptions);
    const paymentElement = this.elements.create("payment");
    paymentElement.mount("#payment-element");
  }

  async handlePaymentMethod(event) {
    event.preventDefault();

    if (this.btnSubmitTargets.some((el) => el.disabled)) {
      return;
    }
    this.btnSubmitTargets.forEach((el) => el.disabled = true);

    if (this.paymentMethodIdFieldTarget.checked) {
      this.newPaymentMethodFieldTarget.value = "1";
      event.preventDefault();
      const stripePayment = await this.processStripePayment();
      if (!stripePayment) {
        this.handleError();
        return;
      }

      this.paymentMethodIdFieldTarget.value = stripePayment.id;
    }

    this.element.submit();
  }

  handleError(e) {
    this.btnSubmitTargets.forEach((el) => el.disabled = false);
  }

  async processStripePayment() {
    const { error: submitError } = await this.elements.submit();
    if (submitError) {
      return false;
    }

    const { error, paymentMethod } = await this.stripe.createPaymentMethod({ elements: this.elements });

    if (error) {
      return false;
    }

    return paymentMethod;
  }
}
