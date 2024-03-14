import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

// Connects to data-controller="admin--shows-form"
export default class extends Controller {
  static targets = [
    "generalAdmissionShowFields",
    "reservedSeatingShowFields",
    "generalAdmissionSectionFields",
    "reservedSeatingSectionFields",
    "showTypeSelect",
    "seatingChartSelect",
    "venueSelect"
  ];

  get #showType() {
    return this.showTypeSelectTarget.value;
  }

  connect() {
  }

  async showFieldsForShowType() {
    this.#hideAndDisableAllShowTypeSpecificFields();

    if (this.#showType === "Shows::ReservedSeating") {
      await this.loadVenueSeatingCharts()
      this.#showReservedSeatingShowFields();
    } else if (this.#showType === "Shows::GeneralAdmission") {
      this.#showGeneralAdmissionShowFields();
    }
  }

  async loadSeatingChartSections() {
    const seatingChartId = this.seatingChartSelectTarget.value;
    await get(`/admin/shows/seating_charts/${seatingChartId}/reserved_seating_show_sections_fields`, {
      responseKind: "turbo-stream"
    });
  }

  async loadVenueSeatingCharts() {
    if (this.#showType !== "Shows::ReservedSeating") {
      return;
    }

    const venueId = this.venueSelectTarget.value;
    await get(`/admin/shows/venues/${venueId}/seating_chart_fields`, {
      responseKind: "turbo-stream"
    });
  }

  #hideAndDisableAllShowTypeSpecificFields() {
    this.generalAdmissionShowFieldsTarget.classList.add("hidden");
    this.reservedSeatingShowFieldsTarget.classList.add("hidden");
    this.generalAdmissionSectionFieldsTargets.forEach(t => t.disabled = this.#showType !== "Shows::GeneralAdmission");
    this.reservedSeatingSectionFieldsTargets.forEach(t => t.disabled = this.#showType !== "Shows::ReservedSeating");
  }

  #showGeneralAdmissionShowFields() {
    this.generalAdmissionShowFieldsTarget.classList.remove("hidden");
    this.generalAdmissionSectionFieldsTargets.forEach(t => t.disabled = false);
  }

  #showReservedSeatingShowFields() {
    this.reservedSeatingShowFieldsTarget.classList.remove("hidden");
    this.reservedSeatingSectionFieldsTargets.forEach(t => t.disabled = false);
  }
}
