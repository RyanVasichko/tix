import {Controller} from "@hotwired/stimulus";
import debounce from 'debounce';
import {post, destroy} from "@rails/request.js"
import Seat from "models/seating_chart/seat";
import CurrentUser from "models/current_user";

// Connects to data-controller="shows--seating-chart--seat"
export default class extends Controller {
  static values = {
    selectedByUserId: String,
    createTicketSelectionPath: String,
    destroyTicketSelectionPath: String,
    selectionExpiresAt: Number,
    soldToUserId: String,
    held: Boolean
  };

  #seat;

  connect() {
    this.#seat = new Seat(this.selectedByUserIdValue, this.selectionExpiresAtValue, this.soldToUserIdValue, this.heldValue);
    this.#presentForCurrentUser();
    this.clickHandler = debounce(this.clickHandler.bind(this), 200, {immediate: true});
  }

  async clickHandler() {
    if (!this.#seat.actionable) {
      return;
    }

    if (this.#seat.selectedByCurrentUser) {
      this.element.setAttribute("fill", "green");
      await destroy(this.destroyTicketSelectionPathValue, {responseKind: "turbo-stream"});
      return;
    }

    if (this.#seat.selectable) {
      this.element.setAttribute("fill", "yellow");
      await post(this.createTicketSelectionPathValue, {responseKind: "turbo-stream"});
    }
  }

  #presentForCurrentUser() {
    let fillColor = "red";
    if (!this.#seat.selected && !this.#seat.sold && !this.#seat.held) {
      fillColor = "green";
    } else if (this.#seat.held && CurrentUser.isAdmin) {
      fillColor = "purple";
    } else if (this.#seat.selectedByCurrentUser || this.#seat.soldToCurrentUser) {
      fillColor = "yellow";
    }

    this.element.setAttribute("fill", fillColor);
    this.element.setAttribute("fill-opacity", 1);
    if (this.#seat.actionable) {
      this.element.classList.add("cursor-pointer");
    }
  }
}
