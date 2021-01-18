//
//  SummaryAnalysisViewModel.swift
//  FLPPD
//
//  Created by PC on 6/16/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

enum RentalOperationPeriod{
  case monthly
  case yearly
}
struct RentalSummaryAnalysisViewModel{
  let purchasePrice:String
  let amountFinanced:String?
  let ltv:String?
  let downPayment:String?
  let purchaseCosts:String
  let rehabCosts:String
  let totalCashNeeded:String
  let pricePerSquareFoot:String
  let grossRent:String
  let vacancy:String
  let vacancyPercentage:String?
  let otherIncome:String?
  let operatingIncome:String
  let operatingExpenses:String
  let operatingExpensesPercentage:String?
  let netOperatingIncome:String
  let loanPayments:String?
  let cashFlow:String
  let capRate:String
  let cashOnCash:String
  let returnOnInvestment:String
  let internalRateOfReturn:String
  let rentToValue:String
  let grossRentMultiplier:String
  let debtCoverageRatio:String?
}
struct FlipSummaryAnalysisViewModel{
  let purchasePrice:String
  let financedRehabCosts:String?
  let financedRehabCostsPercentage:String?
  let amountFinanced:String?
  let ltc:String?
  let downPayment:String?
  let purchaseCosts:String
  let rehabCosts:String
  let totalCashNeeded:String
  let pricePerSquareFoot:String
  let loanPayment:String?
  let recurringExpenses:String?
  let itemizedHoldingCosts:[SummaryProjectionItem]
  let holdingCostsTotal:String
  let afterRepairValue:String
  let sellingCosts:String
  let saleProceeds:String
  let loanRepayment:String?
  let holdingCosts:String
  let investedCash:String
  let totalProfit:String
  let roi:String
  let annualizedROI:String
}

