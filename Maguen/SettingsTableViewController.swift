//
//  SettingsTableViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/19/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

let dataNotificationKey = "co.loginData"

class SettingsTableViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var textConfigName: UITextField!
    @IBOutlet weak var textConfigSurname1: UITextField!
    @IBOutlet weak var textConfigSurname2: UITextField!
    @IBOutlet weak var textConfigSex: UITextField!
    @IBOutlet weak var textConfigBirthday: UITextField!
    @IBOutlet weak var textConfigMail: UITextField!
    @IBOutlet weak var textConfigPhone: UITextField!
    
    let dataNotif = Notification.Name(rawValue: dataNotificationKey)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    let sexTypes = ["HOMBRE", "MUJER"]
    let birthDatePicker: UIDatePicker = UIDatePicker()
    let doneButton: UIButton = UIButton()
    
    var selectedSex: String = "HOMBRE"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = .clear
        
        createSexPicker()
        createDatePicker()
        createPickerToolbar()
        createDatePickerToolbar()
        
        textConfigName.delegate = self
        textConfigSurname1.delegate = self
        textConfigSurname2.delegate = self
        textConfigSex.delegate = self
        textConfigBirthday.delegate = self
        textConfigMail.delegate = self
        textConfigPhone.delegate = self
    
        createObservers()
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateData(notification:)),
                                               name: dataNotif,
                                               object: nil)
    }
    
    @objc func updateData(notification: Notification) {
        let info = notification.userInfo?["mykey"]
        //textConfigName.text =
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    //MARK: - Textfield delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.underlinedWhenSelected()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.underlineWhenNonSelected()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case textConfigName:
            textConfigSurname1.becomeFirstResponder()
        case textConfigSurname1:
            textConfigSurname2.becomeFirstResponder()
        case textConfigSurname2:
            textConfigSex.becomeFirstResponder()
        case textConfigSex:
            textConfigSex.resignFirstResponder()
        case textConfigBirthday:
            textConfigBirthday.resignFirstResponder()
        case textConfigMail:
            textConfigPhone.becomeFirstResponder()
        case textConfigPhone:
            textConfigPhone.resignFirstResponder()
        /*case textConfigSurname2:
            textConfigSurname2.resignFirstResponder()*
        case textConfigMail:
            textConfigPhone.becomeFirstResponder()
        case textConfigPhone:
            textConfigPhone.resignFirstResponder()*/
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    //MARK: - Picker delegates
    func createSexPicker() {
        let sexPicker = UIPickerView()
        sexPicker.delegate = self
        
        textConfigSex.inputView = sexPicker
    }
    
    func createPickerToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let okButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(SettingsTableViewController.dismissKeyboard))
        toolbar.setItems([okButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        textConfigSex.inputAccessoryView = toolbar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sexTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = sexTypes[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
        
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSex = sexTypes[row]
        textConfigSex.text = selectedSex
    }
    
    //MARK: - DatePicker
    func createDatePicker() {
        let birthPicker = UIDatePicker()
        birthPicker.datePickerMode = .date
        birthPicker.maximumDate = Date()
        birthPicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        textConfigBirthday.inputView = birthPicker
    }
    
    func createDatePickerToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let okButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([okButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        textConfigBirthday.inputAccessoryView = toolbar
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        textConfigBirthday.text = dateFormatter.string(from: datePicker.date)
    }
    
}
