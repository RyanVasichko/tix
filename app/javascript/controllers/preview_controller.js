import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="preview"
export default class extends Controller {
  static targets = ["output", "placeholder"];

  preview(event) {
    const reader = new FileReader();

    reader.onload = (e) => {
      this.placeholderTarget.classList.add("hidden");
      this.outputTarget.src = e.target.result;
      this.outputTarget.classList.remove('hidden');
    };

    reader.readAsDataURL(event.target.files[0]);
  }
}
