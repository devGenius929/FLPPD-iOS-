//
//  ProjectionsViewController.swift
//  FLPPD
//
//  Created by PC on 6/25/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
class ProjectionsViewController:UIViewController{
  private let disposeBag = DisposeBag()
  var property:Property!
  private let projectionsView = ProjectionsView()
  private let projectionsSlider = CustomSlider()
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  private func setupView(){
    view.backgroundColor = UIColor.white
    title = "Projections"
    view.addSubview(projectionsView)
    view.addSubview(projectionsSlider)
    projectionsView.setTopInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    projectionsView.setLeadingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    projectionsView.setTrailingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    projectionsView.setBottomInSuperview(-44, priority: UILayoutPriority(rawValue: 1000))
    projectionsSlider.setTrailingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    projectionsSlider.setLeadingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    projectionsSlider.setBottomInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    projectionsSlider.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 1000))
    projectionsSlider.titleLabel.text = "Projections For:"
    projectionsSlider.slider.minimumValue = 1
    projectionsSlider.slider.maximumValue = 35
    projectionsSlider.step = 1
    projectionsSlider.sliderValue.value = NSDecimalNumber(value: 1)
    projectionsSlider.sliderValue.asObservable().subscribe(onNext:{[unowned self](value)->Void in
      self.projectionsSlider.detailLabel.text = "Year "+value.stringValue
      let viewModel = rentalProjections(property: self.property as! RentalProperty, year: value)
      self.loadProjections(viewModel: viewModel)
    }).disposed(by: disposeBag)
  }
  private func loadProjections(viewModel:ProjectionsViewModel){
    projectionsView.grossRentView.rightLabel.text = viewModel.grossRent
    projectionsView.vacancyView.rightLabel.text = viewModel.vacancy
    projectionsView.vacancyView.bottomLabel.text = viewModel.vacancyPercentage
    if let otherIncome = viewModel.otherIncome {
      projectionsView.otherIncomeView.isHidden = false
      projectionsView.otherIncomeView.rightLabel.text = otherIncome
    }else{
      projectionsView.otherIncomeView.isHidden = true
    }
    projectionsView.operatingIncomeView.rightLabel.text = viewModel.operatingIncome
    projectionsView.operatingIncomeView.bottomLabel.text = viewModel.operatingIncomeAppreciation
    if !viewModel.itemizedExpenses.isEmpty{
      projectionsView.totalExpensesView.isHidden = true
      projectionsView.expensesViews.value.removeAll()
      for item in viewModel.itemizedExpenses{
        let expenses = StandardFormFieldWithRightLabel()
        expenses.leftLabel.text = item.name
        expenses.middleLabel.text = "+"
        expenses.rightLabel.text = item.text
        projectionsView.expensesViews.value.append(expenses)
      }
    }else if let totalExpenses = viewModel.totalExpenses{
      projectionsView.totalExpensesView.isHidden = false
      projectionsView.expensesViews.value.removeAll()
      projectionsView.totalExpensesView.rightLabel.text = totalExpenses
    }else{
      projectionsView.totalExpensesView.isHidden = true
      projectionsView.expensesViews.value.removeAll()
    }
    projectionsView.operatingExpensesView.rightLabel.text = viewModel.operatingExpenses
    projectionsView.operatingExpensesView.bottomLabel.text = viewModel.operatingExpensesIncrease
    projectionsView.cashFlowOperatingIncomeView.rightLabel.text = viewModel.operatingIncome
    projectionsView.cashFlowOperatingExpensesView.rightLabel.text = viewModel.operatingExpenses
    projectionsView.cashFlowOperatingExpensesView.bottomLabel.text = viewModel.operatingExpensesAsPercentOfIncome
    projectionsView.netOperatingIncomeView.rightLabel.text = viewModel.netOperatingIncome
    if let loanPayment = viewModel.loanPayment{
      projectionsView.loanPaymentsView.rightLabel.text = loanPayment
    }else{
      projectionsView.loanPaymentsView.isHidden = true
    }
    projectionsView.cashFlowView.rightLabel.text = viewModel.cashFlow
    projectionsView.propertyValueView.rightLabel.text = viewModel.propertyValue
    projectionsView.propertyValueView.bottomLabel.text = viewModel.propertyValueAppreciation
    if let loanBalance = viewModel.loanBalance {
      projectionsView.loanBalanceView.rightLabel.text = loanBalance
    }else{
      projectionsView.loanBalanceView.isHidden = true
    }
    projectionsView.totalEquityView.rightLabel.text = viewModel.totalEquity
    projectionsView.depreciationView.rightLabel.text = viewModel.depreciation
    if let loanInterest = viewModel.loanInterest {
      projectionsView.loanInterestView.rightLabel.text = loanInterest
    }else{
      projectionsView.loanInterestView.isHidden = true
    }
    projectionsView.capRateView.rightLabel.text = viewModel.capRate
    projectionsView.cashOnCashView.rightLabel.text = viewModel.cashOnCash
    projectionsView.returnOnInvestmentView.rightLabel.text = viewModel.returnOnInvestment
    projectionsView.internalRateOfReturnView.rightLabel.text = viewModel.internalRateOfReturn
    projectionsView.rentToValueView.rightLabel.text = viewModel.rentToValue
    projectionsView.grossRentMultiplierView.rightLabel.text = viewModel.grossRentMultiplier
    if let debtCoverageRatio = viewModel.debtCoverageRatio{
      projectionsView.debtCoverageRatioView.isHidden = false
      projectionsView.debtCoverageRatioView.rightLabel.text = debtCoverageRatio
    }else{
      projectionsView.debtCoverageRatioView.isHidden = true
    }
  }
}
