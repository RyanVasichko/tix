import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["destroyInput"];
  static values = {
    persisted: Boolean
  };

  connect() {
  }

  destroy() {
    if (this.persistedValue) {
      this.element.classList.add("d-none");
      this.destroyInputTarget.value = '1';
    } else {
      this.element.remove();
    }
  }
}
