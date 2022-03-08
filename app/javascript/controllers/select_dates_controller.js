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
    "existingBookingModal",
    "existingBookingContainer",
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
      // this is the FIRST click on the calendar
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
        // the user has not clicked on a booking
        arrival.classList.add("new-booking");
        const day_display = parseInt(arrival.dataset.date.slice(-2), 10);
        arrival.insertAdjacentHTML('beforeend', `<div class="meeting-proposed">${day_display}</div>`);
        this.bodyTarget.dataset.click = 'departure';
      } else {
        // the user has clicked on an existing booking
        // retrieve the corresponding booking id
        const bookingId = event.target.dataset.bookingId;
        // fetch simple_booking_modal partial
        const url = `/bookings/find?id=${bookingId}`
        fetch(url, {
          headers: {
            "Accept": "application/json"
          }
        })
        .then(response => response.json())
        .then((data) => {
          // insert simple_booking_modal with booking into the booking_modal empty div
          this.existingBookingModalTarget.innerHTML = data.html;
        });
        // display the modal
        const bookingModalController = this.application.getControllerForElementAndIdentifier(this.existingBookingContainerTarget, 'booking-modal');
        bookingModalController.openBookingModal();
      }
    } else {
      // this is the SECOND click. The user may have selected a departure date
      const arrival = document.querySelector('.new-booking')
      const arrivalDate = arrival.dataset.date;
      const departureDate = event.currentTarget.dataset.date;
      if ((departureDate >= arrivalDate)&&(this.#notAlreadyBooked(arrivalDate, departureDate))) {
        // Departure is after arrival and the period is not already booked
        // HERE: now we need to check if credits are sufficient for the booking.
        const arrDate = new Date(arrivalDate);
        const depDate = new Date(departureDate);
        const arr = arrDate.toLocaleString('fr-FR', { weekday:"long", day: '2-digit', month: 'long' });
        const dep = depDate.toLocaleString('fr-FR', { weekday:"long", day: '2-digit', month: 'long' });
        const totalPrice = ((depDate - arrDate) / (60000 * 60 * 24) + 1) * this.dailyPriceValue;
        const creditBalance = this.tribeCreditBalanceValue;
        if (creditBalance >= totalPrice) {
          // credits are sufficient to book - so we can proceed with the booking in 4 steps
          // 1. highlight dates in the booking
          this.dateTargets.forEach((date)=>{
            if ((date.dataset.date>arrivalDate)&&(date.dataset.date<=departureDate)) {
              date.classList.add("new-booking");
              const day_display = parseInt(date.dataset.date.slice(-2), 10);
              date.insertAdjacentHTML('beforeend', `<div class="meeting-proposed">${day_display}</div>`);
            }
          });
          // 2. show the book button ("RESERVER"). If user click on the button, the new booking modal will show
          this.bookButtonTarget.classList.remove('d-none');
          // 3. fill in the invisible form contained in the new booking modal to create the booking
          this.arrivalTarget.value = arrivalDate;
          this.departureTarget.value = departureDate;
          // 4. insert HTML in the new booking modal as a new booking recap
          const html = this.#fillBookingModal(arr, dep, totalPrice, creditBalance);
          console.log(html);
          this.modalInfoTarget.insertAdjacentHTML('afterbegin', html);
        } else {
          // HERE: credits are not sufficient enough. We should reset the form and send a flash notice. TO BE DONE!
          arrival.classList.remove('new-booking');
          arrival.removeChild(arrival.lastChild);}
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

  #fillBookingModal(arr, dep, totalPrice, creditBalance) {
    const bookingInfoHtml = `
    <div class="text-center px-3 py-1">
    <div>
    <p>Du <b>${arr}</b></p>
    </div>
    <div>
    <p>Au <b>${dep}</b></p>
    </div>
    </div>
    <div class=" px-3 py-1">
    <p class="credit-balance text-start">${totalPrice} crédits requis</p>
    <p class="credit-balance text-start">${creditBalance} crédits disponibles</p>
    <p class="credit-balance text-start">${creditBalance} crédits restants</p>
    </div>
    `;
    return bookingInfoHtml
  }
}
