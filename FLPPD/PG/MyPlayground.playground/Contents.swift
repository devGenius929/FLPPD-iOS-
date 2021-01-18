
import Foundation

// extensions

extension Float {
    func percentValue() -> Float {
        return self / 100.0
    }
    func limitToRange(_ max:Float?,min:Float?)->Float{
        if self.isNaN{
            return 0
        }
        if let max = max, self > max{
            return max
        } else if let min = min, self < min{
            return min
        }
        return self
    }
    var stringValue:String {
        get {
            return String(format: "%0.02f", self)
        }
    }
    func dollarFormat()->String{
        return String(format: "$%01.2f", self)
    }
}
// end extensions

protocol ItemizeField {
    var isSetAmount: Bool {get set}
    var name: String {get set}
    var percentValue: Float {get set}
    var setAmount: Float {get set}
    
}
protocol ItemizedItem {
    var itemized:Bool {get set}
}
struct RehabCosts:ItemizedItem {
    var itemized:Bool
    var itemizedTotal: Float
    var total: Float
    var itemizedRehubCosts: NSOrderedSet?
    
}
struct ItemizedExpensesField: ItemizeField {
    var isSetAmount: Bool
    
    var name: String
    
    var percentValue: Float
    
    var setAmount: Float
    
    var characteristic1:Int32
    var characteristic2:Int32
    var characteristic3:Int32
    var characteristic4:Int32
}
struct ItemizedPurchaseCostsField : ItemizeField{
    var isSetAmount: Bool
    var name: String
    var percentValue: Float
    var setAmount: Float
    var characteristic1:Int32
    var characteristic2:Int32
    var characteristic3:Int32
}
struct PurchaseCosts:ItemizedItem {
    var itemized:Bool
    var itemizedTotal: Float
    var total: Float
    var itemizedPurchaseCosts: NSOrderedSet?
}

enum TextFieldValueType{
    case Percent
    case SetAmount
    case Standard
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

enum RentalOperationPeriod{
    case monthly
    case yearly
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
struct MortgageInsurance {
    var recurring: Float
    var upfront: Float
}

struct AmortizingFinancing {
    var loanTerm: Float
    var useMortgageInsurance: Bool
    var mortgageInsurance: MortgageInsurance?
}

protocol Worksheet {
    var afterRepairValue: Float {get set}
    var amortizing: Bool {get set}
    var customLoanAmount: Bool {get set}
    var downPayment: Float {get set}
    var interestRate: Float {get set}
    var loanAmount: Float {get set}
    var purchasePrice: Float {get set}
    var useFinancing: Bool {get set}
    var amortizingFinancing: AmortizingFinancing? {get set}
    var purchaseCosts: PurchaseCosts {get set}
    var rehabCosts: RehabCosts {get set}
}

struct FlipWorksheet: Worksheet{
    var amortizingFinancing: AmortizingFinancing?
    
    // worksheet
    var afterRepairValue: Float
    var amortizing: Bool
    var customLoanAmount: Bool
    var downPayment: Float
    var interestRate: Float
    var loanAmount: Float
    var purchasePrice: Float
    var useFinancing: Bool
    var rehabCosts: RehabCosts
    var purchaseCosts: PurchaseCosts
    // flip
    var costOverrun: Float
    var customLoanAsPercentOfARV: Bool
    var financeRehabCosts: Bool
    var holdingPeriod: Float
    var percentageToFinance: Float
    var percentOfARV: Float
    //var holdingCosts: HoldingCosts?
    //var sellingCosts: SellingCosts?
    
}
struct Expenses:ItemizedItem {
    var itemized: Bool
    
    var itemizedTotal: Float
    var total: Float
    var itemizedExpenses: NSOrderedSet?
}
struct Income:ItemizedItem {
    var itemized: Bool
    
    var itemizedTotal: Float
    var total: Float
    var itemizedIncome: NSOrderedSet?
}

struct RentalWorksheet: Worksheet{
    var amortizingFinancing: AmortizingFinancing?
    
