import { enter, leave } from "el-transition"
import ApplicationController from "./application_controller";

class ModalController extends ApplicationController {
  static targets = ["body", "backdrop", "focus"];
  static values = { 
    openOnConnect: { type: Boolean, default: false }
  }

  connect() {
    if (this.openOnConnectValue) {
      this.open();
    }
  }

  async open() {
    this.element.classList.remove("hidden");
    if (this.hasFocusTarget) {
      this.focusTarget.focus();
    }
    await Promise.all([
      enter(this.bodyTarget),
      enter(this.backdropTarget)
    ]);
    this.isOpen = true;
  }

  async closeOnSuccessfulFormSubmit(event) {
    if (event.detail.success) {
      await this.close();
      this.element.remove();
    }
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

export default ModalController;