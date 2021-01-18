//
//  ProjectionsViewModel.swift
//  FLPPD
//
//  Created by PC on 6/25/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation

struct CashFlow{
  let income:OperatingIncome
  let expenses:OperatingExpenses
  let netOperatingIncome:NSDecimalNumber
  let loanPayment:NSDecimalNumber?
  let cashFlow:NSDecimalNumber
}
struct OperatingExpenses{
  let items:[SummaryProjectionItem]
  let totalExpenses:NSDecimalNumber?
  let operatingExpenses:NSDecimalNumber
}
struct OperatingIncome{
  let grossRentPerMonth:NSDecimalNumber
  let grossRentPerYear:NSDecimalNumber
  let vacancy:NSDecimalNumber
  let otherIncome:NSDecimalNumber?
  let operatingIncome:NSDecimalNumber
}
struct SummaryProjectionItem{
  let name:String
  let text:String
}
struct ProjectionsViewModel{
  let grossRent:String
  let vacancy:String
  let vacancyPercentage:String?
  let otherIncome:String?
  let operatingIncome:String
  let operatingIncomeAppreciation:String?
  let itemizedExpenses:[SummaryProjectionItem]
  let totalExpenses:String?
  let operatingExpenses:String
  let operatingExpensesIncrease:String?
  let operatingExpensesAsPercentOfIncome:String?
  let netOperatingIncome:String
  let loanPayment:String?
  let cashFlow:String
  let propertyValue:String
  let propertyValueAppreciation:String?
  let loanBalance:String?
  let totalEquity:String
  let depreciation:String
  let loanInterest:String?
  let capRate:String
  let cashOnCash:String
  let returnOnInvestment:String
  let internalRateOfReturn:String
  let rentToValue:String
  let grossRentMultiplier:String
  let debtCoverageRatio:String?
}

