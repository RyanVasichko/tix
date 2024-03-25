import { Controller } from "@hotwired/stimulus";
import { Sortable } from "sortablejs";
import { put } from "@rails/request.js";

// Connects to data-controller="admin--merch"
export default class extends Controller {
  static targets = [ "merch", "merchTableBody" ];
  static values = {
    updateOrderUrl: String
  };

  connect() {
    this.sortable = new Sortable(this.merchTableBodyTarget, {
      group: "test",
      dragClass: ".merch",
      animation: 150,
      easing: "cubic-bezier(1, 0, 0, 1)",
      sort: true,
      onEnd: this.updateOrder
    });
  }

  disconnect() {
    if (this.sortable) {
      this.sortable.destroy();
    }
  }

  updateOrder = async ({ item }) => {
    const orderedMerch = this.merchTargets.map((t, index) => ({ id: +t.dataset.id, order: index + 1 }));

    await put(this.updateOrderUrlValue, {
      body: JSON.stringify({ merch: orderedMerch }),
      contentType: "application/json"
    });
    Turbo.reload();
  };
}
