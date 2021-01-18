//
//  SummaryAnalysisViewController.swift
//  FLPPD
//
//  Created by PC on 6/15/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
class SummaryAnalysisViewController:UIViewController{
  private let disposeBag = DisposeBag()
  private let holdingPeriodSlider = CustomSlider()
  private var summaryAnalysisView:SummaryAnalysisView!
  var property:Property!
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Summary Analysis"
    summaryAnalysisView = property.worksheet!.isKind(of: FlipWorksheet.self) ? FlipSummaryAnalysisView() : RentalSummaryAnalysisView()
    setupView()
  }
  
  private func setupView(){
    view.backgroundColor = UIColor.white
    view.addSubview(summaryAnalysisView)
    summaryAnalysisView.setLeadingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    summaryAnalysisView.setTrailingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    summaryAnalysisView.setTopInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    
    //MARK:Slider
    if let flipWorksheet = property.worksheet as? FlipWorksheet,let flipSummaryAnalysisView = summaryAnalysisView as? FlipSummaryAnalysisView{
      summaryAnalysisView.setBottomInSuperview(-44,priority:UILayoutPriority(rawValue: 1000))
      view.addSubview(holdingPeriodSlider)
      holdingPeriodSlider.titleLabel.text = "Holding Period"
      holdingPeriodSlider.detailLabel.text = flipWorksheet.holdingPeriod!.stringValue + " Month"
      holdingPeriodSlider.setBottomInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
      holdingPeriodSlider.setLeadingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
      holdingPeriodSlider.setTrailingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
      holdingPeriodSlider.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 1000))
      holdingPeriodSlider.slider.maximumValue = 12
      holdingPeriodSlider.sliderValue.value = flipWorksheet.holdingPeriod!
      holdingPeriodSlider.sliderValue.asObservable().subscribe(onNext:{[unowned self](value)->Void in
        self.holdingPeriodSlider.detailLabel.text = value.isGreaterThan(1) ? value.stringValue + " Months" : value.stringValue + " Month"
        let viewModel = flipSummaryAnalysis(self.property,holdingPeriod: value)
        self.loadFlipSummaryAnalysisData(viewModel,summaryAnalysisView:flipSummaryAnalysisView)
      }).disposed(by: disposeBag)
    }else{
      summaryAnalysisView.setBottomInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
      summaryAnalysisView.financedRehabCostsView.isHidden = true
      let rentalSummaryAnalysisView = summaryAnalysisView as! RentalSummaryAnalysisView
      rentalSummaryAnalysisView.operationSegmentedControl.selectedSegmentIndex = 0
      let viewModel = rentalSummaryAnalysis(self.property, operationPeriod: .monthly)
      loadRentalSummaryAnalysis(viewModel, summaryAnalysisView: rentalSummaryAnalysisView)
      rentalSummaryAnalysisView.operationSegmentedControl.rx.selectedSegmentIndex.subscribe(onNext:{[unowned self](index)-> Void in
        let period = index == 0 ? RentalOperationPeriod.monthly : RentalOperationPeriod.yearly
        let viewModel = rentalSummaryAnalysis(self.property, operationPeriod: period)
        self.loadRentalSummaryAnalysis(viewModel, summaryAnalysisView: rentalSummaryAnalysisView)
      }).disposed(by: disposeBag)
    }
  }
  private func loadRentalSummaryAnalysis(_ viewModel:RentalSummaryAnalysisViewModel,summaryAnalysisView:RentalSummaryAnalysisView){
    summaryAnalysisView.purchasePriceView.rightLabel.text = viewModel.purchasePrice
    if let amountFinanced = viewModel.amountFinanced{
      summaryAnalysisView.amountFinancedView.rightLabel.text = amountFinanced
      summaryAnalysisView.amountFinancedView.bottomLabel.text = viewModel.ltv
    }else{
      summaryAnalysisView.amountFinancedView.isHidden = true
    }
    if let downPayment = viewModel.downPayment{
      summaryAnalysisView.downPaymentView.rightLabel.text = downPayment
    }else{
      summaryAnalysisView.downPaymentView.isHidden = true
    }
    summaryAnalysisView.purchaseCostsView.rightLabel.text = viewModel.purchaseCosts
    summaryAnalysisView.rehabCostsView.rightLabel.text = viewModel.rehabCosts
    summaryAnalysisView.totalCashNeededView.rightLabel.text = viewModel.totalCashNeeded
    summaryAnalysisView.pricePerSquareFootView.rightLabel.text = viewModel.pricePerSquareFoot
    summaryAnalysisView.grossRentView.rightLabel.text = viewModel.grossRent
    summaryAnalysisView.vacancyView.rightLabel.text = viewModel.vacancy
    summaryAnalysisView.vacancyView.bottomLabel.text = viewModel.vacancyPercentage
    if let otherIncome = viewModel.otherIncome{
      summaryAnalysisView.otherIncomeView.rightLabel.text = otherIncome
    }else{
      summaryAnalysisView.otherIncomeView.isHidden = true
    }
    summaryAnalysisView.operatingIncomeView.rightLabel.text = viewModel.operatingIncome
    summaryAnalysisView.operatingExpensesView.rightLabel.text = viewModel.operatingExpenses
    summaryAnalysisView.operatingExpensesView.bottomLabel.text = viewModel.operatingExpensesPercentage
    summaryAnalysisView.netOperatingIncomeView.rightLabel.text = viewModel.netOperatingIncome
    if let loanPayment = viewModel.loanPayments{
      summaryAnalysisView.loanPaymentView.rightLabel.text = loanPayment
    }else{
      summaryAnalysisView.loanPaymentView.isHidden = true
    }
    summaryAnalysisView.cashFlowView.rightLabel.text = viewModel.cashFlow
    summaryAnalysisView.capRateView.rightLabel.text = viewModel.capRate
    summaryAnalysisView.cashOnCashView.rightLabel.text = viewModel.cashOnCash
    summaryAnalysisView.returnOnInvestmentView.rightLabel.text = viewModel.returnOnInvestment
    summaryAnalysisView.internalRateOfReturnView.rightLabel.text = viewModel.internalRateOfReturn
    summaryAnalysisView.rentToValueView.rightLabel.text = viewModel.rentToValue
    summaryAnalysisView.grossRentMultiplierView.rightLabel.text = viewModel.grossRentMultiplier
    if let debtCoverageRatio = viewModel.debtCoverageRatio{
      summaryAnalysisView.debtCoverageRatioView.rightLabel.text = debtCoverageRatio
    }else{
      summaryAnalysisView.debtCoverageRatioView.isHidden = true
    }
  }
  private func loadFlipSummaryAnalysisData(_ viewModel:FlipSummaryAnalysisViewModel,summaryAnalysisView:FlipSummaryAnalysisView){
    summaryAnalysisView.purchasePriceView.rightLabel.text = viewModel.purchasePrice
    if let financedRehabCosts = viewModel.financedRehabCosts{
      summaryAnalysisView.financedRehabCostsView.rightLabel.text = financedRehabCosts
      summaryAnalysisView.financedRehabCostsView.bottomLabel.text = viewModel.financedRehabCostsPercentage
    }else{
      summaryAnalysisView.financedRehabCostsView.isHidden = true
    }
    if let amountFinanced = viewModel.amountFinanced{
      summaryAnalysisView.amountFinancedView.rightLabel.text = amountFinanced
      summaryAnalysisView.amountFinancedView.bottomLabel.text = viewModel.ltc
    }else{
      summaryAnalysisView.amountFinancedView.isHidden = true
    }
    if let downPayment = viewModel.downPayment{
      summaryAnalysisView.downPaymentView.rightLabel.text = downPayment
    }else{
      summaryAnalysisView.downPaymentView.isHidden = true
    }
    summaryAnalysisView.purchaseCostsView.rightLabel.text = viewModel.purchaseCosts
    summaryAnalysisView.rehabCostsView.rightLabel.text = viewModel.rehabCosts
    summaryAnalysisView.totalCashNeededView.rightLabel.text = viewModel.totalCashNeeded
    summaryAnalysisView.pricePerSquareFootView.rightLabel.text = viewModel.pricePerSquareFoot
    if let loanPayment = viewModel.loanPayment {
      summaryAnalysisView.loanPaymentsView.rightLabel.text = loanPayment
    }else{
      summaryAnalysisView.loanPaymentsView.isHidden = true
    }
    if !viewModel.itemizedHoldingCosts.isEmpty{
      summaryAnalysisView.recurringExpensesView.isHidden = true
      summaryAnalysisView.holdingCostsViews.value.removeAll()
      for item in viewModel.itemizedHoldingCosts{
        let holdingCost = StandardFormFieldWithRightLabel()
        holdingCost.leftLabel.text = item.name
        holdingCost.middleLabel.text = "+"
        holdingCost.rightLabel.text = item.text
        summaryAnalysisView.holdingCostsViews.value.append(holdingCost)
      }
    }else if let recurringExpenses = viewModel.recurringExpenses{
      summaryAnalysisView.recurringExpensesView.isHidden = false
      summaryAnalysisView.holdingCostsViews.value.removeAll()
      summaryAnalysisView.recurringExpensesView.rightLabel.text = recurringExpenses
    }else{
      summaryAnalysisView.recurringExpensesView.isHidden = true
      summaryAnalysisView.holdingCostsViews.value.removeAll()
    }
    summaryAnalysisView.holdingCostsTotalView.rightLabel.text = viewModel.holdingCostsTotal
    //MARK:Sale & Profit
    summaryAnalysisView.afterRepairValueView.rightLabel.text = viewModel.afterRepairValue
    summaryAnalysisView.sellingCostsView.rightLabel.text = viewModel.sellingCosts
    summaryAnalysisView.saleProceedsView.rightLabel.text = viewModel.saleProceeds
    if let loanRepayment = viewModel.loanRepayment{
      summaryAnalysisView.loanRepaymentView.rightLabel.text = loanRepayment
    }else{
      summaryAnalysisView.loanRepaymentView.isHidden = true
    }
    summaryAnalysisView.holdingCostsView.rightLabel.text = viewModel.holdingCosts
    summaryAnalysisView.investedCashView.rightLabel.text = viewModel.investedCash
    summaryAnalysisView.totalProfitView.rightLabel.text = viewModel.totalProfit
    summaryAnalysisView.returnOnInvestmentView.rightLabel.text = viewModel.roi
    summaryAnalysisView.annualizedROIView.rightLabel.text = viewModel.annualizedROI
  }
}
