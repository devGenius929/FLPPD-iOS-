//
//  Report.swift
//  FLPPD
//
//  Created by PC on 7/30/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import MapKit
import WebKit
enum HtmlPlaceholder{
  static let nickname = "#NICKNAME#"
  static let leftTop = "#LEFTTOP#"
  static let rightTop = "#RIGHTTOP#"
  static let street = "#STREET#"
  static let zipcode = "#ZIP CODE#"
  static let city = "#CITY#"
  static let state = "#STATE#"
  static let purchasePrice = "#PURCHASE PRICE#"
  static let capRate = "#CAP RATE PERCENT#"
  static let preparedBy = "#PREPARED BY#"
  static let preparedByBox = "#PREPARED BY BOX#"
  static let leftPreparedByBox = "#LEFT PREPARED BY BOX#"
  static let rightPreparedByBox = "#RIGHT PREPARED BY BOX#"
  static let author = "#AUTHOR#"
  static let contactDetails = "#CONTACT DETAILS#"
  static let logo = "#LOGO#"
  static let coverPhoto = "#COVER PHOTO#"
  static let propertyType = "#PROPERTY TYPE#"
  static let beds = "#BEDS#"
  static let baths = "#BATHS#"
  static let squareFootage = "#SQUARE FOOTAGE#"
  static let yearBuilt = "#YEAR BUILT#"
  static let parking = "#PARKING#"
  static let lotSize = "#LOT SIZE#"
  static let zoning = "#ZONING#"
  static let map1 = "#MAP1#"
  static let map2 = "#MAP2#"
  static let image = "#IMAGE#"
  static let title = "#TITLE#"
  static let sign = "#SIGN#"
  static let value = "#VALUE#"
  static let value2 = "#2ND VALUE#"
  static let value3 = "#3RD VALUE#"
  static let value4 = "#4TH VALUE#"
  static let value5 = "#5TH VALUE#"
  static let value6 = "#6TH VALUE#"
  static let value7 = "#7TH VALUE#"
  static let financing = "#FINANCING#"
  static let purchaseCostsDetails = "#PURCHASE COSTS DETAILS#"
  static let holdingCostsDetails = "#HOLDING COSTS DETAILS#"
  static let rehabCostsDetails = "#REHAB COSTS DETAILS#"
  static let otherIncomeDetails = "#OTHER INCOME DETAILS#"
  static let expensesDetails = "#EXPENSES DETAILS#"
  static let expensesProjections = "#EXPENSES PROJECTIONS#"
  static let additionalPages = "#ADDITIONAL PAGES#"
  static let additionalPhotos = "#ADDITIONAL PHOTOS#"
  static let branding = "#BRANDING#"
  static let pageIndex = "#PAGE INDEX#"
  static let pageCount = "#PAGE COUNT#"
  static let roiPercent = "#ROI PERCENT#"
  static let sellingCostsDetails = "#SELLING COSTS DETAILS#"
  static let holdingCostsPPDetails = "#HOLDING COSTS PP DETAILS#"
}
enum DivHtml{
  static let singleImg = "<div class=\"single-img\"><img src=\"data:image/png;base64,#IMAGE#\" scale=\"0\"></div>"
  static let authorDiv = "<td><div id=\"right_box\"><span class=\"color-blue\">#AUTHOR#</span><br>"
  static let contactDetailsDiv = "<div style=\"white-space: pre\"><span>#CONTACT DETAILS#</span><div></td>"
  static let imgDiv = "<img src=\"data:image/png;base64,#IMAGE#\" scale=\"0\"></div>"
  static let imageFullDiv = "<div class=\"image-full\"><img src=\"data:image/png;base64,#IMAGE#\" scale=\"0\"></div>"
  static let map2ImgDiv = "<div class=\"second_map\"><img src=\"data:image/png;base64,#IMAGE#\" scale=\"0\"></div>"
}
enum PageHtml{
  static let firstAdditionalPhotosPage = "<page size=\"A4\"><div class=\"header\"><div class=\"title-tp bottom-border clearfix\"><div class=\"left-top\">#LEFTTOP#</div>#RIGHTTOP#</div></div><div class=\"midd-cnt-section\"><div class=\"title-head\"><h1 class=\"color-blue\">Photos</h1></div><div class=\"photo-section\">#ADDITIONAL PHOTOS#</div></div><div class=\"footer\"><div class=\"title-tp top-border clearfix\">#BRANDING#<div class=\"rtt-top\">Page #PAGE INDEX# of #PAGE COUNT#</div></div></div></page>"
  static let additionalPhotosPage = "<page size=\"A4\"><div class=\"header\"><div class=\"title-tp bottom-border clearfix\"><div class=\"left-top\">#LEFTTOP#</div>#RIGHTTOP#</div></div><div class=\"midd-cnt-section\"><div class=\"title-head\"><h1 class=\"color-blue\">Photos</h1></div><div class=\"photo-section\">#ADDITIONAL PHOTOS#</div></div><div class=\"footer\"><div class=\"title-tp top-border clearfix\">#BRANDING#<div class=\"rtt-top\">Page #PAGE INDEX# of #PAGE COUNT#</div></div></div></page>"
}
enum RowHtml{
  static let regularRow = "<tr><td>#TITLE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#VALUE#</td></tr>"
  static let rowWithNoSign = "<tr><td>#TITLE#</td><td>#VALUE#</td></tr>"
  static let blueRowWithTopBorder = "<tr class=\"color-blue border-tpp\"><td>#TITLE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#VALUE#</td></tr><tr>"
  static let blueRow = "<tr class=\"color-blue\"><td>#TITLE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#VALUE#</td></tr><tr>"
  static let blueRowWithNoSign = "<tr class=\"color-blue\"><td>#TITLE#</td><td>#VALUE#</td></tr><tr>"
  static let blueRowWithTopBorderWithNoSign = "<tr class=\"color-blue border-tpp\"><td>#TITLE#</td><td>#VALUE#</td></tr><tr>"
  static let doubleRow = "<tr><td>#TITLE#</td><td>#VALUE#</td></tr><tr><td></td><td>#2ND VALUE#</td></tr>"
  static let doubleColumn = "<tr><td>#TITLE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#VALUE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#2ND VALUE#</td></tr><tr>"
  static let doubleColumnBlueWithTopBorder = "<tr class=\"color-blue border-tpp\"><td>#TITLE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#VALUE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#2ND VALUE#</td></tr>"
  static let doubleColumnBlue = "<tr class=\"color-blue\"><td>#TITLE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#VALUE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#2ND VALUE#</td></tr>"
  static let sevenColumn = "<tr><td>#TITLE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#VALUE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#2ND VALUE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#3RD VALUE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#4TH VALUE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#5TH VALUE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#6TH VALUE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#7TH VALUE#</td></tr>"
  static let sevenColumnBlue = "<tr class=\"color-blue\"><td>#TITLE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#VALUE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#2ND VALUE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#3RD VALUE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#4TH VALUE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#5TH VALUE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#6TH VALUE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#7TH VALUE#</td></tr>"
  static let sevenColumnBlueWithTopBorder = "<tr class=\"color-blue border-tpp\"><td>#TITLE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#VALUE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#2ND VALUE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#3RD VALUE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#4TH VALUE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#5TH VALUE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#6TH VALUE#</td><td width=\"40\" align=\"center\">#SIGN#</td><td>#7TH VALUE#</td></tr>"
}

enum FlipProfitProjectionsHtml{
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
    case .saleProceeds:
      return RowHtml.sevenColumnBlueWithTopBorder
    case .totalProfit:
      return RowHtml.sevenColumnBlueWithTopBorder
    default:
      return RowHtml.sevenColumn
    }
  }
  var placeholder:String{
    switch self{
    case .afterRepairValue:
      return "#AFTER REPAIR VALUE PP#"
    case .sellingCosts:
      return "#SELLING COSTS PP#"
    case .saleProceeds:
      return "#SALE PROCEEDS PP#"
    case .loanRepayment:
      return "#LOAN REPAYMENT PP#"
    case .holdingCosts:
      return "#HOLDING COSTS PP#"
    case .investedCash:
      return "#INVESTED CASH PP#"
    case .totalProfit:
      return "#TOTAL PROFIT PP#"
    case .returnOnInvestment:
      return "#RETURN ON INVESTMENT PP#"
    case .annualizedROI:
      return "#ANNUALIZED ROI PP#"
    }
  }
  
  static let cases:[FlipProfitProjectionsHtml] = [.afterRepairValue,.sellingCosts,.saleProceeds,.loanRepayment,.holdingCosts,.investedCash,.totalProfit,.returnOnInvestment,.annualizedROI]
}
enum RentalHoldingProjectionsHtml{
  case grossRent
  case vacancy
  case otherIncome
  case operatingIncome
  case operatingIncomeCF
  case operatingExpenses
  case netOperatingIncome
  case loanPayments
  case cashFlow
  case propertyValue
  case loanBalance
  case totalEquity
  case depreciation
  case loanInterest
  case capRate
  case cashOnCash
  case returnOnInvestment
  case internalRateOfReturn
  case rentToValue
  case grossRentMultiplier
  case debtCoverageRatio
  
