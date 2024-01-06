import {Controller} from "@hotwired/stimulus"
import debounce from "debounce";

// Connects to data-controller="debounced-submit"
export default class extends Controller {
  static targets = ["form"];
  static values = {wait: {type: Number, default: 250}};

  get form() {
    return this.hasFormTarget ? this.formTarget : this.element.form;
  }

  constructor(...args) {
    super(...args);
    this.submit = debounce(this.submit, this.waitValue);
  }

  connect() {
  }

  submit() {
    this.form.requestSubmit();
  }
}
