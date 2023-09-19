import { Controller } from "@hotwired/stimulus"
import { post, destroy } from "@rails/request.js"

// Connects to data-controller="shows--seating-chart--seat"
export default class extends Controller {
  static values = {
    reservedById: Number,
    reservationPath: String,
    reservedUntil: Number,
    soldToUserId: Number
  };

  get reservedUntilDate() {
    if (!this.reservedUntilValue) {
      return null;
    }

    return new Date(this.reservedUntilValue * 1000);
  }

  get reservedByCurrentUser() {
    return this.currentUserId === this.reservedByIdValue && this.reservedUntilDate > new Date();
  }

  get soldToCurrentUser() {
    return this.currentUserId === this.soldToUserIdValue;
  }

  get notReserved() {
    return this.reservedByIdValue === 0 || this.reservedUntilDate < new Date();
  }

  get notSold() {
    return this.soldToUserIdValue === 0;
  }

  get fillColor() {
    if (this.notReserved && this.notSold) {
      return "green";
    }

    return this.reservedByCurrentUser || this.soldToCurrentUser ? "yellow" : "red";
  }

  get currentUserId() {
    return +document.body.dataset.currentUserId;
  }

  connect() {
    this.element.setAttribute("fill", this.fillColor);
    this.element.setAttribute("fill-opacity", 1);
  }

  async clickHandler() {
    if (this.reservedByCurrentUser) {
      await destroy(this.reservationPathValue, { responseKind: "turbo-stream" });
      return;
    }

    if (this.notReserved && this.notSold) {
      await post(this.reservationPathValue, { responseKind: "turbo-stream" });
    }
  }
}
