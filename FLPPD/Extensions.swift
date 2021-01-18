//
//  Extensions.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 4/17/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

extension UIPrintPageRenderer {
  func printToPDF() -> NSData {
    let pdfData = NSMutableData()
    UIGraphicsBeginPDFContextToData(pdfData, self.paperRect, nil)
    let bounds = UIGraphicsGetPDFContextBounds()
    for i in 0..<self.numberOfPages {
      UIGraphicsBeginPDFPage();
      self.drawPage(at: i, in: bounds)
    }
    UIGraphicsEndPDFContext();
    return pdfData;
  }
}
extension Float {
  var clean: String {
    return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
  }
}

extension NSDecimalNumber{
  
  func isGreaterThan(_ int:Int)->Bool{
    return self.compare(NSNumber(value:int)) == ComparisonResult.orderedDescending
  }
  func isGreaterThanDecimal(_ decimal:NSDecimalNumber)->Bool{
    return self.compare(decimal) == ComparisonResult.orderedDescending
  }
  func isLessThan(_ int:Int)->Bool{
    return self.compare(NSNumber(value: int)) == ComparisonResult.orderedAscending
  }
  func limitToRange(_ max:Int?,min:Int?)->NSDecimalNumber{
    if self == NSDecimalNumber.notANumber{
      return NSDecimalNumber.zero
    }
    if let max = max,self.isGreaterThan(max){
      return NSDecimalNumber(value: max)
    }else if let min = min,self.isLessThan(min){
      return NSDecimalNumber(value: min)
    }
    return self
  }
  func percentValue()->NSDecimalNumber{
    return self.dividing(by: NSDecimalNumber(value: 100))
  }
  func dividingBy12()->NSDecimalNumber{
    return self.dividing(by: NSDecimalNumber(value: 12))
  }
  func multiplyingBy12()->NSDecimalNumber{
    return self.multiplying(by: NSDecimalNumber(value: 12))
  }
  func multiplyingBy100()->NSDecimalNumber{
    return self.multiplying(by: NSDecimalNumber(value:100))
  }
  func roundTo2DecimalPlace()->NSDecimalNumber{
    let round = NSDecimalNumberHandler(roundingMode: .bankers, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
    return self.rounding(accordingToBehavior: round)
  }
  func dollarFormat()->String{
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = NumberFormatter.Style.decimal
    let decimalStr = numberFormatter.string(from: self.roundTo2DecimalPlace())
    return decimalStr != nil ? "$ " + decimalStr! : ""
  }
  func decimalFormat()->String{
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = NumberFormatter.Style.decimal
    let decimalStr = numberFormatter.string(from: self.roundTo2DecimalPlace())
    return decimalStr != nil ? decimalStr! : ""
  }
}
extension Int32{
  func dollarFormat()->String{
    return "$ "+self.formatDecimal()
  }
  func formatDecimal()->String{
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = NumberFormatter.Style.decimal
    return numberFormatter.string(from: NSNumber(value: self))!
  }
  var decimalValue: NSDecimalNumber {
    return NSDecimalNumber(value:self)
  }
}
extension Int{
  func dollarFormat()->String{
    return "$ "+self.formatDecimal()
  }
  func formatDecimal()->String{
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = NumberFormatter.Style.decimal
    return numberFormatter.string(from: NSNumber(value: self))!
  }
  var decimalValue: NSDecimalNumber {
    return NSDecimalNumber(value:self)
  }
}
//coner radius just top right and left
extension UIView {
  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
}

//create a Image base on color
// can be called UIImage.imageWithColor(UIColor.red) for ex
extension UIImage {
  static func imageWithColor(tintColor: UIColor) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
    tintColor.setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
  }
}

extension UIEdgeInsets{
  static var defaultInset:UIEdgeInsets{
    get {
      return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
  }
}
extension UIColor {
  static var darkerGold: UIColor  {
    get {
      return UIColor(red:0.72, green:0.69, blue:0.55, alpha:1.0)
    }
  }
  static var darkgreen:UIColor{
    get{
      return UIColor(hue: 0.34, saturation: 0.43, brightness: 0.39, alpha: 1)
    }
  }
  static var darkpurple:UIColor{
    get{
      return UIColor(hue: 0.87, saturation: 0.43, brightness: 0.39, alpha: 1)
    }
  }
  static var darkRed:UIColor{
    get{
      return UIColor(hue: 0.98, saturation: 0.98, brightness: 0.41, alpha: 1)
    }
  }
  static var imageIndexLabelBackgroundColor:UIColor{
    get{
      return UIColor(hue: 0.58, saturation: 0.30, brightness: 0.17, alpha: 0.80)
    }
  }
}

extension Array{
  static func getYearFrom1900ToPresent()->[String]{
    let currentYear = Calendar.current.component(.year, from: Date())
    var yearsArray = [String]()
    for year in (1900..<currentYear+1){
      yearsArray.append(String(year))
    }
    return yearsArray
  }
}

extension UIView{
  static func createSeparatorView(_ thickness:CGFloat,rightInset:CGFloat,leftInset:CGFloat,color:UIColor)->UIView{
    let view = UIView()
    let separator = UIView()
    view.addSubview(separator)
    separator.centerVerticallyInSuperview()
    let leadingConstraint = NSLayoutConstraint(item: separator, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant:leftInset)
    let trailingConstraint = NSLayoutConstraint(item: separator, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: rightInset)
    let heightConstraint = NSLayoutConstraint(item: separator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: thickness)
    trailingConstraint.priority = UILayoutPriority(rawValue: 999)
    NSLayoutConstraint.activate([leadingConstraint,trailingConstraint,heightConstraint])
    separator.backgroundColor = color
    return view
  }

