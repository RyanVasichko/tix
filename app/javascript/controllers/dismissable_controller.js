import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dismissable"
export default class extends Controller {
  static values = {
    autoDismiss: { type: Boolean, default: true },
    autoDismissAfter: { type: Number, default: 3000 }
  };

  connect() {
    if (this.autoDismissValue) {
      setTimeout(() => this.dismiss(), this.autoDismissAfterValue);
    }
  }

  dismiss() {
    this.element.classList.remove('opacity-100');
    this.element.classList.add('transition', 'ease-in', 'duration-100', 'opacity-0');
    setTimeout(() => this.element.remove(), 100);
  }
}
