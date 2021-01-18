//
//  Report+Helper.swift
//  FLPPD
//
//  Created by PC on 8/11/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import MapKit

func insertStaticValue(_ html:String,property:Property)->String{
  var returnHtml = html
  //MARK:Nickname
  let nickname = property.nickname == nil ? "" : property.nickname!
  returnHtml =  returnHtml.replacingOccurrences(of:HtmlPlaceholder.nickname, with: nickname)
  //MARK:City
  returnHtml =  returnHtml.replacingOccurrences(of:HtmlPlaceholder.city, with: property.city!)
  //MARK:State
  returnHtml =  returnHtml.replacingOccurrences(of:HtmlPlaceholder.state, with: property.state!)
  //MARK:Purchase price
  returnHtml =  returnHtml.replacingOccurrences(of:HtmlPlaceholder.purchasePrice, with: property.worksheet!.purchasePrice!.decimalFormat())
  //MARK:Street
  returnHtml =  returnHtml.replacingOccurrences(of:HtmlPlaceholder.street, with: property.street!)
  //MARK:Zip code
  returnHtml =  returnHtml.replacingOccurrences(of:HtmlPlaceholder.zipcode, with: property.zipcode!)
  //MARK:Property type
  returnHtml = property.propertyType == nil ? returnHtml.replacingOccurrences(of:HtmlPlaceholder.propertyType, with: "") : returnHtml.replacingOccurrences(of:HtmlPlaceholder.propertyType, with: property.propertyType!)
  //MARK:Beds
  returnHtml = property.beds == nil ? returnHtml.replacingOccurrences(of:HtmlPlaceholder.beds, with: "") : returnHtml.replacingOccurrences(of:HtmlPlaceholder.beds, with: property.beds!)
  //MARK:baths
  returnHtml = property.baths == nil ? returnHtml.replacingOccurrences(of:HtmlPlaceholder.baths, with: "") : returnHtml.replacingOccurrences(of:HtmlPlaceholder.baths, with: property.baths!)
  //MARK:square footage
  returnHtml = property.squareFootage == nil ? returnHtml.replacingOccurrences(of:HtmlPlaceholder.squareFootage, with: "") : returnHtml.replacingOccurrences(of:HtmlPlaceholder.squareFootage, with: property.squareFootage!)
  //MARK:Year built
  returnHtml = property.yearBuilt == nil ? returnHtml.replacingOccurrences(of:HtmlPlaceholder.yearBuilt, with: "") : returnHtml.replacingOccurrences(of:HtmlPlaceholder.yearBuilt, with: property.yearBuilt!)
  //MARK:Parking
  returnHtml = property.parking == nil ? returnHtml.replacingOccurrences(of:HtmlPlaceholder.parking, with: "") : returnHtml.replacingOccurrences(of:HtmlPlaceholder.parking, with: property.parking!)
  //MARK:Lot size
  returnHtml = property.lotSize == nil ? returnHtml.replacingOccurrences(of:HtmlPlaceholder.lotSize, with: "") : returnHtml.replacingOccurrences(of:HtmlPlaceholder.lotSize, with: property.lotSize! + " sq ft")
  //MARK:Zoning
  returnHtml = property.zoning ? returnHtml.replacingOccurrences(of:HtmlPlaceholder.zoning, with: "YES") : returnHtml.replacingOccurrences(of:HtmlPlaceholder.zoning, with: "NO")
  return returnHtml
}

