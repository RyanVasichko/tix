import ApplicationController from "controllers/application_controller";
import { get } from "@rails/request.js";

export default class extends ApplicationController {
  static targets = [
    "svgCanvas",
    "seatsContainer",
    "sectionNameInput",
    "modal",
    "seat",
    "ticketTypeSelect",
    "venueSelect"
  ];

  static values = {
    newSeatUrl: String,
    removedSections: Array,
    ticketTypeOptionsUrl: String,
    newSectionUrl: String
  };

  connect() {
    super.connect();
  }

  get sections() {
    return this.sectionNameInputTargets
      .filter(i => !this.removedSectionsValue.includes(+i.dataset.sectionId))
      .map(s => ({ id: s.dataset.sectionId, name: s.value }));
  }

  async addSeat() {
    const response = await get(this.newSeatUrlValue);
    const html = await response.text;

    this.svgCanvasTarget.innerHTML += html;
    const newSeat = this.svgCanvasTarget.lastElementChild;
    this.application.getControllerForElementAndIdentifier(this.modalTarget, "admin--seating-chart-form--seat-form-modal").open(newSeat, this.sections);
  }

  editSeat(event) {
    const modalController = this.application.getControllerForElementAndIdentifier(this.modalTarget, "admin--seating-chart-form--seat-form-modal");
    modalController.open(event.target, this.sections);
  }

  submitForm() {
    this.seatsContainerTarget.innerHTML = "";

    this.seatTargets.forEach((seat, i) => {
      const seatController = this.application.getControllerForElementAndIdentifier(seat, "admin--seating-chart-form--seat");
      const namePrefix = `seating_chart[sections_attributes][${seatController.sectionIdValue}][seats_attributes][${i}]`;
      this.appendHiddenField(`${namePrefix}[seat_number]`, seatController.seatNumberValue);
      this.appendHiddenField(`${namePrefix}[table_number]`, seatController.tableNumberValue);
      this.appendHiddenField(`${namePrefix}[x]`, seatController.xValue);
      this.appendHiddenField(`${namePrefix}[y]`, seatController.yValue);
      this.appendHiddenField(`${namePrefix}[_destroy]`, seat.classList.contains("d-none"));
      if (seatController.idValue) {
        this.appendHiddenField(`${namePrefix}[id]`, seatController.idValue);
      }
    });
  }

  appendHiddenField(name, value) {
    const inputField = document.createElement("input");
    inputField.type = "hidden";
    inputField.name = name;
    inputField.value = value;
    this.seatsContainerTarget.appendChild(inputField);
  }

  removeSection(e) {
    const removedSectionId = e.currentTarget.dataset.sectionId;
    this.removedSectionsValue = [...this.removedSectionsValue, +removedSectionId];
    this.seatTargets.filter(c => c.dataset.seatSectionIdValue === removedSectionId).forEach(c => c.remove());
  }

  async loadTicketTypeOptionsForVenue(e) {
    const selectedVenue = e.currentTarget.value;
    const ticketTypeOptionsResponse = await get(this.ticketTypeOptionsUrlValue.replace("venue_id", selectedVenue));
    const ticketTypeOptionsHtml = await ticketTypeOptionsResponse.text
    this.ticketTypeSelectTargets.forEach((s) => {
      s.innerHTML = ticketTypeOptionsHtml;
    });
  }

  async loadNewSectionForm() {
    const venueSeatsUrl = this.newSectionUrlValue.replace("_venue_id_", this.venueSelectTarget.value);
    await get(venueSeatsUrl, { responseKind: "turbo-stream" });
  }
}