    // worksheet
    var afterRepairValue: Float
    var amortizing: Bool
    var customLoanAmount: Bool
    var downPayment: Float
    var interestRate: Float
    var loanAmount: Float
    var purchasePrice: Float
    var useFinancing: Bool
    var rehabCosts: RehabCosts
    var purchaseCosts: PurchaseCosts
    // rental
    var appreciation: Float
    var expensesIncrease: Float
    var grossRent: Float
    var incomeIncrease: Float
    var landValue: Float
    var rentCollection: Int32
    var sellingCosts: Float
    var vacancy: Float
    var expenses: Expenses
    var income: Income
}

enum PropertyType:String{
    case singleFamily = "Single Family"
    case townHouse = "TownHouse/Condo"
    case lot = "Lot"
    case multiFamily = "Multi-Family"
    case countryHomes = "Country Homes/Acreage"
    case midHiRise  = "Mid/Hi-Rise Condo"
}

enum ParkingType:String
{
    case o1="Attached Garage"
    case o2="Detached Garage"
    case o3="Oversized Garage"
    case o4="Attached/Detached Garage"
    case o5="Tandem"
    case o6="No Parking"
    case o7="Parking Lot"
    
}

struct Property {
    var baths: String
    var beds: String
    var city: String
    var lotSize: String
    var nickname: String
    var numberOfUnits: Int32
    var parking: String
    var propertyDescription: String
    var propertyType: String
    var squareFootage: String
    var state: String
    var street: String
    var type: Int16
    var yearBuilt: String
    var zipcode: String
    var zoning: Bool
    var worksheet:Worksheet?
}
// view models
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
    let loanPayment:String
    let cashFlow:String
    let propertyValue:String
    let propertyValueAppreciation:String?
    let loanBalance:String
    let totalEquity:String
    let depreciation:String
    let loanInterest:String
    let capRate:String
    let cashOnCash:String
    let returnOnInvestment:String
    let internalRateOfReturn:String
    let rentToValue:String
    let grossRentMultiplier:String
    let debtCoverageRatio:String?
}
// rental projections
struct CashFlow{
    let income:OperatingIncome
    let expenses:OperatingExpenses
    let netOperatingIncome:Float
    let loanPayment:Float?
    let cashFlow:Float
}
struct OperatingExpenses{
    let items:[SummaryProjectionItem]
    let totalExpenses:Float?
    let operatingExpenses:Float
}
struct OperatingIncome{
    let grossRentPerMonth:Float
    let grossRentPerYear:Float
    let vacancy:Float
    let otherIncome:Float?
    let operatingIncome:Float
}
let rehubCosts = RehabCosts(itemized: false,
                            itemizedTotal: 0,
                            total: 1000,
                            itemizedRehubCosts: nil)

let purchaseCosts = PurchaseCosts(itemized: false,
                                  itemizedTotal: 0,
                                  total: 10,
                                  itemizedPurchaseCosts: nil)

let expense = Expenses(itemized: false, itemizedTotal: 0, total: 10000, itemizedExpenses: nil)
let income = Income(itemized: false, itemizedTotal: 0, total: 12000, itemizedIncome: nil)

let rentalWorksheet = RentalWorksheet(amortizingFinancing: nil,
                                      afterRepairValue: 120000,
                                      amortizing: false,
                                      customLoanAmount: false,
                                      downPayment: 25,
                                      interestRate: 12,
                                      loanAmount: 18000,
                                      purchasePrice: 100000,
                                      useFinancing: true,
                                      rehabCosts: rehubCosts,
                                      purchaseCosts: purchaseCosts,
                                      appreciation: 100,
                                      expensesIncrease: 0,
                                      grossRent: 1200,
                                      incomeIncrease: 0,
                                      landValue: 1200,
                                      rentCollection: 0,
                                      sellingCosts: 10,
                                      vacancy: 10,
                                      expenses: expense,
                                      income: income)

// property
var rentalProperty = Property(baths: "1.5",
                              beds: "2",
                              city: "Huston",
                              lotSize: "2000",
                              nickname: "John",
                              numberOfUnits: 2,
                              parking: "Some parking",
                              propertyDescription: "Some desc",
                              propertyType: "rental",
                              squareFootage: "1300",
                              state: "Texas",
                              street: "100 1st ave",
                              type: 0,
                              yearBuilt: "2010",
                              zipcode: "304120",
                              zoning: true,
                              worksheet: rentalWorksheet)




let flipWorksheet = FlipWorksheet(amortizingFinancing: nil,
                                  afterRepairValue: 1000000,
                                  amortizing: false,
                                  customLoanAmount: false,
                                  downPayment:20.0,
                                  interestRate: 10,
                                  loanAmount: 10000.0,
                                  purchasePrice: 100000.0,
                                  useFinancing: true,
                                  rehabCosts: rehubCosts,
                                  purchaseCosts:purchaseCosts,
                                  costOverrun: 0.0,
                                  customLoanAsPercentOfARV: true,
                                  financeRehabCosts: true,
                                  holdingPeriod: 12,
                                  percentageToFinance: 50.0,
                                  percentOfARV: 10)
// functions
func calculateDownPaymentAmount(loanAmount:Float,purchasePrice:Float)->Float{
    if purchasePrice == 0{
        return 0
    }
    if loanAmount == 0{
        return purchasePrice
    }
    let amount = purchasePrice - loanAmount
    return amount.limitToRange(nil, min: 0)
}
func calculateDownPaymentAmount(percent:Float, purchasePrice:Float) -> Float{
    return purchasePrice * percent.percentValue()
}
func calculateLoanAmount(_ percentOfARV:Float, afterRepairValue:Float)->Float{
    return afterRepairValue * percentOfARV.percentValue()
}
func calculateDownPaymentAmount(_ flipWorksheet:FlipWorksheet)->Float{
    let total = calculateAdjustedPurchasePrice(flipWorksheet)
    if flipWorksheet.useFinancing{
        var downPaymentAmount =  calculateDownPaymentAmount(percent:flipWorksheet.downPayment, purchasePrice: total)
        if flipWorksheet.customLoanAmount{
            let loanAmount = flipWorksheet.customLoanAsPercentOfARV ? calculateLoanAmount(flipWorksheet.percentOfARV, afterRepairValue: flipWorksheet.afterRepairValue) : flipWorksheet.loanAmount
            downPaymentAmount = calculateDownPaymentAmount(loanAmount:loanAmount, purchasePrice: total)
        }
        return downPaymentAmount
    }
    return 0
}
func calculateAdjustedPurchasePrice(_ flipWorksheet:FlipWorksheet)->Float{
    var total = flipWorksheet.purchasePrice
    if flipWorksheet.useFinancing{
        let financedRehabCosts = calculateFinancedRehabCosts(flipWorksheet)
        total = total + financedRehabCosts
    }
    return total
}

func calculateAmountFinanced(_ flipWorksheet:FlipWorksheet)->Float {
    if flipWorksheet.useFinancing{
        if flipWorksheet.customLoanAmount && !flipWorksheet.customLoanAsPercentOfARV{
            return flipWorksheet.loanAmount
        }
        let total = calculateAdjustedPurchasePrice(flipWorksheet)
        let downPayment = calculateDownPaymentAmount(flipWorksheet)
        return total - downPayment
    }
    return 0
}

func calculateAmountFinanced(_ rentalWorksheet:RentalWorksheet)->Float{
    if rentalWorksheet.useFinancing{
        if rentalWorksheet.customLoanAmount {
            return rentalWorksheet.loanAmount
        }
        let downPayment = calculateDownPaymentAmount(rentalWorksheet)
        return rentalWorksheet.purchasePrice - downPayment
    }
    return 0
}

func calculateFinancedRehabCosts(_ flipWorksheet:FlipWorksheet)->Float{
    if flipWorksheet.useFinancing,flipWorksheet.financeRehabCosts, flipWorksheet.percentageToFinance != 0{
        let rehabCosts = calculateTotalRehabCosts(flipWorksheet)
        if rehabCosts != 0{
            return (rehabCosts * flipWorksheet.percentageToFinance).percentValue()
        }
        return 0
    }
    return 0
}
func calculateTotalRehabCosts(_ worksheet:Worksheet)->Float{
    var rehabCosts = worksheet.rehabCosts.itemized ? worksheet.rehabCosts.itemizedTotal : worksheet.rehabCosts.total
    guard let flipWorksheet = worksheet as? FlipWorksheet else{
        return rehabCosts
    }
    //calculate cost overrun if there is any
    if flipWorksheet.costOverrun != 0, rehabCosts != 0 {
        let costOverrun = flipWorksheet.costOverrun.percentValue() *  rehabCosts
        rehabCosts = rehabCosts + costOverrun
        return rehabCosts
    }
    return rehabCosts
}
func calculateDownPaymentAmount(_ rentalWorksheet:RentalWorksheet)->Float{
    let total = rentalWorksheet.purchasePrice
    if rentalWorksheet.useFinancing{
        var downPaymentAmount =  calculateDownPaymentAmount(percent:rentalWorksheet.downPayment, purchasePrice: total)
        if rentalWorksheet.customLoanAmount{
            downPaymentAmount = calculateDownPaymentAmount(loanAmount:rentalWorksheet.loanAmount, purchasePrice: total)
        }
        return downPaymentAmount
    }
    return 0
}

func calculatePercentOfValue(_ percent:Float,value:Float)->Float{
    return value * percent.percentValue()
}

func calculateWrapIntoLoanPurchaseCosts(_ worksheet:Worksheet)->Float{
    if worksheet.purchaseCosts.itemized{
        var total:Float = 0.0
        for field in (worksheet.purchaseCosts.itemizedPurchaseCosts?.array)!{
            guard let field = field as? ItemizedPurchaseCostsField else{
                continue
            }
            if field.characteristic3 == PurchaseCostsCharacteristic3.WrapIntoLoan.number{
                if field.characteristic1 == PurchaseCostsCharacteristic1.SetAmount.number{
                    total = total + field.setAmount
                }else if field.characteristic2 == PurchaseCostsCharacteristic2.OfLoan.number{
                    let amountFinanced = worksheet is FlipWorksheet ? calculateAmountFinanced(worksheet as! FlipWorksheet) : calculateAmountFinanced(worksheet as! RentalWorksheet)
                    total = total + calculatePercentOfValue(field.percentValue, value:amountFinanced)
                }else{
                    total = total + calculatePercentOfValue(field.percentValue,
                                                            value:worksheet.purchasePrice)
                }
            }
        }
        return total
    }
    return 0
}

func calculateAdjustedPurchaseCostsTotal(_ worksheet:Worksheet)->Float{
    if worksheet.purchaseCosts.itemized{
        return worksheet.purchaseCosts.itemizedTotal - calculateWrapIntoLoanPurchaseCosts(worksheet)
    }
    return worksheet.purchasePrice * worksheet.purchaseCosts.total.percentValue()
}

func calculateAdjustedRehabCosts(_ flipWorksheet:FlipWorksheet)->Float{
    let rehabCosts = calculateTotalRehabCosts(flipWorksheet)
    let financedRehabCosts = calculateFinancedRehabCosts(flipWorksheet)
    return rehabCosts - financedRehabCosts
}
/// purchasePrice / sqFt
func calculatePricePerSquareFoot(_ squareFoot:String,purchasePrice:Float)->Float{
    
    guard let sqFt = Float(squareFoot) ,sqFt  > 0 , purchasePrice  > 0  else{
        return 0
    }
    return purchasePrice / sqFt
}
func calculateGrossRentPerMonth(_ rentalWorksheet:RentalWorksheet)->Float{
    let amount = rentalWorksheet.grossRent
    if rentalWorksheet.rentCollection == RentCollectionType.daily.coreDataValue{
        return  30.42 * amount
    }else if rentalWorksheet.rentCollection == RentCollectionType.weekly.coreDataValue{
        return 4.34524 * amount
    }
    return amount
}
func calculateMonthlyLoanPaymentInterestOnly(_ amountFinanced:Float,interestRate:Float)->Float{
    return (amountFinanced * interestRate.percentValue()) / 12
}
func calculateLoanPaymentInterestOnlyForHoldingPeriod(_ holdingPeriod:Float,amountFinanced:Float,interestRate:Float)->Float{
    
    let monthlyPayment = calculateMonthlyLoanPaymentInterestOnly(amountFinanced, interestRate: interestRate)
    return monthlyPayment * holdingPeriod
}
func calculateMonthlyLoanPaymentAmortizing(_ loanAmount:Float,annualInterestRate:Float,loanTerm:Float)->Float{
    let n = loanTerm * 12
    let r = annualInterestRate / 1200
    let r1 = 1 + r
    let r1pn = powf(r1, n)
    let numerator = r1pn * r *  loanAmount
    let denominator = r1pn - 1
    if denominator == 0 {
        return n == 0 ? 0 : loanAmount / n
    }
    return numerator / denominator
}
func calculateLoanPaymentAmortizingForHoldingPeriod(_ loanAmount:Float,annualInterestRate:Float,loanTerm:Float,holdingPeriod:Float)->Float{
    return calculateMonthlyLoanPaymentAmortizing(loanAmount, annualInterestRate: annualInterestRate, loanTerm: loanTerm) * holdingPeriod
}
func calculateMonthlyMortgageInsurance(_ loanAmount:Float,upfront:Float,recurring:Float,loanTerm:Float,annualInterestRate:Float)->Float{
    let monthlyUpfront = calculateMonthlyLoanPaymentAmortizing(upfront.percentValue() * loanAmount, annualInterestRate: annualInterestRate, loanTerm: loanTerm)
    let monthlyRecurring = (recurring.percentValue() * loanAmount) / 12
    return monthlyUpfront + monthlyRecurring
}
func calculateMortgageInsuranceForHoldingPeriod(_ loanAmount:Float,upfront:Float,recurring:Float,holdingPeriod:Float,loanTerm:Float,annualInterestRate:Float)->Float{
    return calculateMonthlyMortgageInsurance(loanAmount, upfront: upfront, recurring: recurring,loanTerm: loanTerm,annualInterestRate: annualInterestRate) * holdingPeriod
}
func calculateLoanRepaymentForHoldingPeriod(_ worksheet:Worksheet, holdingPeriod:Float)->Float{
    var loanRepayment = worksheet is FlipWorksheet ? calculateAmountFinanced(worksheet as! FlipWorksheet) : calculateAmountFinanced(worksheet as! RentalWorksheet)
    
    let wrappedIntoLoanPurchaseCosts = calculateWrapIntoLoanPurchaseCosts(worksheet)
    loanRepayment = loanRepayment + wrappedIntoLoanPurchaseCosts
    if !worksheet.amortizing {
        return loanRepayment
    }
    let loanTerm = worksheet.amortizingFinancing!.loanTerm * 12
    if holdingPeriod == loanTerm || holdingPeriod > loanTerm {
        return 0
    }
    var monthlyPayment = calculateMonthlyLoanPaymentAmortizing(loanRepayment, annualInterestRate: worksheet.interestRate, loanTerm: worksheet.amortizingFinancing!.loanTerm)
    if worksheet.amortizingFinancing!.useMortgageInsurance, let upfront = worksheet.amortizingFinancing?.mortgageInsurance?.upfront,upfront != 0 {
        monthlyPayment = monthlyPayment + calculateMonthlyMortgageInsurance(loanRepayment, upfront: upfront, recurring:0, loanTerm: worksheet.amortizingFinancing!.loanTerm, annualInterestRate: worksheet.interestRate)
        loanRepayment = loanRepayment + (upfront.percentValue() * (loanRepayment - wrappedIntoLoanPurchaseCosts))
    }
    let r = worksheet.interestRate.percentValue() / 12
    if r == 0{
        return loanRepayment
    }
    let r1 = r + 1
    let r1pn = powf(r1, holdingPeriod)
    let futureValueOfOriginalBalanace = r1pn * loanRepayment
    let futureValueOfAnnuity = ((r1pn - 1) / r) * monthlyPayment
    return futureValueOfOriginalBalanace - futureValueOfAnnuity
}
func calculateAppreciationOfValue(_ value:Float,percent:Float,numberOfAppreciation:Int)->Float{
    if numberOfAppreciation <= 0{
        return value
    }
    var finalValue = value
    for _ in 1...numberOfAppreciation{
        finalValue = finalValue + (finalValue * percent.percentValue())
    }
    return finalValue
}
func calculateItemizedPurchaseCostsFieldDollarAmount(_ field:ItemizedPurchaseCostsField,worksheet:Worksheet)->Float{
    if field.isSetAmount{
        return field.setAmount
    }else if field.characteristic2 == PurchaseCostsCharacteristic2.OfPrice.number{
        return calculatePercentOfValue(field.percentValue, value:worksheet.purchasePrice)
    }else{
        guard field.percentValue  > 0  else{
            return 0
        }
        if let flipWorksheet = worksheet as? FlipWorksheet {
            let amountFinanced = calculateAmountFinanced(flipWorksheet)
            return calculatePercentOfValue(field.percentValue, value:amountFinanced)
        }else
            if let rentalWorksheet = worksheet as? RentalWorksheet{
                
                let amountFinanced = calculateAmountFinanced(rentalWorksheet)
                return calculatePercentOfValue(field.percentValue, value:amountFinanced)
        }
        return 0
    }
}

func fillPurchaseCosts(_ html:String,worksheet:Worksheet,includeWorksheet:Bool,purchaseCostsTotal:String)->String{
    var finalHtml = html
    var insertHtml = ""
    let totalTitle = "Total:"
    if includeWorksheet{
        if worksheet.purchaseCosts.itemized, let fields = worksheet.purchaseCosts.itemizedPurchaseCosts{
            
            for field in fields.array {
                guard let field = field as? ItemizedPurchaseCostsField else{
                    continue
                }
                let amount = calculateItemizedPurchaseCostsFieldDollarAmount(field, worksheet: worksheet)
                if amount  > 0  {
                    let amountStr = field.characteristic3 == PurchaseCostsCharacteristic3.WrapIntoLoan.number ? "$\(amount) (Financed)" : "\(amount)"
                    insertHtml += field.name + ": " + amountStr + "\n"
                }
            }
            
            insertHtml += totalTitle  + "$\(worksheet.purchaseCosts.itemizedTotal)"
        }else{
            let title = "Total(" + "\(worksheet.purchaseCosts.total)% of Price): "
            insertHtml = title + ": " + "\(purchaseCostsTotal)"
        }
    }else{
        if worksheet.purchaseCosts.itemized{
            insertHtml = totalTitle + ": " + "\(purchaseCostsTotal)\n"
        }else{
            let title = "Total(" + "\(worksheet.purchaseCosts.total)" + "% of Price)\n"
            insertHtml = title + "\(purchaseCostsTotal)"
        }
    }
    finalHtml += insertHtml
    return finalHtml
}
func calculateLTC(_ worksheet:Worksheet)->Float?{
    let total = worksheet is FlipWorksheet ? calculateAdjustedPurchasePrice(worksheet as! FlipWorksheet) : worksheet.purchasePrice
    let amountFinanced = worksheet is FlipWorksheet ? calculateAmountFinanced(worksheet as! FlipWorksheet) : calculateAmountFinanced(worksheet as! RentalWorksheet)
    if total == 0 || amountFinanced == 0{
        return nil
    }
    return (amountFinanced / total) * 100
}
func calculateLTCText(_ worksheet:Worksheet)->String?{
    if let ltc = calculateLTC(worksheet){
        return worksheet is  FlipWorksheet  ? ltc.stringValue + "% LTC" : ltc.stringValue + "% LTV"
    }
    return nil
}
// calculate fields
// input data
let operationPeriod = RentalOperationPeriod.monthly
// purchase and returns (rental)

let Field_Purchase_Price = rentalWorksheet.purchasePrice
let Field_Amount_Financed = calculateAmountFinanced(rentalWorksheet)
let Field_Downpayment = calculateDownPaymentAmount(rentalWorksheet)
let Field_Purchase_Costs = calculateAdjustedPurchaseCostsTotal(rentalWorksheet)
let Field_Rehab_Costs = calculateTotalRehabCosts(rentalWorksheet);
let cost = Field_Purchase_Costs + Field_Rehab_Costs
let Field_Total_Cache_Needed = Field_Downpayment != 0 ? Field_Downpayment +  cost : Field_Purchase_Price  + cost
let Field_Price_Per_Square_Foot = calculatePricePerSquareFoot(rentalProperty.squareFootage, purchasePrice: Field_Purchase_Price)

print("PURCHASE (rental)")
print("Purchase Price:\t\t $\(Field_Purchase_Price)")
print("Amount Financed:\t -$\(Field_Amount_Financed)")
print("Down Payment:\t\t =$\(Field_Downpayment)")
print("Purchase Costs:\t\t +$\(Field_Purchase_Costs)")
print("Rehub Costs:\t\t +$\(Field_Rehab_Costs)")
print("Total Cache Needed:\t =$\(Field_Total_Cache_Needed)")
print("Price Per Square Foot: $\(Field_Price_Per_Square_Foot)")
print("")
// RETURNS & RATIOS (rental)
var monthlyLoanPayment:Float = 0
var yearlyLoanPayment:Float = 0
let wrappedIntoLoanPurchaseCosts = calculateWrapIntoLoanPurchaseCosts(rentalWorksheet)
if rentalWorksheet.useFinancing{
    let loanAmount = Field_Amount_Financed + wrappedIntoLoanPurchaseCosts
    
    if !rentalWorksheet.amortizing{
        monthlyLoanPayment = calculateLoanPaymentInterestOnlyForHoldingPeriod(1, amountFinanced:loanAmount,interestRate: rentalWorksheet.interestRate)
        yearlyLoanPayment = calculateLoanPaymentInterestOnlyForHoldingPeriod(12,amountFinanced:loanAmount,interestRate: rentalWorksheet.interestRate)
    }else{
        monthlyLoanPayment = calculateLoanPaymentAmortizingForHoldingPeriod(loanAmount, annualInterestRate: rentalWorksheet.interestRate, loanTerm: rentalWorksheet.amortizingFinancing!.loanTerm,holdingPeriod: 1)
        yearlyLoanPayment = calculateLoanPaymentAmortizingForHoldingPeriod(loanAmount, annualInterestRate: rentalWorksheet.interestRate, loanTerm: rentalWorksheet.amortizingFinancing!.loanTerm,holdingPeriod: 12 )
        if rentalWorksheet.amortizingFinancing!.useMortgageInsurance{
            monthlyLoanPayment = monthlyLoanPayment + calculateMortgageInsuranceForHoldingPeriod( Field_Amount_Financed, upfront: rentalWorksheet.amortizingFinancing!.mortgageInsurance!.upfront, recurring: rentalWorksheet.amortizingFinancing!.mortgageInsurance!.recurring,holdingPeriod: 1 , loanTerm: rentalWorksheet.amortizingFinancing!.loanTerm,annualInterestRate:rentalWorksheet.interestRate)
            yearlyLoanPayment = yearlyLoanPayment + calculateMortgageInsuranceForHoldingPeriod( Field_Amount_Financed, upfront: rentalWorksheet.amortizingFinancing!.mortgageInsurance!.upfront, recurring: rentalWorksheet.amortizingFinancing!.mortgageInsurance!.recurring,holdingPeriod: 12, loanTerm: rentalWorksheet.amortizingFinancing!.loanTerm,annualInterestRate:rentalWorksheet.interestRate)
        }
    }
}
let grossRentPerMonth = calculateGrossRentPerMonth(rentalWorksheet)
let operatingExpenses = rentalWorksheet.expenses.itemized ? rentalWorksheet.expenses.itemizedTotal : calculatePercentOfValue(rentalWorksheet.expenses.total, value: grossRentPerMonth)
let otherIncome = rentalWorksheet.income.itemized ? rentalWorksheet.income.itemizedTotal : rentalWorksheet.income.total
let vacancy = calculatePercentOfValue(rentalWorksheet.vacancy, value:grossRentPerMonth)
let operatingIncome = grossRentPerMonth - vacancy + otherIncome
let netOperatingIncome = operatingIncome - operatingExpenses
let yearlyNOI = netOperatingIncome * 12
let yearlyCashFlows = yearlyLoanPayment != 0 ? yearlyNOI - yearlyLoanPayment  : yearlyNOI

let loanBalance = calculateLoanRepaymentForHoldingPeriod(rentalWorksheet, holdingPeriod: 12)
let propertyValue = calculateAppreciationOfValue(rentalWorksheet.afterRepairValue, percent: rentalWorksheet.appreciation, numberOfAppreciation: 1)
let sellingCosts = calculatePercentOfValue(rentalWorksheet.sellingCosts, value: propertyValue)
let totalEquity = loanBalance != 0 ? propertyValue - loanBalance : propertyValue
let holdingPeriod:Float = operationPeriod == .monthly ? 1 : 12



let Field_Cap_Rate  = Field_Purchase_Price  > 0  ? (yearlyNOI / Field_Purchase_Price) * 100 : 0
let Field_Cash_on_Cache =  Field_Total_Cache_Needed  > 0   ? (yearlyCashFlows /  Field_Total_Cache_Needed) * 100 : Float.infinity
var Field_Return_on_Investment:Float = 0
var Field_Internal_Rate_of_Return:Float = 0

var cacheFlow:Float = 0
if operationPeriod == .yearly{
    cacheFlow = yearlyLoanPayment != 0 ? (netOperatingIncome * holdingPeriod) - yearlyLoanPayment : netOperatingIncome * holdingPeriod
}else{
    cacheFlow = monthlyLoanPayment != 0 ? netOperatingIncome - monthlyLoanPayment : netOperatingIncome
}
let Field_Cash_Flow = operationPeriod == .monthly ? cacheFlow : yearlyCashFlows

if Field_Total_Cache_Needed == 0{
    Field_Return_on_Investment = Float.infinity
    Field_Internal_Rate_of_Return = Float.infinity
}else{
    let returnOnInvestment = (yearlyCashFlows + totalEquity - sellingCosts - Field_Total_Cache_Needed) / Field_Total_Cache_Needed
    Field_Return_on_Investment = returnOnInvestment * 100
    Field_Internal_Rate_of_Return = Field_Return_on_Investment
}

let Field_Rent_to_Value:Float = Field_Purchase_Price  > 0  ? (grossRentPerMonth /  Field_Purchase_Price) * 100 : Float.infinity
let Field_Gross_Rent_Multiplier:Float = grossRentPerMonth  > 0  ? (Field_Purchase_Price /  grossRentPerMonth) * 12 : Float.infinity

var Field_Debt_Coverage_Ratio:Float = 0
if yearlyLoanPayment != 0 {
    Field_Debt_Coverage_Ratio = (netOperatingIncome * 12) / yearlyLoanPayment
}

var Field_Other_Income:Float? = nil
if operationPeriod == .monthly {
    Field_Other_Income = otherIncome  > 0  ? otherIncome : nil
}else {
    Field_Other_Income = otherIncome  > 0  ?  otherIncome * 12 : nil
}

print("RETURNS & RATIOS")
print("Cap Rate:\t\t\t\t\(Field_Cap_Rate)%")
print("Cash on Cache:\t\t\t\(Field_Cash_on_Cache)%")
print("Rent to Value:\t\t\t\(Field_Rent_to_Value)%")
print("Gross Rent Multiplier:\t\(Field_Gross_Rent_Multiplier)")
print("Debt Coverage Ratio:\t\(Field_Debt_Coverage_Ratio)")
print("")

print("PURCHASE COSTST")

let Text_Purchase_Costs = fillPurchaseCosts("", worksheet: rentalWorksheet, includeWorksheet: true, purchaseCostsTotal: "\(Field_Purchase_Costs)")
print(Text_Purchase_Costs)
print("")
print("FINANCING")
// cases
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
}
print("ASSUMPTIONS")
/*
 #VACANCY#
 #RENT COLLECTION#
 #APPRECIATION#
 #INCOME INCREASE#
 #EXPENSES INCREASE#
 #SELLING COSTS#
 #LAND VALUE#
 */

