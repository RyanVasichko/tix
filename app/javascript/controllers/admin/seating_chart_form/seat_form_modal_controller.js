import ModalController from "../../modal_controller";

class SeatFormModal extends ModalController {
  static targets = [
    "seatNumberInput",
    "tableNumberInput",
    "sectionSelect"
  ];
  
  open(seat, sections) {
    this.seat = seat;
    this.#populateSectionsSelectOptions(sections);
    this.#setSeatFields();
    super.open();
  }
  
  save() {
    const seatController = this.application.getControllerForElementAndIdentifier(this.seat, 'admin--seating-chart-form--seat');

    seatController.seatNumberValue = this.seatNumberInputTarget.value;
    seatController.tableNumberValue = this.tableNumberInputTarget.value;
    seatController.sectionIdValue = this.sectionSelectTarget.value;

    this.close();
  }

  delete() {
    const seatController = this.application.getControllerForElementAndIdentifier(this.seat, 'admin--seating-chart-form--seat');
    if (seatController.idValue) {
      this.seat.classList.add("d-none");
    } else {
      this.seat.remove();
    }

    this.close();
  }

  #populateSectionsSelectOptions(sections) {
    this.sectionSelectTarget.innerHTML = '';
    sections.forEach(section => {
      const option = document.createElement("option");
      option.text = section.name;
      option.value = section.id;
      this.sectionSelectTarget.appendChild(option);
    });
  }

  #setSeatFields() {
    const seatController = this.application.getControllerForElementAndIdentifier(this.seat, 'admin--seating-chart-form--seat');

    this.seatNumberInputTarget.value = seatController?.seatNumberValue || '';
    this.tableNumberInputTarget.value = seatController?.tableNumberValue || '';
    this.sectionSelectTarget.value = seatController?.sectionIdValue || '';
  }

}

export default SeatFormModal;