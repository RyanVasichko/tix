import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="admin--seating-chart-form--venue-layout"
export default class extends Controller {
  static targets = [ "svgCanvas", "imageInput" ];

  loadImage(event) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        const img = new Image();
        img.onload = () => {
          this.svgCanvasTarget.style.width = `${img.width}px`;
          this.svgCanvasTarget.style.height = `${img.height}px`;

          this.svgCanvasTarget.style.backgroundImage = `url(${e.target.result})`;
          this.svgCanvasTarget.style.backgroundSize = "cover";
        };
        img.src = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  }
}
