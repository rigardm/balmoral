import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "date",
    "body",
    "bookButton",
    "arrival",
    "departure",
    "form",
    "modalInfo",
    "bookingPreview",
    "previewButton",
    "newBookingModal",
    "newBookingOverlay"
  ]
  static values = {
    dailyPrice: Number,
    tribeCreditBalance: Number
   }

  connect() {
    const today = document.querySelector('[class*="today"]');
    const day_display = parseInt(today.dataset.date.slice(-2), 10);
    today.insertAdjacentHTML('beforeend', `<div class="day-today">${day_display}</div>`);
  }

  select(event) {
    if (this.bodyTarget.dataset.click === 'arrival') {
      // the user may have selected an arrival date
      this.bookButtonTarget.classList.add('d-none');
      this.modalInfoTarget.innerHTML = "";
      this.dateTargets.forEach((date)=>{
        date.classList.remove("new-booking");
        if (date.lastChild.className === "meeting-proposed") {
          date.removeChild(date.lastChild);
        };
      });
      const arrival = event.currentTarget;
      if (!arrival.classList.contains("has-events")) {
        arrival.classList.add("new-booking");
        const day_display = parseInt(arrival.dataset.date.slice(-2), 10);
        arrival.insertAdjacentHTML('beforeend', `<div class="meeting-proposed">${day_display}</div>`);
        this.bodyTarget.dataset.click = 'departure';
      } else {
        // the user has clicked on an existing booking
        // retrieve the récupérer l'id du booking correspondant:
        const bookingId = event.target.dataset.bookingId;
        // fetch booking_details_modal partial
        const url = `/bookings/find?id=${bookingId}`
        fetch(url, {
          headers: {
            "Accept": "application/json"
          }
        })
        .then(response => response.json())
        .then((data) => {
          // insert booking_details_modal partial with booking inside preview modal
          this.bookingPreviewTarget.innerHTML = data.html;
        });
        // afficher la modale
        this.previewButtonTarget.click();
      }
    } else {
      // the user may have selected a departure date
      const arrival = document.querySelector('.new-booking')
      const arrivalDate = arrival.dataset.date;
      const departureDate = event.currentTarget.dataset.date;
      if ((departureDate >= arrivalDate)&&(this.#notAlreadyBooked(arrivalDate, departureDate))) {
        // Departure is after arrival and the period is not already booked
        // So we can proceed with the booking
        this.dateTargets.forEach((date)=>{
          if ((date.dataset.date>arrivalDate)&&(date.dataset.date<=departureDate)) {
            date.classList.add("new-booking");
            const day_display = parseInt(date.dataset.date.slice(-2), 10);
            date.insertAdjacentHTML('beforeend', `<div class="meeting-proposed">${day_display}</div>`);
          }
        });
        this.bookButtonTarget.classList.remove('d-none');
        this.arrivalTarget.value = arrivalDate;
        this.departureTarget.value = departureDate;
        // insert HTML in the modal info:
        const arrDate = new Date(arrivalDate);
        const depDate = new Date(departureDate);
        const arr = arrDate.toLocaleString('fr-FR', { weekday:"long", day: '2-digit', month: 'long' });
        const dep = depDate.toLocaleString('fr-FR', { weekday:"long", day: '2-digit', month: 'long' });
        const totalPrice = ((depDate - arrDate) / (60000 * 60 * 24) + 1) * this.dailyPriceValue;
        const creditBalance = this.tribeCreditBalanceValue;
        const html = `
        <div class="row">
        <div class="col-12">
        <h1>Votre réservation</h1>
        </div>
        </div>
        <div class="row">
        <div class="col-12 text-start">
        <h2>Dates</h2>
        <p>Du <b>${arr}</b></p>
        </div>
        </div>
        <div class="row">
        <div class="col-12 text-start">
        <p>Au <b>${dep}</b></p>
        </div>
        </div>
        <div class="row">
        <div class="col-12 text-start mt-2">
        <h2>Crédits</h2>
        <p>Pour cette réservation : <b>${totalPrice}</b> crédits</p>
        </div>
        </div>
        <div class="row">
        <div class="col-12 text-start">
        <p>Votre solde actuel : <b>${creditBalance}</b> crédits</p>
        </div>
        </div>
        `;
        this.modalInfoTarget.insertAdjacentHTML('afterbegin', html);
      } else {
        // Departure is before arrival or it is already booked
        // So we need to reset the calendar
        arrival.classList.remove('new-booking');
        arrival.removeChild(arrival.lastChild);
      }
      this.bodyTarget.dataset.click = 'arrival';
    }
  }

  #notAlreadyBooked = ((arrivalDate, departureDate) => {
    let notBooked = true;
    this.dateTargets.forEach((date)=>{
      if ((date.dataset.date>=arrivalDate)&&(date.dataset.date<=departureDate)) {
        if (date.classList.contains('has-events')) {
          notBooked = false;
        }
      }
    });
    return notBooked;
  });

  newBookingModalShow(event) {
    event.preventDefault();
    this.newBookingModalTarget.classList.remove('d-none');
    this.newBookingOverlayTarget.classList.remove('d-none');
  }

  submit() {
    this.newBookingModalTarget.classList.add('d-none');
    this.newBookingOverlayTarget.classList.add('d-none');
    this.formTarget.submit();
  }

  cancel() {
    window.location.reload();
  }

}
