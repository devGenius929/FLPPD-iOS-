//
//  SummaryAnalysisModel.swift
//  FLPPD
//
//  Created by PC on 6/16/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation

func calculateGrossRentPerMonth(_ rentalWorksheet:RentalWorksheet)->NSDecimalNumber{
  let amount = rentalWorksheet.grossRent!
  if rentalWorksheet.rentCollection == RentCollectionType.daily.coreDataValue{
    return NSDecimalNumber(value: 30.42).multiplying(by:amount)
  }else if rentalWorksheet.rentCollection == RentCollectionType.weekly.coreDataValue{
    return NSDecimalNumber(value: 4.34524).multiplying(by: amount)
  }
  return amount
}
func calculateItemizeHoldingCostForHoldingPeriod(_ field:ItemizedHoldingCostsField,purchasePrice:NSDecimalNumber,holdingPeriod:NSDecimalNumber)->NSDecimalNumber{
  return calculateMonthlyItemizeHoldingCost(field, purchasePrice: purchasePrice).multiplying(by: holdingPeriod)
  
}
func calculateMonthlyItemizeHoldingCost(_ field:ItemizedHoldingCostsField,purchasePrice:NSDecimalNumber)->NSDecimalNumber{
  if field.isSetAmount{
    return field.characteristic2 == HoldingCostsCharacteristic2.PerMonth.number ? field.setAmount! : field.setAmount!.dividingBy12()
  }
  let percent = field.percentValue!.percentValue()
  return percent.multiplying(by: purchasePrice).dividingBy12()
}
func calculateLoanPaymentInterestOnlyForHoldingPeriod(_ holdingPeriod:NSDecimalNumber,amountFinanced:NSDecimalNumber,interestRate:NSDecimalNumber)->NSDecimalNumber{
  let monthlyPayment = calculateMonthlyLoanPaymentInterestOnly(amountFinanced, interestRate: interestRate)
  return monthlyPayment.multiplying(by: holdingPeriod)
}
func calculateLoanPaymentAmortizingForHoldingPeriod(_ loanAmount:NSDecimalNumber,annualInterestRate:NSDecimalNumber,loanTerm:NSDecimalNumber,holdingPeriod:NSDecimalNumber)->NSDecimalNumber{
  return calculateMonthlyLoanPaymentAmortizing(loanAmount, annualInterestRate: annualInterestRate, loanTerm: loanTerm).multiplying(by: holdingPeriod)
}
func calculateMortgageInsuranceForHoldingPeriod(_ loanAmount:NSDecimalNumber,upfront:NSDecimalNumber,recurring:NSDecimalNumber,holdingPeriod:NSDecimalNumber,loanTerm:NSDecimalNumber,annualInterestRate:NSDecimalNumber)->NSDecimalNumber{
  return calculateMonthlyMortgageInsurance(loanAmount, upfront: upfront, recurring: recurring,loanTerm: loanTerm,annualInterestRate: annualInterestRate).multiplying(by: holdingPeriod)
}
func calculateMonthlyMortgageInsurance(_ loanAmount:NSDecimalNumber,upfront:NSDecimalNumber,recurring:NSDecimalNumber,loanTerm:NSDecimalNumber,annualInterestRate:NSDecimalNumber)->NSDecimalNumber{
  let monthlyUpfront = calculateMonthlyLoanPaymentAmortizing(upfront.percentValue().multiplying(by:loanAmount), annualInterestRate: annualInterestRate, loanTerm: loanTerm)
  let monthlyRecurring = recurring.percentValue().multiplying(by: loanAmount).dividingBy12()
  return monthlyUpfront.adding(monthlyRecurring)
}
func calculateMonthlyLoanPaymentAmortizing(_ loanAmount:NSDecimalNumber,annualInterestRate:NSDecimalNumber,loanTerm:NSDecimalNumber)->NSDecimalNumber{
  let n = loanTerm.multiplyingBy12()
  let r = annualInterestRate.dividing(by: NSDecimalNumber(value: 1200))
  let r1 = NSDecimalNumber(value: 1).adding(r).doubleValue
  let r1pn = NSDecimalNumber(value:pow(r1, n.doubleValue))
  let numerator = r1pn.multiplying(by: r).multiplying(by: loanAmount)
  let denominator = r1pn.subtracting(NSDecimalNumber(value: 1))
  if denominator == NSDecimalNumber.zero{
    return n == NSDecimalNumber.zero ? NSDecimalNumber.zero : loanAmount.dividing(by: n)
  }
  return numerator.dividing(by: denominator)
}
func calculateMonthlyLoanPaymentInterestOnly(_ amountFinanced:NSDecimalNumber,interestRate:NSDecimalNumber)->NSDecimalNumber{
  return amountFinanced.multiplying(by: interestRate.percentValue()).dividing(by: NSDecimalNumber(value: 12))
}
func calculateDownPaymentAmount(percent:NSDecimalNumber,purchasePrice:NSDecimalNumber)->NSDecimalNumber{
  if purchasePrice == NSDecimalNumber.zero {
    return NSDecimalNumber.zero
  }
  if percent == NSDecimalNumber(value: 100){
    return purchasePrice
  }
  return purchasePrice.multiplying(by: percent.percentValue())
}
func calculateLoanAmount(_ percentOfARV:NSDecimalNumber,afterRepairValue:NSDecimalNumber)->NSDecimalNumber{
  if afterRepairValue == NSDecimalNumber.zero || percentOfARV == NSDecimalNumber.zero{
    return NSDecimalNumber.zero
  }
  return afterRepairValue.multiplying(by: percentOfARV.percentValue())
}
func calculateDownPaymentAmount(_ percentOfARVLoan:NSDecimalNumber,afterRepairValue:NSDecimalNumber,purchasePrice:NSDecimalNumber)->NSDecimalNumber{
  return calculateDownPaymentAmount(loanAmount:calculateLoanAmount(percentOfARVLoan, afterRepairValue: afterRepairValue), purchasePrice: purchasePrice)
}
func calculateDownPaymentAmount(loanAmount:NSDecimalNumber,purchasePrice:NSDecimalNumber)->NSDecimalNumber{
  if purchasePrice == NSDecimalNumber.zero{
    return NSDecimalNumber.zero
  }
  if loanAmount == NSDecimalNumber.zero{
    return purchasePrice
  }
  let amount = purchasePrice.subtracting(loanAmount)
  return amount.limitToRange(nil, min: 0)
}
func calculateLTCText(_ worksheet:Worksheet)->String?{
  if let ltc = calculateLTC(worksheet){
    return worksheet.isKind(of: FlipWorksheet.self) ? ltc.stringValue + "% LTC" : ltc.stringValue + "% LTV"
  }
  return nil
}

