import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

// Connects to data-controller="admin--shows-form--sections"
export default class extends Controller {
  async loadSections(event) {
    const selectedSeatingChartId = event.target.value;
    await get(`/admin/shows/seating_charts/${selectedSeatingChartId}/sections/new`, {
      responseKind: "turbo-stream",
    });
  }
}