func rentalSummaryAnalysis(_ rentalProperty:Property,operationPeriod:RentalOperationPeriod)->RentalSummaryAnalysisViewModel{
  let holdingPeriod = operationPeriod == .monthly ? NSDecimalNumber(value: 1) : NSDecimalNumber(value: 12)
  let rentalWorksheet = rentalProperty.worksheet as! RentalWorksheet
  let purchasePrice = rentalWorksheet.purchasePrice!
  let amountFinanced = calculateAmountFinanced(rentalWorksheet)
  let wrappedIntoLoanPurchaseCosts = calculateWrapIntoLoanPurchaseCosts(rentalWorksheet)
  let ltv = calculateLTCText(rentalWorksheet)
  let downPayment = calculateDownPaymentAmount(rentalWorksheet)
  let purchaseCosts = calculateAdjustedPurchaseCostsTotal(rentalWorksheet)
  let rehabCosts = calculateTotalRehabCosts(rentalWorksheet)
  let cost = purchaseCosts.adding(rehabCosts)
  let totalCashNeeded = downPayment != nil ? downPayment!.adding(cost) : purchasePrice.adding(cost)
  let pricePerSquareFoot = calculatePricePerSquareFoot(rentalProperty.squareFootage, purchasePrice: purchasePrice)
  //MARK:Operation
  let grossRentPerMonth = calculateGrossRentPerMonth(rentalWorksheet)
  let vacancy = calculatePercentOfValue(rentalWorksheet.vacancy!,value:grossRentPerMonth)
  let vacancyPercentage = rentalWorksheet.vacancy!.isGreaterThan(0) ? rentalWorksheet.vacancy!.stringValue + "% of Rent" : nil
  let otherIncome = rentalWorksheet.income!.itemized ? rentalWorksheet.income!.itemizedTotal! : rentalWorksheet.income!.total!
  let operatingIncome = grossRentPerMonth.subtracting(vacancy).adding(otherIncome)
  let operatingExpenses = rentalWorksheet.expenses!.itemized ? rentalWorksheet.expenses!.itemizedTotal! : calculatePercentOfValue(rentalWorksheet.expenses!.total!, value: grossRentPerMonth)
  let operatingExpensesPercentage = operatingIncome != NSDecimalNumber.zero ? operatingExpenses.dividing(by: operatingIncome).multiplyingBy100().roundTo2DecimalPlace().stringValue + "% of Income" : nil
  let netOperatingIncome = operatingIncome.subtracting(operatingExpenses)
  var monthlyLoanPayment:NSDecimalNumber?
  var yearlyLoanPayment:NSDecimalNumber?
  //MARK:Loan Payment
  if rentalWorksheet.useFinancing{
    let loanAmount = amountFinanced!.adding(wrappedIntoLoanPurchaseCosts)
    if !rentalWorksheet.amortizing{
      monthlyLoanPayment = calculateLoanPaymentInterestOnlyForHoldingPeriod(NSDecimalNumber(value:1),amountFinanced:loanAmount,interestRate: rentalWorksheet.interestRate!)
      yearlyLoanPayment = calculateLoanPaymentInterestOnlyForHoldingPeriod(NSDecimalNumber(value:12),amountFinanced:loanAmount,interestRate: rentalWorksheet.interestRate!)
    }else{
      monthlyLoanPayment = calculateLoanPaymentAmortizingForHoldingPeriod(loanAmount, annualInterestRate: rentalWorksheet.interestRate!, loanTerm: rentalWorksheet.amortizingFinancing!.loanTerm!,holdingPeriod: NSDecimalNumber(value:1))
      yearlyLoanPayment = calculateLoanPaymentAmortizingForHoldingPeriod(loanAmount, annualInterestRate: rentalWorksheet.interestRate!, loanTerm: rentalWorksheet.amortizingFinancing!.loanTerm!,holdingPeriod: NSDecimalNumber(value:12))
      if rentalWorksheet.amortizingFinancing!.useMortgageInsurance{
        monthlyLoanPayment = monthlyLoanPayment!.adding(calculateMortgageInsuranceForHoldingPeriod( amountFinanced!, upfront: rentalWorksheet.amortizingFinancing!.mortgageInsurance!.upfront!, recurring: rentalWorksheet.amortizingFinancing!.mortgageInsurance!.recurring!,holdingPeriod: NSDecimalNumber(value:1),loanTerm: rentalWorksheet.amortizingFinancing!.loanTerm!,annualInterestRate:rentalWorksheet.interestRate!))
        yearlyLoanPayment = yearlyLoanPayment!.adding(calculateMortgageInsuranceForHoldingPeriod( amountFinanced!, upfront: rentalWorksheet.amortizingFinancing!.mortgageInsurance!.upfront!, recurring: rentalWorksheet.amortizingFinancing!.mortgageInsurance!.recurring!,holdingPeriod: NSDecimalNumber(value:12),loanTerm: rentalWorksheet.amortizingFinancing!.loanTerm!,annualInterestRate:rentalWorksheet.interestRate!))
      }
    }
  }
  let cashFlow:NSDecimalNumber
  if operationPeriod == .yearly{
    cashFlow = yearlyLoanPayment != nil ? netOperatingIncome.multiplying(by: holdingPeriod).subtracting(yearlyLoanPayment!) : netOperatingIncome.multiplying(by:holdingPeriod)
  }else{
    cashFlow = monthlyLoanPayment != nil ? netOperatingIncome.subtracting(monthlyLoanPayment!) : netOperatingIncome
  }
  //MARK:Returns
  let yearlyNOI = netOperatingIncome.multiplyingBy12()
  let yearlyCashFlows = yearlyLoanPayment != nil ? yearlyNOI.subtracting(yearlyLoanPayment!) : yearlyNOI
  let capRate = purchasePrice.isGreaterThan(0) ? yearlyNOI.dividing(by:purchasePrice).multiplyingBy100().roundTo2DecimalPlace() : NSDecimalNumber.zero
  let cashOnCash = totalCashNeeded.isGreaterThan(0) ? yearlyCashFlows.dividing(by: totalCashNeeded).multiplyingBy100().roundTo2DecimalPlace().stringValue + "%" : "infinite %"
  let propertyValue = calculateAppreciationOfValue(rentalWorksheet.afterRepairValue!, percent: rentalWorksheet.appreciation!, numberOfAppreciation: 1)
  let sellingCosts = calculatePercentOfValue(rentalWorksheet.sellingCosts!, value: propertyValue)
  let loanBalance = calculateLoanRepaymentForHoldingPeriod(rentalWorksheet, holdingPeriod: NSDecimalNumber(value:12))
  let totalEquity = loanBalance != nil ? propertyValue.subtracting(loanBalance!) : propertyValue
  var roi:String
  var irr:String
  if totalCashNeeded == NSDecimalNumber.zero{
      roi = "infinite %"
      irr = roi
  }else{
    let returnOnInvestment = yearlyCashFlows.adding(totalEquity).subtracting(sellingCosts).subtracting(totalCashNeeded).dividing(by: totalCashNeeded)
    roi = returnOnInvestment.multiplyingBy100().roundTo2DecimalPlace().stringValue + " %"
    irr = roi
  }
  let rentToValue = purchasePrice.isGreaterThan(0) ? grossRentPerMonth.dividing(by: purchasePrice).multiplyingBy100().roundTo2DecimalPlace().stringValue + "%" : "infinite %"
  let grossRentMultiplier = grossRentPerMonth.isGreaterThan(0) ? purchasePrice.dividing(by: grossRentPerMonth.multiplyingBy12()).roundTo2DecimalPlace().stringValue : "infinite"
  var debtCoverageRatio:NSDecimalNumber?
  if yearlyLoanPayment != nil && yearlyLoanPayment != NSDecimalNumber.zero{
    debtCoverageRatio = netOperatingIncome.multiplyingBy12().dividing(by: yearlyLoanPayment!).roundTo2DecimalPlace()
  }
  if operationPeriod == .monthly{
    let otherIncomeText = otherIncome.isGreaterThan(0) ? "$ " + otherIncome.roundTo2DecimalPlace().stringValue : nil
    return RentalSummaryAnalysisViewModel(purchasePrice: purchasePrice.dollarFormat(), amountFinanced: amountFinanced?.dollarFormat(), ltv: ltv, downPayment: downPayment?.dollarFormat(), purchaseCosts: purchaseCosts.dollarFormat(), rehabCosts: rehabCosts.dollarFormat(), totalCashNeeded: totalCashNeeded.dollarFormat(), pricePerSquareFoot: pricePerSquareFoot.dollarFormat(), grossRent: grossRentPerMonth.dollarFormat(), vacancy: vacancy.dollarFormat(),vacancyPercentage:vacancyPercentage,otherIncome: otherIncomeText, operatingIncome: operatingIncome.dollarFormat(), operatingExpenses: operatingExpenses.dollarFormat(), operatingExpensesPercentage: operatingExpensesPercentage, netOperatingIncome: netOperatingIncome.dollarFormat(), loanPayments: monthlyLoanPayment?.dollarFormat(), cashFlow: cashFlow.dollarFormat(), capRate: capRate.stringValue + "%", cashOnCash: cashOnCash, returnOnInvestment: roi, internalRateOfReturn: irr, rentToValue: rentToValue, grossRentMultiplier: grossRentMultiplier, debtCoverageRatio: debtCoverageRatio?.stringValue)
  }
  let otherIncomeText = otherIncome.isGreaterThan(0) ? "$ " + otherIncome.multiplyingBy12().roundTo2DecimalPlace().stringValue : nil
  return RentalSummaryAnalysisViewModel(purchasePrice: purchasePrice.dollarFormat(), amountFinanced: amountFinanced?.dollarFormat(), ltv: ltv, downPayment: downPayment?.dollarFormat(), purchaseCosts: purchaseCosts.dollarFormat(), rehabCosts: rehabCosts.dollarFormat(), totalCashNeeded: totalCashNeeded.dollarFormat(), pricePerSquareFoot: pricePerSquareFoot.dollarFormat(), grossRent: grossRentPerMonth.multiplyingBy12().dollarFormat(), vacancy: vacancy.multiplyingBy12().dollarFormat(),vacancyPercentage:vacancyPercentage, otherIncome: otherIncomeText, operatingIncome: operatingIncome.multiplyingBy12().dollarFormat(), operatingExpenses: operatingExpenses.multiplyingBy12().dollarFormat(), operatingExpensesPercentage: operatingExpensesPercentage, netOperatingIncome: netOperatingIncome.multiplyingBy12().dollarFormat(), loanPayments: yearlyLoanPayment?.dollarFormat(), cashFlow: yearlyCashFlows.dollarFormat(), capRate: capRate.stringValue + "%", cashOnCash: cashOnCash, returnOnInvestment: roi, internalRateOfReturn: irr, rentToValue: rentToValue, grossRentMultiplier: grossRentMultiplier, debtCoverageRatio: debtCoverageRatio?.stringValue)
}

