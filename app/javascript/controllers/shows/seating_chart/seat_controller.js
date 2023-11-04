import { post, destroy } from "@rails/request.js"
import ApplicationController from "../../application_controller";

// Connects to data-controller="shows--seating-chart--seat"
export default class extends ApplicationController {
  static values = {
    reservedByUserId: String,
    reservationPath: String,
    reservedUntil: Number,
    soldToUserId: String
  };

  get reservedUntilDate() {
    if (!this.reservedUntilValue) {
      return undefined;
    }

    return new Date(this.reservedUntilValue * 1000);
  }

  get reservedByCurrentUser() {
    return this.currentUserId === this.reservedByUserIdValue && this.reservedUntilDate > new Date();
  }

  get soldToCurrentUser() {
    return this.currentUserId === this.soldToUserIdValue;
  }

  get notReserved() {
    return !this.reservedByUserIdValue || this.reservedUntilDate < new Date();
  }

  get notSold() {
    return !this.soldToUserIdValue;
  }

  get fillColor() {
    if (this.notReserved && this.notSold) {
      return "green";
    }

    return this.reservedByCurrentUser || this.soldToCurrentUser ? "yellow" : "red";
  }

  get currentUserId() {
    return document.body.dataset.currentUserId;
  }

  connect() {
    super.connect();
    this.element.setAttribute("fill", this.fillColor);
    this.element.setAttribute("fill-opacity", 1);
    this.clickHandler = this.debounce(this.clickHandler.bind(this), 1000);
  }

  async clickHandler() {
    Turbo.cache.exemptPageFromPreview();

    if (this.reservedByCurrentUser) {
      this.element.setAttribute("fill", "green");
      await destroy(this.reservationPathValue);
      return;
    }

    if (this.notReserved && this.notSold) {
      this.element.setAttribute("fill", "yellow");
      await post(this.reservationPathValue);
    }
  }
}