  var title:String{
    switch self{
    case .grossRent:
      return "Gross Rent:"
    case .vacancy:
      return "Vacancy:"
    case .otherIncome:
      return "Other Income:"
    case .operatingIncome:
      return "Operating Income:"
    case .operatingIncomeCF:
      return "Operating Income:"
    case .operatingExpenses:
      return "Operating Expenses:"
    case .netOperatingIncome:
      return "Net Operating Income:"
    case .loanPayments:
      return "Loan Payments:"
    case .cashFlow:
      return "Cash Flow:"
    case .propertyValue:
      return "Property Value:"
    case .loanBalance:
      return "Loan Balance:"
    case .totalEquity:
      return "Total Equity:"
    case .depreciation:
      return "Depreciation:"
    case .loanInterest:
      return "Loan Interest:"
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
    }
  }
  var sign:String{
    switch self{
    case .vacancy:
      return "-"
    case .otherIncome:
      return "+"
    case .operatingIncome:
      return "="
    case .operatingExpenses:
      return "-"
    case .netOperatingIncome:
      return "="
    case .loanPayments:
      return "-"
    case .cashFlow:
      return "="
    case .loanBalance:
      return "-"
    case .totalEquity:
      return "="
    default:
      return ""
    }
  }
  var rowType:String{
    switch self{
    case .operatingIncome:
      return RowHtml.sevenColumnBlueWithTopBorder
    case .netOperatingIncome:
      return RowHtml.sevenColumnBlueWithTopBorder
    case .cashFlow:
      return RowHtml.sevenColumnBlueWithTopBorder
    case .totalEquity:
      return RowHtml.sevenColumnBlueWithTopBorder
    default:
      return RowHtml.sevenColumn
    }
  }
  var placeholder:String{
    switch self{
    case .grossRent:
      return "#HP GROSS RENT#"
    case .vacancy:
      return "#HP VACANCY#"
    case .otherIncome:
      return "#HP OTHER INCOME#"
    case .operatingIncome:
      return "#HP OPERATING INCOME#"
    case .operatingIncomeCF:
      return "#HP OPERATING INCOME CF#"
    case .operatingExpenses:
      return "#HP OPERATING EXPENSES#"
    case .netOperatingIncome:
      return "#HP NET OPERATING INCOME#"
    case .loanPayments:
      return "#HP LOAN PAYMENTS#"
    case .cashFlow:
      return "#HP CASH FLOW#"
    case .propertyValue:
      return "#HP PROPERTY VALUE#"
    case .loanBalance:
      return "#HP LOAN BALANCE#"
    case .totalEquity:
      return "#HP TOTAL EQUITY#"
    case .depreciation:
      return "#HP DEPRECIATION#"
    case .loanInterest:
      return "#HP LOAN INTEREST#"
    case .capRate:
      return "#HP CAP RATE#"
    case .cashOnCash:
      return "#HP CASH ON CASH#"
    case .returnOnInvestment:
      return "#HP RETURN ON INVESTMENT#"
    case .internalRateOfReturn:
      return "#HP INTERNAL RATE OF RETURN#"
    case .rentToValue:
      return "#HP RENT TO VALUE#"
    case .grossRentMultiplier:
      return "#HP GROSS RENT MULTIPLIER#"
    case .debtCoverageRatio:
      return "#HP DEBT COVERAGE RATIO#"
    }
  }
  
  static let cases:[RentalHoldingProjectionsHtml] = [.grossRent,.vacancy,.otherIncome,.operatingIncome,.operatingIncomeCF,.operatingExpenses,.netOperatingIncome,.loanPayments,.cashFlow,.propertyValue,.loanBalance,.totalEquity,.depreciation,.loanInterest,.capRate,.cashOnCash,.returnOnInvestment,.internalRateOfReturn,.rentToValue,.grossRentMultiplier,.debtCoverageRatio]
}
enum MapImageType{
  case coverMap
  case map1
  case map2
  var placeholder:String{
    switch self{
    case .coverMap:
      return "<div class=\"image-full\"><img src=\"data:image/png;base64,#COVER PHOTO#\" scale=\"0\"></div>"
    case .map1:
      return "<img src=\"data:image/png;base64,#MAP1#\" scale=\"0\">"
    case .map2:
      return "<img src=\"data:image/png;base64,#MAP2#\" scale=\"0\">"
    }
  }
  var size:CGSize{
    switch self{
    case .coverMap:
      return CGSize(width: 1200, height: 800)
    case .map1:
      return CGSize(width: 570, height: 570)
    case .map2:
      return CGSize(width: 1200, height: 600)
    }
  }
  var span:MKCoordinateSpan{
    switch self{
    case .coverMap:
      return MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    case .map1:
      return MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    case .map2:
      return MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    }
  }
}
struct MapImage{
  let type:MapImageType
  let data:Data?
}

