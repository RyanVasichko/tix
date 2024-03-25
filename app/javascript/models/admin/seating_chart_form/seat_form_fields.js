export default class SeatFormFields {
  static #counter = 0;
  #seatController;

  constructor(seatController) {
    this.#seatController = seatController;
  }

  appendHiddenFieldsTo(target) {
    const values = this.#formValuesForSeat;

    const namePrefix = this.#buildNamePrefix(this.#seatController.sectionIdWasValue || this.#seatController.sectionIdValue);
    let hiddenFields = this.#mapValuesToHiddenFields(namePrefix, values);

    if (this.#seatController.sectionIdWasValue) {
      const newHiddenFields = this.#buildHiddenFieldsForNewSeat(values, hiddenFields);
      hiddenFields = hiddenFields.concat(newHiddenFields);
    }

    hiddenFields.forEach(field => target.append(field));
  }

  #buildHiddenFieldsForNewSeat(values, hiddenFields) {
    const newSeatValues = { ...values, "_destroy": "0" };
    delete newSeatValues["id"];
    newSeatValues["section_id"] = this.#seatController.sectionIdValue;
    return this.#mapValuesToHiddenFields(this.#buildNamePrefix(this.#seatController.sectionIdValue), newSeatValues);
  }

  #buildNamePrefix(sectionId) {
    return `seating_chart[sections_attributes][${sectionId}][seats_attributes][${SeatFormFields.#counter++}]`;
  }

  get #formValuesForSeat() {
    return {
      "x": this.#seatController.xValue,
      "y": this.#seatController.yValue,
      "seat_number": this.#seatController.seatNumberValue,
      "table_number": this.#seatController.tableNumberValue,
      "section_id": this.#seatController.sectionIdWasValue || this.#seatController.sectionIdValue,
      "_destroy": !!(this.#seatController.element.classList.contains("hidden") || this.#seatController.sectionIdWasValue),
      "id": this.#seatController.idValue
    };
  }

  #mapValuesToHiddenFields(namePrefix, values) {
    return Object.entries(values).map(([ name, value ]) => {
      const inputField = document.createElement("input");
      inputField.type = "hidden";
      inputField.name = `${namePrefix}[${name}]`;
      inputField.value = value;

      return inputField;
    });
  }
}
