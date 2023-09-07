import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="ease-in"
export default class extends Controller {
  connect() {
    this.element.classList.remove('translate-y-2', 'opacity-0', 'sm:translate-y-0', 'sm:translate-x-2');
    this.element.classList.add('translate-y-0', 'opacity-100', 'sm:translate-x-0');
  }
}
