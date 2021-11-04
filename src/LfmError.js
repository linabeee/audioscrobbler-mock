export default class LfmError extends Error {
  static messageFromCode(code) {
    let message
    switch (code) {
      case 6:
        message =
          "Invalid parameters - Your request is missing a required parameter"
    }
    return message
  }

  constructor(code) {
    super()
    this.message = LfmError.messageFromCode(code)
    this.code = code
    this.stack = Error.captureStackTrace(this)
  }

  toJSON() {
    return JSON.stringify({ code: this.code, message: this.message })
  }
}
