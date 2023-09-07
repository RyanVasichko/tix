import { Controller } from "@hotwired/stimulus";
import * as bootstrap from "bootstrap";

export default class extends Controller {
  static targets = [
    "svgCanvas",
    "seatsContainer",
    "modal",
    "seatNumberInput",
    "tableNumberInput",
    "sectionSelect",
    "sectionNameInput",
    "seat"
  ];

  static values = {
    newSeatUrl: String,
    removedSections: Array
  };

  connect() {
    this.modal = new bootstrap.Modal(this.modalTarget);
  }

  addSeat() {
    fetch(this.newSeatUrlValue)
      .then(response => response.text())
      .then(html => {
        this.svgCanvasTarget.innerHTML += html;
        const newSeat = this.svgCanvasTarget.lastElementChild;
        this.openModalForSeat(newSeat);
      });
  }

  openModal(event) {
    this.openModalForSeat(event.target);
  }

  openModalForSeat(seat) {
    this.populateSectionsSelectOptions();
    
    this.selectedSeat = seat;

    const seatController = this.application.getControllerForElementAndIdentifier(seat, 'admin--seating-chart-form--seat');

    this.seatNumberInputTarget.value = seatController?.seatNumberValue || '';
    this.tableNumberInputTarget.value = seatController?.tableNumberValue || '';
    this.sectionSelectTarget.value = seatController?.sectionIdValue || '';

    this.modal.show();
  }

  saveSeatData() {
    if (this.selectedSeat) {
      const seatController = this.application.getControllerForElementAndIdentifier(this.selectedSeat, 'admin--seating-chart-form--seat');

      seatController.seatNumberValue = this.seatNumberInputTarget.value;
      seatController.tableNumberValue = this.tableNumberInputTarget.value;
      seatController.sectionIdValue = this.sectionSelectTarget.value;
    }

    this.closeModal();
  }

  closeModal() {
    this.selectedSeat = null;
    this.modal.hide();
  }

  populateSectionsSelectOptions() {
    this.sectionSelectTarget.innerHTML = '';
    this.sectionNameInputTargets.filter(i => !this.removedSectionsValue.includes(+i.dataset.sectionId)).forEach(t => {
      const option = document.createElement("option");
      option.text = t.value;
      option.value = t.dataset.sectionId;
      this.sectionSelectTarget.appendChild(option);
    });
  }

  submitForm() {
    this.seatsContainerTarget.innerHTML = "";

    this.seatTargets.forEach((seat, i) => {
      const seatController = this.application.getControllerForElementAndIdentifier(seat, 'admin--seating-chart-form--seat');
      const namePrefix = `seating_chart[sections_attributes][${seatController.sectionIdValue}][seats_attributes][${i}]`;
      this.appendHiddenField(`${namePrefix}[seat_number]`, seatController.seatNumberValue);
      this.appendHiddenField(`${namePrefix}[table_number]`, seatController.tableNumberValue);
      this.appendHiddenField(`${namePrefix}[x]`, seatController.xValue);
      this.appendHiddenField(`${namePrefix}[y]`, seatController.yValue);
      this.appendHiddenField(`${namePrefix}[_destroy]`, seat.classList.contains("d-none"));
      if (seatController.idValue) {
        this.appendHiddenField(`${namePrefix}[id]`, seatController.idValue);
      }
    });
  }

  focusSeatNumberInput() {
    this.seatNumberInputTarget.focus();
  }

  appendHiddenField(name, value) {
    const inputField = document.createElement('input');
    inputField.type = 'hidden';
    inputField.name = name;
    inputField.value = value;
    this.seatsContainerTarget.appendChild(inputField);
  }

  removeSection(e) {
    const removedSectionId = e.currentTarget.dataset.sectionId;
    this.removedSectionsValue = [...this.removedSectionsValue, +removedSectionId];
    this.seatTargets.filter(c => c.dataset.seatSectionIdValue === removedSectionId).forEach(c => c.remove());
  }

  removeSeat() {
    const seatController = this.application.getControllerForElementAndIdentifier(this.selectedSeat, 'admin--seating-chart-form--seat');
    if (seatController.idValue) {
      this.selectedSeat.classList.add("d-none");
    } else {
      this.selectedSeat.remove();
    }

    this.closeModal();
  }
}