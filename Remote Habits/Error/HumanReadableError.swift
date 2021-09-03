import Foundation

/**
 Error meant to show the end user of the app in the UI. Many error messages are technical and not helpful to the user.
 Instead, we try to log those un-readable errors and return back a human readable version.
 */
class HumanReadableError: MessageError {}
