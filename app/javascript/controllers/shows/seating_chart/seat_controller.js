import debounce from 'debounce';
import { post, destroy } from "@rails/request.js"
import ApplicationController from "controllers/application_controller";

// Connects to data-controller="shows--seating-chart--seat"
export default class extends ApplicationController {
  static values = {
    selectedByUserId: String,
    createTicketSelectionPath: String,
    destroyTicketSelectionPath: String,
    selectionExpiresAt: Number,
    soldToUserId: String,
    heldByUserId: String
  };

  get #selectionExpiresAtDate() {
    if (!this.selectionExpiresAtValue) {
      return undefined;
    }

    return new Date(this.selectionExpiresAtValue * 1000);
  }

  get #selectedByCurrentUser() {
    return this.currentUserId === this.selectedByUserIdValue && this.#selectionExpiresAtDate > new Date();
  }

  get #soldToCurrentUser() {
    return this.currentUserId === this.soldToUserIdValue;
  }

  get #selected() {
    return !!this.selectedByUserIdValue && this.#selectionExpiresAtDate > new Date();
  }

  get #sold() {
    return !!this.soldToUserIdValue;
  }

  get #held() {
    return !!this.heldByUserIdValue;
  }

  get #fillColor() {
    if (!this.#selected && !this.#sold && !this.#held) {
      return "green";
    }

    if (this.#held && this.currentUserIsAdmin) {
      return "purple";
    }

    if (this.#selectedByCurrentUser || this.#soldToCurrentUser) {
      return "yellow";
    }

    return "red";
  }

  get #selectable() {
    return !this.#selected && !this.#sold && !this.#held
  }

  get #actionable() {
    return this.#selectable || this.#selectedByCurrentUser;
  }

  connect() {
    super.connect();
    this.element.setAttribute("fill", this.#fillColor);
    this.element.setAttribute("fill-opacity", 1);
    if (this.#actionable) {
      this.element.classList.add("cursor-pointer");
    }
    this.clickHandler = debounce(this.clickHandler.bind(this), 1_000, { immediate: true });
  }

  async clickHandler() {
    if (!this.#actionable) {
      return;
    }

    if (this.#selectedByCurrentUser) {
      this.element.setAttribute("fill", "green");
      await destroy(this.destroyTicketSelectionPathValue, { responseKind: "turbo-stream" });
      return;
    }

    if (this.#selectable) {
      this.element.setAttribute("fill", "yellow");
      await post(this.createTicketSelectionPathValue, { responseKind: "turbo-stream" });
    }
  }
}
