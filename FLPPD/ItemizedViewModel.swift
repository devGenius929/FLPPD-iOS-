//
//  ItemizedViewModel.swift
//  FLPPD
//
//  Created by PC on 5/30/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

enum Characteristic{
  case SetAmount
  case Percent
  case OfPrice
  case OfLoan
  case OfRent
  case PayUpfront
  case WrapIntoLoan
  case PerMonth
  case PerYear
  case WithoutVacancy
  case WithVacancy
  var placeHolder:String{
    switch self{
    case .SetAmount:
      return "$"
    case .Percent:
      return "%"
    case .OfPrice:
      return "of Price"
    case .OfLoan:
      return "of Loan"
    case .OfRent:
      return "of Rent"
    case .PayUpfront:
      return "Pay Upfront"
    case .WrapIntoLoan:
      return "Wrap into Loan"
    case .PerMonth:
      return "Per Month"
    case .PerYear:
      return "Per Year"
    case .WithoutVacancy:
      return "Without Vacancy"
    case .WithVacancy:
      return "With Vacancy"
    }
  }
  var title:String{
    switch self{
    case .SetAmount:
      return "Set Amount"
    case .Percent:
      return "Percent"
    case .OfPrice:
      return "Of Price"
    case .OfLoan:
      return "Of Loan"
    case .OfRent:
      return "Of Rent"
    case .PayUpfront:
      return "Pay Upfront"
    case .WrapIntoLoan:
      return "Wrap into Loan"
    case .PerMonth:
      return "Per Month"
    case .PerYear:
      return "Per Year"
    case .WithoutVacancy:
      return "Without Vacancy"
    case .WithVacancy:
      return "With Vacancy"
    }
  }
}
enum PurchaseCostsCharacteristic1{
  case SetAmount
  case Percent

  var number:Int32{
    switch self{
    case .SetAmount:
      return 0
    case .Percent:
      return 1
    }
  }
  var characteristic:Characteristic{
    switch self{
    case .SetAmount:
      return .SetAmount
    case .Percent:
      return .Percent
    }
  }
  var keyboardType:TextFieldValueType{
    switch self{
    case .SetAmount:
      return .SetAmount
    case .Percent:
      return .Percent
    }
  }
}
enum PurchaseCostsCharacteristic2{
  case OfPrice
  case OfLoan
  
  var number:Int32{
    switch self{
    case .OfPrice:
      return 0
    case .OfLoan:
      return 1
    }
  }
  var characteristic:Characteristic{
    switch self{
    case .OfPrice:
      return .OfPrice
    case .OfLoan:
      return .OfLoan
    }
  }
}
enum PurchaseCostsCharacteristic3{
  case PayUpfront
  case WrapIntoLoan
  
  var number:Int32{
    switch self{
    case .PayUpfront:
      return 0
    case .WrapIntoLoan:
      return 1
    }
  }
  var characteristic:Characteristic{
    switch self{
    case .PayUpfront:
      return .PayUpfront
    case .WrapIntoLoan:
      return .WrapIntoLoan
    }
  }
}

enum HoldingCostsCharacteristic1{
  case SetAmount
  case Percent
  
  var number:Int32{
    switch self{
    case .SetAmount:
      return 0
    case .Percent:
      return 1
    }
  }
  var characteristic:Characteristic{
    switch self{
    case .SetAmount:
      return .SetAmount
    case .Percent:
      return .Percent
    }
  }
  var keyboardType:TextFieldValueType{
    switch self{
    case .SetAmount:
      return .SetAmount
    case .Percent:
      return .Percent
    }
  }
}
enum HoldingCostsCharacteristic2{
  case PerMonth
  case PerYear
  
  var number:Int32{
    switch self{
    case .PerMonth:
      return 0
    case .PerYear:
      return 1
    }
  }
  var characteristic:Characteristic{
    switch self{
    case .PerMonth:
      return .PerMonth
    case .PerYear:
      return .PerYear
    }
  }
}
enum SellingCostsCharacteristic1{
  case SetAmount
  case Percent
  
  var number:Int32{
    switch self{
    case .SetAmount:
      return 0
    case .Percent:
      return 1
    }
  }
  var characteristic:Characteristic{
    switch self{
    case .SetAmount:
      return .SetAmount
    case .Percent:
      return .Percent
    }
  }
  var keyboardType:TextFieldValueType{
    switch self{
    case .SetAmount:
      return .SetAmount
    case .Percent:
      return .Percent
    }
  }
}
enum IncomeCharacteristic1{
  case PerMonth
  case PerYear
  
