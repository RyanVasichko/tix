import { Application, Controller } from "@hotwired/stimulus";

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

  debounce(func, wait) {
    let timeout;

    return function(...args) {
      if (!timeout) {
        func.apply(this, args);
        timeout = setTimeout(() => {
          timeout = null;
        }, wait);
      }
    };
  }
}

export default ApplicationController;