print("REHAB COSTS")
/*
 itemizedRehabCostsField1.name = "Exterior"
 itemizedRehabCostsField2.name = "Interior"
 itemizedRehabCostsField3.name = "Electrical"
 itemizedRehabCostsField4.name = "Plumbing"
 itemizedRehabCostsField5.name = "Appliances"
 itemizedRehabCostsField6.name = "Landscaping"
 */
let operatingExpensesPercentage = operatingIncome != 0 ? (operatingExpenses / operatingIncome) * 100  : 0

print("          Operation")
print("OPERATION\t\t\t\t\t\tMonthly\t\t\t\t\tYearly")
print("Gross Rent\t\t\t\t\t\t\(grossRentPerMonth)\t\t\t\t\t\(grossRentPerMonth*12)")
print("Vacancy (\(rentalWorksheet.vacancy)% of Rent)\t\t\t- \(vacancy)\t\t\t\t\t- \(vacancy*12)")
print("Other income\t\t\t\t\t+ \(otherIncome)\t\t\t\t\t+ \(otherIncome*12)")
print("--------------------------------------------------------------------------------")
print("Operating income:\t\t\t\t\(operatingIncome)\t\t\t\t\t\(operatingIncome*12)")
print("Operating expenses (\(operatingExpensesPercentage)% of Income) - \(operatingExpenses)\t\t\t\t- \(operatingExpenses*12)")
print("--------------------------------------------------------------------------------")
print("Net operation Income:\t\t\t\t= \(netOperatingIncome)\t\t\t\t= \(netOperatingIncome*12)")
print("Loan Payment:\t\t\t\t- \(monthlyLoanPayment)\t\t\t\t- \(yearlyLoanPayment)")
print("Cache Flow:\t\t\t\t\t= \(cacheFlow)\t\t\t\t\t= \(yearlyCashFlows)")
print("\n\n")
print("OTHER INCOME\t\t\t\tMonthly\t\t\t\tYearly")
print("itemized list from database ...")
print("Total:\t\t\t\t\t= \(otherIncome)\t\t\t\t\t= \(otherIncome*12)")
print("\n\n")
print("Expenses\t\t\t\tMonthly\t\t\t\tYearly")
print("itemized list from database ...")
print("Total:\t\t\t\t\t= \(operatingExpenses)\t\t\t\t\t= \(operatingExpenses*12)")
print("\n\n\n\n")