  func addRightSeparator(_ thickness:CGFloat,topInset:CGFloat,bottomInset:CGFloat,color:UIColor){
    let borderRight = UIView()
    borderRight.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(borderRight)
    let topConstraint = NSLayoutConstraint(item: borderRight, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: topInset)
    let bottomConstraint = NSLayoutConstraint(item: borderRight, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant:-bottomInset)
    let trailingConstraint = NSLayoutConstraint(item: borderRight, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
    let widthConstraint = NSLayoutConstraint(item: borderRight, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: thickness)
    NSLayoutConstraint.activate([topConstraint,bottomConstraint,trailingConstraint,widthConstraint])
    borderRight.backgroundColor = color
  }
  
  func addTopSeparator(_ thickness:CGFloat,rightInset:CGFloat,leftInset:CGFloat,color:UIColor){
    let separator = UIView()
    self.addSubview(separator)
    separator.translatesAutoresizingMaskIntoConstraints = false
    let topConstraint = NSLayoutConstraint(item: separator, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
    let leadingConstraint = NSLayoutConstraint(item: separator, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant:leftInset)
    let trailingConstraint = NSLayoutConstraint(item: separator, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: rightInset)
    let heightConstraint = NSLayoutConstraint(item: separator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: thickness)
    trailingConstraint.priority = UILayoutPriority(rawValue: 999)
    NSLayoutConstraint.activate([topConstraint,leadingConstraint,trailingConstraint,heightConstraint])
    separator.backgroundColor = color
  }
  
  func pinToSuperView(){
    let trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.superview, attribute: .trailing, multiplier: 1, constant: 0)
    let leadingConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.superview, attribute: .leading, multiplier: 1, constant: 0)
    let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.superview, attribute: .top, multiplier: 1, constant: 0)
    let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.superview, attribute: .bottom, multiplier: 1, constant: 0)
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([trailingConstraint,leadingConstraint,topConstraint,bottomConstraint])
  }
  
  func pinToSuperViewTopRightCorner(_ topMargin:CGFloat,rightMargin:CGFloat){
    let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.superview, attribute: .top, multiplier: 1, constant: topMargin)
    let trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.superview, attribute: .trailing, multiplier: 1, constant: -rightMargin)
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([topConstraint,trailingConstraint])
  }
  
  func pinToSuperViewBottomRightCorner(_ bottomMargin:CGFloat,rightMargin:CGFloat){
    let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.superview, attribute: .bottom, multiplier: 1, constant: -bottomMargin)
    let trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.superview, attribute: .trailing, multiplier: 1, constant: -rightMargin)
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([bottomConstraint,trailingConstraint])
  }
  func pinToSuperViewBottom(_ bottomMargin:CGFloat,rightMargin:CGFloat,leftMargin:CGFloat){
    let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.superview, attribute: .bottom, multiplier: 1, constant: -bottomMargin)
    let trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.superview, attribute: .trailing, multiplier: 1, constant: -rightMargin)
    let leadingContraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.superview, attribute: .leading, multiplier: 1, constant: leftMargin)
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([bottomConstraint,trailingConstraint,leadingContraint])
  }
  
  func setHeightConstraint(_ height:CGFloat,priority:UILayoutPriority){
    let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
    heightConstraint.priority = priority
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([heightConstraint])
  }
  func setWidthConstraint(_ width:CGFloat,priority:UILayoutPriority){
    let widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
    widthConstraint.priority = priority
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([widthConstraint])
  }
  func centerVerticallyInSuperview(){
    let centerYConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: self.superview!, attribute: .centerY, multiplier: 1, constant: 0)
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([centerYConstraint])
  }
    func centerVertically(inView view:UIView){
        let centerYConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([centerYConstraint])
    }
  func centerHorizontallyInSuperview(){
    let centerXConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.superview!, attribute: .centerX, multiplier: 1, constant: 0)
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([centerXConstraint])
  }
  func setLeadingInSuperview(_ margin:CGFloat,priority:UILayoutPriority){
    let leadingConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.superview!, attribute: .leading, multiplier: 1, constant: margin)
    leadingConstraint.priority = priority
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([leadingConstraint])
  }
  func setTrailingInSuperview(_ margin:CGFloat,priority:UILayoutPriority){
    let trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.superview!, attribute: .trailing, multiplier: 1, constant: margin)
    trailingConstraint.priority = priority
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([trailingConstraint])
  }
  func setTopInSuperview(_ margin:CGFloat,priority:UILayoutPriority){
    let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.superview!, attribute: .top, multiplier: 1, constant: margin)
    topConstraint.priority = priority
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([topConstraint])
  }
  func setBottomInSuperview(_ margin:CGFloat,priority:UILayoutPriority){
    let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.superview!, attribute: .bottom, multiplier: 1, constant: margin)
    bottomConstraint.priority = priority
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([bottomConstraint])
  }
  func pinWidthToSuperview(){
    let widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self.superview!, attribute: .width, multiplier: 1, constant: 0)
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([widthConstraint])
  }
}
