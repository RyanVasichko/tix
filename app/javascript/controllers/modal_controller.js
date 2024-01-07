import {enter, leave} from "el-transition"
import ApplicationController from "./application_controller";
import {Modal} from "flowbite";

class ModalController extends ApplicationController {
  static values = {
    openOnConnect: {type: Boolean, default: false},
    targetTopFrameOnSuccess: {type: Boolean, default: true}
  }

  connect() {
    super.connect();

    this.modal = new Modal(this.element);

    if (this.openOnConnectValue) {
      this.open();
    }
  }

  disconnect() {
    this.modal.destroy();
    this.modal = null;
  }

  open() {
    this.modal.show();
    this.isOpen = true;
  }

  close() {
    this.modal.hide();
  }

  closeOnSuccessfulFormSubmit(event) {
    if (event.detail.success) {
      this.close();
      this.element.remove();
    }
  }
}

export default ModalController;