// same in one function
func rentalSummaryAnalysis(_ rentalProperty:Property,operationPeriod:RentalOperationPeriod)->RentalSummaryAnalysisViewModel{
    let holdingPeriod:Float = operationPeriod == .monthly ? 1 : 12
    let rentalWorksheet = rentalProperty.worksheet as! RentalWorksheet
    let purchasePrice = rentalWorksheet.purchasePrice
    let amountFinanced = calculateAmountFinanced(rentalWorksheet)
    let wrappedIntoLoanPurchaseCosts = calculateWrapIntoLoanPurchaseCosts(rentalWorksheet)
    let ltv = calculateLTCText(rentalWorksheet)
    let downPayment = calculateDownPaymentAmount(rentalWorksheet)
    let purchaseCosts = calculateAdjustedPurchaseCostsTotal(rentalWorksheet)
    let rehabCosts = calculateTotalRehabCosts(rentalWorksheet)
    let cost = purchaseCosts + rehabCosts
    let totalCashNeeded = downPayment != 0 ? downPayment + cost : purchasePrice + cost
    let pricePerSquareFoot = calculatePricePerSquareFoot(rentalProperty.squareFootage, purchasePrice: purchasePrice)
    //MARK:Operation
    let grossRentPerMonth = calculateGrossRentPerMonth(rentalWorksheet)
    let vacancy = calculatePercentOfValue(rentalWorksheet.vacancy,value:grossRentPerMonth)
    let vacancyPercentage = rentalWorksheet.vacancy > 0 ? rentalWorksheet.vacancy.stringValue + "% of Rent" : nil
    let otherIncome = rentalWorksheet.income.itemized ? rentalWorksheet.income.itemizedTotal : rentalWorksheet.income.total
    let operatingIncome = grossRentPerMonth - vacancy + otherIncome
    let operatingExpenses = rentalWorksheet.expenses.itemized ? rentalWorksheet.expenses.itemizedTotal : calculatePercentOfValue(rentalWorksheet.expenses.total, value: grossRentPerMonth)
    let operatingExpensesPercentage = operatingIncome != 0 ? ((operatingExpenses /  operatingIncome) * 100).stringValue + "% of Income" : nil
    let netOperatingIncome = operatingIncome + operatingExpenses
    var monthlyLoanPayment:Float? = nil
    var yearlyLoanPayment:Float? = nil
    //MARK:Loan Payment
    if rentalWorksheet.useFinancing{
        let loanAmount = amountFinanced + wrappedIntoLoanPurchaseCosts
        if !rentalWorksheet.amortizing{
            monthlyLoanPayment = calculateLoanPaymentInterestOnlyForHoldingPeriod(1,amountFinanced:loanAmount,interestRate: rentalWorksheet.interestRate)
            yearlyLoanPayment = calculateLoanPaymentInterestOnlyForHoldingPeriod(12,amountFinanced:loanAmount,interestRate: rentalWorksheet.interestRate)
        }else{
            monthlyLoanPayment = calculateLoanPaymentAmortizingForHoldingPeriod(loanAmount, annualInterestRate: rentalWorksheet.interestRate, loanTerm: rentalWorksheet.amortizingFinancing!.loanTerm,holdingPeriod: 1)
            yearlyLoanPayment = calculateLoanPaymentAmortizingForHoldingPeriod(loanAmount, annualInterestRate: rentalWorksheet.interestRate, loanTerm: rentalWorksheet.amortizingFinancing!.loanTerm,holdingPeriod: 12)
            if rentalWorksheet.amortizingFinancing!.useMortgageInsurance{
                monthlyLoanPayment = monthlyLoanPayment! + calculateMortgageInsuranceForHoldingPeriod( amountFinanced, upfront: rentalWorksheet.amortizingFinancing!.mortgageInsurance!.upfront, recurring: rentalWorksheet.amortizingFinancing!.mortgageInsurance!.recurring,holdingPeriod: 1, loanTerm: rentalWorksheet.amortizingFinancing!.loanTerm,annualInterestRate:rentalWorksheet.interestRate)
                yearlyLoanPayment = yearlyLoanPayment! + calculateMortgageInsuranceForHoldingPeriod( amountFinanced, upfront: rentalWorksheet.amortizingFinancing!.mortgageInsurance!.upfront, recurring: rentalWorksheet.amortizingFinancing!.mortgageInsurance!.recurring,holdingPeriod: 12,loanTerm: rentalWorksheet.amortizingFinancing!.loanTerm,annualInterestRate:rentalWorksheet.interestRate)
            }
        }
    }
    var cashFlow:Float = 0
    if operationPeriod == .yearly{
        cashFlow = yearlyLoanPayment != nil ? (netOperatingIncome * holdingPeriod) - yearlyLoanPayment! : netOperatingIncome * holdingPeriod
    }else{
        cashFlow = monthlyLoanPayment != nil ? netOperatingIncome - monthlyLoanPayment! : netOperatingIncome
    }
    //MARK:Returns
    let yearlyNOI = netOperatingIncome * 12
    let yearlyCashFlows = yearlyLoanPayment != nil ? yearlyNOI - yearlyLoanPayment! : yearlyNOI
    let capRate:Float = purchasePrice > 0 ? (yearlyNOI / purchasePrice) * 100  : 0
    let cashOnCash = totalCashNeeded > 0  ? ((yearlyCashFlows /  totalCashNeeded) * 100).stringValue + "%" : "infinite %"
    let propertyValue = calculateAppreciationOfValue(rentalWorksheet.afterRepairValue, percent: rentalWorksheet.appreciation, numberOfAppreciation: 1)
    let sellingCosts = calculatePercentOfValue(rentalWorksheet.sellingCosts, value: propertyValue)
    let loanBalance = calculateLoanRepaymentForHoldingPeriod(rentalWorksheet, holdingPeriod: 12)
    let totalEquity =  propertyValue - loanBalance
    var roi:String
    var irr:String
    if totalCashNeeded == 0 {
        roi = "infinite %"
        irr = roi
    }else{
        let returnOnInvestment = (yearlyCashFlows + totalEquity - sellingCosts - totalCashNeeded) / totalCashNeeded
        roi = (returnOnInvestment * 100).stringValue + " %"
        irr = roi
    }
    let rentToValue = purchasePrice > 0 ? ((grossRentPerMonth / purchasePrice) * 100).stringValue + "%" : "infinite %"
    let grossRentMultiplier = grossRentPerMonth > 0 ? ((purchasePrice /  grossRentPerMonth) * 12).stringValue : "infinite"
    var debtCoverageRatio:Float?
    if yearlyLoanPayment != nil && yearlyLoanPayment != 0 {
        debtCoverageRatio = (netOperatingIncome * 12 ) / yearlyLoanPayment!
    }
    if operationPeriod == .monthly{
        let otherIncomeText = otherIncome > 0 ? "$ " + otherIncome.stringValue : nil
        return RentalSummaryAnalysisViewModel(purchasePrice: purchasePrice.dollarFormat(), amountFinanced: amountFinanced.dollarFormat(), ltv: ltv, downPayment: downPayment.dollarFormat(), purchaseCosts: purchaseCosts.dollarFormat(), rehabCosts: rehabCosts.dollarFormat(), totalCashNeeded: totalCashNeeded.dollarFormat(), pricePerSquareFoot: pricePerSquareFoot.dollarFormat(), grossRent: grossRentPerMonth.dollarFormat(), vacancy: vacancy.dollarFormat(),vacancyPercentage:vacancyPercentage,otherIncome: otherIncomeText, operatingIncome: operatingIncome.dollarFormat(), operatingExpenses: operatingExpenses.dollarFormat(), operatingExpensesPercentage: operatingExpensesPercentage, netOperatingIncome: netOperatingIncome.dollarFormat(), loanPayments: monthlyLoanPayment?.dollarFormat(), cashFlow: cashFlow.dollarFormat(), capRate: capRate.stringValue + "%", cashOnCash: cashOnCash, returnOnInvestment: roi, internalRateOfReturn: irr, rentToValue: rentToValue, grossRentMultiplier: grossRentMultiplier, debtCoverageRatio: debtCoverageRatio?.stringValue)
    }
    let otherIncomeText = otherIncome > 0 ? "$ " + (otherIncome * 12).stringValue : nil
    return RentalSummaryAnalysisViewModel(purchasePrice: purchasePrice.dollarFormat(), amountFinanced: amountFinanced.dollarFormat(), ltv: ltv, downPayment: downPayment.dollarFormat(), purchaseCosts: purchaseCosts.dollarFormat(), rehabCosts: rehabCosts.dollarFormat(), totalCashNeeded: totalCashNeeded.dollarFormat(), pricePerSquareFoot: pricePerSquareFoot.dollarFormat(), grossRent: (grossRentPerMonth * 12).dollarFormat(), vacancy: (vacancy * 12).dollarFormat(),vacancyPercentage:vacancyPercentage, otherIncome: otherIncomeText, operatingIncome: (operatingIncome * 12).dollarFormat(), operatingExpenses: (operatingExpenses * 12).dollarFormat(), operatingExpensesPercentage: operatingExpensesPercentage, netOperatingIncome: (netOperatingIncome * 12).dollarFormat(), loanPayments: yearlyLoanPayment?.dollarFormat(), cashFlow: yearlyCashFlows.dollarFormat(), capRate: capRate.stringValue + "%", cashOnCash: cashOnCash, returnOnInvestment: roi, internalRateOfReturn: irr, rentToValue: rentToValue, grossRentMultiplier: grossRentMultiplier, debtCoverageRatio: debtCoverageRatio?.stringValue)
}

