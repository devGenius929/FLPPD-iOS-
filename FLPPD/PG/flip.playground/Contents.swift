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

struct ItemizedHoldingCostsField: ItemizeField {
    var isSetAmount: Bool
    var name: String
    var percentValue: Float
    var setAmount: Float
     var characteristic1: Int32
     var characteristic2: Int32
     var holdingCosts: HoldingCosts?
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

struct HoldingCosts: ItemizedItem {
    var itemized: Bool
    
    var itemizedTotal: Float
    var total: Float
    var itemizedHoldingCosts: NSOrderedSet?
}

struct SellingCosts:ItemizedItem {
    var itemized: Bool
    
    var itemizedTotal: Float
    var total: Float
    var itemizedSellingCosts: NSOrderedSet?
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
    var holdingCosts: HoldingCosts?
    var sellingCosts: SellingCosts?
    
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



let holdingCosts = HoldingCosts(itemized: false, itemizedTotal: 0, total: 500, itemizedHoldingCosts: nil)
let sellingCosts = SellingCosts(itemized: false, itemizedTotal: 0, total: 6, itemizedSellingCosts: nil)

let flipWorksheet = FlipWorksheet(amortizingFinancing: nil,
                                  afterRepairValue: 25000,
                                  amortizing: false,
                                  customLoanAmount: false,
                                  downPayment:20.0,
                                  interestRate: 10,
                                  loanAmount: 10000.0,
                                  purchasePrice: 20000.0,
                                  useFinancing: true,
                                  rehabCosts: rehubCosts,
                                  purchaseCosts:purchaseCosts,
                                  costOverrun: 10.0,
                                  customLoanAsPercentOfARV: true,
                                  financeRehabCosts: true,
                                  holdingPeriod: 3,
                                  percentageToFinance: 50.0,
                                  percentOfARV: 10,
                                  holdingCosts: holdingCosts,
                                  sellingCosts: sellingCosts)
let flipProperty = Property(baths: "1.5",
                            beds: "2",
                            city: "Huston",
                            lotSize: "2000",
                            nickname: "Sweet Home",
                            numberOfUnits: 1,
                            parking: "Zoned",
                            propertyDescription: "Some good description",
                            propertyType: "Some property type",
                            squareFootage: "1500",
                            state: "Texas",
                            street: "150 1st ave",
                            type: 1,
                            yearBuilt: "2010",
                            zipcode: "304123",
                            zoning: true,
                            worksheet: flipWorksheet)
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
func calculateItemizeHoldingCostForHoldingPeriod(_ field:ItemizedHoldingCostsField,purchasePrice:Float,holdingPeriod:Float)->Float{
    return calculateMonthlyItemizeHoldingCost(field, purchasePrice: purchasePrice) *  holdingPeriod
}
func calculateMonthlyItemizeHoldingCost(_ field:ItemizedHoldingCostsField, purchasePrice:Float)->Float{
    if field.isSetAmount{
        return field.characteristic2 == HoldingCostsCharacteristic2.PerMonth.number ? field.setAmount : field.setAmount / 12
    }
    let percent = field.percentValue.percentValue()
    return (percent * purchasePrice) / 12
}
func flipSummaryAnalysis(_ flipProperty:Property,holdingPeriod:Float)->FlipSummaryAnalysisViewModel{
    let flipWorksheet = flipProperty.worksheet as! FlipWorksheet
    let purchasePrice = flipWorksheet.purchasePrice.dollarFormat()
    let financedRehabCosts = calculateFinancedRehabCosts(flipWorksheet)
    var financedRehabCostsPercentage:String?
    let downPayment = calculateDownPaymentAmount(flipWorksheet)
    let amountFinanced = calculateAmountFinanced(flipWorksheet)
    let ltcText = calculateLTCText(flipWorksheet)
    var loanPayment:Float?
    var recurringExpenses:Float?
    var itemizedHoldingCosts:[SummaryProjectionItem] = []
    var holdingCostsTotal = Float(0)
    let afterRepairValue = flipWorksheet.afterRepairValue
    let loanRepayment = calculateLoanRepaymentForHoldingPeriod(flipWorksheet, holdingPeriod: holdingPeriod)
    var roi:String
    var annualizedROI:String
    if financedRehabCosts != 0{
        financedRehabCostsPercentage = flipWorksheet.percentageToFinance.stringValue + "% of Total"
    }
    let purchaseCosts = calculateAdjustedPurchaseCostsTotal(flipWorksheet)
    let rehabCosts = calculateAdjustedRehabCosts(flipWorksheet)
    let pricePerSquareFoot = calculatePricePerSquareFoot(flipProperty.squareFootage, purchasePrice: flipWorksheet.purchasePrice).dollarFormat()
    let totalCashNeeded = flipWorksheet.useFinancing ? downPayment + purchaseCosts + rehabCosts : flipWorksheet.purchasePrice + purchaseCosts + rehabCosts
    //MARK:Loan Payment
    if flipWorksheet.useFinancing{
        if !flipWorksheet.amortizing{
            loanPayment = calculateLoanPaymentInterestOnlyForHoldingPeriod(holdingPeriod, amountFinanced: loanRepayment, interestRate: flipWorksheet.interestRate)
        }else{
            let loanAmount = amountFinanced + calculateWrapIntoLoanPurchaseCosts(flipWorksheet)
            loanPayment = calculateLoanPaymentAmortizingForHoldingPeriod(loanAmount, annualInterestRate: flipWorksheet.interestRate, loanTerm: flipWorksheet.amortizingFinancing!.loanTerm, holdingPeriod: holdingPeriod)
            if flipWorksheet.amortizingFinancing!.useMortgageInsurance{
                loanPayment = loanPayment! + calculateMortgageInsuranceForHoldingPeriod(amountFinanced, upfront: flipWorksheet.amortizingFinancing!.mortgageInsurance!.upfront, recurring: flipWorksheet.amortizingFinancing!.mortgageInsurance!.recurring,holdingPeriod: holdingPeriod, loanTerm: flipWorksheet.amortizingFinancing!.loanTerm,annualInterestRate:flipWorksheet.interestRate)
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
            let amount = calculateItemizeHoldingCostForHoldingPeriod(field, purchasePrice: flipWorksheet.purchasePrice, holdingPeriod: holdingPeriod)
            if amount > 0{
                holdingCostsTotal = holdingCostsTotal + amount
                let item = SummaryProjectionItem(name: field.name, text: amount.dollarFormat())
                itemizedHoldingCosts.append(item)
            }
        }
    }else{
        recurringExpenses = holdingPeriod + flipWorksheet.holdingCosts!.total
        holdingCostsTotal = holdingCostsTotal + recurringExpenses!
    }
    //MARK:Sale & Profit
    let sellingCosts = flipWorksheet.sellingCosts!.itemized ? flipWorksheet.sellingCosts!.itemizedTotal : flipWorksheet.sellingCosts!.total.percentValue() * flipWorksheet.afterRepairValue
    let saleProceeds = afterRepairValue - sellingCosts
    let totalProfit = flipWorksheet.useFinancing ? (saleProceeds - loanRepayment - holdingCostsTotal - totalCashNeeded) : (saleProceeds - holdingCostsTotal - totalCashNeeded)
    //MARK:Returns
    if totalCashNeeded != 0 {
        let returnOnInvestment = (totalProfit / totalCashNeeded) + holdingCostsTotal
        roi = (returnOnInvestment * 100).stringValue + "%"
        if holdingPeriod == 0{
            annualizedROI = "infinite %"
        }else{
            annualizedROI = (((12 * returnOnInvestment) / holdingPeriod) * 100).stringValue + " %"
        }
    }else{
        roi = "infinite %"
        annualizedROI = "infinite %"
    }
    return FlipSummaryAnalysisViewModel(purchasePrice: purchasePrice, financedRehabCosts: financedRehabCosts.dollarFormat(), financedRehabCostsPercentage: financedRehabCostsPercentage, amountFinanced: amountFinanced.dollarFormat(), ltc: ltcText, downPayment: downPayment.dollarFormat(), purchaseCosts: purchaseCosts.dollarFormat(), rehabCosts: rehabCosts.dollarFormat(), totalCashNeeded: totalCashNeeded.dollarFormat(), pricePerSquareFoot: pricePerSquareFoot,loanPayment:loanPayment?.dollarFormat(),recurringExpenses:recurringExpenses?.dollarFormat(),itemizedHoldingCosts:itemizedHoldingCosts,holdingCostsTotal:holdingCostsTotal.dollarFormat(),afterRepairValue:afterRepairValue.dollarFormat(),sellingCosts:sellingCosts.dollarFormat(),saleProceeds:saleProceeds.dollarFormat(),loanRepayment:loanRepayment.dollarFormat(), holdingCosts:holdingCostsTotal.dollarFormat(),investedCash:totalCashNeeded.dollarFormat(),totalProfit:totalProfit.dollarFormat(),roi:roi,annualizedROI:annualizedROI)
}

let twoWeeksFlipSummaryAnalysisViewModel = flipSummaryAnalysis(flipProperty, holdingPeriod: 0.5)
let oneMonthFlipSummaryAnalysisViewModel = flipSummaryAnalysis(flipProperty, holdingPeriod: (1))
let sixWeeksFlipSummaryAnalysisViewModel = flipSummaryAnalysis(flipProperty, holdingPeriod: (1.5))
let twoMonthsFlipSummaryAnalysisViewModel = flipSummaryAnalysis(flipProperty, holdingPeriod: (2))
let threeMonthsFlipSummaryAnalysisViewModel = flipSummaryAnalysis(flipProperty, holdingPeriod: (3))
let fourMonthsFlipSummaryAnalysisViewModel = flipSummaryAnalysis(flipProperty, holdingPeriod: (4))
let sixMonthsFlipSummaryAnalysisViewModel = flipSummaryAnalysis(flipProperty, holdingPeriod: (6))
