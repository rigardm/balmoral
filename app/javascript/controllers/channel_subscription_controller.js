import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static values = { channelId: Number, userId: Number }
  static targets = ["messages", "form"]

  connect() {
    this.channel = consumer.subscriptions.create(
      { channel: "ChannelChannel", id: this.channelIdValue },
      { received:  (data) => {
        const htmlNode = document.createElement("div")
        // htmlNode.insertAdjacentHTML("beforeend", data.html)
        htmlNode.insertAdjacentHTML("beforeend", data.html)
        console.log(htmlNode.innerHTML)
        if (this.userSender(data)) {
          htmlNode.querySelector("#author-name").innerText = "Vous  "
        }
        this._insertMessageScrollDownAndResetForm(htmlNode.firstElementChild)
      }
       }
    )
    console.log(`Subscribed to the channel with the id ${this.channelIdValue}.`)
    console.log(this.channel)
  }

  disconnect() {
    console.log("Unsubscribed from the channel")
    this.channel.unsubscribe()
  }

  userSender(data) {
    return data.user_id === this.userIdValue
  }

  _insertMessageScrollDownAndResetForm(data) {
    this.messagesTarget.appendChild(data)
    window.scrollTo(0,document.body.scrollHeight);
    //this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight)
    this.formTarget.reset()
  }
}
