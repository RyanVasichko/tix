export default class CurrentUser {
  static get id() {
    return document.body.dataset.currentUserId;
  }

  static get isAdmin() {
    return document.body.dataset.currentUserIsAdmin === "true";
  }
}