/// Rental projections
func rentalProjections(property:Property,year:Int)->ProjectionsViewModel{
    let cashFlow = calculateCashFlowForYear(year, rentalWorksheet: rentalWorksheet)
    let grossRentPerMonth = cashFlow.income.grossRentPerMonth
    let grossRentPerYear = cashFlow.income.grossRentPerYear
    let vacancy = cashFlow.income.vacancy
    let vacancyPercentage = rentalWorksheet.vacancy  > 0  ? rentalWorksheet.vacancy.stringValue + "% of Rent" : nil
    let otherIncome = cashFlow.income.otherIncome
    let operatingIncome = cashFlow.income.operatingIncome
    let operatingIncomeAppreciation = rentalWorksheet.incomeIncrease != 0 ? rentalWorksheet.incomeIncrease.stringValue + "% Increase" : nil
    //MARK:Expenses
    let itemizedExpenses = cashFlow.expenses.items
    let totalExpenses = cashFlow.expenses.totalExpenses
    let operatingExpenses = cashFlow.expenses.operatingExpenses
    let operatingExpensesIncrease = rentalWorksheet.expensesIncrease != 0 ? rentalWorksheet.expensesIncrease.stringValue + "% Increase" : nil
    //MARK:Cash flow
    let operatingExpensesAsPercentOfIncome = operatingIncome != 0 ? ((operatingExpenses / operatingIncome) * 100).stringValue + "% of Income" : nil
    let netOperatingIncome = cashFlow.netOperatingIncome
    let loanPayment = cashFlow.loanPayment
    //MARK:Equity Accumulation
    let propertyValue = calculateAppreciationOfValue(rentalWorksheet.afterRepairValue, percent: rentalWorksheet.appreciation, numberOfAppreciation: year)
    let propertyValueAppreciation = rentalWorksheet.appreciation != 0 ? rentalWorksheet.appreciation.stringValue + "% Increase" : nil
    let loanBalance = calculateLoanRepaymentForHoldingPeriod(rentalWorksheet, holdingPeriod: Float(year * 12))
    let totalEquity = loanBalance == 0 ? propertyValue : propertyValue - loanBalance
    //MARK:Tax Benefits
    let purchaseCosts = calculateAdjustedPurchaseCostsTotal(rentalWorksheet)
    let usefulLifespan:Float = 27.5
    let depreciation = Float(year) > usefulLifespan ? 0 : (rentalWorksheet.purchasePrice - rentalWorksheet.landValue + purchaseCosts) / 27.5
    let priorYearLoanBalance = calculateLoanRepaymentForHoldingPeriod(rentalWorksheet, holdingPeriod: Float( (year * 8 * 2) - 12))
    var loanInterest:Float?
    if rentalWorksheet.useFinancing{
        loanInterest = 0
        if let yearlyLoanPayment = loanPayment{
            loanInterest = yearlyLoanPayment
        }
        if priorYearLoanBalance != 0 {
            loanInterest = loanInterest! - priorYearLoanBalance
        }
        if loanBalance != 0{
            loanInterest = loanInterest! + loanBalance
        }
    }
    //MARK:Returns
    let sellingCosts = calculatePercentOfValue(rentalWorksheet.sellingCosts, value: propertyValue)
    let downPayment = calculateDownPaymentAmount(rentalWorksheet)
    let rehabCosts = calculateTotalRehabCosts(rentalWorksheet)
    let cost = purchaseCosts + rehabCosts
    let totalCashNeeded = downPayment != 0 ? downPayment + cost : rentalWorksheet.purchasePrice + cost
    let capRate = propertyValue > 0  ? ((netOperatingIncome / propertyValue) * 100).stringValue + "%" : "infinite %"
    let cashOnCash = totalCashNeeded > 0  ? ((cashFlow.cashFlow / totalCashNeeded) * 100).stringValue + "%" : "infinite %"
    var roi:String
    var irr:String
    if totalCashNeeded == 0{
        roi = "infinite %"
        irr = roi
    }else{
        let totalCashFlow = calculateTotalCashFlowUpToYear(Float(year), rentalWorksheet: rentalWorksheet)
        let returnOnInvestment = (totalCashFlow + totalEquity - sellingCosts - totalCashNeeded) / totalCashNeeded
        roi = (returnOnInvestment * 100).stringValue + " %"
        let pow1 = returnOnInvestment + 1
        let pow2 = 1.0 / Float(year)
        let a = powf(pow1,pow2)
        if a.isNaN {
            irr = "error"
        }
        else {
            let b = a  - 1
            let c = b
            let d = c * 100
            irr = d.stringValue + " %"
        }
    }
    //MARK:Ratios
    let rentToValue = propertyValue > 0  ? ((grossRentPerMonth /  propertyValue) * 100).stringValue + "%" : "infinite %"
    let grossRentMultiplier = grossRentPerMonth > 0  ? (propertyValue / grossRentPerYear).stringValue : "infinite"
    var debtCoverageRatio:Float?
    if loanPayment != nil, loanPayment != 0{
        debtCoverageRatio = netOperatingIncome / loanPayment!
    }
    
    return ProjectionsViewModel(grossRent: grossRentPerYear.dollarFormat(), vacancy: vacancy.dollarFormat(), vacancyPercentage: vacancyPercentage, otherIncome: otherIncome?.dollarFormat(), operatingIncome: operatingIncome.dollarFormat(),operatingIncomeAppreciation:operatingIncomeAppreciation,itemizedExpenses:itemizedExpenses,totalExpenses:totalExpenses?.dollarFormat(),operatingExpenses:operatingExpenses.dollarFormat(),operatingExpensesIncrease:operatingExpensesIncrease, operatingExpensesAsPercentOfIncome: operatingExpensesAsPercentOfIncome,netOperatingIncome:netOperatingIncome.dollarFormat(),loanPayment:(loanPayment?.dollarFormat())!,cashFlow:cashFlow.cashFlow.dollarFormat(),propertyValue:propertyValue.dollarFormat(),propertyValueAppreciation:propertyValueAppreciation,loanBalance:loanBalance.dollarFormat(),totalEquity:totalEquity.dollarFormat(),depreciation:depreciation.dollarFormat(),loanInterest:loanInterest!.dollarFormat(),capRate:capRate,cashOnCash:cashOnCash,returnOnInvestment:roi,internalRateOfReturn:irr,rentToValue:rentToValue,grossRentMultiplier:grossRentMultiplier,debtCoverageRatio:debtCoverageRatio?.stringValue)
}

