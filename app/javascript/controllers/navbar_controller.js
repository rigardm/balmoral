import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "icon" ]

  select(e) {
    this.iconTargets.forEach((element) => {
      element.classList.remove('selected');
    });
    e.currentTarget.classList.add('selected');
  }
}