class Report:NSObject{
  //MARK:Data for rental report
  private var monthlySummaryAnalysisViewModel:RentalSummaryAnalysisViewModel!
  private var yearlySummaryAnalysisViewModel:RentalSummaryAnalysisViewModel!
  private var year1RentalProjections:ProjectionsViewModel!
  private var year2RentalProjections:ProjectionsViewModel!
  private var year3RentalProjections:ProjectionsViewModel!
  private var year5RentalProjections:ProjectionsViewModel!
  private var year10RentalProjections:ProjectionsViewModel!
  private var year20RentalProjections:ProjectionsViewModel!
  private var year30RentalProjections:ProjectionsViewModel!
  private lazy var rentalHtml:String = {
    let path = Bundle.main.path(forResource: "rental_report", ofType: "html")!
    var html = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
    return html
  }()
  //MARK:Data for flip report
  private var twoWeeksFlipSummaryAnalysisViewModel:FlipSummaryAnalysisViewModel!
  private var oneMonthFlipSummaryAnalysisViewModel:FlipSummaryAnalysisViewModel!
  private var sixWeeksFlipSummaryAnalysisViewModel:FlipSummaryAnalysisViewModel!
  private var twoMonthsFlipSummaryAnalysisViewModel:FlipSummaryAnalysisViewModel!
  private var threeMonthsFlipSummaryAnalysisViewModel:FlipSummaryAnalysisViewModel!
  private var fourMonthsFlipSummaryAnalysisViewModel:FlipSummaryAnalysisViewModel!
  private var sixMonthsFlipSummaryAnalysisViewModel:FlipSummaryAnalysisViewModel!
  private lazy var flipHtml:String = {
    let path = Bundle.main.path(forResource: "flip_report", ofType: "html")!
    var html = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
    return html
  }()
  private let webView = WKWebView()
  let finalHtml:Variable<String?> = Variable(nil)
  private let geocoder = CLGeocoder()
  private let disposeBag = DisposeBag()
  let property:Variable<Property?> = Variable(nil)
  let preparedBy:Variable<String?> = Variable(nil)
  let contactDetails:Variable<String?> = Variable(nil)
  let logo:Variable<UIImage?> = Variable(nil)
  var coverImage:Variable<String?> = Variable(nil)
  let coverMap:Variable<String?> = Variable(nil)
  let map1:Variable<String?> = Variable(nil)
  let map2:Variable<String?> = Variable(nil)
  let additionalImage:Variable<[String]> = Variable([])
  var additionalImages:[String] = []
  let includeWorksheet = Variable(false)
  let includeMaps = Variable(false)
  let includePhotos = Variable(false)
  let hideBranding = Variable(false)
  var coverMapDiv = ""
  var map1Div = ""
  var map2Div = ""
  private var rightPreparedByBoxDiv = ""
  private var leftPreparedByBoxDiv = ""
  private var authorCellDiv = ""
  private var contactDetailsCellDiv = ""
  //MARK:Page 3
  override init(){
    super.init()
    property.asObservable().subscribe(onNext:{[unowned self] property in
      guard let property = property else{
        return
      }
      if let rentalProperty = property as? RentalProperty{
        self.monthlySummaryAnalysisViewModel = rentalSummaryAnalysis(rentalProperty, operationPeriod: .monthly)
        self.yearlySummaryAnalysisViewModel = rentalSummaryAnalysis(rentalProperty,operationPeriod:.yearly)
        self.year1RentalProjections = rentalProjections(property: rentalProperty, year: NSDecimalNumber(value: 1))
        self.year2RentalProjections = rentalProjections(property: rentalProperty, year: NSDecimalNumber(value: 2))
        self.year3RentalProjections = rentalProjections(property: rentalProperty, year: NSDecimalNumber(value: 3))
        self.year5RentalProjections = rentalProjections(property: rentalProperty, year: NSDecimalNumber(value: 5))
        self.year10RentalProjections = rentalProjections(property: rentalProperty, year: NSDecimalNumber(value: 10))
        self.year20RentalProjections = rentalProjections(property: rentalProperty, year: NSDecimalNumber(value: 20))
        self.year30RentalProjections = rentalProjections(property: rentalProperty, year: NSDecimalNumber(value: 30))
      }else if let flipProperty = property as? FlipProperty{
        self.twoWeeksFlipSummaryAnalysisViewModel = flipSummaryAnalysis(flipProperty, holdingPeriod: NSDecimalNumber(value: 0.5))
        self.oneMonthFlipSummaryAnalysisViewModel = flipSummaryAnalysis(flipProperty, holdingPeriod: NSDecimalNumber(value: 1))
        self.sixWeeksFlipSummaryAnalysisViewModel = flipSummaryAnalysis(flipProperty, holdingPeriod: NSDecimalNumber(value: 1.5))
        self.twoMonthsFlipSummaryAnalysisViewModel = flipSummaryAnalysis(flipProperty, holdingPeriod: NSDecimalNumber(value: 2))
        self.threeMonthsFlipSummaryAnalysisViewModel = flipSummaryAnalysis(flipProperty, holdingPeriod: NSDecimalNumber(value: 3))
        self.fourMonthsFlipSummaryAnalysisViewModel = flipSummaryAnalysis(flipProperty, holdingPeriod: NSDecimalNumber(value: 4))
        self.sixMonthsFlipSummaryAnalysisViewModel = flipSummaryAnalysis(flipProperty, holdingPeriod: NSDecimalNumber(value: 6))
      }
      if let photos = property.photos,photos.count > 0{
        for (index,photo) in photos.array.enumerated(){
          if index > 0,let photo = photo as? Photo,let imageData = photo.imageData as Data?{
            self.additionalImages.append(DivHtml.singleImg.replacingOccurrences(of: HtmlPlaceholder.image, with: imageData.base64EncodedString()))
          }
        }
      }
      self.insertValue()
    }).disposed(by: disposeBag)
    
    includeWorksheet.asObservable().subscribe(onNext:{[unowned self] includePhotos in
      self.finalizeReport()
    }).disposed(by: disposeBag)
    
    includePhotos.asObservable().subscribe(onNext:{[unowned self] includePhotos in
      if includePhotos,let property = self.property.value,let photos = property.photos,photos.count > 0,let coverPhoto = photos.array[0] as? Photo,let coverPhotoData = coverPhoto.imageData as Data?{
        self.coverImage.value = coverPhotoData.base64EncodedString()
      }else{
        self.coverImage.value = nil
      }
    }).disposed(by: disposeBag)
    
    includeMaps.asObservable().subscribe(onNext:{[unowned self] includeMaps in
      if includeMaps,let property = self.property.value,self.map1.value == nil,self.map2.value == nil, self.coverMap.value == nil{
        var address = property.street!
        address.append(" "+property.city!+" "+property.state!+" "+property.zipcode!)
        self.createMapImages(address)
      }
      self.finalizeReport()
    }).disposed(by: disposeBag)
    
    coverImage.asObservable().subscribe(onNext:{[unowned self] imgStr in
      self.finalizeReport()
    }).disposed(by: disposeBag)
    
    coverMap.asObservable().subscribe(onNext:{[unowned self] imgStr in
      self.finalizeReport()
    }).disposed(by: disposeBag)
    
    map1.asObservable().subscribe(onNext:{[unowned self] imgStr in
      self.finalizeReport()
    }).disposed(by: disposeBag)
    
    map2.asObservable().subscribe(onNext:{[unowned self] imgStr in
      self.finalizeReport()
    }).disposed(by: disposeBag)
    
    preparedBy.asObservable().subscribe(onNext:{[unowned self] str in
      guard let str = str,!str.isEmpty else{
        self.authorCellDiv = ""
        self.finalizeReport()
        return
      }
      self.authorCellDiv = DivHtml.authorDiv.replacingOccurrences(of: HtmlPlaceholder.author, with: str)
      self.finalizeReport()
    }).disposed(by: disposeBag)
    
    contactDetails.asObservable().subscribe(onNext:{[unowned self] str in
      guard let str = str,!str.isEmpty else{
        self.contactDetailsCellDiv = ""
        self.finalizeReport()
        return
      }
      self.contactDetailsCellDiv = DivHtml.contactDetailsDiv.replacingOccurrences(of: HtmlPlaceholder.contactDetails, with: str)
      self.finalizeReport()
    }).disposed(by: disposeBag)
    
    logo.asObservable().subscribe(onNext:{[unowned self] logo in
      guard let logo = logo,let logoData = UIImageJPEGRepresentation(logo, 0) else{
        self.rightPreparedByBoxDiv = ""
        self.finalizeReport()
        return
      }
      let logoStr = logoData.base64EncodedString()
      self.rightPreparedByBoxDiv = "<td>" + DivHtml.imgDiv.replacingOccurrences(of: HtmlPlaceholder.image, with: logoStr) + "</td>"
      self.finalizeReport()
    }).disposed(by: disposeBag)
    
    finalHtml.asObservable().subscribe(onNext:{[unowned self] str in
      guard let str = str,!str.isEmpty else{
        return
      }
      self.webView.loadHTMLString(str, baseURL: Bundle.main.bundleURL)
    }).disposed(by: disposeBag)
    
    hideBranding.asObservable().subscribe(onNext:{[unowned self] Void in
      self.finalizeReport()
    }).disposed(by: disposeBag)
    
    webView.rx.observe(Double.self, "estimatedProgress").subscribe(onNext:{progress in
      if progress == 1.0{
        let data = createPdfFile(printFormatter: self.webView.viewPrintFormatter())
        let file = "report.pdf"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
          let path = dir.appendingPathComponent(file)
          data.write(to: path, atomically: true)
        }
      }
      
    }).disposed(by: disposeBag)
  }
  private func insertPreparedBy(_ html:String)->String{
    //MARK:Prepared by
    var preparedByDiv = rightPreparedByBoxDiv
    var preparedBy = ""
    if !authorCellDiv.isEmpty && contactDetailsCellDiv.isEmpty{
      preparedByDiv += authorCellDiv + "</div></td>"
    }else if authorCellDiv.isEmpty && !contactDetailsCellDiv.isEmpty{
      preparedByDiv += "<td><div id=\"right_box\">" + contactDetailsCellDiv
    }else if !authorCellDiv.isEmpty && !contactDetailsCellDiv.isEmpty{
      preparedByDiv += authorCellDiv + contactDetailsCellDiv
    }
    if !preparedByDiv.isEmpty{
      preparedBy = "Prepared By"
    }
    let returnHtml = html.replacingOccurrences(of: HtmlPlaceholder.preparedBy, with: preparedBy)
    return returnHtml.replacingOccurrences(of: HtmlPlaceholder.preparedByBox, with: preparedByDiv)
  }
  
  private func insertPhotos(_ html:String)->String{
    //MARK:Insert photos
    var finalHtml = html
    var coverPhotoDiv = ""
    var additionalPages = ""
    if includePhotos.value,let imgStr = coverImage.value {
      coverPhotoDiv = DivHtml.imageFullDiv.replacingOccurrences(of: HtmlPlaceholder.image, with:imgStr)
      var additionalPhotos:[String] = []
      var additionalPhotosForPage = ""
      let numberOfAdditionalPages = additionalImages.count % 6 == 0 ? additionalImages.count / 6 : (additionalImages.count/6) + 1
      if numberOfAdditionalPages > 0{
        for i in 0...numberOfAdditionalPages - 1{
          additionalPhotos.insert("", at: i)
        }
        for (index,additionalImgStr) in additionalImages.enumerated(){
          additionalPhotosForPage += additionalImgStr
          additionalPhotos[index / 6] = additionalPhotosForPage
          if (index + 1) % 6 == 0{
            additionalPhotosForPage = ""
          }
        }
        for div in additionalPhotos{
          additionalPages += PageHtml.additionalPhotosPage.replacingOccurrences(of: HtmlPlaceholder.additionalPhotos, with: div)
        }
        additionalPhotos.removeAll()
      }
      finalHtml = finalHtml.replacingOccurrences(of: HtmlPlaceholder.additionalPages, with: additionalPages)
      additionalPages = ""
    }else if includeMaps.value,let coverMapImgStr = coverMap.value{
      coverPhotoDiv = DivHtml.imageFullDiv.replacingOccurrences(of: HtmlPlaceholder.image, with:coverMapImgStr)
    }else{
      coverPhotoDiv = ""
    }
    finalHtml = finalHtml.replacingOccurrences(of: HtmlPlaceholder.coverPhoto, with: coverPhotoDiv)
    coverPhotoDiv = ""
    //MARK:Map images
    var map1Div = map1.value != nil && includeMaps.value ? DivHtml.imgDiv.replacingOccurrences(of: HtmlPlaceholder.image, with: map1.value!) : ""
    finalHtml = finalHtml.replacingOccurrences(of: HtmlPlaceholder.map1, with: map1Div)
    map1Div = ""
    let map2Div = map2.value != nil && includeMaps.value ? DivHtml.map2ImgDiv.replacingOccurrences(of: HtmlPlaceholder.image, with: map2.value!) : ""
    return finalHtml.replacingOccurrences(of: HtmlPlaceholder.map2, with: map2Div)
  }
  private func insertLeftTop(_ html:String)->String{
    let leftTop = "Property Report"
    guard let property = property.value,let nickname = property.nickname,!nickname.isEmpty else{
      return html.replacingOccurrences(of: HtmlPlaceholder.leftTop, with: leftTop)
    }
    return html.replacingOccurrences(of:HtmlPlaceholder.leftTop, with: leftTop + " for " + nickname)
  }
  private func insertRightTop(_ html:String)->String{
    var div = "<div class=\"rtt-top\">Prepared By <a href=\"#\" class=\"color-blue\">#AUTHOR#</a></div>"
    guard let preparedBy = preparedBy.value,!preparedBy.isEmpty else{
      return html.replacingOccurrences(of: HtmlPlaceholder.rightTop, with: "")
    }
    div = div.replacingOccurrences(of: HtmlPlaceholder.author, with: preparedBy)
    return html.replacingOccurrences(of: HtmlPlaceholder.rightTop, with: div)
  }
  private func insertBranding(_ html:String)->String{
    let div = "<div class=\"left-top\"><div class=\"rtt-top\">Created with <a href=\"#\" class=\"color-blue\">FLPPD Mobile App</a></div></div>"
    return hideBranding.value ? html.replacingOccurrences(of: HtmlPlaceholder.branding, with: "") : html.replacingOccurrences(of: HtmlPlaceholder.branding, with: div)
  }
  private func insertPageNumbers(_ html:String)->String{
    let numberOfPages = html.components(separatedBy: "</page>").count - 1
    var returnHtml = html.replacingOccurrences(of: HtmlPlaceholder.pageCount, with: String(numberOfPages))
    for i in 1...numberOfPages{
      if let range = returnHtml.range(of: HtmlPlaceholder.pageIndex){
        returnHtml = returnHtml.replacingCharacters(in: range, with: String(i))
      }
    }
    return returnHtml
  }
  func finalizeReport(){
    if let rentalWorksheet = property.value?.worksheet as? RentalWorksheet{
      var finalHtml = insertPreparedBy(rentalHtml)
      finalHtml = insertPhotos(finalHtml)
      finalHtml = insertLeftTop(finalHtml)
      finalHtml = insertRightTop(finalHtml)
      finalHtml = insertBranding(finalHtml)
      finalHtml = insertPageNumbers(finalHtml)
      finalizeRentalReport(finalHtml, rentalWorksheet: rentalWorksheet)
    }else if let flipWorksheet = property.value?.worksheet as? FlipWorksheet{
      var finalHtml = insertPreparedBy(flipHtml)
      finalHtml = insertPhotos(finalHtml)
      finalHtml = insertLeftTop(finalHtml)
      finalHtml = insertRightTop(finalHtml)
      finalHtml = insertBranding(finalHtml)
      finalHtml = insertPageNumbers(finalHtml)
      finalizeFlipReport(finalHtml, flipWorksheet: flipWorksheet)
    }
  }
  private func finalizeFlipReport(_ html:String,flipWorksheet:FlipWorksheet){
    var finalHtml = html
    //MARK:Flip Purchase Costs
    finalHtml = fillPurchaseCosts(finalHtml, worksheet: flipWorksheet, includeWorksheet: includeWorksheet.value, purchaseCostsTotal: twoWeeksFlipSummaryAnalysisViewModel.purchaseCosts)
    //MARK:Rehab costs
    finalHtml = fillRehabCosts(finalHtml, worksheet: flipWorksheet, includeWorksheet: includeWorksheet.value, rehabCostsTotal: "$ " + calculateTotalRehabCosts(flipWorksheet).stringValue)
    //MARK:Holding costs
    let flipSummaryViewModel = flipSummaryAnalysis(flipWorksheet.property!, holdingPeriod: flipWorksheet.holdingPeriod!)
    var holdingCostsDetailsHtml = ""
    var holdingCostsProjectionHtml = ""
    let loanPaymentTitle = "Loan Payments:"
    let recurringExpensesTitle = "Recurring Expenses:"
    let totalTitle = "Total:"
    if includeWorksheet.value{
      if let loanPayment = flipSummaryViewModel.loanPayment{
        holdingCostsDetailsHtml += RowHtml.rowWithNoSign.replacingOccurrences(of: HtmlPlaceholder.title, with: loanPaymentTitle).replacingOccurrences(of: HtmlPlaceholder.value, with: loanPayment)
      }
      if let value1 = twoWeeksFlipSummaryAnalysisViewModel.loanPayment,let value2 = oneMonthFlipSummaryAnalysisViewModel.loanPayment,let value3 = sixWeeksFlipSummaryAnalysisViewModel.loanPayment,let value4 = twoMonthsFlipSummaryAnalysisViewModel.loanPayment,let value5 = threeMonthsFlipSummaryAnalysisViewModel.loanPayment,let value6 = fourMonthsFlipSummaryAnalysisViewModel.loanPayment,let value7 = sixMonthsFlipSummaryAnalysisViewModel.loanPayment{
        holdingCostsProjectionHtml += RowHtml.sevenColumn.replacingOccurrences(of: HtmlPlaceholder.title, with: loanPaymentTitle).replacingOccurrences(of: HtmlPlaceholder.value, with:value1).replacingOccurrences(of: HtmlPlaceholder.value2, with: value2).replacingOccurrences(of: HtmlPlaceholder.value3, with: value3).replacingOccurrences(of: HtmlPlaceholder.value4, with: value4).replacingOccurrences(of: HtmlPlaceholder.value5, with: value5).replacingOccurrences(of: HtmlPlaceholder.value6, with: value6).replacingOccurrences(of: HtmlPlaceholder.value7, with: value7).replacingOccurrences(of: HtmlPlaceholder.sign, with: "")
      }
      for item in flipSummaryViewModel.itemizedHoldingCosts{
        holdingCostsDetailsHtml += RowHtml.rowWithNoSign.replacingOccurrences(of: HtmlPlaceholder.title, with: item.name + ":").replacingOccurrences(of: HtmlPlaceholder.value, with: item.text)
      }
      for  (index,item) in twoWeeksFlipSummaryAnalysisViewModel.itemizedHoldingCosts.enumerated(){
        let sign = holdingCostsProjectionHtml.isEmpty ? "" : "+"
        let itemHtml = RowHtml.sevenColumn.replacingOccurrences(of: HtmlPlaceholder.title, with: item.name + ":").replacingOccurrences(of: HtmlPlaceholder.value, with: item.text).replacingOccurrences(of: HtmlPlaceholder.value2, with: oneMonthFlipSummaryAnalysisViewModel.itemizedHoldingCosts[index].text).replacingOccurrences(of: HtmlPlaceholder.value3, with: sixWeeksFlipSummaryAnalysisViewModel.itemizedHoldingCosts[index].text).replacingOccurrences(of: HtmlPlaceholder.value4, with: twoMonthsFlipSummaryAnalysisViewModel.itemizedHoldingCosts[index].text).replacingOccurrences(of: HtmlPlaceholder.value5, with: threeMonthsFlipSummaryAnalysisViewModel.itemizedHoldingCosts[index].text).replacingOccurrences(of: HtmlPlaceholder.value6, with: fourMonthsFlipSummaryAnalysisViewModel.itemizedHoldingCosts[index].text).replacingOccurrences(of: HtmlPlaceholder.value7, with: sixMonthsFlipSummaryAnalysisViewModel.itemizedHoldingCosts[index].text).replacingOccurrences(of: HtmlPlaceholder.sign, with: sign)
        holdingCostsProjectionHtml += itemHtml
      }
      if let recurringExpenses = flipSummaryViewModel.recurringExpenses{
        holdingCostsDetailsHtml += RowHtml.rowWithNoSign.replacingOccurrences(of: HtmlPlaceholder.title, with: recurringExpensesTitle).replacingOccurrences(of: HtmlPlaceholder.value, with: recurringExpenses)
      }
      if let value1 = twoWeeksFlipSummaryAnalysisViewModel.recurringExpenses,let value2 = oneMonthFlipSummaryAnalysisViewModel.recurringExpenses,let value3 = sixWeeksFlipSummaryAnalysisViewModel.recurringExpenses,let value4 = twoMonthsFlipSummaryAnalysisViewModel.recurringExpenses,let value5 = threeMonthsFlipSummaryAnalysisViewModel.recurringExpenses,let value6 = fourMonthsFlipSummaryAnalysisViewModel.recurringExpenses,let value7 = sixMonthsFlipSummaryAnalysisViewModel.recurringExpenses{
        holdingCostsProjectionHtml += RowHtml.sevenColumn.replacingOccurrences(of: HtmlPlaceholder.title, with: recurringExpensesTitle).replacingOccurrences(of: HtmlPlaceholder.value, with:value1).replacingOccurrences(of: HtmlPlaceholder.value2, with: value2).replacingOccurrences(of: HtmlPlaceholder.value3, with: value3).replacingOccurrences(of: HtmlPlaceholder.value4, with: value4).replacingOccurrences(of: HtmlPlaceholder.value5, with: value5).replacingOccurrences(of: HtmlPlaceholder.value6, with: value6).replacingOccurrences(of: HtmlPlaceholder.value7, with: value7).replacingOccurrences(of: HtmlPlaceholder.sign, with: "")
      }
      let totalRow = holdingCostsDetailsHtml.isEmpty ? RowHtml.blueRowWithNoSign : RowHtml.blueRowWithTopBorderWithNoSign
      let value = flipSummaryViewModel.holdingCostsTotal
      holdingCostsDetailsHtml += totalRow.replacingOccurrences(of: HtmlPlaceholder.title, with: totalTitle).replacingOccurrences(of: HtmlPlaceholder.value, with: value)
      
      let totalPPRow = holdingCostsProjectionHtml.isEmpty ? RowHtml.sevenColumnBlue : RowHtml.sevenColumnBlueWithTopBorder
      let value1 = twoWeeksFlipSummaryAnalysisViewModel.holdingCostsTotal
      let value2 = oneMonthFlipSummaryAnalysisViewModel.holdingCostsTotal
      let value3 = sixWeeksFlipSummaryAnalysisViewModel.holdingCostsTotal
      let value4 = twoMonthsFlipSummaryAnalysisViewModel.holdingCostsTotal
      let value5 = threeMonthsFlipSummaryAnalysisViewModel.holdingCostsTotal
      let value6 = fourMonthsFlipSummaryAnalysisViewModel.holdingCostsTotal
      let value7 = sixMonthsFlipSummaryAnalysisViewModel.holdingCostsTotal
      holdingCostsProjectionHtml += totalPPRow.replacingOccurrences(of: HtmlPlaceholder.title, with: totalTitle).replacingOccurrences(of: HtmlPlaceholder.value, with:value1).replacingOccurrences(of: HtmlPlaceholder.value2, with: value2).replacingOccurrences(of: HtmlPlaceholder.value3, with: value3).replacingOccurrences(of: HtmlPlaceholder.value4, with: value4).replacingOccurrences(of: HtmlPlaceholder.value5, with: value5).replacingOccurrences(of: HtmlPlaceholder.value6, with: value6).replacingOccurrences(of: HtmlPlaceholder.value7, with: value7).replacingOccurrences(of: HtmlPlaceholder.sign, with: "")
    }else{
      if let loanPayment = flipSummaryViewModel.loanPayment{
        holdingCostsDetailsHtml += RowHtml.rowWithNoSign.replacingOccurrences(of: HtmlPlaceholder.title, with: loanPaymentTitle).replacingOccurrences(of: HtmlPlaceholder.value, with: loanPayment)
      }
      if let value1 = twoWeeksFlipSummaryAnalysisViewModel.loanPayment,let value2 = oneMonthFlipSummaryAnalysisViewModel.loanPayment,let value3 = sixWeeksFlipSummaryAnalysisViewModel.loanPayment,let value4 = twoMonthsFlipSummaryAnalysisViewModel.loanPayment,let value5 = threeMonthsFlipSummaryAnalysisViewModel.loanPayment,let value6 = fourMonthsFlipSummaryAnalysisViewModel.loanPayment,let value7 = sixMonthsFlipSummaryAnalysisViewModel.loanPayment{
        holdingCostsProjectionHtml += RowHtml.sevenColumn.replacingOccurrences(of: HtmlPlaceholder.title, with: loanPaymentTitle).replacingOccurrences(of: HtmlPlaceholder.value, with:value1).replacingOccurrences(of: HtmlPlaceholder.value2, with: value2).replacingOccurrences(of: HtmlPlaceholder.value3, with: value3).replacingOccurrences(of: HtmlPlaceholder.value4, with: value4).replacingOccurrences(of: HtmlPlaceholder.value5, with: value5).replacingOccurrences(of: HtmlPlaceholder.value6, with: value6).replacingOccurrences(of: HtmlPlaceholder.value7, with: value7).replacingOccurrences(of: HtmlPlaceholder.sign, with: "")
      }
      
      if let recurringExpenses = flipSummaryViewModel.recurringExpenses{
        holdingCostsDetailsHtml += RowHtml.rowWithNoSign.replacingOccurrences(of: HtmlPlaceholder.title, with: recurringExpensesTitle).replacingOccurrences(of: HtmlPlaceholder.value, with: recurringExpenses)
      }else{
        let recurringExpenses = flipWorksheet.holdingPeriod!.multiplying(by: flipWorksheet.holdingCosts!.itemizedTotal!).dollarFormat()
        holdingCostsDetailsHtml += RowHtml.rowWithNoSign.replacingOccurrences(of: HtmlPlaceholder.title, with: recurringExpensesTitle).replacingOccurrences(of: HtmlPlaceholder.value, with: recurringExpenses)
      }
      
      if let value1 = twoWeeksFlipSummaryAnalysisViewModel.recurringExpenses,let value2 = oneMonthFlipSummaryAnalysisViewModel.recurringExpenses,let value3 = sixWeeksFlipSummaryAnalysisViewModel.recurringExpenses,let value4 = twoMonthsFlipSummaryAnalysisViewModel.recurringExpenses,let value5 = threeMonthsFlipSummaryAnalysisViewModel.recurringExpenses,let value6 = fourMonthsFlipSummaryAnalysisViewModel.recurringExpenses,let value7 = sixMonthsFlipSummaryAnalysisViewModel.recurringExpenses{
        holdingCostsProjectionHtml += RowHtml.sevenColumn.replacingOccurrences(of: HtmlPlaceholder.title, with: recurringExpensesTitle).replacingOccurrences(of: HtmlPlaceholder.value, with:value1).replacingOccurrences(of: HtmlPlaceholder.value2, with: value2).replacingOccurrences(of: HtmlPlaceholder.value3, with: value3).replacingOccurrences(of: HtmlPlaceholder.value4, with: value4).replacingOccurrences(of: HtmlPlaceholder.value5, with: value5).replacingOccurrences(of: HtmlPlaceholder.value6, with: value6).replacingOccurrences(of: HtmlPlaceholder.value7, with: value7).replacingOccurrences(of: HtmlPlaceholder.sign, with: "")
      }else{
        let itemizedTotal = flipWorksheet.holdingCosts!.itemizedTotal!
        let sign = holdingCostsProjectionHtml.isEmpty ? "" : "+"
        let value1 = NSDecimalNumber(value: 0.5).multiplying(by: itemizedTotal).dollarFormat()
        let value2 = NSDecimalNumber(value: 1).multiplying(by: itemizedTotal).dollarFormat()
        let value3 = NSDecimalNumber(value: 1.5).multiplying(by: itemizedTotal).dollarFormat()
        let value4 = NSDecimalNumber(value: 2).multiplying(by: itemizedTotal).dollarFormat()
        let value5 = NSDecimalNumber(value: 3).multiplying(by: itemizedTotal).dollarFormat()
        let value6 = NSDecimalNumber(value: 4).multiplying(by: itemizedTotal).dollarFormat()
        let value7 = NSDecimalNumber(value: 6).multiplying(by: itemizedTotal).dollarFormat()
        holdingCostsProjectionHtml += RowHtml.sevenColumn.replacingOccurrences(of: HtmlPlaceholder.title, with: recurringExpensesTitle).replacingOccurrences(of: HtmlPlaceholder.value, with:value1).replacingOccurrences(of: HtmlPlaceholder.value2, with: value2).replacingOccurrences(of: HtmlPlaceholder.value3, with: value3).replacingOccurrences(of: HtmlPlaceholder.value4, with: value4).replacingOccurrences(of: HtmlPlaceholder.value5, with: value5).replacingOccurrences(of: HtmlPlaceholder.value6, with: value6).replacingOccurrences(of: HtmlPlaceholder.value7, with: value7).replacingOccurrences(of: HtmlPlaceholder.sign, with: sign)
      }
      
      let totalRow = holdingCostsDetailsHtml.isEmpty ? RowHtml.blueRowWithNoSign : RowHtml.blueRowWithTopBorderWithNoSign
      let value = flipSummaryViewModel.holdingCostsTotal
      holdingCostsDetailsHtml += totalRow.replacingOccurrences(of: HtmlPlaceholder.title, with: totalTitle).replacingOccurrences(of: HtmlPlaceholder.value, with: value)
      
      let totalPPRow = holdingCostsProjectionHtml.isEmpty ? RowHtml.sevenColumnBlue : RowHtml.sevenColumnBlueWithTopBorder
      let value1 = twoWeeksFlipSummaryAnalysisViewModel.holdingCostsTotal
      let value2 = oneMonthFlipSummaryAnalysisViewModel.holdingCostsTotal
      let value3 = sixWeeksFlipSummaryAnalysisViewModel.holdingCostsTotal
      let value4 = twoMonthsFlipSummaryAnalysisViewModel.holdingCostsTotal
      let value5 = threeMonthsFlipSummaryAnalysisViewModel.holdingCostsTotal
      let value6 = fourMonthsFlipSummaryAnalysisViewModel.holdingCostsTotal
      let value7 = sixMonthsFlipSummaryAnalysisViewModel.holdingCostsTotal
      holdingCostsProjectionHtml += totalPPRow.replacingOccurrences(of: HtmlPlaceholder.title, with: totalTitle).replacingOccurrences(of: HtmlPlaceholder.value, with:value1).replacingOccurrences(of: HtmlPlaceholder.value2, with: value2).replacingOccurrences(of: HtmlPlaceholder.value3, with: value3).replacingOccurrences(of: HtmlPlaceholder.value4, with: value4).replacingOccurrences(of: HtmlPlaceholder.value5, with: value5).replacingOccurrences(of: HtmlPlaceholder.value6, with: value6).replacingOccurrences(of: HtmlPlaceholder.value7, with: value7).replacingOccurrences(of: HtmlPlaceholder.sign, with: "")
    }
    finalHtml = finalHtml.replacingOccurrences(of: HtmlPlaceholder.holdingCostsDetails, with: holdingCostsDetailsHtml)
    finalHtml = finalHtml.replacingOccurrences(of: HtmlPlaceholder.holdingCostsPPDetails, with: holdingCostsProjectionHtml)
    //MARK:Selling Costs
    var insertHtml = ""
    if let sellingCosts = flipWorksheet.sellingCosts{
      if includeWorksheet.value{
        if sellingCosts.itemized,let fields = sellingCosts.itemizedSellingCosts{
          for field in fields.array{
            guard let field = field as? ItemizedSellingCostsField else{
              continue
            }
            let amount = calculateItemizedSellingCosts(field, flipWorksheet: flipWorksheet)
            if amount.isGreaterThan(0),let title = field.name{
              let value = amount.dollarFormat()
              insertHtml += RowHtml.rowWithNoSign.replacingOccurrences(of: HtmlPlaceholder.title, with: title).replacingOccurrences(of: HtmlPlaceholder.value, with: value)
            }
          }
          let totalRow = insertHtml.isEmpty ? RowHtml.blueRowWithNoSign : RowHtml.blueRowWithTopBorderWithNoSign
          insertHtml += totalRow.replacingOccurrences(of: HtmlPlaceholder.title, with: totalTitle).replacingOccurrences(of: HtmlPlaceholder.value, with: flipSummaryViewModel.sellingCosts)
        }else if let total = sellingCosts.total{
          let totalStr = total.decimalFormat()
          let title = "Total (" + totalStr + "% of Price):"
          insertHtml += RowHtml.blueRowWithNoSign.replacingOccurrences(of: HtmlPlaceholder.title, with: title).replacingOccurrences(of: HtmlPlaceholder.value, with: flipSummaryViewModel.sellingCosts)
        }
      }else{
        var title = ""
        if sellingCosts.itemized{
          title = "Total:"
        }else if let total = sellingCosts.total{
          let totalStr = total.decimalFormat()
          title = "Total (" + totalStr + "% of Price):"
        }
        insertHtml += RowHtml.blueRowWithNoSign.replacingOccurrences(of: HtmlPlaceholder.title, with: title).replacingOccurrences(of: HtmlPlaceholder.value, with: flipSummaryViewModel.sellingCosts)
      }
    }
    finalHtml = finalHtml.replacingOccurrences(of: HtmlPlaceholder.sellingCostsDetails, with: insertHtml)
    self.finalHtml.value = finalHtml
  }
  private func finalizeRentalReport(_ html:String,rentalWorksheet:RentalWorksheet){
    var finalHtml = html
    //MARK:Rental Purchase Costs
    finalHtml = fillPurchaseCosts(finalHtml, worksheet: rentalWorksheet, includeWorksheet: includeWorksheet.value,purchaseCostsTotal:monthlySummaryAnalysisViewModel.purchaseCosts)
    //MARK:Rehab costs
    finalHtml = fillRehabCosts(finalHtml, worksheet: rentalWorksheet, includeWorksheet: includeWorksheet.value, rehabCostsTotal: monthlySummaryAnalysisViewModel.rehabCosts)
    
    //MARK:Other Income
    let totalTitle = "Total:"
    var insertHtml = ""
    let monthlyOtherIncome = monthlySummaryAnalysisViewModel.otherIncome != nil ? monthlySummaryAnalysisViewModel.otherIncome! : NSDecimalNumber.zero.dollarFormat()
    let yearlyOtherIncome = yearlySummaryAnalysisViewModel.otherIncome != nil ? yearlySummaryAnalysisViewModel.otherIncome! : NSDecimalNumber.zero.dollarFormat()
    if includeWorksheet.value{
      if rentalWorksheet.income!.itemized{
        if let fields = rentalWorksheet.income?.itemizedIncome{
          for field in fields.array {
            guard let field = field as? ItemizedIncomeField else{
              continue
            }
            if field.setAmount!.isGreaterThan(0){
              let value = field.characteristic1 == IncomeCharacteristic1.PerMonth.number ? field.setAmount!.dollarFormat() :
                field.setAmount!.dividingBy12().dollarFormat()
              let value2 = field.characteristic1 == IncomeCharacteristic1.PerMonth.number ? (field.setAmount!.multiplyingBy12()).dollarFormat() : field.setAmount!.dollarFormat()
              insertHtml += RowHtml.doubleColumn.replacingOccurrences(of: HtmlPlaceholder.title, with: field.name!).replacingOccurrences(of: HtmlPlaceholder.value, with: value).replacingOccurrences(of: HtmlPlaceholder.value2, with: value2).replacingOccurrences(of: HtmlPlaceholder.sign, with: "")
            }
          }
        }
        let totalRow = insertHtml.isEmpty ? RowHtml.doubleColumnBlue : RowHtml.doubleColumnBlueWithTopBorder
        insertHtml += totalRow.replacingOccurrences(of: HtmlPlaceholder.title, with:totalTitle).replacingOccurrences(of: HtmlPlaceholder.value, with: monthlyOtherIncome).replacingOccurrences(of: HtmlPlaceholder.value2, with: yearlyOtherIncome).replacingOccurrences(of: HtmlPlaceholder.sign, with: "")
      }else{
        insertHtml = RowHtml.doubleColumnBlue.replacingOccurrences(of: HtmlPlaceholder.title, with:totalTitle).replacingOccurrences(of: HtmlPlaceholder.value, with: monthlyOtherIncome).replacingOccurrences(of: HtmlPlaceholder.value2, with: yearlyOtherIncome).replacingOccurrences(of: HtmlPlaceholder.sign, with: "")
      }
    }else{
      insertHtml = RowHtml.doubleColumnBlue.replacingOccurrences(of: HtmlPlaceholder.title, with:totalTitle).replacingOccurrences(of: HtmlPlaceholder.value, with: monthlyOtherIncome).replacingOccurrences(of: HtmlPlaceholder.value2, with: yearlyOtherIncome).replacingOccurrences(of: HtmlPlaceholder.sign, with: "")
    }
    finalHtml = finalHtml.replacingOccurrences(of: HtmlPlaceholder.otherIncomeDetails, with: insertHtml)
    
    //MARK:Expenses
    let operatingExpensesTitle = "Operating Expenses:"
    let totalExpensesTitle = "Total Expenses:"
    let monthlyOperatingExpenses = monthlySummaryAnalysisViewModel.operatingExpenses
    let yearlyOperatingExpenses = yearlySummaryAnalysisViewModel.operatingExpenses
    if includeWorksheet.value{
      if rentalWorksheet.expenses!.itemized,let fields = rentalWorksheet.expenses?.itemizedExpenses{
        var expensesDetailsHtml = ""
        var expensesProjectionsHtml = ""
        for field in fields.array{
          guard let field = field as? ItemizedExpensesField else{
            continue
          }
          let amount = calculateItemizedExpensesPerMonth(field, rentalWorksheet: rentalWorksheet)
          if amount.isGreaterThan(0){
            let value = amount.dollarFormat()
            let value2 = amount.multiplyingBy12().dollarFormat()
            expensesDetailsHtml += RowHtml.doubleColumn.replacingOccurrences(of: HtmlPlaceholder.title, with: field.name!).replacingOccurrences(of: HtmlPlaceholder.value, with: value).replacingOccurrences(of: HtmlPlaceholder.value2, with: value2).replacingOccurrences(of: HtmlPlaceholder.sign, with: "")
          }
        }
        for  (index,item) in year1RentalProjections.itemizedExpenses.enumerated(){
          let sign = index == 0 ? "" : "+"
          let itemHtml = RowHtml.sevenColumn.replacingOccurrences(of: HtmlPlaceholder.title, with: item.name + ":").replacingOccurrences(of: HtmlPlaceholder.value, with: item.text).replacingOccurrences(of: HtmlPlaceholder.value2, with: year2RentalProjections.itemizedExpenses[index].text).replacingOccurrences(of: HtmlPlaceholder.value3, with: year3RentalProjections.itemizedExpenses[index].text).replacingOccurrences(of: HtmlPlaceholder.value4, with: year5RentalProjections.itemizedExpenses[index].text).replacingOccurrences(of: HtmlPlaceholder.value5, with: year10RentalProjections.itemizedExpenses[index].text).replacingOccurrences(of: HtmlPlaceholder.value6, with: year20RentalProjections.itemizedExpenses[index].text).replacingOccurrences(of: HtmlPlaceholder.value7, with: year30RentalProjections.itemizedExpenses[index].text).replacingOccurrences(of: HtmlPlaceholder.sign, with: sign)
          expensesProjectionsHtml += itemHtml
        }
        let totalRow = expensesDetailsHtml.isEmpty ? RowHtml.doubleColumnBlue : RowHtml.doubleColumnBlueWithTopBorder
        expensesDetailsHtml += totalRow.replacingOccurrences(of: HtmlPlaceholder.title, with:totalTitle).replacingOccurrences(of: HtmlPlaceholder.value, with: monthlyOperatingExpenses).replacingOccurrences(of: HtmlPlaceholder.value2, with: yearlyOperatingExpenses).replacingOccurrences(of: HtmlPlaceholder.sign, with: "")
        finalHtml = finalHtml.replacingOccurrences(of: HtmlPlaceholder.expensesDetails, with: expensesDetailsHtml)
        
        if expensesProjectionsHtml.isEmpty,let value1 = year1RentalProjections.totalExpenses,let value2 = year2RentalProjections.totalExpenses,let value3 = year3RentalProjections.totalExpenses,let value4 = year5RentalProjections.totalExpenses,let value5 = year10RentalProjections.totalExpenses,let value6 = year20RentalProjections.totalExpenses,let value7 = year30RentalProjections.totalExpenses{
          let itemHtml = RowHtml.sevenColumn.replacingOccurrences(of: HtmlPlaceholder.title, with: totalExpensesTitle).replacingOccurrences(of: HtmlPlaceholder.value, with:value1).replacingOccurrences(of: HtmlPlaceholder.value2, with: value2).replacingOccurrences(of: HtmlPlaceholder.value3, with: value3).replacingOccurrences(of: HtmlPlaceholder.value4, with: value4).replacingOccurrences(of: HtmlPlaceholder.value5, with: value5).replacingOccurrences(of: HtmlPlaceholder.value6, with: value6).replacingOccurrences(of: HtmlPlaceholder.value7, with: value7).replacingOccurrences(of: HtmlPlaceholder.sign, with: "")
          expensesProjectionsHtml += itemHtml
        }
        expensesProjectionsHtml += RowHtml.sevenColumnBlueWithTopBorder.replacingOccurrences(of: HtmlPlaceholder.title, with: operatingExpensesTitle).replacingOccurrences(of: HtmlPlaceholder.value, with:year1RentalProjections.operatingExpenses).replacingOccurrences(of: HtmlPlaceholder.value2, with: year2RentalProjections.operatingExpenses).replacingOccurrences(of: HtmlPlaceholder.value3, with: year3RentalProjections.operatingExpenses).replacingOccurrences(of: HtmlPlaceholder.value4, with: year5RentalProjections.operatingExpenses).replacingOccurrences(of: HtmlPlaceholder.value5, with: year10RentalProjections.operatingExpenses).replacingOccurrences(of: HtmlPlaceholder.value6, with: year20RentalProjections.operatingExpenses).replacingOccurrences(of: HtmlPlaceholder.value7, with: year30RentalProjections.operatingExpenses).replacingOccurrences(of: HtmlPlaceholder.sign, with: "=")
        finalHtml = finalHtml.replacingOccurrences(of: HtmlPlaceholder.expensesProjections, with: expensesProjectionsHtml)
      }else{
        let insertHtml = RowHtml.doubleColumnBlue.replacingOccurrences(of: HtmlPlaceholder.title, with:totalTitle).replacingOccurrences(of: HtmlPlaceholder.value, with: monthlyOperatingExpenses).replacingOccurrences(of: HtmlPlaceholder.value2, with: yearlyOperatingExpenses).replacingOccurrences(of: HtmlPlaceholder.sign, with: "")
        finalHtml = finalHtml.replacingOccurrences(of: HtmlPlaceholder.expensesDetails, with: insertHtml)
        
        var expensesProjectionsHtml = ""
        if let value = year1RentalProjections.totalExpenses,let value2 = year2RentalProjections.totalExpenses,let value3 = year3RentalProjections.totalExpenses,let value4 = year5RentalProjections.totalExpenses,let value5 = year10RentalProjections.totalExpenses,let value6 = year20RentalProjections.totalExpenses,let value7 = year30RentalProjections.totalExpenses{
          let itemHtml = RowHtml.sevenColumn.replacingOccurrences(of: HtmlPlaceholder.title, with: totalExpensesTitle).replacingOccurrences(of: HtmlPlaceholder.value, with:value).replacingOccurrences(of: HtmlPlaceholder.value2, with: value2).replacingOccurrences(of: HtmlPlaceholder.value3, with: value3).replacingOccurrences(of: HtmlPlaceholder.value4, with: value4).replacingOccurrences(of: HtmlPlaceholder.value5, with: value5).replacingOccurrences(of: HtmlPlaceholder.value6, with: value6).replacingOccurrences(of: HtmlPlaceholder.value7, with: value7).replacingOccurrences(of: HtmlPlaceholder.sign, with: "")
          expensesProjectionsHtml += itemHtml
        }
        expensesProjectionsHtml += RowHtml.sevenColumnBlueWithTopBorder.replacingOccurrences(of: HtmlPlaceholder.title, with: operatingExpensesTitle).replacingOccurrences(of: HtmlPlaceholder.value, with:year1RentalProjections.operatingExpenses).replacingOccurrences(of: HtmlPlaceholder.value2, with: year2RentalProjections.operatingExpenses).replacingOccurrences(of: HtmlPlaceholder.value3, with: year3RentalProjections.operatingExpenses).replacingOccurrences(of: HtmlPlaceholder.value4, with: year5RentalProjections.operatingExpenses).replacingOccurrences(of: HtmlPlaceholder.value5, with: year10RentalProjections.operatingExpenses).replacingOccurrences(of: HtmlPlaceholder.value6, with: year20RentalProjections.operatingExpenses).replacingOccurrences(of: HtmlPlaceholder.value7, with: year30RentalProjections.operatingExpenses).replacingOccurrences(of: HtmlPlaceholder.sign, with: "=")
        finalHtml = finalHtml.replacingOccurrences(of: HtmlPlaceholder.expensesProjections, with: expensesProjectionsHtml)
      }
    }else{
      let insertHtml = RowHtml.doubleColumnBlue.replacingOccurrences(of: HtmlPlaceholder.title, with:totalTitle).replacingOccurrences(of: HtmlPlaceholder.value, with: monthlyOperatingExpenses).replacingOccurrences(of: HtmlPlaceholder.value2, with: yearlyOperatingExpenses).replacingOccurrences(of: HtmlPlaceholder.sign, with: "")
      finalHtml = finalHtml.replacingOccurrences(of: HtmlPlaceholder.expensesDetails, with: insertHtml)
      
      let operatingExpensesHtml = RowHtml.sevenColumnBlueWithTopBorder.replacingOccurrences(of: HtmlPlaceholder.title, with: operatingExpensesTitle).replacingOccurrences(of: HtmlPlaceholder.sign, with: "=")
      let totalExpensesHtml = RowHtml.sevenColumn.replacingOccurrences(of: HtmlPlaceholder.title, with: totalExpensesTitle).replacingOccurrences(of: HtmlPlaceholder.sign, with: "")
      let expensesProjectionsHtml = (totalExpensesHtml + operatingExpensesHtml).replacingOccurrences(of: HtmlPlaceholder.value, with:year1RentalProjections.operatingExpenses).replacingOccurrences(of: HtmlPlaceholder.value2, with: year2RentalProjections.operatingExpenses).replacingOccurrences(of: HtmlPlaceholder.value3, with: year3RentalProjections.operatingExpenses).replacingOccurrences(of: HtmlPlaceholder.value4, with: year5RentalProjections.operatingExpenses).replacingOccurrences(of: HtmlPlaceholder.value5, with: year10RentalProjections.operatingExpenses).replacingOccurrences(of: HtmlPlaceholder.value6, with: year20RentalProjections.operatingExpenses).replacingOccurrences(of: HtmlPlaceholder.value7, with: year30RentalProjections.operatingExpenses)
      finalHtml = finalHtml.replacingOccurrences(of: HtmlPlaceholder.expensesProjections, with: expensesProjectionsHtml)
    }
    
    self.finalHtml.value = finalHtml
  }
  private func insertValue(){
    if let property = property.value{
      if let rentalWorksheet = property.worksheet as? RentalWorksheet{
        rentalHtml = insertStaticValue(rentalHtml, property: property)
        //MARK:Cap Rate
        rentalHtml =  rentalHtml.replacingOccurrences(of:HtmlPlaceholder.capRate, with: monthlySummaryAnalysisViewModel.capRate)
        for row in RentalReportHtml.cases{
          rentalHtml = fillRentalReport(rentalHtml, rentalWorksheet:property.worksheet as! RentalWorksheet, monthlyViewModel: monthlySummaryAnalysisViewModel, yearlyViewModel: yearlySummaryAnalysisViewModel, field: row)
        }
        var financingHtml = ""
        if property.worksheet!.useFinancing{
          for row in RentalFinancingHtml.cases{
            financingHtml += row.placeholder
            financingHtml = fillRentalFinancing(financingHtml, rentalWorksheet:rentalWorksheet, monthlyViewModel: monthlySummaryAnalysisViewModel, yearlyViewModel: yearlySummaryAnalysisViewModel, field: row)
          }
        }else{
          financingHtml = RowHtml.rowWithNoSign.replacingOccurrences(of: HtmlPlaceholder.title, with: "Cash Purchase").replacingOccurrences(of: HtmlPlaceholder.value, with: "")
        }
        rentalHtml = rentalHtml.replacingOccurrences(of: HtmlPlaceholder.financing, with: financingHtml)
        for row in RentalHoldingProjectionsHtml.cases{
          rentalHtml = fillRentalHoldingProjections(rentalHtml, field: row)
        }
      }else if let flipWorksheet = property.worksheet as? FlipWorksheet{
        flipHtml = insertStaticValue(flipHtml, property: property)
        //MARK:ROI
        flipHtml =  flipHtml.replacingOccurrences(of:HtmlPlaceholder.roiPercent, with: twoWeeksFlipSummaryAnalysisViewModel.roi)
        for row in FlipReportHtml.cases{
          flipHtml = fillFlipReport(flipHtml, flipWorksheet: flipWorksheet,viewModel: twoWeeksFlipSummaryAnalysisViewModel,field: row)
        }
        var financingHtml = ""
        if property.worksheet!.useFinancing{
          for row in FlipFinancingHtml.cases{
            financingHtml += row.placeholder
            financingHtml = fillFlipFinancing(financingHtml, flipWorksheet:flipWorksheet, monthlyViewModel: oneMonthFlipSummaryAnalysisViewModel, field: row)
          }
        }else{
          financingHtml = RowHtml.rowWithNoSign.replacingOccurrences(of: HtmlPlaceholder.title, with: "Cash Purchase").replacingOccurrences(of: HtmlPlaceholder.value, with: "")
        }
        flipHtml = flipHtml.replacingOccurrences(of: HtmlPlaceholder.financing, with: financingHtml)
        for row in FlipProfitProjectionsHtml.cases{
          flipHtml = fillFlipProfitProjections(flipHtml, field: row)
        }
      }
      self.finalizeReport()
    }
  }
  
  private func fillFlipProfitProjections(_ html:String,field:FlipProfitProjectionsHtml)->String{
    let value:String?
    let value2:String?
    let value3:String?
    let value4:String?
    let value5:String?
    let value6:String?
    let value7:String?
    switch field{
    case .afterRepairValue:
      value = twoWeeksFlipSummaryAnalysisViewModel.afterRepairValue
      value2 = oneMonthFlipSummaryAnalysisViewModel.afterRepairValue
      value3 = sixWeeksFlipSummaryAnalysisViewModel.afterRepairValue
      value4 = twoMonthsFlipSummaryAnalysisViewModel.afterRepairValue
      value5 = threeMonthsFlipSummaryAnalysisViewModel.afterRepairValue
      value6 = fourMonthsFlipSummaryAnalysisViewModel.afterRepairValue
      value7 = sixMonthsFlipSummaryAnalysisViewModel.afterRepairValue
    case .sellingCosts:
      value = twoWeeksFlipSummaryAnalysisViewModel.sellingCosts
      value2 = oneMonthFlipSummaryAnalysisViewModel.sellingCosts
      value3 = sixWeeksFlipSummaryAnalysisViewModel.sellingCosts
      value4 = twoMonthsFlipSummaryAnalysisViewModel.sellingCosts
      value5 = threeMonthsFlipSummaryAnalysisViewModel.sellingCosts
      value6 = fourMonthsFlipSummaryAnalysisViewModel.sellingCosts
      value7 = sixMonthsFlipSummaryAnalysisViewModel.sellingCosts
    case .saleProceeds:
      value = twoWeeksFlipSummaryAnalysisViewModel.saleProceeds
      value2 = oneMonthFlipSummaryAnalysisViewModel.saleProceeds
      value3 = sixWeeksFlipSummaryAnalysisViewModel.saleProceeds
      value4 = twoMonthsFlipSummaryAnalysisViewModel.saleProceeds
      value5 = threeMonthsFlipSummaryAnalysisViewModel.saleProceeds
      value6 = fourMonthsFlipSummaryAnalysisViewModel.saleProceeds
      value7 = sixMonthsFlipSummaryAnalysisViewModel.saleProceeds
    case .loanRepayment:
      value = twoWeeksFlipSummaryAnalysisViewModel.loanRepayment
      value2 = oneMonthFlipSummaryAnalysisViewModel.loanRepayment
      value3 = sixWeeksFlipSummaryAnalysisViewModel.loanRepayment
      value4 = twoMonthsFlipSummaryAnalysisViewModel.loanRepayment
      value5 = threeMonthsFlipSummaryAnalysisViewModel.loanRepayment
      value6 = fourMonthsFlipSummaryAnalysisViewModel.loanRepayment
      value7 = sixMonthsFlipSummaryAnalysisViewModel.loanRepayment
    case .holdingCosts:
      value = twoWeeksFlipSummaryAnalysisViewModel.holdingCosts
      value2 = oneMonthFlipSummaryAnalysisViewModel.holdingCosts
      value3 = sixWeeksFlipSummaryAnalysisViewModel.holdingCosts
      value4 = twoMonthsFlipSummaryAnalysisViewModel.holdingCosts
      value5 = threeMonthsFlipSummaryAnalysisViewModel.holdingCosts
      value6 = fourMonthsFlipSummaryAnalysisViewModel.holdingCosts
      value7 = sixMonthsFlipSummaryAnalysisViewModel.holdingCosts
    case .investedCash:
      value = twoWeeksFlipSummaryAnalysisViewModel.investedCash
      value2 = oneMonthFlipSummaryAnalysisViewModel.investedCash
      value3 = sixWeeksFlipSummaryAnalysisViewModel.investedCash
      value4 = twoMonthsFlipSummaryAnalysisViewModel.investedCash
      value5 = threeMonthsFlipSummaryAnalysisViewModel.investedCash
      value6 = fourMonthsFlipSummaryAnalysisViewModel.investedCash
      value7 = sixMonthsFlipSummaryAnalysisViewModel.investedCash
    case .totalProfit:
      value = twoWeeksFlipSummaryAnalysisViewModel.totalProfit
      value2 = oneMonthFlipSummaryAnalysisViewModel.totalProfit
      value3 = sixWeeksFlipSummaryAnalysisViewModel.totalProfit
      value4 = twoMonthsFlipSummaryAnalysisViewModel.totalProfit
      value5 = threeMonthsFlipSummaryAnalysisViewModel.totalProfit
      value6 = fourMonthsFlipSummaryAnalysisViewModel.totalProfit
      value7 = sixMonthsFlipSummaryAnalysisViewModel.totalProfit
    case .returnOnInvestment:
      value = twoWeeksFlipSummaryAnalysisViewModel.roi
      value2 = oneMonthFlipSummaryAnalysisViewModel.roi
      value3 = sixWeeksFlipSummaryAnalysisViewModel.roi
      value4 = twoMonthsFlipSummaryAnalysisViewModel.roi
      value5 = threeMonthsFlipSummaryAnalysisViewModel.roi
      value6 = fourMonthsFlipSummaryAnalysisViewModel.roi
      value7 = sixMonthsFlipSummaryAnalysisViewModel.roi
    case .annualizedROI:
      value = twoWeeksFlipSummaryAnalysisViewModel.annualizedROI
      value2 = oneMonthFlipSummaryAnalysisViewModel.annualizedROI
      value3 = sixWeeksFlipSummaryAnalysisViewModel.annualizedROI
      value4 = twoMonthsFlipSummaryAnalysisViewModel.annualizedROI
      value5 = threeMonthsFlipSummaryAnalysisViewModel.annualizedROI
      value6 = fourMonthsFlipSummaryAnalysisViewModel.annualizedROI
      value7 = sixMonthsFlipSummaryAnalysisViewModel.annualizedROI
    }
    guard let unwrappedValue = value else{
      return html.replacingOccurrences(of: field.placeholder, with: "")
    }
    var insertHtml = field.rowType.replacingOccurrences(of: HtmlPlaceholder.title, with: field.title).replacingOccurrences(of: HtmlPlaceholder.sign, with: field.sign).replacingOccurrences(of: HtmlPlaceholder.value, with: unwrappedValue)
    if let value2 = value2{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value2, with: value2)
    }else{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value2, with: "")
    }
    if let value3 = value3{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value3, with: value3)
    }else{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value3, with: "")
    }
    
    if let value4 = value4{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value4, with: value4)
    }else{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value4, with: "")
    }
    
    if let value5 = value5{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value5, with: value5)
    }else{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value5, with: "")
    }
    
    if let value6 = value6{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value6, with: value6)
    }else{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value6, with: "")
    }
    if let value7 = value7{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value7, with: value7)
    }else{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value7, with: "")
    }
    
    return html.replacingOccurrences(of: field.placeholder, with: insertHtml)
  }
  
  private func fillRentalHoldingProjections(_ html:String,field:RentalHoldingProjectionsHtml)->String{
    let value:String?
    let value2:String?
    let value3:String?
    let value4:String?
    let value5:String?
    let value6:String?
    let value7:String?
    switch field{
    case .grossRent:
      value = year1RentalProjections.grossRent
      value2 = year2RentalProjections.grossRent
      value3 = year3RentalProjections.grossRent
      value4 = year5RentalProjections.grossRent
      value5 = year10RentalProjections.grossRent
      value6 = year20RentalProjections.grossRent
      value7 = year30RentalProjections.grossRent
    case .vacancy:
      value = year1RentalProjections.vacancy
      value2 = year2RentalProjections.vacancy
      value3 = year3RentalProjections.vacancy
      value4 = year5RentalProjections.vacancy
      value5 = year10RentalProjections.vacancy
      value6 = year20RentalProjections.vacancy
      value7 = year30RentalProjections.vacancy
    case .otherIncome:
      value = year1RentalProjections.otherIncome
      value2 = year2RentalProjections.otherIncome
      value3 = year3RentalProjections.otherIncome
      value4 = year5RentalProjections.otherIncome
      value5 = year10RentalProjections.otherIncome
      value6 = year20RentalProjections.otherIncome
      value7 = year30RentalProjections.otherIncome
    case .operatingIncome:
      value = year1RentalProjections.operatingIncome
      value2 = year2RentalProjections.operatingIncome
      value3 = year3RentalProjections.operatingIncome
      value4 = year5RentalProjections.operatingIncome
      value5 = year10RentalProjections.operatingIncome
      value6 = year20RentalProjections.operatingIncome
      value7 = year30RentalProjections.operatingIncome
    case .operatingIncomeCF:
      value = year1RentalProjections.operatingIncome
      value2 = year2RentalProjections.operatingIncome
      value3 = year3RentalProjections.operatingIncome
      value4 = year5RentalProjections.operatingIncome
      value5 = year10RentalProjections.operatingIncome
      value6 = year20RentalProjections.operatingIncome
      value7 = year30RentalProjections.operatingIncome
    case .operatingExpenses:
      value = year1RentalProjections.operatingExpenses
      value2 = year2RentalProjections.operatingExpenses
      value3 = year3RentalProjections.operatingExpenses
      value4 = year5RentalProjections.operatingExpenses
      value5 = year10RentalProjections.operatingExpenses
      value6 = year20RentalProjections.operatingExpenses
      value7 = year30RentalProjections.operatingExpenses
    case .netOperatingIncome:
      value = year1RentalProjections.netOperatingIncome
      value2 = year2RentalProjections.netOperatingIncome
      value3 = year3RentalProjections.netOperatingIncome
      value4 = year5RentalProjections.netOperatingIncome
      value5 = year10RentalProjections.netOperatingIncome
      value6 = year20RentalProjections.netOperatingIncome
      value7 = year30RentalProjections.netOperatingIncome
    case .loanPayments:
      value = year1RentalProjections.loanPayment
      value2 = year2RentalProjections.loanPayment
      value3 = year3RentalProjections.loanPayment
      value4 = year5RentalProjections.loanPayment
      value5 = year10RentalProjections.loanPayment
      value6 = year20RentalProjections.loanPayment
      value7 = year30RentalProjections.loanPayment
    case .cashFlow:
      value = year1RentalProjections.cashFlow
      value2 = year2RentalProjections.cashFlow
      value3 = year3RentalProjections.cashFlow
      value4 = year5RentalProjections.cashFlow
      value5 = year10RentalProjections.cashFlow
      value6 = year20RentalProjections.cashFlow
      value7 = year30RentalProjections.cashFlow
    case .propertyValue:
      value = year1RentalProjections.propertyValue
      value2 = year2RentalProjections.propertyValue
      value3 = year3RentalProjections.propertyValue
      value4 = year5RentalProjections.propertyValue
      value5 = year10RentalProjections.propertyValue
      value6 = year20RentalProjections.propertyValue
      value7 = year30RentalProjections.propertyValue
    case .loanBalance:
      value = year1RentalProjections.loanBalance
      value2 = year2RentalProjections.loanBalance
      value3 = year3RentalProjections.loanBalance
      value4 = year5RentalProjections.loanBalance
      value5 = year10RentalProjections.loanBalance
      value6 = year20RentalProjections.loanBalance
      value7 = year30RentalProjections.loanBalance
    case .totalEquity:
      value = year1RentalProjections.totalEquity
      value2 = year2RentalProjections.totalEquity
      value3 = year3RentalProjections.totalEquity
      value4 = year5RentalProjections.totalEquity
      value5 = year10RentalProjections.totalEquity
      value6 = year20RentalProjections.totalEquity
      value7 = year30RentalProjections.totalEquity
    case .depreciation:
      value = year1RentalProjections.depreciation
      value2 = year2RentalProjections.depreciation
      value3 = year3RentalProjections.depreciation
      value4 = year5RentalProjections.depreciation
      value5 = year10RentalProjections.depreciation
      value6 = year20RentalProjections.depreciation
      value7 = year30RentalProjections.depreciation
    case .loanInterest:
      value = year1RentalProjections.loanInterest
      value2 = year2RentalProjections.loanInterest
      value3 = year3RentalProjections.loanInterest
      value4 = year5RentalProjections.loanInterest
      value5 = year10RentalProjections.loanInterest
      value6 = year20RentalProjections.loanInterest
      value7 = year30RentalProjections.loanInterest
    case .capRate:
      value = year1RentalProjections.capRate
      value2 = year2RentalProjections.capRate
      value3 = year3RentalProjections.capRate
      value4 = year5RentalProjections.capRate
      value5 = year10RentalProjections.capRate
      value6 = year20RentalProjections.capRate
      value7 = year30RentalProjections.capRate
    case .cashOnCash:
      value = year1RentalProjections.cashOnCash
      value2 = year2RentalProjections.cashOnCash
      value3 = year3RentalProjections.cashOnCash
      value4 = year5RentalProjections.cashOnCash
      value5 = year10RentalProjections.cashOnCash
      value6 = year20RentalProjections.cashOnCash
      value7 = year30RentalProjections.cashOnCash
    case .returnOnInvestment:
      value = year1RentalProjections.returnOnInvestment
      value2 = year2RentalProjections.returnOnInvestment
      value3 = year3RentalProjections.returnOnInvestment
      value4 = year5RentalProjections.returnOnInvestment
      value5 = year10RentalProjections.returnOnInvestment
      value6 = year20RentalProjections.returnOnInvestment
      value7 = year30RentalProjections.returnOnInvestment
    case .internalRateOfReturn:
      value = year1RentalProjections.internalRateOfReturn
      value2 = year2RentalProjections.internalRateOfReturn
      value3 = year3RentalProjections.internalRateOfReturn
      value4 = year5RentalProjections.internalRateOfReturn
      value5 = year10RentalProjections.internalRateOfReturn
      value6 = year20RentalProjections.internalRateOfReturn
      value7 = year30RentalProjections.internalRateOfReturn
    case .rentToValue:
      value = year1RentalProjections.rentToValue
      value2 = year2RentalProjections.rentToValue
      value3 = year3RentalProjections.rentToValue
      value4 = year5RentalProjections.rentToValue
      value5 = year10RentalProjections.rentToValue
      value6 = year20RentalProjections.rentToValue
      value7 = year30RentalProjections.rentToValue
    case .grossRentMultiplier:
      value = year1RentalProjections.grossRentMultiplier
      value2 = year2RentalProjections.grossRentMultiplier
      value3 = year3RentalProjections.grossRentMultiplier
      value4 = year5RentalProjections.grossRentMultiplier
      value5 = year10RentalProjections.grossRentMultiplier
      value6 = year20RentalProjections.grossRentMultiplier
      value7 = year30RentalProjections.grossRentMultiplier
    case .debtCoverageRatio:
      value = year1RentalProjections.debtCoverageRatio
      value2 = year2RentalProjections.debtCoverageRatio
      value3 = year3RentalProjections.debtCoverageRatio
      value4 = year5RentalProjections.debtCoverageRatio
      value5 = year10RentalProjections.debtCoverageRatio
      value6 = year20RentalProjections.debtCoverageRatio
      value7 = year30RentalProjections.debtCoverageRatio
    }
    guard let unwrappedValue = value else{
      return html.replacingOccurrences(of: field.placeholder, with: "")
    }
    var insertHtml = field.rowType.replacingOccurrences(of: HtmlPlaceholder.title, with: field.title).replacingOccurrences(of: HtmlPlaceholder.sign, with: field.sign).replacingOccurrences(of: HtmlPlaceholder.value, with: unwrappedValue)
    if let value2 = value2{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value2, with: value2)
    }else{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value2, with: "")
    }
    if let value3 = value3{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value3, with: value3)
    }else{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value3, with: "")
    }
    
    if let value4 = value4{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value4, with: value4)
    }else{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value4, with: "")
    }
    
    if let value5 = value5{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value5, with: value5)
    }else{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value5, with: "")
    }
    
    if let value6 = value6{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value6, with: value6)
    }else{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value6, with: "")
    }
    if let value7 = value7{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value7, with: value7)
    }else{
      insertHtml = insertHtml.replacingOccurrences(of: HtmlPlaceholder.value7, with: "")
    }
    
    return html.replacingOccurrences(of: field.placeholder, with: insertHtml)
  }
  
  private func createMapImages(_ address:String){
    if !geocoder.isGeocoding{
      geocoder.geocodeAddressString(address, completionHandler: {[unowned self](placemarks,error) -> Void in
        if let placemark = placemarks?[0]{
          let mkPlaceMark = MKPlacemark(placemark: placemark)
          self.takeMapSnapshot(.coverMap, coordinate: mkPlaceMark.coordinate,imgVar: self.coverMap)
          self.takeMapSnapshot(.map1, coordinate: mkPlaceMark.coordinate,imgVar: self.map1)
          self.takeMapSnapshot(.map2, coordinate: mkPlaceMark.coordinate,imgVar: self.map2)
        }
      })
    }
  }
  
  private func takeMapSnapshot(_ type:MapImageType,coordinate:CLLocationCoordinate2D,imgVar:Variable<String?>){
    let options = MKMapSnapshotOptions()
    let region = MKCoordinateRegion(center: coordinate, span:type.span)
    options.region = region
    options.size = type.size
    options.scale = UIScreen.main.scale
    let snapshotter = MKMapSnapshotter(options:options)
    snapshotter.start(completionHandler: {snapshot, error in
      guard let snapshot = snapshot,let image = drawPinAtCoordinate(snapshot, coordinate: region.center),let imageData = UIImagePNGRepresentation(image) else {
        imgVar.value = nil
        return
      }
      imgVar.value = imageData.base64EncodedString()
    })
  }
  
  
}
