import { Controller } from "@hotwired/stimulus"

const HIGHLIGHT_CLASSES = ['border-indigo-500', 'bg-indigo-50'];

// Connects to data-controller="file-drop"
export default class extends Controller {
  static targets = ["input"];

  dragover(event) {
    event.preventDefault();
    this.element.classList.add(...HIGHLIGHT_CLASSES);
  }

  dragleave(event) {
    this.element.classList.remove(...HIGHLIGHT_CLASSES);
  }

  drop(event) {
    event.preventDefault();

    this.element.classList.remove(...HIGHLIGHT_CLASSES);

    const files = event.dataTransfer.files;
    if (files.length > 0) {
      this.inputTarget.files = files;
      this.inputTarget.dispatchEvent(new Event("change"));
    }
  }
}
