//
//  SettingsTableViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/19/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import SQLite

struct optionsComponents {
    var selected = Bool()
    var optionClass = Int64()
    var optionName = String()
}

class SettingsTableViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var tableViewData = [optionsComponents]()
    
    @IBOutlet weak var textConfigName: UITextField!
    @IBOutlet weak var textConfigSurname1: UITextField!
    @IBOutlet weak var textConfigSurname2: UITextField!
    @IBOutlet weak var textConfigSex: UITextField!
    @IBOutlet weak var textConfigBirthday: UITextField!
    @IBOutlet weak var textConfigMail: UITextField!
    @IBOutlet weak var textConfigPhone: UITextField!
    
    @IBOutlet weak var textConfigBalance: UILabel!
    //let dataNotif = Notification.Name(rawValue: dataNotificationKey)
    
    /*deinit {
        NotificationCenter.default.removeObserver(self)
    }*/
    
    let sexTypes = ["HOMBRE", "MUJER"]
    let birthDatePicker: UIDatePicker = UIDatePicker()
    let doneButton: UIButton = UIButton()
    
    var selectedSex: String = "HOMBRE"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = .clear
        
        tableView.register(UINib(nibName: "OptionsTableViewCell", bundle: nil), forCellReuseIdentifier: "options")
        
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

        //createObservers()
        do {
            
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
         
         /*let users = Table("centro")
         let db_centro_id = Expression<Int64>("centro_id")
         let db_categoria_centro_id = Expression<Int64>("categoria_centro_id")
         let db_descripcion = Expression<String>("descripcion")
         let db_eliminado = Expression<Int64>("eliminado")*/
         
            guard let queryResults = try? db.prepare("SELECT categoria_centro_id, nombre FROM centro WHERE eliminado = 0 ORDER BY categoria_centro_id") else {
                print("ERROR al consultar Comites")
                return
            }
            
            _ = queryResults.map { row in
                let data = optionsComponents(selected: false, optionClass: row[0] as! Int64, optionName: row[1] as! String)
                tableViewData.append(data)
            }
         }
         catch let ex {
            print("ReadCentroDB error: \(ex)")
         }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textConfigName.text = UserDefaults.standard.string(forKey: "name") ?? ""
        textConfigSurname1.text = UserDefaults.standard.string(forKey: "surname1") ?? ""
        textConfigSurname2.text =  UserDefaults.standard.string(forKey: "surname2") ?? ""
        textConfigSex.text =  UserDefaults.standard.string(forKey: "sex") ?? ""
        textConfigBirthday.text = UserDefaults.standard.string(forKey: "birthday") ?? ""
        textConfigMail.text = UserDefaults.standard.string(forKey: "mail") ?? ""
        textConfigPhone.text = UserDefaults.standard.string(forKey: "phone") ?? ""
        textConfigBalance.text = UserDefaults.standard.string(forKey: "balance") ?? ""
    }
    
    /*func createObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateData(notification:)),
                                               name: dataNotif,
                                               object: nil)
    }
    
    @objc func updateData(notification: Notification) {
        let info = notification.userInfo?["mykey"]
        //textConfigName.text =
    }*/
    
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
    
    // MARK: - Table view delegates

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }*/
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(section)
        if section == 3 {
            return tableViewData.count
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "options", for: indexPath) as! OptionTableViewCell
            //cell.txtClass.text = "0"//String(tableViewData[indexPath.row].optionClass)
            //cell.txtPlace.text = "Hola"//tableViewData[indexPath.row].optionName
            //cell.option.isSelected = false //tableViewData[indexPath.row].selected
            return cell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.section == 3 {
            let newIndexPath = IndexPath(row: 0, section: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath as IndexPath)
    }
    /*override func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
     
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
            return 44
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }*/
    
}
