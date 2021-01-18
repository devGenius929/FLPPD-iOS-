//
//  Report+Rental.swift
//  FLPPD
//
//  Created by PC on 8/11/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
enum RentalReportHtml{
  case amountFinanced
  case downPayment
  case purchaseCosts
  case rehabCosts
  case totalCashNeeded
  case pricePerSquareFoot
  case capRate
  case cashOnCash
  case returnOnInvestment
  case internalRateOfReturn
  case rentToValue
  case grossRentMultiplier
  case debtCoverageRatio
  case vacancy
  case rentCollection
  case appreciation
  case incomeIncrease
  case expensesIncrease
  case sellingCosts
  case landValue
  //page 4
  case grossRent
  case vacancyOp
  case otherIncome
  case operatingIncome
  case operatingExpenses
  case netOperatingIncome
  case loanPaymentOp
  case cashFlow
  
  var title:String{
    switch self{
    case .amountFinanced:
      return "Amount Financed:"
    case .downPayment:
      return "Down Payment:"
    case .purchaseCosts:
      return "Purchase Costs:"
    case .rehabCosts:
      return "Rehab Costs:"
    case .totalCashNeeded:
      return "Total Cash Needed:"
    case .pricePerSquareFoot:
      return "Price Per Square Foot:"
    case .capRate:
      return "Cap Rate:"
    case .cashOnCash:
      return "Cash on Cash:"
    case .returnOnInvestment:
      return "Return on Investment:"
    case .internalRateOfReturn:
      return "Internal Rate of Return:"
    case .rentToValue:
      return "Rent to Value:"
    case .grossRentMultiplier:
      return "Gross Rent Multiplier:"
    case .debtCoverageRatio:
      return "Debt Coverage Ratio:"
    case .vacancy:
      return "Vacancy:"
    case .rentCollection:
      return "Rent Collection:"
    case .appreciation:
      return "Appreciation:"
    case .incomeIncrease:
      return "Income Increase:"
    case .expensesIncrease:
      return "Expenses Increase:"
    case .sellingCosts:
      return "Selling Costs:"
    case .landValue:
      return "Land Value:"
    case .grossRent:
      return "Gross Rent:"
    case .vacancyOp:
      return "Vacancy"
    case .otherIncome:
      return "Other Income:"
    case .operatingIncome:
      return "Operating Income:"
    case .operatingExpenses:
      return "Operating Expenses"
    case .netOperatingIncome:
      return "Net Operating Income:"
    case .loanPaymentOp:
      return "Loan Payment:"
    case .cashFlow:
      return "Cash Flow:"
    }
  }
  var sign:String{
    switch self{
    case .amountFinanced:
      return "-"
    case .downPayment:
      return "="
    case .purchaseCosts:
      return "+"
    case .rehabCosts:
      return "+"
    case .totalCashNeeded:
      return "="
    case .vacancyOp:
      return "-"
    case .otherIncome:
      return "+"
    case .operatingIncome:
      return "="
    case .operatingExpenses:
      return "-"
    case .netOperatingIncome:
      return "="
    case .loanPaymentOp:
      return "-"
    case .cashFlow:
      return "="
    default:
      return ""
    }
  }
  var rowType:String{
    switch self{
    case .downPayment:
      return RowHtml.blueRowWithTopBorder
    case .totalCashNeeded:
      return RowHtml.blueRowWithTopBorder
    case .vacancy:
      return RowHtml.rowWithNoSign
    case .rentCollection:
      return RowHtml.rowWithNoSign
    case .appreciation:
      return RowHtml.rowWithNoSign
    case .incomeIncrease:
      return RowHtml.rowWithNoSign
    case .expensesIncrease:
      return RowHtml.rowWithNoSign
    case .sellingCosts:
      return RowHtml.rowWithNoSign
    case .landValue:
      return RowHtml.rowWithNoSign
    case .grossRent:
      return RowHtml.doubleColumn
    case .vacancyOp:
      return RowHtml.doubleColumn
    case .otherIncome:
      return RowHtml.doubleColumn
    case .operatingIncome:
      return RowHtml.doubleColumnBlueWithTopBorder
    case .operatingExpenses:
      return RowHtml.doubleColumn
    case .netOperatingIncome:
      return RowHtml.doubleColumnBlueWithTopBorder
    case .loanPaymentOp:
      return RowHtml.doubleColumn
    case .cashFlow:
      return RowHtml.doubleColumn
    default:
      return RowHtml.regularRow
    }
  }
  var placeholder:String{
    switch self{
    case .amountFinanced:
      return "#AMOUNT FINANCED#"
    case .downPayment:
      return "#DOWN PAYMENT#"
    case .purchaseCosts:
      return "#PURCHASE COSTS#"
    case .rehabCosts:
      return "#REHAB COSTS#"
    case .totalCashNeeded:
      return "#TOTAL CASH NEEDED#"
    case .pricePerSquareFoot:
      return "#PRICE PER SQUARE FOOT#"
    case .capRate:
      return "#CAP RATE#"
    case .cashOnCash:
      return "#CASH ON CASH#"
    case .returnOnInvestment:
      return "#RETURN ON INVESTMENT#"
    case .internalRateOfReturn:
      return "#INTERNAL RATE OF RETURN#"
    case .rentToValue:
      return "#RENT TO VALUE#"
    case .grossRentMultiplier:
      return "#GROSS RENT MULTIPLIER#"
    case .debtCoverageRatio:
      return "#DEBT COVERAGE RATIO#"
    case .vacancy:
      return "#VACANCY#"
    case .rentCollection:
      return "#RENT COLLECTION#"
    case .appreciation:
      return "#APPRECIATION#"
    case .incomeIncrease:
      return "#INCOME INCREASE#"
    case .expensesIncrease:
      return "#EXPENSES INCREASE#"
    case .sellingCosts:
      return "#SELLING COSTS#"
    case .landValue:
      return "#LAND VALUE#"
    case .grossRent:
      return "#GROSS RENT#"
    case .vacancyOp:
      return "#VACANCY OP#"
    case .otherIncome:
      return "#OTHER INCOME#"
    case .operatingIncome:
      return "#OPERATING INCOME#"
    case .operatingExpenses:
      return "#OPERATING EXPENSES#"
    case .netOperatingIncome:
      return "#NET OPERATING INCOME#"
    case .loanPaymentOp:
      return "#LOAN PAYMENT OP#"
    case .cashFlow:
      return "#CASH FLOW#"
    }
  }
  
