import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [ "destroyInput" ];

  connect() {
  }

  destroy() {
    this.element.classList.add("hidden");
    if (this.destroyInputTarget) {
      this.destroyInputTarget.value = "1";
    }
  }
}
