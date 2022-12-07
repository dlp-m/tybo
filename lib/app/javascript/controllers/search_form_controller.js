import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit()
    }, 200)
  }

  setBooleanField(e) {
    let value = e.target.getAttribute('data-value')
    let targetId = e.target.getAttribute('data-target-id')
    let target = document.getElementById(targetId)
    target.value = value
    this.formTarget.requestSubmit()
  }
}
