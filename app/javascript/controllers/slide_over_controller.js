import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="slide-over"
export default class extends Controller {
  static targets = ["wrapper", "toggle", "backdrop"];

  get isShown() {
    const isShown = this.wrapperTarget.classList.contains("translate-x-0");
    return isShown
  }

  connect() {
    this.show();
  }

  toggle(event) {
    event.stopPropagation();

    if (this.isShown) {
      this.hide();
    } else {
      this.show();
    }
  }

  show() {
    this.wrapperTarget.classList.remove('translate-x-full');
    this.wrapperTarget.classList.add('translate-x-0');
    this.toggleTarget.classList.add("hidden");
  }
  
  hide() {
    this.wrapperTarget.classList.remove("translate-x-0");
    this.wrapperTarget.classList.add('translate-x-full');
    setTimeout(() => this.toggleTarget.classList.remove("hidden"), 600);
  }

  hideOnOutsideClick(event) {
    if (!this.wrapperTarget.contains(event.target)) {
      this.hide();
    }
  }
}
