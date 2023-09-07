import { Controller } from "@hotwired/stimulus";
import * as bootstrap from "bootstrap";

export default class extends Controller {
  static targets = [
    "svgCanvas",
    "imageInput",
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
          this.svgCanvasTarget.style.backgroundSize = 'cover';
        };
        img.src = e.target.result;
      };
      reader.readAsDataURL(file);
    }
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

    this.seatNumberInputTarget.value = seat.dataset.seatSeatNumberValue;
    this.tableNumberInputTarget.value = seat.dataset.seatTableNumberValue;
    this.sectionSelectTarget.value = seat.dataset.seatSectionIdValue;

    this.modal.show();
  }

  saveSeatData() {
    if (this.selectedSeat) {
      this.selectedSeat.dataset.seatSeatNumberValue = this.seatNumberInputTarget.value;
      this.selectedSeat.dataset.seatTableNumberValue = this.tableNumberInputTarget.value;
      this.selectedSeat.dataset.seatSectionIdValue = this.sectionSelectTarget.value;
    }

    this.closeModal();
  }

  closeModal() {
    this.selectedSeat = null;
    this.modal.hide();
    setTimeout(this.modal.hide, 5000);
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
      const dataset = seat.dataset;
      const namePrefix = `seating_chart[sections_attributes][${dataset.seatSectionIdValue}][seats_attributes][${i}]`;

      this.appendHiddenField(`${namePrefix}[seat_number]`, dataset.seatSeatNumberValue);
      this.appendHiddenField(`${namePrefix}[table_number]`, dataset.seatTableNumberValue);
      this.appendHiddenField(`${namePrefix}[x]`, dataset.seatXValue);
      this.appendHiddenField(`${namePrefix}[y]`, dataset.seatYValue);
      this.appendHiddenField(`${namePrefix}[_destroy]`, seat.classList.contains("d-none"));
      if (dataset.seatIdValue) {
        this.appendHiddenField(`${namePrefix}[id]`, dataset.seatIdValue);
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
    if (this.selectedSeat.dataset.seatIdValue) {
      this.selectedSeat.classList.add("d-none");
    } else {
      this.selectedSeat.remove();
    }

    this.closeModal();
  }
}