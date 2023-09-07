import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class extends Controller {
  static targets = ["body", "backdrop", "focus"];

  async open() {
    this.element.classList.remove("hidden");
    if (this.focusTarget) {
      this.focusTarget.focus();
    }
    await Promise.all([
      enter(this.bodyTarget),
      enter(this.backdropTarget)
    ]);
    this.isOpen = true;

  }

  async close() {
    this.isOpen = false;
    await Promise.all([
      leave(this.bodyTarget),
      leave(this.backdropTarget)
    ]);
    this.element.classList.add("hidden");
  }

  hideOnOutsideClick(event) {
    if (this.isOpen && !this.bodyTarget.contains(event.target)) {
      this.close();
    }
  }
}
