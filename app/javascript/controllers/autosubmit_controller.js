// app/javascript/controllers/autosubmit_controller.js
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autosubmit"
export default class extends Controller {
  submit() {
    // This programmatically submits the form that this controller is attached to.
    this.element.requestSubmit();
  }
}