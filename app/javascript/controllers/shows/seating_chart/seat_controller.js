import debounce from 'debounce';
import { post, destroy } from "@rails/request.js"
import ApplicationController from "../../application_controller";

// Connects to data-controller="shows--seating-chart--seat"
export default class extends ApplicationController {
  static values = {
    reservedByUserId: String,
    reservationPath: String,
    reservedUntil: Number,
    soldToUserId: String,
    heldByUserId: String
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

  get reserved() {
    return !!this.reservedByUserIdValue && this.reservedUntilDate > new Date();
  }

  get sold() {
    return !!this.soldToUserIdValue;
  }

  get held() {
    return !!this.heldByUserIdValue;
  }

  get fillColor() {
    if (!this.reserved && !this.sold && !this.held) {
      return "green";
    }

    if (this.held && this.currentUserIsAdmin) {
      return "purple";
    }

    if (this.reservedByCurrentUser || this.soldToCurrentUser) {
      return "yellow";
    }

    return "red";
  }

  connect() {
    super.connect();
    this.element.setAttribute("fill", this.fillColor);
    this.element.setAttribute("fill-opacity", 1);
    this.clickHandler = debounce(this.clickHandler.bind(this), 1000, { immediate: true });
  }

  async clickHandler() {
    console.log(this.heldByUserIdValue)
    if (this.reservedByCurrentUser) {
      this.element.setAttribute("fill", "green");
      await destroy(this.reservationPathValue, { responseKind: "turbo-stream" });
      return;
    }

    const reservable = !this.reserved && !this.sold && !this.held;
    if (reservable) {
      this.element.setAttribute("fill", "yellow");
      await post(this.reservationPathValue, { responseKind: "turbo-stream" });
    }
  }
}
