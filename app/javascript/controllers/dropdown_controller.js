import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["menu"];
  static values = {
    isVisible: { type: Boolean, default: false }
  };

  connect() {
    this.isVisibleValue = false;
  }

  toggle(event) {
    event.stopPropagation();
    this.isVisibleValue = !this.isVisibleValue;

    this.isVisibleValue ? this.show() : this.hide();
  }

  outsideClick(event) {
    // Check if the click was inside the dropdown; if not, hide the dropdown
    if (!this.element.contains(event.target)) {
      this.isVisibleValue = false;
      this.hide();
    }
  }

  show() {
    this.menuTarget.classList.remove("transform", "opacity-0", "scale-95", "hidden");
    this.menuTarget.classList.add("transition", "ease-out", "duration-100", "transform", "opacity-100", "scale-100");
  }

  hide() {
    this.menuTarget.classList.remove("transition", "ease-out", "duration-100", "transform", "opacity-100", "scale-100");
    this.menuTarget.classList.add("transition", "ease-in", "duration-75", "transform", "opacity-0", "scale-95");
    setTimeout(() => this.menuTarget.classList.add("hidden"), 100);
  }
}
