import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["Michel", "Nath", "Jacques"]

  selectTribe(e) {
    this.NathTargets.forEach((element) => {
      element.classList.remove('d-none');
    });
    this.JacquesTargets.forEach((element) => {
      element.classList.remove('d-none');
    });
    this.MichelTargets.forEach((element) => {
      element.classList.remove('d-none');
    });
    if (e.currentTarget.classList.contains("tribe-green")) {
      this.NathTargets.forEach((element) => {
        element.classList.add('d-none');
      });
      this.JacquesTargets.forEach((element) => {
        element.classList.add('d-none');
      });
    } else if (e.currentTarget.classList.contains("tribe-red")) {
      this.NathTargets.forEach((element) => {
        element.classList.add('d-none');
      });
      this.MichelTargets.forEach((element) => {
        element.classList.add('d-none');
      });
    } else {
      this.MichelTargets.forEach((element) => {
        element.classList.add('d-none');
      });
      this.JacquesTargets.forEach((element) => {
        element.classList.add('d-none');
      });
    }
  }
  showAll () {
    this.NathTargets.forEach((element) => {
      element.classList.remove('d-none');
    });
    this.JacquesTargets.forEach((element) => {
      element.classList.remove('d-none');
    });
    this.MichelTargets.forEach((element) => {
      element.classList.remove('d-none');
    });
  }
}