  static let cases:[RentalReportHtml] = [.amountFinanced,.downPayment,.purchaseCosts,.rehabCosts,.totalCashNeeded,.pricePerSquareFoot,.capRate,.cashOnCash,.returnOnInvestment,.internalRateOfReturn,.rentToValue,.grossRentMultiplier,.debtCoverageRatio,.vacancy,.rentCollection,.appreciation,.incomeIncrease,.expensesIncrease,.sellingCosts,.landValue,.grossRent,.vacancyOp,.otherIncome,.operatingIncome,.operatingExpenses,.netOperatingIncome,.loanPaymentOp,.cashFlow]
}

func fillRentalReport(_ html:String,rentalWorksheet:RentalWorksheet,monthlyViewModel:RentalSummaryAnalysisViewModel,yearlyViewModel:RentalSummaryAnalysisViewModel,field:RentalReportHtml)->String{
  let value:String?
  var secondValue:String? = ""
  var title = field.title
  switch field{
  case .amountFinanced:
    value = monthlyViewModel.amountFinanced
  case .downPayment:
    value = monthlyViewModel.downPayment
  case .purchaseCosts:
    value = monthlyViewModel.purchaseCosts
  case .rehabCosts:
    value = monthlyViewModel.rehabCosts
  case .totalCashNeeded:
    value = monthlyViewModel.totalCashNeeded
  case .pricePerSquareFoot:
    value = monthlyViewModel.pricePerSquareFoot
  case .capRate:
    value = monthlyViewModel.capRate
  case .cashOnCash:
    value = monthlyViewModel.cashOnCash
  case .returnOnInvestment:
    value = monthlyViewModel.returnOnInvestment
  case .internalRateOfReturn:
    value = monthlyViewModel.internalRateOfReturn
  case .rentToValue:
    value = monthlyViewModel.rentToValue
  case .grossRentMultiplier:
    value = monthlyViewModel.grossRentMultiplier
  case .debtCoverageRatio:
    value = monthlyViewModel.debtCoverageRatio
  case .vacancy:
    value = rentalWorksheet.vacancy!.stringValue + "%"
  case .rentCollection:
    var collectionType = ""
    for type in RentCollectionType.cases{
      if rentalWorksheet.rentCollection == type.coreDataValue{
        collectionType = type.stringValue
      }
    }
    value = collectionType
  case .appreciation:
    value = rentalWorksheet.appreciation!.stringValue + "% Per Year"
  case .incomeIncrease:
    value = rentalWorksheet.incomeIncrease!.stringValue + "% Per Year"
  case .expensesIncrease:
    value = rentalWorksheet.expensesIncrease!.stringValue + "% Per Year"
  case .sellingCosts:
    value = rentalWorksheet.sellingCosts!.stringValue + "% of Sales Price"
  case .landValue:
    value = rentalWorksheet.landValue!.dollarFormat()
  case .grossRent:
    value = monthlyViewModel.grossRent
    secondValue = yearlyViewModel.grossRent
  case .vacancyOp:
    title += monthlyViewModel.vacancyPercentage == nil ? ":" : " (" + monthlyViewModel.vacancyPercentage! + "):"
    value = monthlyViewModel.vacancy
    secondValue = yearlyViewModel.vacancy
  case .otherIncome:
    value = monthlyViewModel.otherIncome
    secondValue = yearlyViewModel.otherIncome
  case .operatingIncome:
    value = monthlyViewModel.operatingIncome
    secondValue = yearlyViewModel.operatingIncome
  case .operatingExpenses:
    title += monthlyViewModel.operatingExpensesPercentage == nil ? ":" : " (" + monthlyViewModel.operatingExpensesPercentage! + "):"
    value = monthlyViewModel.operatingExpenses
    secondValue = yearlyViewModel.operatingExpenses
  case .netOperatingIncome:
    value = monthlyViewModel.netOperatingIncome
    secondValue = yearlyViewModel.netOperatingIncome
  case .loanPaymentOp:
    value = monthlyViewModel.loanPayments
    secondValue = yearlyViewModel.loanPayments
  case .cashFlow:
    value = monthlyViewModel.cashFlow
    secondValue = yearlyViewModel.cashFlow
  }
  guard let unwrappedValue = value else{
    return html.replacingOccurrences(of: field.placeholder, with: "")
  }
  var insertHtml = field.rowType.replacingOccurrences(of: HtmlPlaceholder.title, with: title).replacingOccurrences(of: HtmlPlaceholder.sign, with: field.sign).replacingOccurrences(of: HtmlPlaceholder.value, with: unwrappedValue)
  if let secondValue = secondValue{
    insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value2, with: secondValue)
  }
  return html.replacingOccurrences(of: field.placeholder, with: insertHtml)
}

