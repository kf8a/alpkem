import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fileName", "uploadArea"]

  displayFileName(event) {
    const file = event.target.files[0]
    if (file) {
      this.fileNameTarget.textContent = file.name
      this.fileNameTarget.classList.remove("hidden")
      this.uploadAreaTarget.classList.add("border-blue-500", "bg-blue-50")
      this.uploadAreaTarget.classList.remove("border-gray-300")
    } else {
      this.fileNameTarget.textContent = ""
      this.fileNameTarget.classList.add("hidden")
      this.uploadAreaTarget.classList.remove("border-blue-500", "bg-blue-50")
      this.uploadAreaTarget.classList.add("border-gray-300")
    }
  }
}
