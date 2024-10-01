import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="turbo-modal"
export default class extends Controller {
  static targets = ["modal"];

  closeModal() {
    this.modalTarget.parentElement.parentElement.removeAttribute("src");
    this.modalTarget.parentElement.remove();
  }

  submitEnd(e) {
    if (e.detail.success) {
      this.closeModal();
    }
  }

  closeBackground(e) {
    if (e && this.modalTarget.contains(e.target)) {
      return;
    }
    this.closeModal();
  }
}