enum RentalFinancingHtml{
  case loanType
  case loanAmount
  case loanToValue
  case loanTerm
  case interestRate
  case mortgageInsurance
  case loanPayment
  
  
  var title:String{
    switch self{
    case .loanType:
      return "Loan Type:"
    case .loanAmount:
      return "Loan Amount:"
    case .loanToValue:
      return "Loan to Value:"
    case .loanTerm:
      return "Loan Term:"
    case .interestRate:
      return "Interest Rate:"
    case .mortgageInsurance:
      return "Mortgage Insurance:"
    case .loanPayment:
      return "Loan Payment:"
    }
  }
  var rowType:String{
    switch self{
    case .mortgageInsurance:
      return RowHtml.doubleRow
    case .loanPayment:
      return RowHtml.doubleRow
    default:
      return RowHtml.rowWithNoSign
    }
  }
  var placeholder:String{
    switch self{
    case .loanType:
      return "#LOAN TYPE#"
    case .loanAmount:
      return "#LOAN AMOUNT#"
    case .loanToValue:
      return "#LOAN TO VALUE#"
    case .loanTerm:
      return "#LOAN TERM#"
    case .interestRate:
      return "#INTEREST RATE#"
    case .mortgageInsurance:
      return "#PMI#"
    case .loanPayment:
      return "#LOAN PAYMENT#"
    }
  }
  
  static let cases:[RentalFinancingHtml] = [.loanType,.loanAmount,.loanToValue,.loanTerm,.interestRate,.mortgageInsurance,.loanPayment]
  
}
func fillRentalFinancing(_ html:String,rentalWorksheet:RentalWorksheet,monthlyViewModel:RentalSummaryAnalysisViewModel,yearlyViewModel:RentalSummaryAnalysisViewModel,field:RentalFinancingHtml)->String{
  let value:String?
  let secondValue:String?
  
  switch field{
  case .loanType:
    value = rentalWorksheet.amortizing ? "Amortizing" : "Interest Only"
    secondValue = nil
  case .loanAmount:
    value = calculateAmountFinanced(rentalWorksheet)?.adding(calculateWrapIntoLoanPurchaseCosts(rentalWorksheet)).dollarFormat()
    secondValue = nil
  case .loanToValue:
    value = monthlyViewModel.ltv
    secondValue = nil
  case .loanTerm:
    value = rentalWorksheet.amortizing ? rentalWorksheet.amortizingFinancing!.loanTerm!.stringValue + " Years" : nil
    secondValue = nil
  case .interestRate:
    value = rentalWorksheet.interestRate!.stringValue + " %"
    secondValue = nil
  case .mortgageInsurance:
    if rentalWorksheet.amortizing,rentalWorksheet.amortizingFinancing!.useMortgageInsurance,let recurring = rentalWorksheet.amortizingFinancing?.mortgageInsurance?.recurring,let upfront = rentalWorksheet.amortizingFinancing?.mortgageInsurance?.upfront,upfront != NSDecimalNumber.zero || recurring != NSDecimalNumber.zero {
      value = upfront.stringValue + "% Upfront"
      secondValue = recurring.stringValue + "% Per Year"
    }else{
      value = nil
      secondValue = nil
    }
  case .loanPayment:
    value = monthlyViewModel.loanPayments
    secondValue = yearlyViewModel.loanPayments
  }
  guard let unwrappedValue = value else{
    return html.replacingOccurrences(of: field.placeholder, with: "")
  }
  guard let unwrappedSecondValue = secondValue else{
    let insertHtml = field.rowType.replacingOccurrences(of: HtmlPlaceholder.title, with: field.title).replacingOccurrences(of: HtmlPlaceholder.value, with: unwrappedValue)
    return html.replacingOccurrences(of: field.placeholder, with: insertHtml)
  }
  let insertHtml = field.rowType.replacingOccurrences(of: HtmlPlaceholder.title, with: field.title).replacingOccurrences(of: HtmlPlaceholder.value, with: unwrappedValue).replacingOccurrences(of: HtmlPlaceholder.value2, with: unwrappedSecondValue)
  return html.replacingOccurrences(of: field.placeholder, with: insertHtml)
}
