import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clear-errors"
export default class extends Controller {
  connect() {
  }

  clearErrors() {
    this.element.classList.remove("errors");
  }
}
