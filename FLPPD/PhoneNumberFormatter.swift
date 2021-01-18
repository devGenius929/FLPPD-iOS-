//
//  PhoneNumberFormatter.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 3/8/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//


import Foundation

/**
 Example:::
 
 var phoneFormatter = PhoneNumberFormatter()
 @IBAction func formValueChanged(sender: UITextField) {
 sender.text = phoneFormatter.format(sender.text, hash: sender.hash)
 }
 */
public struct PhoneNumberFormatter {
  
  /**
   Set available locales here.
   */
  fileprivate enum AvailableLocales: String {
    case UnitedStates = "US",
    Canada = "CA"
  }
  
  /**
   Set default locale here.
   */
  fileprivate static var defaultLocale = AvailableLocales.UnitedStates
  
  fileprivate static var locale: AvailableLocales = {
    let country = Locale.current.regionCode
    return AvailableLocales(rawValue: country ?? "") ?? defaultLocale
  }()
  
  
  /**
   Set formats for available locales here.
   (expect a string of correct length, but match with dot (.), not digit (\d))
   */
  fileprivate let formatByLocale: [AvailableLocales: Format] = [
    .UnitedStates: (length: 10, match: "^(...)(...)(....)$", format: "$1 $2 $3"),
    .Canada: (length: 10, match: "^(...)(...)(....)$", format: "$1 $2 $3"),
    ]
  fileprivate typealias Format = (length: Int, match: String, format: String)
  
  fileprivate var lastPhoneNumbers: [Int: String] = [:]
  
  //Mark: Public functions:
  
  /**
   Turns a phone number into a pretty formatted phone number for the current locale. Strips text down to numbers before running.
   
   - parameter phoneNumber:      Any string with numbers or existing formatting
   - parameter hash:             If you are dealing with multiple phone numbers, you will need to include a unique id for each (field.hash is good)
   - returns:                Formatted phone number string
   */
  mutating public func format(_ phoneNumber: String, hash: Int = 0) -> String {
    //strip to numbers
    var numericText = phoneNumber.onlyCharacters("0123456789")
    if numericText.length == 0 {
      lastPhoneNumbers[hash] = ""
      return ""
    }
    if let formatStyle = formatByLocale[PhoneNumberFormatter.locale] {
      //if characters removed by user, change to remove numbers instead of formatting
      let lastPhoneNumber = self.lastPhoneNumbers[hash] ?? ""
      let lastNumericText = lastPhoneNumber.onlyCharacters("0123456789")
      let requestedSubtractChars = lastPhoneNumber.length - phoneNumber.length
      let actualSubtractChars = max(0, lastNumericText.length - numericText.length)
      if requestedSubtractChars > 0 && actualSubtractChars < requestedSubtractChars {
        let subtractChars = requestedSubtractChars - actualSubtractChars
        dprint(subtractChars)
        numericText = subtractChars >= numericText.length  ? "" : numericText.stringFrom(0, to: -1 * subtractChars)
      }
      //add formatting
      let placeholder = "*"
      if numericText.length < formatStyle.length {
        numericText = numericText.rpad(placeholder, length: formatStyle.length)
      }
      if numericText.length > formatStyle.length {
        numericText = numericText.stringFrom(0, to: formatStyle.length)
      }
      let fullyFormattedNumber = numericText.replacingOccurrences(of: formatStyle.match, with: formatStyle.format, options: NSString.CompareOptions.regularExpression, range: nil)
      if let editingNumber = fullyFormattedNumber.split(maxSplits: 1, omittingEmptySubsequences: false, whereSeparator: {
        Character(placeholder) == $0
      }).first {
        let eNumber = String(editingNumber)
        lastPhoneNumbers[hash] = eNumber
        return eNumber
      }
      lastPhoneNumbers[hash] = fullyFormattedNumber
      return fullyFormattedNumber
    }
    return numericText
  }
  
  /**
   Checks phone number is a valid phone number for the current locale.
   
   - parameter phoneNumber:      A numeric phone number. Expects no formatting!
   - returns:                True if phone number matches locale pattern
   */
  public func isValid(_ phoneNumber: String) -> Bool {
    let numericText = phoneNumber.onlyCharacters("0123456789")
    if let formatStyle = formatByLocale[PhoneNumberFormatter.locale] {
      return numericText.length == formatStyle.length
    }
    return false
  }
  
  /**
   Remove prior saved values for fresh field comparison.
   */
  mutating public func reset() {
    lastPhoneNumbers = [:]
  }
}

// uhg, worst Swift 3.0 decision ever. Stupid people don't grok optionals.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

extension String {
  /**
   Pads the left side of a string with the specified string up to the specified length.
   Does not clip the string if too long.
   
   - parameter padding:   The string to use to create the padding (if needed)
   - parameter length:    Integer target length for entire string
   - returns: The padded string
   */
  func lpad(_ padding: String, length: Int) -> (String) {
    if self.count > length {
      return self
    }
    return "".padding(toLength: length - self.count, withPad:padding, startingAt:0) + self
  }
  /**
   Pads the right side of a string with the specified string up to the specified length.
   Does not clip the string if too long.
   
   - parameter padding:   The string to use to create the padding (if needed)
   - parameter length:    Integer target length for entire string
   - returns: The padded string
   */
  func rpad(_ padding: String, length: Int) -> (String) {
    if self.count > length { return self }
    return self.padding(toLength: length, withPad:padding, startingAt:0)
  }
  /**
   Returns string with left and right spaces trimmed off.
   
   - returns: Trimmed String
   */
  func trim() -> String {
    return self.trimmingCharacters(in: CharacterSet.whitespaces)
  }
  /**
   Shortcut for getting length (since Swift keeps cahnging this).
   
   - returns: Int length of string
   */
  var length: Int {
    return self.count
  }
  /**
   Returns character at a specific position from a string.
   
   - parameter index:               The position of the character
   - returns: Character
   */
  subscript (i: Int) -> Character {
    return self[self.index(self.startIndex, offsetBy: i)]
  }
  subscript (i: Int) -> String {
    return String(self[i] as Character)
  }
  /**
   Returns substring extracted from a string at start and end location.
   
   - parameter start:               Where to start (-1 acceptable)
   - parameter end:                 (Optional) Where to end (-1 acceptable) - default to end of string
   - returns: String
   */
  func stringFrom(_ start: Int, to end: Int? = nil) -> String {
    var maximum = self.count
    
    let i = start < 0 ? self.endIndex : self.startIndex
    let ioffset = min(maximum, max(-1 * maximum, start))
    let startIndex = self.index(i, offsetBy: ioffset)
    
    maximum -= start
    
    let j = end < 0 ? self.endIndex : self.startIndex
    let joffset = min(maximum, max(-1 * maximum, end ?? 0))
    let endIndex = end != nil && end! < self.count ? self.index(j, offsetBy: joffset) : self.endIndex
    return self.substring(with: (startIndex ..< endIndex))
  }
  /**
   Returns substring composed of only the allowed characters.
   
   - parameter allowed:             String list of acceptable characters
   - returns: String
   */
  func onlyCharacters(_ allowed: String) -> String {
    let search = allowed.characters
    return characters.filter({ search.contains($0) }).reduce("", { $0 + String($1) })
  }
  /**
   Simple pattern matcher. Requires full match (ie, includes ^$ implicitly).
   
   - parameter pattern:             Regex pattern (includes ^$ implicitly)
   - returns: true if full match found
   */
  func matches(_ pattern: String) -> Bool {
    let test = NSPredicate(format:"SELF MATCHES %@", pattern)
    return test.evaluate(with: self)
  }
}