func rentalProjections(property:RentalProperty,year:NSDecimalNumber)->ProjectionsViewModel{
  let rentalWorksheet = property.worksheet as! RentalWorksheet
  let cashFlow = calculateCashFlowForYear(year, rentalWorksheet: rentalWorksheet)
  let grossRentPerMonth = cashFlow.income.grossRentPerMonth
  let grossRentPerYear = cashFlow.income.grossRentPerYear
  let vacancy = cashFlow.income.vacancy
  let vacancyPercentage = rentalWorksheet.vacancy!.isGreaterThan(0) ? rentalWorksheet.vacancy!.stringValue + "% of Rent" : nil
  let otherIncome = cashFlow.income.otherIncome
  let operatingIncome = cashFlow.income.operatingIncome
  let operatingIncomeAppreciation = rentalWorksheet.incomeIncrease! != NSDecimalNumber.zero ? rentalWorksheet.incomeIncrease!.stringValue + "% Increase" : nil
  //MARK:Expenses
  let itemizedExpenses = cashFlow.expenses.items
  let totalExpenses = cashFlow.expenses.totalExpenses
  let operatingExpenses = cashFlow.expenses.operatingExpenses
  let operatingExpensesIncrease = rentalWorksheet.expensesIncrease! != NSDecimalNumber.zero ? rentalWorksheet.expensesIncrease!.stringValue + "% Increase" : nil
  //MARK:Cash flow
  let operatingExpensesAsPercentOfIncome = operatingIncome != NSDecimalNumber.zero ? operatingExpenses.dividing(by: operatingIncome).multiplyingBy100().roundTo2DecimalPlace().stringValue + "% of Income" : nil
  let netOperatingIncome = cashFlow.netOperatingIncome
  let loanPayment = cashFlow.loanPayment
  //MARK:Equity Accumulation
  let propertyValue = calculateAppreciationOfValue(rentalWorksheet.afterRepairValue!, percent: rentalWorksheet.appreciation!, numberOfAppreciation: year.intValue)
  let propertyValueAppreciation = rentalWorksheet.appreciation! != NSDecimalNumber.zero ? rentalWorksheet.appreciation!.stringValue + "% Increase" : nil
  let loanBalance = calculateLoanRepaymentForHoldingPeriod(rentalWorksheet, holdingPeriod: year.multiplyingBy12())
  let totalEquity = loanBalance == nil ? propertyValue : propertyValue.subtracting(loanBalance!)
  //MARK:Tax Benefits
  let purchaseCosts = calculateAdjustedPurchaseCostsTotal(rentalWorksheet)
  let usefulLifespan = NSDecimalNumber(value: 27.5)
  let depreciation = year.compare(usefulLifespan) == ComparisonResult.orderedDescending ? NSDecimalNumber.zero : rentalWorksheet.purchasePrice!.subtracting(rentalWorksheet.landValue!).adding(purchaseCosts).dividing(by: NSDecimalNumber(value: 27.5))
  let priorYearLoanBalance = calculateLoanRepaymentForHoldingPeriod(rentalWorksheet, holdingPeriod: year.multiplyingBy12().subtracting(NSDecimalNumber(value: 12)))
  var loanInterest:NSDecimalNumber?
  if rentalWorksheet.useFinancing{
    loanInterest = NSDecimalNumber.zero
    if let yearlyLoanPayment = loanPayment{
      loanInterest = yearlyLoanPayment
    }
    if priorYearLoanBalance != nil{
      loanInterest = loanInterest!.subtracting(priorYearLoanBalance!)
    }
    if loanBalance != nil{
      loanInterest = loanInterest!.adding(loanBalance!)
    }
  }
  //MARK:Returns
  let sellingCosts = calculatePercentOfValue(rentalWorksheet.sellingCosts!, value: propertyValue)
  let downPayment = calculateDownPaymentAmount(rentalWorksheet)
  let rehabCosts = calculateTotalRehabCosts(rentalWorksheet)
  let cost = purchaseCosts.adding(rehabCosts)
  let totalCashNeeded = downPayment != nil ? downPayment!.adding(cost) : rentalWorksheet.purchasePrice!.adding(cost)
  let capRate = propertyValue.isGreaterThan(0) ? netOperatingIncome.dividing(by: propertyValue).multiplyingBy100().roundTo2DecimalPlace().stringValue + "%" : "infinite %"
  let cashOnCash = totalCashNeeded.isGreaterThan(0) ? cashFlow.cashFlow.dividing(by: totalCashNeeded).multiplyingBy100().roundTo2DecimalPlace().stringValue + "%" : "infinite %"
  var roi:String
  var irr:String
  if totalCashNeeded == NSDecimalNumber.zero{
    roi = "infinite %"
    irr = roi
  }else{
    let totalCashFlow = calculateTotalCashFlowUpToYear(year, rentalWorksheet: rentalWorksheet)
    let returnOnInvestment = totalCashFlow.adding(totalEquity).subtracting(sellingCosts).subtracting(totalCashNeeded).dividing(by: totalCashNeeded)
    roi = returnOnInvestment.multiplyingBy100().roundTo2DecimalPlace().stringValue + " %"
    //irr = NSDecimalNumber(value:(pow(returnOnInvestment.adding(NSDecimalNumber(value: 1)).doubleValue,1/year.doubleValue) - 1)).multiplyingBy100().roundTo2DecimalPlace().stringValue + " %"
    let pow1 = returnOnInvestment.adding(NSDecimalNumber(value: 1)).doubleValue
    let pow2 = 1/year.doubleValue
    let a = pow(pow1,pow2)
    if a.isNaN {
        irr = "error"
    }
    else {
        let b = a  - 1
        let c = NSDecimalNumber(value:b)
        let d = c.multiplyingBy100()
        let e = d.roundTo2DecimalPlace()
        irr = e.stringValue + " %"
    }
  }
  //MARK:Ratios
  let rentToValue = propertyValue.isGreaterThan(0) ? grossRentPerMonth.dividing(by: propertyValue).multiplyingBy100().roundTo2DecimalPlace().stringValue + "%" : "infinite %"
  let grossRentMultiplier = grossRentPerMonth.isGreaterThan(0) ? propertyValue.dividing(by: grossRentPerYear).roundTo2DecimalPlace().stringValue : "infinite"
  var debtCoverageRatio:NSDecimalNumber?
  if loanPayment != nil,loanPayment != NSDecimalNumber.zero{
    debtCoverageRatio = netOperatingIncome.dividing(by: loanPayment!).roundTo2DecimalPlace()
  }

  return ProjectionsViewModel(grossRent: grossRentPerYear.dollarFormat(), vacancy: vacancy.dollarFormat(), vacancyPercentage: vacancyPercentage, otherIncome: otherIncome?.dollarFormat(), operatingIncome: operatingIncome.dollarFormat(),operatingIncomeAppreciation:operatingIncomeAppreciation,itemizedExpenses:itemizedExpenses,totalExpenses:totalExpenses?.dollarFormat(),operatingExpenses:operatingExpenses.dollarFormat(),operatingExpensesIncrease:operatingExpensesIncrease, operatingExpensesAsPercentOfIncome: operatingExpensesAsPercentOfIncome,netOperatingIncome:netOperatingIncome.dollarFormat(),loanPayment:loanPayment?.dollarFormat(),cashFlow:cashFlow.cashFlow.dollarFormat(),propertyValue:propertyValue.dollarFormat(),propertyValueAppreciation:propertyValueAppreciation,loanBalance:loanBalance?.dollarFormat(),totalEquity:totalEquity.dollarFormat(),depreciation:depreciation.dollarFormat(),loanInterest:loanInterest?.dollarFormat(),capRate:capRate,cashOnCash:cashOnCash,returnOnInvestment:roi,internalRateOfReturn:irr,rentToValue:rentToValue,grossRentMultiplier:grossRentMultiplier,debtCoverageRatio:debtCoverageRatio?.stringValue)
}