func calculateLTC(_ worksheet:Worksheet)->NSDecimalNumber?{
  let total = worksheet.isKind(of: FlipWorksheet.self) ? calculateAdjustedPurchasePrice(worksheet as! FlipWorksheet) : worksheet.purchasePrice!
  if let amountFinanced = worksheet.isKind(of: FlipWorksheet.self) ? calculateAmountFinanced(worksheet as! FlipWorksheet) : calculateAmountFinanced(worksheet as! RentalWorksheet){
    if total == NSDecimalNumber.zero || amountFinanced == NSDecimalNumber.zero{
      return nil
    }
    return amountFinanced.dividing(by: total).multiplyingBy100().roundTo2DecimalPlace()
  }
  return nil
}

func calculateFinancedRehabCosts(_ flipWorksheet:FlipWorksheet)->NSDecimalNumber?{
  if flipWorksheet.useFinancing,flipWorksheet.financeRehabCosts,flipWorksheet.percentageToFinance != NSDecimalNumber.zero{
    let rehabCosts = calculateTotalRehabCosts(flipWorksheet)
    if rehabCosts != NSDecimalNumber.zero{
      return rehabCosts.multiplying(by: flipWorksheet.percentageToFinance!.percentValue())
    }
    return nil
  }
  return nil 
}