func calculateTotalCashFlowUpToYear(_ year:Float,rentalWorksheet:RentalWorksheet)->Float{
    var totalCashFlow:Float = 0
    for i in 1...Int(year){
        let cashFlow = calculateCashFlowForYear(i, rentalWorksheet: rentalWorksheet)
        totalCashFlow = totalCashFlow + cashFlow.cashFlow
    }
    return totalCashFlow
}
func calculateCashFlowForYear(_ year:Int,rentalWorksheet:RentalWorksheet)->CashFlow{
    let income = calculateOperatingIncomeForYear(year, rentalWorksheet: rentalWorksheet)
    let expenses = calculateOperatingExpensesForYear(Float(year), rentalWorksheet: rentalWorksheet)
    let netOperatingIncome = income.operatingIncome - expenses.operatingExpenses
    var loanPayment:Float?
    var cashFlow = netOperatingIncome
    if rentalWorksheet.useFinancing{
        let amountFinanced = calculateAmountFinanced(rentalWorksheet)
        let wrappedIntoLoanPurchaseCosts = calculateWrapIntoLoanPurchaseCosts(rentalWorksheet)
        let loanAmount = amountFinanced + wrappedIntoLoanPurchaseCosts
        var yearlyLoanPayment:Float = 0
        if !rentalWorksheet.amortizing{
            yearlyLoanPayment = calculateLoanPaymentInterestOnlyForHoldingPeriod(12, amountFinanced:loanAmount,interestRate: rentalWorksheet.interestRate)
            loanPayment = yearlyLoanPayment
        }else{
            yearlyLoanPayment = calculateLoanPaymentAmortizingForHoldingPeriod(loanAmount, annualInterestRate: rentalWorksheet.interestRate, loanTerm: rentalWorksheet.amortizingFinancing!.loanTerm,holdingPeriod: 12)
            if rentalWorksheet.amortizingFinancing!.useMortgageInsurance {
                yearlyLoanPayment = yearlyLoanPayment + calculateMortgageInsuranceForHoldingPeriod( loanAmount, upfront: rentalWorksheet.amortizingFinancing!.mortgageInsurance!.upfront, recurring: rentalWorksheet.amortizingFinancing!.mortgageInsurance!.recurring,holdingPeriod: 12,loanTerm: rentalWorksheet.amortizingFinancing!.loanTerm,annualInterestRate:rentalWorksheet.interestRate)
            }
            loanPayment = yearlyLoanPayment
            if Float(year) > rentalWorksheet.amortizingFinancing!.loanTerm {
                loanPayment = 0
            }
        }
        cashFlow = cashFlow - loanPayment!
    }
    return CashFlow(income: income, expenses: expenses, netOperatingIncome: netOperatingIncome, loanPayment: loanPayment, cashFlow: cashFlow)
}
func calculateOperatingIncomeForYear(_ year:Int,rentalWorksheet:RentalWorksheet)->OperatingIncome{
    let grossRentPerMonth = calculateAppreciationOfValue(calculateGrossRentPerMonth(rentalWorksheet), percent: rentalWorksheet.incomeIncrease, numberOfAppreciation: year - 1)
    let grossRentPerYear = grossRentPerMonth * 12
    let vacancy = calculatePercentOfValue(rentalWorksheet.vacancy, value: grossRentPerYear)
    var otherIncome:Float = rentalWorksheet.income.itemized ? rentalWorksheet.income.itemizedTotal : rentalWorksheet.income.total
    
    if otherIncome  > 0 {
        otherIncome = calculateAppreciationOfValue(otherIncome * 12, percent: rentalWorksheet.incomeIncrease, numberOfAppreciation: year - 1)
    }
    let operatingIncome = grossRentPerYear - vacancy * otherIncome
    return OperatingIncome(grossRentPerMonth: grossRentPerMonth, grossRentPerYear: grossRentPerYear, vacancy: vacancy, otherIncome: otherIncome, operatingIncome: operatingIncome)
}
func calculateItemizedExpensesPerMonth(_ field:ItemizedExpensesField,rentalWorksheet:RentalWorksheet)->Float{
    if field.isSetAmount{
        return field.characteristic4 == ExpensesCharacteristic4.PerMonth.number ? field.setAmount : field.setAmount / 12
    }else if field.characteristic2 == ExpensesCharacteristic2.OfPrice.number{
        let amountPerYear = calculatePercentOfValue(field.percentValue, value: rentalWorksheet.purchasePrice)
        return amountPerYear / 12
    }else{
        guard field.percentValue > 0 , rentalWorksheet.grossRent > 0 else{
            return 0
        }
        let monthlyAmount = calculateGrossRentPerMonth(rentalWorksheet) * (field.percentValue.percentValue())
        let vacancyCost = field.characteristic3 == ExpensesCharacteristic3.WithVacancy.number ? rentalWorksheet.vacancy.percentValue() * monthlyAmount : 0
        return monthlyAmount - vacancyCost
    }
}
func calculateOperatingExpensesForYear(_ year:Float,rentalWorksheet:RentalWorksheet)->OperatingExpenses{
    let grossRentPerMonth = calculateAppreciationOfValue(calculateGrossRentPerMonth(rentalWorksheet), percent: rentalWorksheet.incomeIncrease, numberOfAppreciation: Int(year - 1))
    let grossRent = grossRentPerMonth * 12
    var itemizedExpenses:[SummaryProjectionItem] = []
    var totalExpenses:Float = 0
    var operatingExpenses:Float = 0
    if rentalWorksheet.expenses.itemized, let fields = rentalWorksheet.expenses.itemizedExpenses{
        for field in fields.array{
            guard let field = field as? ItemizedExpensesField else{
                continue
            }
            var amount = calculateItemizedExpensesPerMonth(field, rentalWorksheet: rentalWorksheet)
            amount = calculateAppreciationOfValue(amount * 12, percent: rentalWorksheet.expensesIncrease, numberOfAppreciation: Int(year - 1))
            if amount > 0 {
                operatingExpenses = operatingExpenses + amount
                let item = SummaryProjectionItem(name: field.name, text: amount.dollarFormat())
                itemizedExpenses.append(item)
            }
        }
    }else{
        totalExpenses = calculatePercentOfValue(rentalWorksheet.expenses.total, value: grossRent)
        operatingExpenses = totalExpenses
    }
    return OperatingExpenses(items: itemizedExpenses, totalExpenses: totalExpenses, operatingExpenses: operatingExpenses)
}

