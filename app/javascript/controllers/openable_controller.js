import { Controller } from "@hotwired/stimulus"
import { enter, leave, toggle } from "el-transition"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["content"];
  
  toggle(event) {
    event.stopPropagation();
    toggle(this.contentTarget);
  }

  hideOnOutsideClick(event) {
    // Check if the click was inside the dropdown; if not, hide the dropdown
    if (!this.element.contains(event.target)) {
      this.hide();
    }
  }

  show() {
    enter(this.contentTarget);
  }

  async hide() {
    await leave(this.contentTarget);
  }
}
