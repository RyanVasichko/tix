import { Controller } from "@hotwired/stimulus";

class ApplicationController extends Controller {
  connect() {
    this.element[this.identifier] = this;
  }

  createElementFromHTML(html) {
    let div = document.createElement("div");
    div.innerHTML = html.trim();

    const createdElement = div.firstChild;
    if (createdElement) {
      div.removeChild(createdElement);  // Detach the element from the div.
    }

    return createdElement;
  }
}

export default ApplicationController;
