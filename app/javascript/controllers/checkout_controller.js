import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="checkout"
export default class extends Controller {
  static targets = ["submitButton", "newPaymentMethodRadioButton"];
  static values = {
    amount: Number,
    stripePublicKey: String
  };

  connect() {
    this.stripe = Stripe(this.stripePublicKeyValue);

    const elementsOptions = {
      mode: "payment",
      amount: this.amountValue,
      currency: "usd",
      paymentMethodCreation: "manual"
    };
    this.stripeElements = this.stripe.elements(elementsOptions);
    const paymentElement = this.stripeElements.create("payment");
    paymentElement.mount("#payment-element");
  }

  async handlePaymentMethod(event) {
    event.preventDefault();

    if (this.submitButtonTargets.some((el) => el.disabled)) {
      return;
    }
    this.submitButtonTargets.forEach((el) => el.disabled = true);

    if (this.newPaymentMethodRadioButtonTarget.checked) {
      event.preventDefault();
      const stripePayment = await this.processStripePayment();
      if (!stripePayment) {
        this.submitButtonTargets.forEach((el) => el.disabled = false);
        return;
      }

      this.newPaymentMethodRadioButtonTarget.value = stripePayment.id;
    }

    this.element.submit();
  }

  async processStripePayment() {
    const { error: submitError } = await this.stripeElements.submit();
    if (submitError) {
      return false;
    }

    const { error, paymentMethod } = await this.stripe.createPaymentMethod({ elements: this.stripeElements });

    if (error) {
      return false;
    }

    return paymentMethod;
  }
}
