import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle() {
    this.menuTarget.classList.toggle("hidden")
    // this.element.textContent = "Hello World!"
  }
  // close() {
  //   this.menuTarget.classList.add("hidden")
  // }
}
