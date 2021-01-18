//
//  WorksheetModel.swift
//  FLPPD
//
//  Created by PC on 5/26/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import CoreData
enum EvalPropertyType:Int{
  case flip = 1
  case rental = 0
  var savedNotification:String{
    switch self{
    case .flip:
      return "flipPropertySaved"
    case .rental:
      return "rentalPropertySaved"
    }
  }
}
enum RentCollectionType{
  case daily
  case weekly
  case monthly
  var stringValue:String{
    switch self{
    case .daily:
      return "Daily"
    case .weekly:
      return "Weekly"
    case .monthly:
      return "Monthly"
    }
  }
  var coreDataValue:Int32{
    switch self{
    case .daily:
      return 0
    case .weekly:
      return 1
    case .monthly:
      return 2
    }
  }
  var placeholder:String{
    switch self{
    case .daily:
      return "$ Per Day"
    case .weekly:
      return "$ Per Week"
    case .monthly:
      return "$ Per Month"
    }
  }
  static let cases = [RentCollectionType.daily,RentCollectionType.weekly,RentCollectionType.monthly]
}
func generateDefaultFlipWorksheet(context:NSManagedObjectContext)->FlipWorksheet{
  let flipWorksheet = FlipWorksheet(context: context)
  setupDefaultWorksheet(flipWorksheet,context: context)
  flipWorksheet.amortizing = false
  flipWorksheet.downPayment = NSDecimalNumber(value: 25)
  flipWorksheet.interestRate = NSDecimalNumber(value: 12)
  let holdingCosts = HoldingCosts(context: context)
  let sellingCosts = SellingCosts(context: context)
  let itemizedHoldingCostsField1 = ItemizedHoldingCostsField(context: context)
  let itemizedHoldingCostsField2 = ItemizedHoldingCostsField(context: context)
  let itemizedHoldingCostsField3 = ItemizedHoldingCostsField(context: context)
  let itemizedHoldingCostsField4 = ItemizedHoldingCostsField(context: context)
  itemizedHoldingCostsField1.name = "Property Taxes"
  itemizedHoldingCostsField2.name = "Insurance"
  itemizedHoldingCostsField3.name = "Utilities"
  itemizedHoldingCostsField4.name = "Landscaping"
  itemizedHoldingCostsField1.characteristic2 = HoldingCostsCharacteristic2.PerYear.number
  itemizedHoldingCostsField2.characteristic2 = HoldingCostsCharacteristic2.PerYear.number
  holdingCosts.addToItemizedHoldingCosts([itemizedHoldingCostsField1,itemizedHoldingCostsField2,itemizedHoldingCostsField3,itemizedHoldingCostsField4])
  let itemizedSellingCostsField1 = ItemizedSellingCostsField(context: context)
  let itemizedSellingCostsField2 = ItemizedSellingCostsField(context: context)
  let itemizedSellingCostsField3 = ItemizedSellingCostsField(context: context)
  itemizedSellingCostsField1.name = "Agent Commissions"
  itemizedSellingCostsField2.name = "Home Warranty"
  itemizedSellingCostsField3.name = "Title Insurance"
  itemizedSellingCostsField1.isSetAmount = false
  itemizedSellingCostsField1.characteristic1 = 1
  sellingCosts.addToItemizedSellingCosts([itemizedSellingCostsField1,itemizedSellingCostsField2,itemizedSellingCostsField3])
  flipWorksheet.holdingCosts = holdingCosts
  flipWorksheet.sellingCosts = sellingCosts
  return flipWorksheet
}

