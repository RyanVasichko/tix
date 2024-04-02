import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [ "seatNumberInput", "tableNumberInput", "sectionSelect" ];
  #seat;

  open(seat, sections) {
    this.#seat = seat;
    this.#populateSectionsSelectOptions(sections);
    this.#setSeatFields();
    this.element.showModal();
  }

  close() {
    this.element.close();
  }

  save() {
    const seatController = this.#getSeatController();

    seatController.seatNumberValue = this.seatNumberInputTarget.value;
    seatController.tableNumberValue = this.tableNumberInputTarget.value;
    seatController.sectionIdValue = this.sectionSelectTarget.value;

    this.close();
  }

  delete() {
    const seatController = this.#getSeatController();

    const seatElement = seatController.element;
    if (seatController.idValue) {
      seatElement.classList.add("hidden");
    } else {
      seatElement.remove();
    }

    this.close();
  }

  #getSeatController() {
    return this.application.getControllerForElementAndIdentifier(this.#seat, "admin--seating-chart-form--seat");
  }

  #populateSectionsSelectOptions(sections) {
    this.sectionSelectTarget.innerHTML = "";
    sections.forEach(section => {
      const option = document.createElement("option");
      option.text = section.name;
      option.value = section.id;
      this.sectionSelectTarget.appendChild(option);
    });
  }

  #setSeatFields() {
    const seatController = this.#getSeatController();

    this.seatNumberInputTarget.value = seatController?.seatNumberValue || "";
    this.tableNumberInputTarget.value = seatController?.tableNumberValue || "";
    this.sectionSelectTarget.value = seatController?.sectionIdValue || "";
  }
}
