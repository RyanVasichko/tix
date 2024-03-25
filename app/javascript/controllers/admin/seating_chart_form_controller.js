import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";
import SeatFormFields from "models/admin/seating_chart_form/seat_form_fields";

export default class extends Controller {
  static targets = [ "svgCanvas", "seatsContainer", "sectionNameInput", "modal", "ticketTypeSelect", "venueSelect" ];
  static outlets = [ "admin--seating-chart-form--seat" ];
  static values = { newSeatUrl: String, removedSections: Array, ticketTypeOptionsUrl: String, newSectionUrl: String };

  async addSeat() {
    const response = await get(this.newSeatUrlValue);
    const html = await response.text;

    const svgCircle = this.#createSvgCircleFromString(html);
    this.svgCanvasTarget.appendChild(svgCircle);
    this.#seatFormModal.open(svgCircle, this.#sections);
  }

  editSeat(event) {
    this.#seatFormModal.open(event.target, this.#sections);
  }

  addSeatFieldsToForm({ currentTarget }) {
    this.seatsContainerTarget.innerHTML = "";

    this.adminSeatingChartFormSeatOutlets.forEach((seat) => {
      const seatFormFields = new SeatFormFields(seat);
      seatFormFields.appendHiddenFieldsTo(this.seatsContainerTarget);
    });

    currentTarget.submit();
  }

  removeSection(e) {
    const removedSectionId = +e.currentTarget.dataset.sectionId;
    this.removedSectionsValue = [ ...this.removedSectionsValue, removedSectionId ];
    this.adminSeatingChartFormSeatOutlets.filter(c => c.sectionIdValue === removedSectionId)
      .forEach(c => c.element.remove());
  }

  async loadTicketTypeOptionsForVenue({ currentTarget }) {
    const ticketTypeOptionsResponse = await get(this.ticketTypeOptionsUrlValue.replace("_venue_id_", currentTarget.value));
    const ticketTypeOptionsHtml = await ticketTypeOptionsResponse.text;
    this.ticketTypeSelectTargets.forEach((s) => s.innerHTML = ticketTypeOptionsHtml);
  }

  async loadNewSectionForm() {
    const venueSeatsUrl = this.newSectionUrlValue.replace("_venue_id_", this.venueSelectTarget.value);
    await get(venueSeatsUrl, { responseKind: "turbo-stream" });
  }

  get #seatFormModal() {
    return this.application.getControllerForElementAndIdentifier(this.modalTarget, "admin--seating-chart-form--seat-form-modal");
  }

  get #sections() {
    return this.sectionNameInputTargets
      .filter(i => !this.removedSectionsValue.includes(+i.dataset.sectionId))
      .map(s => ({ id: s.dataset.sectionId, name: s.value }));
  }

  #createSvgCircleFromString(html) {
    const htmlCircle = new DOMParser().parseFromString(html, "image/svg+xml").querySelector("circle");
    const svgCircle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
    Array.from(htmlCircle.attributes).forEach((attr) => svgCircle.setAttribute(attr.name, attr.value));
    return svgCircle;
  }
}