func calculateAmountFinanced(_ flipWorksheet:FlipWorksheet)->NSDecimalNumber?{
  if flipWorksheet.useFinancing{
    if flipWorksheet.customLoanAmount && !flipWorksheet.customLoanAsPercentOfARV{
      return flipWorksheet.loanAmount!
    }
    let total = calculateAdjustedPurchasePrice(flipWorksheet)
    if let downPayment = calculateDownPaymentAmount(flipWorksheet){
      return total.subtracting(downPayment)
    }
    return nil
  }
  return nil
}
func calculateLoanRepaymentForHoldingPeriod(_ worksheet:Worksheet,holdingPeriod:NSDecimalNumber)->NSDecimalNumber?{
  guard var loanRepayment = worksheet.isKind(of: FlipWorksheet.self) ? calculateAmountFinanced(worksheet as! FlipWorksheet) : calculateAmountFinanced(worksheet as! RentalWorksheet) else{
    return nil
  }

  let wrappedIntoLoanPurchaseCosts = calculateWrapIntoLoanPurchaseCosts(worksheet)
  loanRepayment = loanRepayment.adding(wrappedIntoLoanPurchaseCosts)
  if !worksheet.amortizing {
    return loanRepayment
  }
  let loanTerm = worksheet.amortizingFinancing!.loanTerm!.multiplyingBy12()
  if holdingPeriod.compare(loanTerm) == ComparisonResult.orderedSame || holdingPeriod.compare(loanTerm) == ComparisonResult.orderedDescending{
    return NSDecimalNumber.zero
  }
  var monthlyPayment = calculateMonthlyLoanPaymentAmortizing(loanRepayment, annualInterestRate: worksheet.interestRate!, loanTerm: worksheet.amortizingFinancing!.loanTerm!)
  if worksheet.amortizingFinancing!.useMortgageInsurance, let upfront = worksheet.amortizingFinancing?.mortgageInsurance?.upfront,upfront != NSDecimalNumber.zero{
    monthlyPayment = monthlyPayment.adding(calculateMonthlyMortgageInsurance(loanRepayment, upfront: upfront, recurring:NSDecimalNumber.zero, loanTerm: worksheet.amortizingFinancing!.loanTerm!, annualInterestRate: worksheet.interestRate!))
    loanRepayment = loanRepayment.adding(upfront.percentValue().multiplying(by:loanRepayment.subtracting(wrappedIntoLoanPurchaseCosts)))
  }
  let r = worksheet.interestRate!.percentValue().dividingBy12()
  if r == NSDecimalNumber.zero{
    return loanRepayment
  }
  let r1 = r.adding(NSDecimalNumber(value: 1))
  let r1pn = NSDecimalNumber(value:pow(r1.doubleValue, holdingPeriod.doubleValue))
  let futureValueOfOriginalBalanace = r1pn.multiplying(by: loanRepayment)
  let futureValueOfAnnuity = r1pn.subtracting(NSDecimalNumber(value: 1)).dividing(by: r).multiplying(by:monthlyPayment)
  return futureValueOfOriginalBalanace.subtracting(futureValueOfAnnuity)
}
func calculateAmountFinanced(_ rentalWorksheet:RentalWorksheet)->NSDecimalNumber?{
  if rentalWorksheet.useFinancing{
    if rentalWorksheet.customLoanAmount {
      return rentalWorksheet.loanAmount!
    }
    if let downPayment = calculateDownPaymentAmount(rentalWorksheet){
      return rentalWorksheet.purchasePrice!.subtracting(downPayment)
    }
    return nil
  }
  return nil
}
func calculateDownPaymentAmount(_ rentalWorksheet:RentalWorksheet)->NSDecimalNumber?{
  let total = rentalWorksheet.purchasePrice!
  if rentalWorksheet.useFinancing{
    var downPaymentAmount =  calculateDownPaymentAmount(percent:rentalWorksheet.downPayment!, purchasePrice: total)
    if rentalWorksheet.customLoanAmount{
      downPaymentAmount = calculateDownPaymentAmount(loanAmount:rentalWorksheet.loanAmount!, purchasePrice: total)
    }
    return downPaymentAmount
  }
  return nil
}
func calculateDownPaymentAmount(_ flipWorksheet:FlipWorksheet)->NSDecimalNumber?{
  let total = calculateAdjustedPurchasePrice(flipWorksheet)
  if flipWorksheet.useFinancing{
    var downPaymentAmount =  calculateDownPaymentAmount(percent:flipWorksheet.downPayment!, purchasePrice: total)
    if flipWorksheet.customLoanAmount{
      let loanAmount = flipWorksheet.customLoanAsPercentOfARV ? calculateLoanAmount(flipWorksheet.percentOfARV!, afterRepairValue: flipWorksheet.afterRepairValue!) : flipWorksheet.loanAmount!
      downPaymentAmount = calculateDownPaymentAmount(loanAmount:loanAmount, purchasePrice: total)
    }
    return downPaymentAmount
  }
  return nil
}
func calculateAdjustedPurchasePrice(_ flipWorksheet:FlipWorksheet)->NSDecimalNumber{
  var total = flipWorksheet.purchasePrice!
  if flipWorksheet.useFinancing,let financedRehabCosts = calculateFinancedRehabCosts(flipWorksheet){
      total = total.adding(financedRehabCosts)
  }
  return total
}
func calculateAdjustedPurchaseCostsTotal(_ worksheet:Worksheet)->NSDecimalNumber{
  if worksheet.purchaseCosts!.itemized{
    return worksheet.purchaseCosts!.itemizedTotal!.subtracting(calculateWrapIntoLoanPurchaseCosts(worksheet))
  }
  return calculatePercentOfValue(worksheet.purchaseCosts!.total!, value: worksheet.purchasePrice!)
}
func calculateWrapIntoLoanPurchaseCosts(_ worksheet:Worksheet)->NSDecimalNumber{
  if worksheet.purchaseCosts!.itemized{
    var total = NSDecimalNumber.zero
    for field in worksheet.purchaseCosts!.itemizedPurchaseCosts!.array{
      guard let field = field as? ItemizedPurchaseCostsField else{
        continue
      }
      if field.characteristic3 == PurchaseCostsCharacteristic3.WrapIntoLoan.number{
        if field.characteristic1 == PurchaseCostsCharacteristic1.SetAmount.number{
          total = total.adding(field.setAmount!)
        }else if field.characteristic2 == PurchaseCostsCharacteristic2.OfLoan.number{
          guard let amountFinanced = worksheet.isKind(of: FlipWorksheet.self) ? calculateAmountFinanced(worksheet as! FlipWorksheet) : calculateAmountFinanced(worksheet as! RentalWorksheet) else{
            continue
          }
          total = total.adding(calculatePercentOfValue(field.percentValue!, value:amountFinanced))
        }else{
          total = total.adding(calculatePercentOfValue(field.percentValue!, value:worksheet.purchasePrice!))
        }
      }
    }
    return total
  }
  return NSDecimalNumber.zero
}

