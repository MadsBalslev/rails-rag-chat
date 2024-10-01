import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="turbo-modal"
export default class extends Controller {
  closeModal() {
    this.element.parentElement.removeAttribute("src");
    this.element.remove();
  }
}