func calculateTotalCashFlowUpToYear(_ year:NSDecimalNumber,rentalWorksheet:RentalWorksheet)->NSDecimalNumber{
  var totalCashFlow = NSDecimalNumber.zero
  for i in 1...year.intValue{
    let cashFlow = calculateCashFlowForYear(NSDecimalNumber(value:i), rentalWorksheet: rentalWorksheet)
    totalCashFlow = totalCashFlow.adding(cashFlow.cashFlow)
  }
  return totalCashFlow
}
func calculateCashFlowForYear(_ year:NSDecimalNumber,rentalWorksheet:RentalWorksheet)->CashFlow{
  let income = calculateOperatingIncomeForYear(year, rentalWorksheet: rentalWorksheet)
  let expenses = calculateOperatingExpensesForYear(year, rentalWorksheet: rentalWorksheet)
  let netOperatingIncome = income.operatingIncome.subtracting(expenses.operatingExpenses)
  var loanPayment:NSDecimalNumber?
  var cashFlow = netOperatingIncome
  if rentalWorksheet.useFinancing{
    let amountFinanced = calculateAmountFinanced(rentalWorksheet)
    let wrappedIntoLoanPurchaseCosts = calculateWrapIntoLoanPurchaseCosts(rentalWorksheet)
    let loanAmount = amountFinanced!.adding(wrappedIntoLoanPurchaseCosts)
    var yearlyLoanPayment:NSDecimalNumber!
    if !rentalWorksheet.amortizing{
      yearlyLoanPayment = calculateLoanPaymentInterestOnlyForHoldingPeriod(NSDecimalNumber(value:12),amountFinanced:loanAmount,interestRate: rentalWorksheet.interestRate!)
      loanPayment = yearlyLoanPayment
    }else{
      yearlyLoanPayment = calculateLoanPaymentAmortizingForHoldingPeriod(loanAmount, annualInterestRate: rentalWorksheet.interestRate!, loanTerm: rentalWorksheet.amortizingFinancing!.loanTerm!,holdingPeriod: NSDecimalNumber(value:12))
      if rentalWorksheet.amortizingFinancing!.useMortgageInsurance{
        yearlyLoanPayment = yearlyLoanPayment!.adding(calculateMortgageInsuranceForHoldingPeriod( loanAmount, upfront: rentalWorksheet.amortizingFinancing!.mortgageInsurance!.upfront!, recurring: rentalWorksheet.amortizingFinancing!.mortgageInsurance!.recurring!,holdingPeriod: NSDecimalNumber(value:12),loanTerm: rentalWorksheet.amortizingFinancing!.loanTerm!,annualInterestRate:rentalWorksheet.interestRate!))
      }
      loanPayment = yearlyLoanPayment
      if year.compare(rentalWorksheet.amortizingFinancing!.loanTerm!) == ComparisonResult.orderedDescending{
        loanPayment = NSDecimalNumber.zero
      }
    }
    cashFlow = cashFlow.subtracting(loanPayment!)
  }
  return CashFlow(income: income, expenses: expenses, netOperatingIncome: netOperatingIncome, loanPayment: loanPayment, cashFlow: cashFlow)
}
func calculateOperatingIncomeForYear(_ year:NSDecimalNumber,rentalWorksheet:RentalWorksheet)->OperatingIncome{
  let grossRentPerMonth = calculateAppreciationOfValue(calculateGrossRentPerMonth(rentalWorksheet), percent: rentalWorksheet.incomeIncrease!, numberOfAppreciation: year.intValue - 1)
  let grossRentPerYear = grossRentPerMonth.multiplyingBy12()
  let vacancy = calculatePercentOfValue(rentalWorksheet.vacancy!, value: grossRentPerYear)
  var otherIncome:NSDecimalNumber? = rentalWorksheet.income!.itemized ? rentalWorksheet.income!.itemizedTotal! : rentalWorksheet.income!.total
  
  if otherIncome!.isGreaterThan(0){
    otherIncome = calculateAppreciationOfValue(otherIncome!.multiplyingBy12(), percent: rentalWorksheet.incomeIncrease!, numberOfAppreciation: year.intValue - 1)
  }
  let operatingIncome = grossRentPerYear.subtracting(vacancy).adding(otherIncome!)
  if otherIncome! == NSDecimalNumber.zero{
    otherIncome = nil
  }
  return OperatingIncome(grossRentPerMonth: grossRentPerMonth, grossRentPerYear: grossRentPerYear, vacancy: vacancy, otherIncome: otherIncome, operatingIncome: operatingIncome)
}
func calculateOperatingExpensesForYear(_ year:NSDecimalNumber,rentalWorksheet:RentalWorksheet)->OperatingExpenses{
  let grossRentPerMonth = calculateAppreciationOfValue(calculateGrossRentPerMonth(rentalWorksheet), percent: rentalWorksheet.incomeIncrease!, numberOfAppreciation: year.intValue - 1)
  let grossRent = grossRentPerMonth.multiplyingBy12()
  var itemizedExpenses:[SummaryProjectionItem] = []
  var totalExpenses:NSDecimalNumber?
  var operatingExpenses = NSDecimalNumber.zero
  if rentalWorksheet.expenses!.itemized,let fields = rentalWorksheet.expenses?.itemizedExpenses{
    for field in fields.array{
      guard let field = field as? ItemizedExpensesField else{
        continue
      }
      var amount = calculateItemizedExpensesPerMonth(field, rentalWorksheet: rentalWorksheet)
      amount = calculateAppreciationOfValue(amount.multiplyingBy12(), percent: rentalWorksheet.expensesIncrease!, numberOfAppreciation: year.intValue - 1)
      if amount.isGreaterThan(0){
        operatingExpenses = operatingExpenses.adding(amount)
        let item = SummaryProjectionItem(name: field.name!, text: amount.dollarFormat())
        itemizedExpenses.append(item)
      }
    }
  }else{
    totalExpenses = calculatePercentOfValue(rentalWorksheet.expenses!.total!, value: grossRent)
    operatingExpenses = totalExpenses!
  }
  return OperatingExpenses(items: itemizedExpenses, totalExpenses: totalExpenses, operatingExpenses: operatingExpenses)
}
func calculateAppreciationOfValue(_ value:NSDecimalNumber,percent:NSDecimalNumber,numberOfAppreciation:Int)->NSDecimalNumber{
  if numberOfAppreciation <= 0{
    return value
  }
  var finalValue = value
  for _ in 1...numberOfAppreciation{
    finalValue = finalValue.adding(finalValue.multiplying(by: percent.percentValue()))
  }
  return finalValue
}
