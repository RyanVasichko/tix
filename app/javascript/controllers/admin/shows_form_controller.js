import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

// Connects to data-controller="admin--shows-form"
export default class extends Controller {
  connect() {
  }

  async loadSeatingChartSections(event) {
    const selectedSeatingChartId = event.currentTarget.value;
    await get(`/admin/shows/seating_charts/${selectedSeatingChartId}/sections_fields/`, {
      responseKind: "turbo-stream"
    });
  }

  async loadVenueSeatingCharts(event) {
    const selectedVenueId = event.currentTarget.value;
    await get(`/admin/shows/venues/${selectedVenueId}/seating_chart_fields/`, {
      responseKind: "turbo-stream"
    });
  }
}
