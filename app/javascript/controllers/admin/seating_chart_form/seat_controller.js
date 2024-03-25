import { Controller } from "@hotwired/stimulus";
import * as d3 from "d3";

export default class extends Controller {
  static values = {
    id: String,
    x: Number,
    y: Number,
    seatNumber: Number,
    tableNumber: Number,
    sectionId: Number,
    sectionIdWas: Number
  };

  connect() {
    const drag = d3.drag().on("drag", this.#updatePositionValues);

    d3.select(this.element).call(drag);
  }

  xValueChanged() {
    this.element.setAttribute("cx", this.xValue);
  }

  yValueChanged() {
    this.element.setAttribute("cy", this.yValue);
  }

  sectionIdValueChanged(value, previousValue) {
    this.sectionIdWasValue = this.sectionIdWasValue || previousValue;
  }

  #updatePositionValues = (event) => {
    this.xValue = event.x;
    this.yValue = event.y;
  };
}