func flipSummaryAnalysis(_ flipProperty:Property,holdingPeriod:NSDecimalNumber)->FlipSummaryAnalysisViewModel{
  let flipWorksheet = flipProperty.worksheet as! FlipWorksheet
  let purchasePrice = flipWorksheet.purchasePrice!.dollarFormat()
  let financedRehabCosts = calculateFinancedRehabCosts(flipWorksheet)
  var financedRehabCostsPercentage:String?
  let downPayment = calculateDownPaymentAmount(flipWorksheet)
  let amountFinanced = calculateAmountFinanced(flipWorksheet)
  let ltcText = calculateLTCText(flipWorksheet)
  var loanPayment:NSDecimalNumber?
  var recurringExpenses:NSDecimalNumber?
  var itemizedHoldingCosts:[SummaryProjectionItem] = []
  var holdingCostsTotal = NSDecimalNumber.zero
  let afterRepairValue = flipWorksheet.afterRepairValue!
  let loanRepayment = calculateLoanRepaymentForHoldingPeriod(flipWorksheet, holdingPeriod: holdingPeriod)
  var roi:String!
  var annualizedROI:String!
  if financedRehabCosts != nil{
    financedRehabCostsPercentage = flipWorksheet.percentageToFinance!.stringValue + "% of Total"
  }
  let purchaseCosts = calculateAdjustedPurchaseCostsTotal(flipWorksheet)
  let rehabCosts = calculateAdjustedRehabCosts(flipWorksheet)
  let pricePerSquareFoot = calculatePricePerSquareFoot(flipProperty.squareFootage, purchasePrice: flipWorksheet.purchasePrice!).dollarFormat()
  let totalCashNeeded = flipWorksheet.useFinancing ? downPayment!.adding(purchaseCosts).adding(rehabCosts) : flipWorksheet.purchasePrice!.adding(purchaseCosts).adding(rehabCosts)
  //MARK:Loan Payment
  if flipWorksheet.useFinancing{
    if !flipWorksheet.amortizing{
      loanPayment = calculateLoanPaymentInterestOnlyForHoldingPeriod(holdingPeriod, amountFinanced: loanRepayment!, interestRate: flipWorksheet.interestRate!)
    }else{
      let loanAmount = amountFinanced!.adding(calculateWrapIntoLoanPurchaseCosts(flipWorksheet))
      loanPayment = calculateLoanPaymentAmortizingForHoldingPeriod(loanAmount, annualInterestRate: flipWorksheet.interestRate!, loanTerm: flipWorksheet.amortizingFinancing!.loanTerm!, holdingPeriod: holdingPeriod)
      if flipWorksheet.amortizingFinancing!.useMortgageInsurance{
        loanPayment = loanPayment!.adding(calculateMortgageInsuranceForHoldingPeriod(amountFinanced!, upfront: flipWorksheet.amortizingFinancing!.mortgageInsurance!.upfront!, recurring: flipWorksheet.amortizingFinancing!.mortgageInsurance!.recurring!,holdingPeriod: holdingPeriod, loanTerm: flipWorksheet.amortizingFinancing!.loanTerm!,annualInterestRate:flipWorksheet.interestRate!))
      }
    }
    holdingCostsTotal = loanPayment!
  }
  //MARK:Holding costs expenses
  if flipWorksheet.holdingCosts!.itemized,let fields = flipWorksheet.holdingCosts?.itemizedHoldingCosts{
    for field in fields.array{
      guard let field = field as? ItemizedHoldingCostsField else{
        continue
      }
    let amount = calculateItemizeHoldingCostForHoldingPeriod(field, purchasePrice: flipWorksheet.purchasePrice!, holdingPeriod: holdingPeriod)
      if amount.isGreaterThan(0){
        holdingCostsTotal = holdingCostsTotal.adding(amount)
        let item = SummaryProjectionItem(name: field.name!, text: amount.dollarFormat())
        itemizedHoldingCosts.append(item)
      }
    }
  }else{
    recurringExpenses = holdingPeriod.multiplying(by: flipWorksheet.holdingCosts!.total!)
    holdingCostsTotal = holdingCostsTotal.adding(recurringExpenses!)
  }
  //MARK:Sale & Profit
  let sellingCosts = flipWorksheet.sellingCosts!.itemized ? flipWorksheet.sellingCosts!.itemizedTotal! : flipWorksheet.sellingCosts!.total!.percentValue().multiplying(by: flipWorksheet.afterRepairValue!)
  let saleProceeds = afterRepairValue.subtracting(sellingCosts)
  let totalProfit = flipWorksheet.useFinancing ? saleProceeds.subtracting(loanRepayment!).subtracting(holdingCostsTotal).subtracting(totalCashNeeded) : saleProceeds.subtracting(holdingCostsTotal).subtracting(totalCashNeeded)
  //MARK:Returns
  if totalCashNeeded != NSDecimalNumber.zero{
    let returnOnInvestment = totalProfit.dividing(by: totalCashNeeded.adding(holdingCostsTotal))
    roi = returnOnInvestment.multiplyingBy100().roundTo2DecimalPlace().stringValue + "%"
    if holdingPeriod == NSDecimalNumber.zero{
      annualizedROI = "infinite %"
    }else{
      annualizedROI = NSDecimalNumber(value: 12).multiplying(by: returnOnInvestment).dividing(by: holdingPeriod).multiplying(by: NSDecimalNumber(value:100)).roundTo2DecimalPlace().stringValue + " %"
    }
  }else{
    roi = "infinite %"
    annualizedROI = "infinite %"
  }
  return FlipSummaryAnalysisViewModel(purchasePrice: purchasePrice, financedRehabCosts: financedRehabCosts?.dollarFormat(), financedRehabCostsPercentage: financedRehabCostsPercentage, amountFinanced: amountFinanced?.dollarFormat(), ltc: ltcText, downPayment: downPayment?.dollarFormat(), purchaseCosts: purchaseCosts.dollarFormat(), rehabCosts: rehabCosts.dollarFormat(), totalCashNeeded: totalCashNeeded.dollarFormat(), pricePerSquareFoot: pricePerSquareFoot,loanPayment:loanPayment?.dollarFormat(),recurringExpenses:recurringExpenses?.dollarFormat(),itemizedHoldingCosts:itemizedHoldingCosts,holdingCostsTotal:holdingCostsTotal.dollarFormat(),afterRepairValue:afterRepairValue.dollarFormat(),sellingCosts:sellingCosts.dollarFormat(),saleProceeds:saleProceeds.dollarFormat(),loanRepayment:loanRepayment?.dollarFormat(), holdingCosts:holdingCostsTotal.dollarFormat(),investedCash:totalCashNeeded.dollarFormat(),totalProfit:totalProfit.dollarFormat(),roi:roi,annualizedROI:annualizedROI)
}
