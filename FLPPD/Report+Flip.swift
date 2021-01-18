//
//  Report+Flip.swift
//  FLPPD
//
//  Created by PC on 8/11/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
enum FlipReportHtml{
  case financedRehabCosts
  case amountFinanced
  case downPayment
  case purchaseCosts
  case rehabCosts
  case totalCashNeeded
  case pricePerSquareFoot
  case holdingPeriod
  case rehabCostOverrun
  case rehabCostFinancing
  case afterRepairValue
  case sellingCosts
  case saleProceeds
  case loanRepayment
  case holdingCosts
  case investedCash
  case totalProfit
  case returnOnInvestment
  case annualizedROI
  
  var title:String{
    switch self{
    case .financedRehabCosts:
      return "Financed Rehab Costs:"
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
    case .holdingPeriod:
      return "Holding Period:"
    case .rehabCostOverrun:
      return "Rehab Cost Overrun:"
    case .rehabCostFinancing:
      return "Rehab Cost Financing:"
    case .afterRepairValue:
      return "After Repair Value:"
    case .sellingCosts:
      return "Selling Costs:"
    case .saleProceeds:
      return "Sale Proceeds:"
    case .loanRepayment:
      return "Loan Repayment:"
    case .holdingCosts:
      return "Holding Costs:"
    case .investedCash:
      return "Invested Cash:"
    case .totalProfit:
      return "Total Profit:"
    case .returnOnInvestment:
      return "Return on Investment:"
    case .annualizedROI:
      return "Annualized ROI:"
    }
  }
  var sign:String{
    switch self{
    case .financedRehabCosts:
      return "+"
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
    case .sellingCosts:
      return "-"
    case .saleProceeds:
      return "="
    case .loanRepayment:
      return "-"
    case .holdingCosts:
      return "-"
    case .investedCash:
      return "-"
    case .totalProfit:
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
    case .saleProceeds:
      return RowHtml.blueRowWithTopBorder
    case .totalProfit:
      return RowHtml.blueRowWithTopBorder
    default:
      return RowHtml.regularRow
    }
  }
  var placeholder:String{
    switch self{
    case .financedRehabCosts:
      return "#FINANCED REHAB COSTS#"
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
    case .holdingPeriod:
      return "#HOLDING PERIOD#"
    case .rehabCostOverrun:
      return "#REHAB COST OVERRUN#"
    case .rehabCostFinancing:
      return "#REHAB COST FINANCING#"
    case .afterRepairValue:
      return "#AFTER REPAIR VALUE#"
    case .sellingCosts:
      return "#SELLING COSTS#"
    case .saleProceeds:
      return "#SALE PROCEEDS#"
    case .loanRepayment:
      return "#LOAN REPAYMENT#"
    case .holdingCosts:
      return "#HOLDING COSTS#"
    case .investedCash:
      return "#INVESTED CASH#"
    case .totalProfit:
      return "#TOTAL PROFIT#"
    case .returnOnInvestment:
      return "#RETURN ON INVESTMENT#"
    case .annualizedROI:
      return "#ANNUALIZED ROI#"
    }
  }
  
  static let cases:[FlipReportHtml] = [.financedRehabCosts,.amountFinanced,.downPayment,.purchaseCosts,.rehabCosts,.totalCashNeeded,.pricePerSquareFoot,.holdingPeriod,.rehabCostOverrun,.rehabCostFinancing,.afterRepairValue,.sellingCosts,.saleProceeds,.loanRepayment,.holdingCosts,.investedCash,.totalProfit,.returnOnInvestment,.annualizedROI]
}