func generateDefaultRentalWorksheet(context:NSManagedObjectContext)->RentalWorksheet{
  let rentalWorksheet = RentalWorksheet(context:context)
  setupDefaultWorksheet(rentalWorksheet,context: context)
  let income = Income(context: context)
  let expenses = Expenses(context: context)
  let itemizedIncomeField1 = ItemizedIncomeField(context: context)
  let itemizedIncomeField2 = ItemizedIncomeField(context: context)
  let itemizedIncomeField3 = ItemizedIncomeField(context: context)
  itemizedIncomeField1.name = "Parking"
  itemizedIncomeField2.name = "Laundry"
  itemizedIncomeField3.name = "Storage Rental"
  itemizedIncomeField3.characteristic1 = IncomeCharacteristic1.PerYear.number
  income.addToItemizedIncome([itemizedIncomeField1,itemizedIncomeField2,itemizedIncomeField3])
  let itemizedExpensesField1 = ItemizedExpensesField(context: context)
  let itemizedExpensesField2 = ItemizedExpensesField(context: context)
  let itemizedExpensesField3 = ItemizedExpensesField(context: context)
  let itemizedExpensesField4 = ItemizedExpensesField(context: context)
  let itemizedExpensesField5 = ItemizedExpensesField(context: context)
  let itemizedExpensesField6 = ItemizedExpensesField(context: context)
  itemizedExpensesField1.name = "Property Taxes"
  itemizedExpensesField2.name = "Insurance"
  itemizedExpensesField3.name = "Property Management"
  itemizedExpensesField4.name = "Maintenance"
  itemizedExpensesField5.name = "Capital Expenditures"
  itemizedExpensesField6.name = "Landscaping"
  itemizedExpensesField1.characteristic4 = ExpensesCharacteristic4.PerYear.number
  itemizedExpensesField2.characteristic4 = ExpensesCharacteristic4.PerYear.number
  itemizedExpensesField3.characteristic1 = ExpensesCharacteristic1.Percent.number
  itemizedExpensesField3.characteristic3 = ExpensesCharacteristic3.WithVacancy.number
  itemizedExpensesField4.characteristic1 = ExpensesCharacteristic1.Percent.number
  itemizedExpensesField5.characteristic1 = ExpensesCharacteristic1.Percent.number
  itemizedExpensesField3.percentValue = NSDecimalNumber(value: 10)
  itemizedExpensesField4.percentValue = NSDecimalNumber(value: 10)
  itemizedExpensesField5.percentValue = NSDecimalNumber(value: 10)
  itemizedExpensesField3.isSetAmount = false
  itemizedExpensesField4.isSetAmount = false
  itemizedExpensesField5.isSetAmount = false
  expenses.addToItemizedExpenses([itemizedExpensesField1,itemizedExpensesField2,itemizedExpensesField3,itemizedExpensesField4,itemizedExpensesField5,itemizedExpensesField6])
  rentalWorksheet.income = income
  rentalWorksheet.expenses = expenses
  return rentalWorksheet
}

func setupDefaultWorksheet(_ defaultWorksheet:Worksheet,context:NSManagedObjectContext){
  let amortizingFinancing = AmortizingFinancing(context: context)
  let purchaseCosts = PurchaseCosts(context: context)
  let rehabCosts = RehabCosts(context: context)
  amortizingFinancing.mortgageInsurance = MortgageInsurance(context:context)
  defaultWorksheet.amortizingFinancing = amortizingFinancing
  //MARK:Default purchase costs
  let itemizedPurchaseCostsField1 = ItemizedPurchaseCostsField(context: context)
  let itemizedPurchaseCostsField2 = ItemizedPurchaseCostsField(context: context)
  let itemizedPurchaseCostsField3 = ItemizedPurchaseCostsField(context: context)
  itemizedPurchaseCostsField1.name = "Home Inspection"
  itemizedPurchaseCostsField2.name = "Appraisal"
  itemizedPurchaseCostsField3.name = "Closing Costs"
  itemizedPurchaseCostsField3.characteristic1 = PurchaseCostsCharacteristic1.Percent.number
  itemizedPurchaseCostsField3.characteristic2 = PurchaseCostsCharacteristic2.OfLoan.number
  itemizedPurchaseCostsField3.isSetAmount = false
  purchaseCosts.addToItemizedPurchaseCosts([itemizedPurchaseCostsField1,itemizedPurchaseCostsField2,itemizedPurchaseCostsField3])
  //MARK:Default rehab costs
  let itemizedRehabCostsField1 = ItemizedRehabCostsField(context: context)
  let itemizedRehabCostsField2 = ItemizedRehabCostsField(context: context)
  let itemizedRehabCostsField3 = ItemizedRehabCostsField(context: context)
  let itemizedRehabCostsField4 = ItemizedRehabCostsField(context: context)
  let itemizedRehabCostsField5 = ItemizedRehabCostsField(context: context)
  let itemizedRehabCostsField6 = ItemizedRehabCostsField(context: context)
  itemizedRehabCostsField1.name = "Exterior"
  itemizedRehabCostsField2.name = "Interior"
  itemizedRehabCostsField3.name = "Electrical"
  itemizedRehabCostsField4.name = "Plumbing"
  itemizedRehabCostsField5.name = "Appliances"
  itemizedRehabCostsField6.name = "Landscaping"
  rehabCosts.addToItemizedRehabCosts([itemizedRehabCostsField1,itemizedRehabCostsField2,itemizedRehabCostsField3,itemizedRehabCostsField4,itemizedRehabCostsField5,itemizedRehabCostsField6])
  defaultWorksheet.purchaseCosts = purchaseCosts
  defaultWorksheet.rehabCosts = rehabCosts
}

