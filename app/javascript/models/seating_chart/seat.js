import CurrentUser from 'models/current_user';

export default class Seat {
  #selectedByUserId;
  #selectionExpiresAt;
  #soldToUserId;
  #held;

  constructor(selectedByUserId, selectionExpiresAt, soldToUserId, held) {
    this.#selectedByUserId = selectedByUserId;
    this.#selectionExpiresAt = new Date(selectionExpiresAt);
    this.#soldToUserId = soldToUserId;
    this.#held = held;
  }

  get held() {
    return this.#held;
  }

  get selected() {
    return !!this.#selectedByUserId && this.#selectionExpiresAt > new Date();
  }

  get selectedByCurrentUser() {
    return CurrentUser.id === this.#selectedByUserId && this.#selectionExpiresAt > new Date();
  }

  get sold() {
    return !!this.#soldToUserId;
  }

  get soldToCurrentUser() {
    return CurrentUser.id === this.#soldToUserId;
  }

  get selectable() {
    return !this.selected && !this.sold && !this.held;
  }

  get actionable() {
    return this.selectable || this.selectedByCurrentUser;
  }
}
