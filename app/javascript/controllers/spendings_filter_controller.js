import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["Michel", "Nath", "Jacques", "avatar"]
// pour plus tard : définir en static targets les 5-6 tribe colors qui sont définies car communes a toutes les houses
// puis modifier les Targets dans selectTribe pour inclure toutes les tribes colors

  selectTribe(e) {
    this.avatarTargets.forEach((element) => {
      element.classList.remove('selected');
    });
    e.currentTarget.classList.add('selected');
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
    this.avatarTargets.forEach((element) => {
      element.classList.remove('selected');
    });
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
