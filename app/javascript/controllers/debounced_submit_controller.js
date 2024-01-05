import { Controller } from "@hotwired/stimulus"
import debounce from "debounce";

// Connects to data-controller="debounced-submit"
export default class extends Controller {
  static values = { wait: { type: Number, default: 250 } };

  constructor(...args) {
    super(...args);
    this.submit = debounce(this.submit, this.waitValue);
  }

  connect() {
  }

  submit() {
    this.element.form.requestSubmit();
  }
}
