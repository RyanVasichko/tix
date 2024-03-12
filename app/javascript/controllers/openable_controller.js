import { Controller } from "@hotwired/stimulus"
import { enter, leave, toggle } from "el-transition"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["content"];

  toggle(event) {
    event.stopPropagation();
    this.contentTargets.forEach(t => toggle(t));
  }

  hideOnOutsideClick(event) {
    // Check if the click was inside the dropdown; if not, hide the dropdown
    if (!this.element.contains(event.target)) {
      this.hide();
    }
  }

  show() {
    this.contentTargets.forEach(t => enter(t));
  }

  hide() {
    this.contentTargets.forEach(t => leave(t));
  }
}