func calculateItemizedExpensesTotal(_ worksheet:RentalWorksheet){
  guard let fields = worksheet.expenses?.itemizedExpenses else{
    return
  }
  var total = NSDecimalNumber.zero
  for field in fields.array{
    guard let field = field as? ItemizedExpensesField else{
      continue
    }
    total = total.adding(calculateItemizedExpensesPerMonth(field, rentalWorksheet: worksheet))
  }
  worksheet.expenses?.itemizedTotal = total
}
func calculateItemizedExpensesPerMonth(_ field:ItemizedExpensesField,rentalWorksheet:RentalWorksheet)->NSDecimalNumber{
  if field.isSetAmount{
    return field.characteristic4 == ExpensesCharacteristic4.PerMonth.number ? field.setAmount! : field.setAmount!.dividingBy12()
  }else if field.characteristic2 == ExpensesCharacteristic2.OfPrice.number{
    let amountPerYear = calculatePercentOfValue(field.percentValue!, value: rentalWorksheet.purchasePrice!)
    return amountPerYear.dividingBy12()
  }else{
    guard field.percentValue!.isGreaterThan(0),rentalWorksheet.grossRent!.isGreaterThan(0) else{
      return NSDecimalNumber.zero
    }
    let monthlyAmount = calculateGrossRentPerMonth(rentalWorksheet).multiplying(by: field.percentValue!.percentValue())
    let vacancyCost = field.characteristic3 == ExpensesCharacteristic3.WithVacancy.number ? rentalWorksheet.vacancy!.percentValue().multiplying(by: monthlyAmount) : NSDecimalNumber.zero
    return monthlyAmount.subtracting(vacancyCost)
  }
}
func calculateItemizedPurchaseCostsTotal(_ worksheet:Worksheet){
  guard let fields = worksheet.purchaseCosts?.itemizedPurchaseCosts else{
    return
  }
  var total = NSDecimalNumber.zero
  for field in fields.array{
    guard let field = field as? ItemizedPurchaseCostsField else{
      continue
    }
    total = total.adding(calculateItemizedPurchaseCostsFieldDollarAmount(field, worksheet: worksheet))
  }
  worksheet.purchaseCosts?.itemizedTotal = total
}
func calculateItemizedPurchaseCostsFieldDollarAmount(_ field:ItemizedPurchaseCostsField,worksheet:Worksheet)->NSDecimalNumber{
  if field.isSetAmount{
    return field.setAmount!
  }else if field.characteristic2 == PurchaseCostsCharacteristic2.OfPrice.number{
    return calculatePercentOfValue(field.percentValue!, value:worksheet.purchasePrice!)
  }else{
    guard field.percentValue!.isGreaterThan(0) else{
      return NSDecimalNumber.zero
    }
    if let flipWorksheet = worksheet as? FlipWorksheet,let amountFinanced = calculateAmountFinanced(flipWorksheet) {
      return calculatePercentOfValue(field.percentValue!, value:amountFinanced)
    }else if let rentalWorksheet = worksheet as? RentalWorksheet,let amountFinanced = calculateAmountFinanced(rentalWorksheet){
      return calculatePercentOfValue(field.percentValue!, value:amountFinanced)
    }
    return NSDecimalNumber.zero
  }
}
func calculateItemizedSellingCostsTotal(_ worksheet:FlipWorksheet){
  guard let fields = worksheet.sellingCosts?.itemizedSellingCosts else{
    return
  }
  var total = NSDecimalNumber.zero
  for field in fields.array{
    guard let field = field as? ItemizedSellingCostsField else{
      continue
    }
    total = total.adding(calculateItemizedSellingCosts(field, flipWorksheet: worksheet))
  }
  worksheet.sellingCosts?.itemizedTotal = total
}
func calculateItemizedSellingCosts(_ field:ItemizedSellingCostsField,flipWorksheet:FlipWorksheet)->NSDecimalNumber{
  if field.isSetAmount{
    return field.setAmount!
  }else{
    let amount = calculatePercentOfValue(field.percentValue!, value: flipWorksheet.afterRepairValue!)
    return amount
  }
}
func calculateItemizeHoldingCostsTotal(_ worksheet:FlipWorksheet){
  guard let fields = worksheet.holdingCosts?.itemizedHoldingCosts else{
    return
  }
  var total = NSDecimalNumber.zero
  for field in fields.array{
    guard let field = field as? ItemizedHoldingCostsField else{
      continue
    }
    if field.isSetAmount{
      if field.characteristic2 == HoldingCostsCharacteristic2.PerMonth.number{
        total = total.adding(field.setAmount!)
      }else{
        total = total.adding(field.setAmount!.dividingBy12())
      }
    }else{
      let amount = calculatePercentOfValue(field.percentValue!, value: worksheet.purchasePrice!).dividingBy12()
      total = total.adding(amount)
    }
  }
  worksheet.holdingCosts?.itemizedTotal = total
}