func fillFlipReport(_ html:String,flipWorksheet:FlipWorksheet,viewModel:FlipSummaryAnalysisViewModel,field:FlipReportHtml)->String{
  let value:String?
  switch field{
  case .financedRehabCosts:
    value = viewModel.financedRehabCosts
  case .amountFinanced:
    value = viewModel.amountFinanced
  case .downPayment:
    value = viewModel.downPayment
  case .purchaseCosts:
    value = viewModel.purchaseCosts
  case .rehabCosts:
    value = viewModel.rehabCosts
  case .totalCashNeeded:
    value = viewModel.totalCashNeeded
  case .pricePerSquareFoot:
    value = viewModel.pricePerSquareFoot
  case .holdingPeriod:
    value = flipWorksheet.holdingPeriod!.isGreaterThan(1) ? flipWorksheet.holdingPeriod!.decimalFormat() + " Months" : flipWorksheet.holdingPeriod!.decimalFormat() + " Month"
  case .rehabCostOverrun:
    value = flipWorksheet.costOverrun!.decimalFormat() + "%"
  case .rehabCostFinancing:
    if flipWorksheet.financeRehabCosts,flipWorksheet.percentageToFinance!.isGreaterThan(0){
      value = "Yes (" + flipWorksheet.percentageToFinance!.decimalFormat() + "%)"
    }else{
      value = "No"
    }
  case .afterRepairValue:
    value = viewModel.afterRepairValue
  case .sellingCosts:
    value = viewModel.sellingCosts
  case .saleProceeds:
    value = viewModel.saleProceeds
  case .loanRepayment:
    value = viewModel.loanRepayment
  case .holdingCosts:
    value = viewModel.holdingCosts
  case .investedCash:
    value = viewModel.investedCash
  case .totalProfit:
    value = viewModel.totalProfit
  case .returnOnInvestment:
    value = viewModel.roi
  case .annualizedROI:
    value = viewModel.annualizedROI
  }
  guard let unwrappedValue = value else{
    return html.replacingOccurrences(of: field.placeholder, with: "")
  }
  let insertHtml = field.rowType.replacingOccurrences(of: HtmlPlaceholder.title, with: field.title).replacingOccurrences(of: HtmlPlaceholder.sign, with: field.sign).replacingOccurrences(of: HtmlPlaceholder.value, with: unwrappedValue)
  return html.replacingOccurrences(of: field.placeholder, with: insertHtml)
}

enum FlipFinancingHtml{
  case loanType
  case loanAmount
  case loanToCost
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
    case .loanToCost:
      return "Loan to Cost:"
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
    case .loanToCost:
      return "#LOAN TO COST#"
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
  
  static let cases:[FlipFinancingHtml] = [.loanType,.loanAmount,.loanToCost,.loanTerm,.interestRate,.mortgageInsurance,.loanPayment]
  
}
func fillFlipFinancing(_ html:String,flipWorksheet:FlipWorksheet,monthlyViewModel:FlipSummaryAnalysisViewModel,field:FlipFinancingHtml)->String{
  
  let value:String?
  let secondValue:String?
  
  switch field{
  case .loanType:
    value = flipWorksheet.amortizing ? "Amortizing" : "Interest Only"
    secondValue = nil
  case .loanAmount:
    value = calculateAmountFinanced(flipWorksheet)?.adding(calculateWrapIntoLoanPurchaseCosts(flipWorksheet)).dollarFormat()
    secondValue = nil
  case .loanToCost:
    value = monthlyViewModel.ltc
    secondValue = nil
  case .loanTerm:
    value = flipWorksheet.amortizing ? flipWorksheet.amortizingFinancing!.loanTerm!.stringValue + " Years" : nil
    secondValue = nil
  case .interestRate:
    value = flipWorksheet.interestRate!.stringValue + " %"
    secondValue = nil
  case .mortgageInsurance:
    if flipWorksheet.amortizing,flipWorksheet.amortizingFinancing!.useMortgageInsurance,let recurring = flipWorksheet.amortizingFinancing?.mortgageInsurance?.recurring,let upfront = flipWorksheet.amortizingFinancing?.mortgageInsurance?.upfront,upfront != NSDecimalNumber.zero || recurring != NSDecimalNumber.zero {
      value = upfront.stringValue + "% Upfront"
      secondValue = recurring.stringValue + "% Per Year"
    }else{
      value = nil
      secondValue = nil
    }
  case .loanPayment:
    value = monthlyViewModel.loanPayment != nil ? monthlyViewModel.loanPayment! + " Per Month" : nil
    secondValue = nil
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
