import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
  }

  clearErrors() {
    this.element.classList.remove("errors");
  }
}