  var number:Int32{
    switch self{
    case .PerMonth:
      return 0
    case .PerYear:
      return 1
    }
  }
  var characteristic:Characteristic{
    switch self{
    case .PerMonth:
      return .PerMonth
    case .PerYear:
      return .PerYear
    }
  }
}
enum ExpensesCharacteristic1{
  case SetAmount
  case Percent
  
  var number:Int32{
    switch self{
    case .SetAmount:
      return 0
    case .Percent:
      return 1
    }
  }
  var characteristic:Characteristic{
    switch self{
    case .SetAmount:
      return .SetAmount
    case .Percent:
      return .Percent
    }
  }
  var keyboardType:TextFieldValueType{
    switch self{
    case .SetAmount:
      return .SetAmount
    case .Percent:
      return .Percent
    }
  }
}
enum ExpensesCharacteristic2{
  case OfPrice
  case OfRent
  
  var number:Int32{
    switch self{
    case .OfPrice:
      return 0
    case .OfRent:
      return 1
    }
  }
  var characteristic:Characteristic{
    switch self{
    case .OfPrice:
      return .OfPrice
    case .OfRent:
      return .OfRent
    }
  }
}
enum ExpensesCharacteristic3{
  case WithoutVacancy
  case WithVacancy
  
  var number:Int32{
    switch self{
    case .WithoutVacancy:
      return 0
    case .WithVacancy:
      return 1
    }
  }
  var characteristic:Characteristic{
    switch self{
    case .WithoutVacancy:
      return .WithoutVacancy
    case .WithVacancy:
      return .WithVacancy
    }
  }
}
enum ExpensesCharacteristic4{
  case PerMonth
  case PerYear
  
  var number:Int32{
    switch self{
    case .PerMonth:
      return 0
    case .PerYear:
      return 1
    }
  }
  var characteristic:Characteristic{
    switch self{
    case .PerMonth:
      return .PerMonth
    case .PerYear:
      return .PerYear
    }
  }
}


struct CharacteristicData{
  let characteristic:Characteristic
  let hideSegmentedControlIndex:[Int]
  let showSegmentedControlIndex:[Int]
}
enum ItemizeFieldMode{
  case edit
  case new
}
enum ItemizeItemType{
  case PurchaseCosts
  case RehabCosts
  case HoldingCosts
  case SellingCosts
  case Income
  case Expenses
  var savedNotification:String{
    switch self{
    case .PurchaseCosts:
      return "savedPurchaseCosts"
    case .RehabCosts:
      return "savedRehabCosts"
    case .HoldingCosts:
      return "savedHoldingCosts"
    case .SellingCosts:
      return "savedSellingCosts"
    case .Income:
      return "savedIncome"
    case .Expenses:
      return "savedExpenses"
    }
  }
}
struct ItemizeData{
  let cell:UIView
  var height:CGFloat
  var collapsed:Bool
  var canEdit:Bool
  var enableMove:Bool
  var separatorInset:UIEdgeInsets
}

func setupFormFieldLayout(_ view:UIView,leftLabel:UILabel,rightTF:FloatLabelTextField){
  view.addSubview(leftLabel)
  view.addSubview(rightTF)
  leftLabel.centerVerticallyInSuperview()
  leftLabel.setLeadingInSuperview(16,priority: UILayoutPriority(rawValue: 1000))
  rightTF.setTrailingInSuperview(-16, priority: UILayoutPriority(rawValue: 1000))
  rightTF.setTopInSuperview(5, priority: UILayoutPriority(rawValue: 999))
  rightTF.setBottomInSuperview(-5, priority: UILayoutPriority(rawValue: 999))
  rightTF.textAlignment = .right
  let leftLabelWidthConstraint = NSLayoutConstraint(item: leftLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.45, constant: -32)
  let rightTFWidthConstraint = NSLayoutConstraint(item: rightTF, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.55, constant: -32)
  NSLayoutConstraint.activate([leftLabelWidthConstraint,rightTFWidthConstraint])
}
func setupNewItemizeFieldLayout(_ tf:FloatLabelTextField){
  tf.setLeadingInSuperview(16, priority: UILayoutPriority(rawValue: 1000))
  tf.setTrailingInSuperview(-16, priority: UILayoutPriority(rawValue: 1000))
  tf.setTopInSuperview(5, priority: UILayoutPriority(rawValue: 999))
  tf.setBottomInSuperview(-5, priority: UILayoutPriority(rawValue: 999))
}
