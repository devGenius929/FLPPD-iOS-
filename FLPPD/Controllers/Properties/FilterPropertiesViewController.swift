//
//  FilterPropertiesViewController.swift
//  FLPPD
//
//  Created by Vlad Konon on 01/30/18.
//  Copyright © 2018 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import KRProgressHUD

struct PropertyFilters{
    var type:String?
    var city:String?
    var state:String?
    var zipcode:Int?
    var price_max:Int?
    var price_min:Int?
    mutating func clear() {
        type = nil
        city = nil
        state = nil
        zipcode = nil
        price_max = nil
        price_min = nil
    }
    func getFilterString() -> String? {
        var filters = [String]()
        if let type = self.type {
            filters.append("type=\(type)")
        }
        if let city = self.city {
            filters.append("city=\(city)")
        }
        if let state = self.state {
            filters.append("state=\(state)")
        }
        if let zipcode = self.zipcode {
            filters.append("zipcode=\(zipcode)")
        }
        if let price_min = self.price_min {
            filters.append("price_min=\(price_min)")
        }
        if let price_max = self.price_max {
            filters.append("price_max=\(price_max)")
        }
        if filters.count > 0 {
            return filters.joined(separator: "&").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        }
        return nil
    }
}

extension String {
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        //let unreserved = "-._~/?"
        //var allowed = CharacterSet.alphanumerics
        //allowed.insert(charactersIn: unreserved)
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    }
}

extension UITextField{
    func stringOrNil() -> String? {
        if let string = text, !string.isEmpty {
            return string
        }
        return nil
    }
    func intOrNil() -> Int? {
        if let string = text, let number = Int(string) {
            return number
        }
        return nil
    }
}

class FilterPropertiesViewController: UITableViewController, UITextFieldDelegate {
    var filters = PropertyFilters()
    var completion:((_ filters:PropertyFilters?) -> Void)? = nil
    let disposeBag = DisposeBag()
    let picker = UIPickerView()
    var bar:UIToolbar!
    let typesList:[(String?, String)] = [
        (nil, "None"),
        ("flip", "Flip"),
        ("rental", "Rental")
    ]
    internal var updateEnabled = true
    internal var selectedTypeIndex:Int = 0{
        didSet{
                filters.type = typesList[selectedTypeIndex].0
                typeField.text = typesList[selectedTypeIndex].1 == "None" ? nil : typesList[selectedTypeIndex].1
        }
    }
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipField: UITextField!
    @IBOutlet weak var minPriceField: UITextField!
    @IBOutlet weak var maxPriceField: UITextField!
    
    
    internal let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: nil, action: nil)
    
    internal let clearButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash, target: nil, action: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Filtering"
        self.navigationItem.rightBarButtonItems = [ saveButton, clearButton]
        updateFileds()
        clearButton.rx.tap.subscribe(onNext:{[unowned self ] in
            self.filters.clear()
            self.dismiss()
        }).disposed(by: disposeBag)
        saveButton.rx.tap.subscribe(onNext:{ [unowned self] in
            self.save()
        }).disposed(by: disposeBag)
        typeField.inputView = picker
        picker.delegate = self
        picker.dataSource = self
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(FilterPropertiesViewController.done))
        bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        bar.barStyle = .default
        bar.setItems([spacer, done], animated: false)
        bar.sizeToFit()
        maxPriceField.inputAccessoryView = bar
        typeField.inputAccessoryView = bar
        cityField.inputAccessoryView = bar
        stateField.inputAccessoryView = bar
        zipField.inputAccessoryView = bar
        minPriceField.inputAccessoryView = bar
        typeField.delegate = self
        updateFileds()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTypeIndex = typesList.index { (value, _) -> Bool in
            return value == filters.type
            } ?? 0
        picker.selectRow(selectedTypeIndex, inComponent: 0, animated: false)
    }
    @objc func done() {
        updateEnabled = false
        if self.typeField.isFirstResponder {
            self.typeField.resignFirstResponder()
        }
        else {
            self.view.endEditing(true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {[unowned self] in
            self.picker.selectRow(self.selectedTypeIndex, inComponent: 0, animated: false)
            self.updateEnabled = true
            
        }
    }
    func validateFields() -> Bool{
        if let text = cityField.text,!text.isEmpty, text.length < 2{
            cityField.becomeFirstResponder()
            KRProgressHUD.showError(withMessage: "Wrong city")
            return false
        }
        if let text = stateField.text, !text.isEmpty, text.length < 2{
            stateField.becomeFirstResponder()
            KRProgressHUD.showError(withMessage: "Wrong state")
            return false
        }
        if let text = zipField.text, !text.isEmpty, text.length != 5, Int(text) == nil{
            zipField.becomeFirstResponder()
            KRProgressHUD.showError(withMessage: "Wrong zip")
            return false
        }
        if let text = minPriceField.text, !text.isEmpty, text.length == 0, Int(text) == nil{
            minPriceField.becomeFirstResponder()
            KRProgressHUD.showError(withMessage: "Wrong minimal price")
            return false
        }
        if let text = maxPriceField.text, !text.isEmpty, Int(text) == nil{
            maxPriceField.becomeFirstResponder()
            KRProgressHUD.showError(withMessage: "Wrong maximum price")
            return false
        }
        return true
    }
    internal func save(){
        if validateFields(){
            filters.city = cityField.stringOrNil()
            filters.price_max = maxPriceField.intOrNil()
            filters.price_min = minPriceField.intOrNil()
            filters.state = stateField.stringOrNil()
            filters.zipcode = zipField.intOrNil()
            dismiss()
        }
    }
    func dismiss(){
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
        self.completion?(self.filters)
    }
    internal func updateFileds() {
        if typeField != nil {
            let index = typesList.index { (value, _) -> Bool in
                return value == filters.type
                } ?? 0
            typeField.text = self.typesList[index].1
            cityField.text = filters.city
            stateField.text = filters.state?.uppercased()
            zipField.text = filters.zipcode != nil ? String(filters.zipcode!) : nil
            minPriceField.text = filters.price_min != nil ? String(filters.price_min!) : nil
            maxPriceField.text = filters.price_max != nil ? String(filters.price_max!) : nil
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension FilterPropertiesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typesList.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if updateEnabled {
            self.selectedTypeIndex = row
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typesList[row].1
    }
}
