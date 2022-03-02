import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["date"]

  select(e) {
    const arrivalDate = e.currentTarget;
    arrivalDate.classList.add("arrival");
    console.log(arrivalDate)
    const arrivalWeek = arrivalDate.parentElement.rowIndex
    const arrivalDay = arrivalDate.cellIndex
    this.dateTargets.forEach((date)=>{
      if (date.cellIndex == arrivalDay) {
        console.log(date.innerText)
      }
    });
    console.log(this.dateTargets.length);
  }
}