let year1 = rentalProjections(property: rentalProperty, year:  1)
let year2 = rentalProjections(property: rentalProperty, year:  2)
let year3 = rentalProjections(property: rentalProperty, year:  3)
let year5 = rentalProjections(property: rentalProperty, year:  5)
let year10 = rentalProjections(property: rentalProperty, year: 10)
let year20 = rentalProjections(property: rentalProperty, year: 20)
let year30 = rentalProjections(property: rentalProperty, year: 30)

print("\t\t\tHolding Projections")
print("\n")
print("\t\t\t\tYear 1\t\t\tYear 2\t\t\tYear 3\t\t\tYear 5\t\t\tYear 10\t\t\tYear 20\t\t\tYear30")
print("INCOME")
print("Gross Rent:  \t\t" + year1.grossRent +
    "\t\t\t" + year2.grossRent +
    "\t\t\t" + year3.grossRent +
    "\t\t\t" + year5.grossRent +
    "\t\t\t" + year10.grossRent +
    "\t\t\t" + year20.grossRent +
    "\t\t\t" + year30.grossRent)
print("Vacancy:  " +
    "\t\t"  + year1.vacancy +
    "\t\t\t" + year2.vacancy +
    "\t\t\t" + year3.vacancy +
    "\t\t\t" + year5.vacancy +
    "\t\t\t" + year10.vacancy +
    "\t\t\t" + year20.vacancy +
    "\t\t\t" + year30.vacancy)
if year1.otherIncome != nil {
    print("Other Income:  \t\t"+year1.otherIncome! +
        "\t\t\t" + year2.otherIncome! +
        "\t\t\t" + year3.otherIncome! +
        "\t\t\t" + year5.otherIncome! +
        "\t\t\t" + year10.otherIncome! +
        "\t\t\t" + year20.otherIncome! +
        "\t\t\t" + year30.otherIncome!)
}
print("----------------------------------------------------------------------------------")
print("Operating Income:  " +
    "\t\t" + year1.operatingIncome +
    "\t\t\t" + year2.operatingIncome +
    "\t\t\t" + year3.operatingIncome +
    "\t\t\t" + year5.operatingIncome +
    "\t\t\t" + year10.operatingIncome +
    "\t\t\t" + year20.operatingIncome +
    "\t\t\t" + year30.operatingIncome)
print("\n\n")
print("Expences")
//// --------- itemized expences ----------
//let expense1 =  "Property Taxes"
//let expense2 =  "Insurance"
//let expense3 =  "Property Management"
//let expense4 =  "Maintenance"
//let expense5 =  "Capital Expenditures"
//let expense6 =  "Landscaping"
//let expense_list  = [ expense1, expense2, expense3, expense4, expense5, expense6]
//for expense in expense_list {
//    print(expense)
//}
let operatingExpensesTitle = "Operating Expenses:"
let totalExpensesTitle = "Total Expenses:"
let totalTitle = "Total:"
let monthlySummaryAnalysisViewModel = rentalSummaryAnalysis(rentalProperty, operationPeriod: .monthly)
let yearlySummaryAnalysisViewModel = rentalSummaryAnalysis(rentalProperty,operationPeriod:.yearly)
let monthlyOperatingExpenses = monthlySummaryAnalysisViewModel.operatingExpenses
let yearlyOperatingExpenses = yearlySummaryAnalysisViewModel.operatingExpenses
var finalHtml=""
if rentalWorksheet.expenses.itemized, let fields = rentalWorksheet.expenses.itemizedExpenses{
    var expensesDetailsHtml = ""
    var expensesProjectionsHtml = ""
    for field in fields.array{
        guard let field = field as? ItemizedExpensesField else{
            continue
        }
        let amount = calculateItemizedExpensesPerMonth(field, rentalWorksheet: rentalWorksheet)
        if amount > 0{
            let value = amount.dollarFormat()
            let value2 = (amount * 12).dollarFormat()
            expensesDetailsHtml += field.name + ":"  + value + " " + value2 + "\n"
        }
    }
    for  (index,item) in year1.itemizedExpenses.enumerated(){
        let itemHtml = item.name + ":" + item.text + "\t" +
            year2.itemizedExpenses[index].text + "\t" +
            year3.itemizedExpenses[index].text + "\t" +
            year5.itemizedExpenses[index].text + "\t" +
            year10.itemizedExpenses[index].text + "\t" +
            year20.itemizedExpenses[index].text + "\t" +
            year30.itemizedExpenses[index].text + "\n"
        expensesProjectionsHtml += itemHtml
    }
    
    expensesDetailsHtml += totalTitle + monthlyOperatingExpenses + "\t" + yearlyOperatingExpenses + "\n"
    finalHtml = finalHtml + expensesDetailsHtml
    
    if expensesProjectionsHtml.isEmpty,let value1 = year1.totalExpenses,let value2 = year2.totalExpenses,let value3 = year3.totalExpenses,let value4 = year5.totalExpenses,let value5 = year10.totalExpenses,let value6 = year20.totalExpenses,let value7 = year30.totalExpenses{
        let itemHtml = totalExpensesTitle + " " + value1 + " " +  value2 + " " + value3 + " " + value4 + " " + value5 + " " + value6 + " " + value7 + "\n"
        expensesProjectionsHtml += itemHtml
    }
    expensesProjectionsHtml += operatingExpensesTitle + "\t" +
        year1.operatingExpenses +  "\t" +
        year2.operatingExpenses + "\t" +
        year5.operatingExpenses + "\t" +
        year10.operatingExpenses + "\t" +
        year20.operatingExpenses + "\t" +
        year30.operatingExpenses +
    "\n"
    finalHtml = finalHtml + expensesProjectionsHtml
}else{
    let insertHtml = totalTitle + "MM " +  monthlyOperatingExpenses + " YY " + yearlyOperatingExpenses + "\n"
    finalHtml +=  "Operting " + insertHtml
    
    var expensesProjectionsHtml = ""
    if let value = year1.totalExpenses,let value2 = year2.totalExpenses, let value3 = year3.totalExpenses,let value4 = year5.totalExpenses,let value5 = year10.totalExpenses,let value6 = year20.totalExpenses, let value7 = year30.totalExpenses{
        let itemHtml = totalExpensesTitle + "\t\t" + value
            + "\t" + value2
            + "\t" + value3
            + "\t" + value4
            + "\t" + value5
            + "\t" + value6
            + "\t" + value7
            + "\n"
        expensesProjectionsHtml += itemHtml
    }
    expensesProjectionsHtml += operatingExpensesTitle +  "\t" +
        year1.operatingExpenses + "\t" +
        year2.operatingExpenses + "\t" +
        year3.operatingExpenses + "\t" +
        year5.operatingExpenses + "\t" +
        year10.operatingExpenses + "\t" +
        year20.operatingExpenses + "\t" +
        year30.operatingExpenses + "\n"
    
    finalHtml = finalHtml + expensesProjectionsHtml
    
}
print(finalHtml)

