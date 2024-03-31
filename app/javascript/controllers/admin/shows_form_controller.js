import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {
  static targets = [ "generalAdmissionShowFields", "reservedSeatingShowFields", "generalAdmissionSectionFields", "reservedSeatingSectionFields", "showTypeSelect", "venueSelect" ];

  connect() {
  }

  get #showType() {
    return this.showTypeSelectTarget.value;
  }

  async showFieldsForShowType() {
    if (this.#showType === "Shows::ReservedSeating") {
      await this.loadVenueSeatingCharts();
    }

    this.generalAdmissionShowFieldsTargets.forEach(t => t.classList.toggle("hidden", this.#showType !== "Shows::GeneralAdmission"));
    this.generalAdmissionSectionFieldsTargets.forEach(t => t.disabled = this.#showType !== "Shows::GeneralAdmission");

    this.reservedSeatingShowFieldsTargets.forEach(t => t.classList.toggle("hidden", this.#showType !== "Shows::ReservedSeating"));
    this.reservedSeatingSectionFieldsTargets.forEach(t => t.disabled = this.#showType !== "Shows::ReservedSeating");
  }

  async loadSeatingChartSections({ currentTarget }) {
    const seatingChartId = currentTarget.value;
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
}
