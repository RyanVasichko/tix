import { Controller } from "@hotwired/stimulus";
import * as d3 from "d3";

export default class extends Controller {
  static values = {
    id: String,
    x: Number,
    y: Number,
    seatNumber: Number,
    tableNumber: Number
  };

  connect() {
    const drag = d3.drag()
      .on("drag", this.dragged.bind(this));

    d3.select(this.element).call(drag);
  }

  xValueChanged() {
    this.element.setAttribute('cx', this.xValue);
  }

  yValueChanged() {
    this.element.setAttribute('cy', this.yValue);
  }

  dragged(event) {
    this.xValue = event.x;
    this.yValue = event.y;
  }
}