func calculatePercentOfValue(_ percent:NSDecimalNumber,value:NSDecimalNumber)->NSDecimalNumber{
  if percent == NSDecimalNumber.zero || value == NSDecimalNumber.zero{
    return NSDecimalNumber.zero
  }
  return value.multiplying(by: percent.percentValue())
}
func calculateAdjustedRehabCosts(_ flipWorksheet:FlipWorksheet)->NSDecimalNumber{
  let rehabCosts = calculateTotalRehabCosts(flipWorksheet)
  if let financedRehabCosts = calculateFinancedRehabCosts(flipWorksheet){
    return rehabCosts.subtracting(financedRehabCosts)
  }
  return rehabCosts
}
func calculateTotalRehabCosts(_ worksheet:Worksheet)->NSDecimalNumber{
  var rehabCosts = worksheet.rehabCosts!.itemized ? worksheet.rehabCosts!.itemizedTotal! : worksheet.rehabCosts!.total!
  guard let flipWorksheet = worksheet as? FlipWorksheet else{
    return rehabCosts
  }
  //calculate cost overrun if there is any
  if flipWorksheet.costOverrun != NSDecimalNumber.zero,rehabCosts != NSDecimalNumber.zero {
    let costOverrun = flipWorksheet.costOverrun!.percentValue().multiplying(by: rehabCosts)
    rehabCosts = rehabCosts.adding(costOverrun)
    return rehabCosts
  }
  return rehabCosts
}
func calculateCostOverrun(_ flipWorksheet:FlipWorksheet)->NSDecimalNumber{
  let rehabCosts = flipWorksheet.rehabCosts!.itemized ? flipWorksheet.rehabCosts!.itemizedTotal! : flipWorksheet.rehabCosts!.total!
  //calculate cost overrun if there is any
  if flipWorksheet.costOverrun != NSDecimalNumber.zero,rehabCosts != NSDecimalNumber.zero {
    return flipWorksheet.costOverrun!.percentValue().multiplying(by: rehabCosts)
  }
  return NSDecimalNumber.zero
}
func calculatePricePerSquareFoot(_ squareFoot:String?,purchasePrice:NSDecimalNumber)->NSDecimalNumber{
  let sqFt = NSDecimalNumber(string:squareFoot)
  guard sqFt != NSDecimalNumber.notANumber,sqFt.isGreaterThan(0),purchasePrice.isGreaterThan(0) else{
    return NSDecimalNumber.zero
  }
  return purchasePrice.dividing(by: sqFt)
}
