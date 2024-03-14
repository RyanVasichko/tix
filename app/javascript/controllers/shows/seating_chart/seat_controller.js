import debounce from 'debounce';
import { post, destroy } from "@rails/request.js"
import ApplicationController from "controllers/application_controller";

// Connects to data-controller="shows--seating-chart--seat"
export default class extends ApplicationController {
  static values = {
    reservedByUserId: String,
    reservationPath: String,
    reservedUntil: Number,
    soldToUserId: String,
    heldByUserId: String
  };

  get #reservedUntilDate() {
    if (!this.reservedUntilValue) {
      return undefined;
    }

    return new Date(this.reservedUntilValue * 1000);
  }

  get #reservedByCurrentUser() {
    return this.currentUserId === this.reservedByUserIdValue && this.#reservedUntilDate > new Date();
  }

  get #soldToCurrentUser() {
    return this.currentUserId === this.soldToUserIdValue;
  }

  get #reserved() {
    return !!this.reservedByUserIdValue && this.#reservedUntilDate > new Date();
  }

  get #sold() {
    return !!this.soldToUserIdValue;
  }

  get #held() {
    return !!this.heldByUserIdValue;
  }

  get #fillColor() {
    if (!this.#reserved && !this.#sold && !this.#held) {
      return "green";
    }

    if (this.#held && this.currentUserIsAdmin) {
      return "purple";
    }

    if (this.#reservedByCurrentUser || this.#soldToCurrentUser) {
      return "yellow";
    }

    return "red";
  }

  get #reservable() {
    return !this.#reserved && !this.#sold && !this.#held
  }

  get #actionable() {
    return this.#reservable || this.#reservedByCurrentUser;
  }

  connect() {
    super.connect();
    this.element.setAttribute("fill", this.#fillColor);
    this.element.setAttribute("fill-opacity", 1);
    if (this.#actionable) {
      this.element.classList.add("cursor-pointer");
    }
    this.clickHandler = debounce(this.clickHandler.bind(this), 1000, { immediate: true });
  }

  async clickHandler() {
    if (!this.#actionable) {
      return;
    }

    if (this.#reservedByCurrentUser) {
      this.element.setAttribute("fill", "green");
      await destroy(this.reservationPathValue, { responseKind: "turbo-stream" });
      return;
    }

    if (this.#reservable) {
      this.element.setAttribute("fill", "yellow");
      await post(this.reservationPathValue, { responseKind: "turbo-stream" });
    }
  }
}
