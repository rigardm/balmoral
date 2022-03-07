import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static values = { channelId: Number }
  static targets = ["messages", "form"]

  connect() {
    this.channel = consumer.subscriptions.create(
      { channel: "ChannelChannel", id: this.channelIdValue },
      { received: data => this._insertMessageScrollDownAndResetForm(data) }
    )
    console.log(`Subscribed to the channel with the id ${this.channelIdValue}.`)
    console.log(this.channel)
  }

  disconnect() {
    console.log("Unsubscribed from the channel")
    this.channel.unsubscribe()
  }

  _insertMessageScrollDownAndResetForm(data) {
    this.messagesTarget.insertAdjacentHTML("beforeend", data)
    window.scrollTo(0,document.body.scrollHeight);
    //this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight)
    this.formTarget.reset()
  }
}