func fillPurchaseCosts(_ html:String,worksheet:Worksheet,includeWorksheet:Bool,purchaseCostsTotal:String)->String{
  var finalHtml = html
  var insertHtml = ""
  let totalTitle = "Total:"
  if includeWorksheet{
    if worksheet.purchaseCosts!.itemized,let fields = worksheet.purchaseCosts!.itemizedPurchaseCosts{
      
        for field in fields.array {
          guard let field = field as? ItemizedPurchaseCostsField else{
            continue
          }
          let amount = calculateItemizedPurchaseCostsFieldDollarAmount(field, worksheet: worksheet)
          if amount.isGreaterThan(0){
            let amountStr = field.characteristic3 == PurchaseCostsCharacteristic3.WrapIntoLoan.number ? amount.dollarFormat() + " (Financed)" : amount.dollarFormat()
            insertHtml += RowHtml.rowWithNoSign.replacingOccurrences(of: HtmlPlaceholder.title, with: field.name!).replacingOccurrences(of: HtmlPlaceholder.value, with: amountStr)
          }
        }
      
      let totalRow = insertHtml.isEmpty ? RowHtml.blueRow : RowHtml.blueRowWithTopBorderWithNoSign
      insertHtml += totalRow.replacingOccurrences(of: HtmlPlaceholder.title, with:totalTitle).replacingOccurrences(of: HtmlPlaceholder.value, with: worksheet.purchaseCosts!.itemizedTotal!.dollarFormat()).replacingOccurrences(of: HtmlPlaceholder.sign, with: "")
    }else{
      let title = "Total(" + worksheet.purchaseCosts!.total!.stringValue + "% of Price):"
      insertHtml = RowHtml.blueRowWithNoSign.replacingOccurrences(of: HtmlPlaceholder.title, with:title).replacingOccurrences(of: HtmlPlaceholder.value, with: purchaseCostsTotal)
    }
  }else{
    if worksheet.purchaseCosts!.itemized{
      insertHtml = RowHtml.blueRow.replacingOccurrences(of: HtmlPlaceholder.title, with:totalTitle).replacingOccurrences(of: HtmlPlaceholder.value, with: purchaseCostsTotal).replacingOccurrences(of: HtmlPlaceholder.sign, with: "")
    }else{
      let title = "Total(" + worksheet.purchaseCosts!.total!.stringValue + "% of Price):"
      insertHtml = RowHtml.blueRowWithNoSign.replacingOccurrences(of: HtmlPlaceholder.title, with:title).replacingOccurrences(of: HtmlPlaceholder.value, with: purchaseCostsTotal)
    }
  }
  finalHtml = finalHtml.replacingOccurrences(of: HtmlPlaceholder.purchaseCostsDetails, with: insertHtml)
  return finalHtml
}
func fillRehabCosts(_ html:String,worksheet:Worksheet,includeWorksheet:Bool,rehabCostsTotal:String)->String{
  var finalHtml = html
  var insertHtml = ""
  let costOverrunTitle = "Cost Overrun:"
  let totalTitle = "Total:"
  if includeWorksheet{
    if worksheet.rehabCosts!.itemized,let fields = worksheet.rehabCosts?.itemizedRehabCosts{
      for field in fields.array {
        guard let field = field as? ItemizedRehabCostsField,let setAmount = field.setAmount,setAmount.isGreaterThan(0) else{
          continue
        }
        insertHtml += RowHtml.rowWithNoSign.replacingOccurrences(of: HtmlPlaceholder.title, with: field.name!).replacingOccurrences(of: HtmlPlaceholder.value, with: field.setAmount!.dollarFormat())
      }
      
      if let flipWorksheet = worksheet as? FlipWorksheet{
        let value = calculateCostOverrun(flipWorksheet).dollarFormat() + " (" + flipWorksheet.costOverrun!.stringValue + "%)"
        insertHtml += RowHtml.rowWithNoSign.replacingOccurrences(of: HtmlPlaceholder.title, with: costOverrunTitle).replacingOccurrences(of: HtmlPlaceholder.value, with: value)
      }
      let totalRow = insertHtml.isEmpty ? RowHtml.blueRowWithNoSign : RowHtml.blueRowWithTopBorderWithNoSign
      insertHtml += totalRow.replacingOccurrences(of: HtmlPlaceholder.title, with:totalTitle).replacingOccurrences(of: HtmlPlaceholder.value, with: rehabCostsTotal)
    }else{
      insertHtml = insertNoItemizedRehabCosts(insertHtml, worksheet:worksheet, rehabCostsTotal: rehabCostsTotal)
    }
  }else{
    insertHtml = insertNoItemizedRehabCosts(insertHtml, worksheet:worksheet, rehabCostsTotal: rehabCostsTotal)
  }
  finalHtml = finalHtml.replacingOccurrences(of: HtmlPlaceholder.rehabCostsDetails, with: insertHtml)
  return finalHtml
}
func insertNoItemizedRehabCosts(_ html:String,worksheet:Worksheet,rehabCostsTotal:String)->String{
  let totalTitle = "Total:"
  var insertHtml = insertCostOverrunHtml(html, worksheet: worksheet)
  let totalRow = insertHtml.isEmpty ? RowHtml.blueRowWithNoSign : RowHtml.blueRowWithTopBorderWithNoSign
  insertHtml += totalRow.replacingOccurrences(of: HtmlPlaceholder.title, with:totalTitle).replacingOccurrences(of: HtmlPlaceholder.value, with: rehabCostsTotal)
  return insertHtml
}
func insertCostOverrunHtml(_ html:String,worksheet:Worksheet)->String{
  var insertHtml = html
  let costOverrunTitle = "Cost Overrun:"
  let rehabCostsTitle = "Rehab Costs:"
  if let flipWorksheet = worksheet as? FlipWorksheet{
    let rehabCosts = flipWorksheet.rehabCosts!.itemized ? flipWorksheet.rehabCosts!.itemizedTotal! : flipWorksheet.rehabCosts!.total!
    let rehabCostsValue = rehabCosts.dollarFormat()
    insertHtml += RowHtml.rowWithNoSign.replacingOccurrences(of: HtmlPlaceholder.title, with: rehabCostsTitle).replacingOccurrences(of: HtmlPlaceholder.value, with: rehabCostsValue)
    let costOverrunValue = calculateCostOverrun(flipWorksheet).dollarFormat() + " (" + flipWorksheet.costOverrun!.stringValue + "%)"
    insertHtml += RowHtml.rowWithNoSign.replacingOccurrences(of: HtmlPlaceholder.title, with: costOverrunTitle).replacingOccurrences(of: HtmlPlaceholder.value, with: costOverrunValue)
  }
  return insertHtml
}
func drawPinAtCoordinate(_ snapshot:MKMapSnapshot, coordinate:CLLocationCoordinate2D)->UIImage?{
  let point = snapshot.point(for: coordinate)
  let pin = UIImage(named: "greenDot")!
  UIGraphicsBeginImageContextWithOptions(snapshot.image.size, true, snapshot.image.scale)
  snapshot.image.draw(at: .zero)
  pin.draw(at: point)
  let image = UIGraphicsGetImageFromCurrentImageContext()
  UIGraphicsEndImageContext()
  return image
}

func createPdfFile(printFormatter: UIViewPrintFormatter) -> NSData {
  let renderer = UIPrintPageRenderer()
  renderer.addPrintFormatter(printFormatter, startingAtPageAt: 0);
  let paperSize = CGSize(width: 1275, height: 1650)
  let printableRect = CGRect(x: 0, y: 0, width: paperSize.width, height: paperSize.height)
  let paperRect = CGRect(x: 0, y: 0, width: paperSize.width, height: paperSize.height)
  renderer.setValue(NSValue(cgRect: paperRect), forKey: "paperRect")
  renderer.setValue(NSValue(cgRect: printableRect), forKey: "printableRect")
  return renderer.printToPDF()
}