print("CASH FLOW")
print("Operating Income:" +
    "\t" + year1.operatingIncome +
    "\t" + year2.operatingIncome +
    "\t" + year3.operatingIncome +
    "\t" + year5.operatingIncome +
    "\t" + year10.operatingIncome +
    "\t" + year20.operatingIncome +
    "\t" + year30.operatingIncome)
print("Operating Expences:  " +
    "\t" + year1.operatingExpenses +
    "\t" + year2.operatingExpenses +
    "\t" + year3.operatingExpenses +
    "\t" + year5.operatingExpenses +
    "\t" + year10.operatingExpenses +
    "\t" + year20.operatingExpenses +
    "\t" + year30.operatingExpenses)
print("----------------------------------------------------------------------------------")
print("Net Operating Income:  " +
    "\t" + year1.netOperatingIncome +
    "\t" + year2.netOperatingIncome +
    "\t" + year3.netOperatingIncome +
    "\t" + year5.netOperatingIncome +
    "\t" + year10.netOperatingIncome +
    "\t" + year20.netOperatingIncome +
    "\t" + year30.netOperatingIncome)
print("Loan Payments:  ", terminator:"")
print(    "\t" + year1.loanPayment , terminator:"")
print(    "\t" + year2.loanPayment , terminator:"")
print(    "\t" + year3.loanPayment , terminator:"")
print(    "\t" + year5.loanPayment , terminator:"")
print(    "\t" + year10.loanPayment , terminator:"")
print(    "\t" + year20.loanPayment , terminator:"")
print(    "\t" + year30.loanPayment)

print("Cash Flow:  ", terminator:"")
print(    "\t\t" + year1.cashFlow , terminator:"")
print(    "\t" + year2.cashFlow , terminator:"")
print(    "\t" + year3.cashFlow , terminator:"")
print(    "\t" + year5.cashFlow , terminator:"")
print(    "\t" + year10.cashFlow , terminator:"")
print(    "\t" + year20.cashFlow , terminator:"")
print(    "\t" + year30.cashFlow)
print("\n")
print("EQUITY ACCUMULATION")
print("Property Value:  ", terminator:"")
print(    "\t" + year1.propertyValue , terminator:"")
print(    "\t" + year2.propertyValue , terminator:"")
print(    "\t" + year3.propertyValue , terminator:"")
print(    "\t" + year5.propertyValue , terminator:"")
print(    "\t" + year10.propertyValue , terminator:"")
print(    "\t" + year20.propertyValue , terminator:"")
print(    "\t" + year30.propertyValue)
print("Loan Balance:  ", terminator:"")
print(    "\t" + year1.loanBalance , terminator:"")
print(    "\t" + year2.loanBalance , terminator:"")
print(    "\t" + year3.loanBalance , terminator:"")
print(    "\t" + year5.loanBalance , terminator:"")
print(    "\t" + year10.loanBalance , terminator:"")
print(    "\t" + year20.loanBalance , terminator:"")
print(    "\t" + year30.loanBalance)
print("----------------------------------------------------------------------------------")
print("Total Equity:  ", terminator:"")
print(    "\t" + year1.totalEquity , terminator:"")
print(    "\t" + year2.totalEquity , terminator:"")
print(    "\t" + year3.totalEquity , terminator:"")
print(    "\t" + year5.totalEquity , terminator:"")
print(    "\t" + year10.totalEquity , terminator:"")
print(    "\t" + year20.totalEquity , terminator:"")
print(    "\t" + year30.totalEquity)
print("\n")
print("TAX BENEFITS")
print("Depreciation:  ", terminator:"")
print(    "\t" + year1.depreciation , terminator:"")
print(    "\t" + year2.depreciation , terminator:"")
print(    "\t" + year3.depreciation , terminator:"")
print(    "\t" + year5.depreciation , terminator:"")
print(    "\t" + year10.depreciation , terminator:"")
print(    "\t" + year20.depreciation , terminator:"")
print(    "\t" + year30.depreciation)
print("Loan Interest:  ", terminator:"")
print(    "\t\t" + year1.loanInterest , terminator:"")
print(    "\t" + year2.loanInterest , terminator:"")
print(    "\t" + year3.loanInterest , terminator:"")
print(    "\t" + year5.loanInterest , terminator:"")
print(    "\t" + year10.loanInterest , terminator:"")
print(    "\t" + year20.loanInterest , terminator:"")
print(    "\t" + year30.loanInterest)
print("\n")
print("RETURNS & RATIOS")
print("Cap Rate:  ", terminator:"")
print(    "\t" + year1.capRate , terminator:"")
print(    "\t" + year2.capRate , terminator:"")
print(    "\t" + year3.capRate , terminator:"")
print(    "\t" + year5.capRate , terminator:"")
print(    "\t" + year10.capRate , terminator:"")
print(    "\t" + year20.capRate , terminator:"")
print(    "\t" + year30.capRate)
print("Cash on Cash:  ", terminator:"")
print(    "\t" + year1.cashOnCash , terminator:"")
print(    "\t" + year2.cashOnCash , terminator:"")
print(    "\t" + year3.cashOnCash , terminator:"")
print(    "\t" + year5.cashOnCash , terminator:"")
print(    "\t" + year10.cashOnCash , terminator:"")
print(    "\t" + year20.cashOnCash , terminator:"")
print(    "\t" + year30.cashOnCash)
print("Return on Investment:  ", terminator:"")
print(    "\t" + year1.returnOnInvestment , terminator:"")
print(    "\t" + year2.returnOnInvestment , terminator:"")
print(    "\t" + year3.returnOnInvestment , terminator:"")
print(    "\t" + year5.returnOnInvestment , terminator:"")
print(    "\t" + year10.returnOnInvestment , terminator:"")
print(    "\t" + year20.returnOnInvestment , terminator:"")
print(    "\t" + year30.returnOnInvestment)
print("Internal Rate of Return:  ", terminator:"")
print(    "\t" + year1.internalRateOfReturn , terminator:"")
print(    "\t" + year2.internalRateOfReturn , terminator:"")
print(    "\t" + year3.internalRateOfReturn , terminator:"")
print(    "\t" + year5.internalRateOfReturn , terminator:"")
print(    "\t" + year10.internalRateOfReturn , terminator:"")
print(    "\t" + year20.internalRateOfReturn , terminator:"")
print(    "\t" + year30.internalRateOfReturn)
print("Rent to Value:  ", terminator:"")
print(    "\t" + year1.rentToValue , terminator:"")
print(    "\t" + year2.rentToValue , terminator:"")
print(    "\t" + year3.rentToValue , terminator:"")
print(    "\t" + year5.rentToValue , terminator:"")
print(    "\t" + year10.rentToValue , terminator:"")
print(    "\t" + year20.rentToValue , terminator:"")
print(    "\t" + year30.rentToValue)
print("Gross Rent Multiplier:  ", terminator:"")
print(    "\t" + year1.grossRentMultiplier , terminator:"")
print(    "\t" + year2.grossRentMultiplier , terminator:"")
print(    "\t" + year3.grossRentMultiplier , terminator:"")
print(    "\t" + year5.grossRentMultiplier , terminator:"")
print(    "\t" + year10.grossRentMultiplier , terminator:"")
print(    "\t" + year20.grossRentMultiplier , terminator:"")
print(    "\t" + year30.grossRentMultiplier)
if year1.debtCoverageRatio != nil {
    print("Debt Coverage Ratio:  ", terminator:"")
    print(    "\t" + year1.debtCoverageRatio! , terminator:"")
    print(    "\t" + year2.debtCoverageRatio! , terminator:"")
    print(    "\t" + year3.debtCoverageRatio! , terminator:"")
    print(    "\t" + year5.debtCoverageRatio! , terminator:"")
    print(    "\t" + year10.debtCoverageRatio! , terminator:"")
    print(    "\t" + year20.debtCoverageRatio! , terminator:"")
    print(    "\t" + year30.debtCoverageRatio!)
}


