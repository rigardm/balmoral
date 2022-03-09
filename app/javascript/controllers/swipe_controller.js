import { Controller } from "@hotwired/stimulus"
let touchstartX = 0
let touchstartY = 0
let swipemove = ""
export default class extends Controller {
  static targets = ["swipezone","nextbutton","previousbutton", "listbutton"]

//event = 'touchstart', 'touchend'

connect() {
  console.log("coucou c'est moi le controleur des swipes!")
}

  identifyswipe(e) {
  //e.preventDefault();
  if (e.type == 'touchstart') {
  touchstartX = e.touches[0].clientX;
  touchstartY = e.touches[0].clientY;
  } else if (e.type == 'touchend') {
  let changeX = e.changedTouches[0].clientX - touchstartX;
  let changeY = e.changedTouches[0].clientY - touchstartY;
  if (Math.abs(changeX) > Math.abs(changeY)) {
    swipemove = (changeX >0 ? "swipe right" : "swipe left")
  } else if (Math.abs(changeX) < Math.abs(changeY)) {
    swipemove = (changeY >0 ? "swipe down" : "swipe up")
  } else {
    swipemove = "tap"
  };
  console.log(swipemove);
  this._dosomething(swipemove);
  }
  }

  _dosomething(swipemove) {
    if (swipemove == "swipe down") {
      this.previousbuttonTarget.click();
    } else if (swipemove == "swipe up") {
      this.nextbuttonTarget.click();
    } else if (swipemove == "swipe left") {
      this.listbuttonTarget.click();
    }
  }
}
