import { DirectUpload } from 'activestorage'

// See DirectUploadController from Rails Active Storage source
export class WompUploader {
  constructor(input, file) {
    this.input = input
    this.file = file
    this.directUpload = new DirectUpload(this.file, this.url, this)
    this.dispatch("initialize")
  }

  start() {
    const hiddenInput = document.createElement("input")
    hiddenInput.type = "hidden"
    hiddenInput.name = this.input.name
    hiddenInput.classList.add('cache')
    this.input.insertAdjacentElement("beforebegin", hiddenInput)

    this.dispatch("start")

    this.directUpload.create((error, attributes) => {
      if (error) {
        hiddenInput.parentNode.removeChild(hiddenInput)
        this.dispatchError(error)
      } else {
        hiddenInput.value = attributes.signed_id
      }

      this.dispatchEnd("end", { attributes }, attributes.signed_id)
      // callback(error)
    })
  }

  uploadRequestDidProgress(event) {
    const progress = event.loaded / event.total * 100
    if (progress) {
      this.dispatch("progress", { progress })
    }
  }

  get url() {
    return this.input.getAttribute("data-direct-upload-url")
  }

  dispatch(name, detail = {}) {
    detail.file = this.file
    detail.id = this.directUpload.id
    return dispatchEvent(this.input, `direct-upload:${name}`, { detail })
  }

  dispatchEnd(name, detail = {}, signed_id) {
    detail.file = this.file
    detail.id = this.directUpload.id
    detail.signed_id = signed_id
    return dispatchEvent(this.input, `direct-upload:${name}`, { detail })
  }

  dispatchError(error) {
    const event = this.dispatch("error", { error })
    if (!event.defaultPrevented) {
      alert(error)
    }
  }

  directUploadWillStoreFileWithXHR(xhr) {
    this.dispatch("before-storage-request", { xhr })
    xhr.upload.addEventListener("progress", event => this.uploadRequestDidProgress(event))
  }
}

function dispatchEvent(element, type, eventInit = {}) {
  const { disabled } = element
  const { bubbles, cancelable, detail } = eventInit
  const event = document.createEvent("Event")

  event.initEvent(type, bubbles || true, cancelable || true)
  event.detail = detail || {}

  try {
    element.disabled = false
    element.dispatchEvent(event)
  } finally {
    element.disabled = disabled
  }

  return event
}
