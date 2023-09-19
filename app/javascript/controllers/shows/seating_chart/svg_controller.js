import { Controller } from "@hotwired/stimulus";
import * as d3 from "d3";

// Connects to data-controller="shows--seating-chart--svg"
export default class extends Controller {
  connect() {
    document.addEventListener("turbo:before-stream-render", this.replaceSeat);
  }

  disconnect() {
    document.removeEventListener("turbo:before-stream-render", this.replaceSeat);
  }

  replaceSeat = (event) => {
    // turbo streams can't handle svg stuff, so replacing the seat has to be done manually
    const newStream = event.detail.newStream;

    if (!newStream.getAttribute("target").startsWith("show_seat_"))
    {
      return;
    }

    event.preventDefault();

    const circleData = newStream.querySelector("template").content.querySelector("circle");

    if (circleData) {
      d3.select(this.element).append("circle")
        .each(function() {
          for (let attribute of circleData.attributes) {
            d3.select(this).attr(attribute.name, attribute.value);
          }
        });

      const oldCircle = d3.select(`#${newStream.getAttribute("target")}`);
      if (oldCircle) oldCircle.remove();
    }
  };
}
