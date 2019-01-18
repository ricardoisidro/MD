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

struct comunidadComponents {
    var id = Int64()
    var nombre = String()
}

class SettingsTableViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var btnVerSaldoName: UIButton!
    
     var objCredencial = Credencial()

  
    @IBAction func btnVerSaldo(_ sender: Any) {
        
        print("di clic en ver saldo")
        let myView = self.storyboard!.instantiateViewController(withIdentifier: "DetalleSaldoViewController")
        
        self.present(myView, animated: true)
        
        
     
        
        
    }
    
    var tableViewData = [optionsComponents]()
    var comunidadViewData = [comunidadComponents]()
    
    @IBOutlet weak var textConfigName: UITextField!
    @IBOutlet weak var textConfigSurname1: UITextField!
    @IBOutlet weak var textConfigSurname2: UITextField!
    @IBOutlet weak var textConfigSex: UITextField!
    @IBOutlet weak var textConfigBirthday: UITextField!
    @IBOutlet weak var textConfigMail: UITextField!
    @IBOutlet weak var textConfigPhone: UITextField!
    
    @IBOutlet weak var textConfigCommunity: UITextField!
    @IBOutlet weak var textConfigBalance: UILabel!
    
    var database: Connection!
   /* let db_user = Table("usuariomaguen")
    let db_user_id = Expression<Int64>("user_id")
    let db_user_name = Expression<String>("user_name")
    let db_user_surname1 = Expression<String>("user_surname1")
    let db_user_surname2 = Expression<String>("user_surname2")
    let db_user_sex = Expression<String>("user_sex")
    let db_user_birthday = Expression<String>("user_birthday")
    let db_user_mail = Expression<String>("user_mail")
    let db_user_phone = Expression<String>("user_phone")
    let db_user_photo = Expression<String>("user_photo")
    let db_user_username = Expression<String>("user_username")
    let db_user_idtype = Expression<Int64>("user_idtype")
    let db_user_idactivedate = Expression<String>("user_idactivedate")
    let db_user_cardid = Expression<Int64>("user_cardid")
 */
    
    let db_user = Table("usuarioapp")
    let db_usuario_app_id = Expression<Int64>("usuario_app_id")
    let db_numero_maguen = Expression<String?>("numero_maguen")
    let db_nombre = Expression<String?>("nombre")
    let db_primer_apellido = Expression<String?>("primer_apellido")
    let db_segundo_apellido = Expression<String?>("segundo_apellido")
    let db_sexo = Expression<String?>("sexo")
    let db_fecha_nacimiento = Expression<Date?>("fecha_nacimiento")
    let db_usuario = Expression<String?>("usuario")
    let db_contrasena = Expression<String?>("contrasena")
    let db_correo = Expression<String?>("correo")
    let db_categoria_id = Expression<Int64>("categoria_id")
    let db_comunidad_id = Expression<Int64>("comunidad_id")
    let db_domicilio_id = Expression<Int64>("domicilio_id")
    let db_fecha_activacion = Expression<Date?>("fecha_activacion")
    let db_activo = Expression<Int64>("activo")
    let db_eliminado = Expression<Int64>("eliminado")
    //let dataNotif = Notification.Name(rawValue: dataNotificationKey)
    
    /*deinit {
        NotificationCenter.default.removeObserver(self)
    }*/
    
    let sexTypes = ["HOMBRE", "MUJER"]
    //var communityTypes: [String] = []
    let birthDatePicker: UIDatePicker = UIDatePicker()
    let doneButton: UIButton = UIButton()
    
    var selectedSex: String = "HOMBRE"
    var selectedComunityId: Int64 = -1
    var selectedCommunity: String = "SELECCIONE..."
    var comunidadSelected = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = .clear
        
        tableView.register(UINib(nibName: "OptionsTableViewCell", bundle: nil), forCellReuseIdentifier: "options")
        
        createSexPicker()
        createCommunityPicker()
        createDatePicker()
        createSexPickerToolbar()
        createCommunityPickerToolbar()
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
         
            //getting centers list
            guard let queryResults = try? db.prepare("SELECT categoria_centro_id, nombre FROM centro WHERE eliminado = 0 ORDER BY categoria_centro_id") else {
                print("ERROR al consultar Comites")
                return
            }
            
            _ = queryResults.map { row in
                let data = optionsComponents(selected: false, optionClass: row[0] as! Int64, optionName: row[1] as! String)
                tableViewData.append(data)
            }
            
            //getting communities
            guard let queryResults3 = try? db.prepare("SELECT comunidad_id, descripcion  FROM comunidad") else {
                print("ERROR al consultar Comunidad")
                return
            }
            
            _ = queryResults3.map { row in
                let data = comunidadComponents(id: row[0] as! Int64, nombre: row[1] as! String)
                comunidadViewData.append(data)
                
                //communityTypes.append(data)
            }
            
       
            //comento para compilacion
        
           let idSelected =  UserDefaults.standard.string(forKey: "comunidadID")
            
            guard let queryComunidadSocio = try? db.prepare("SELECT comunidad_id, descripcion  FROM comunidad where comunidad_id = " + idSelected!) else {
             print("ERROR al consultar Comunidad")
             return
             }
             
             
            for row in queryComunidadSocio {
             
             if var myComunidad:String = row[1] as! String?
             {  // do something here if exists
                comunidadSelected = myComunidad
             }
             
             }
 
            
            
            // getting user
            let query2 = db_user.select(db_nombre, db_primer_apellido, db_segundo_apellido, db_sexo, db_fecha_nacimiento, db_correo)
            
            guard let queryResults2 = try? db.pluck(query2)
                else {
                    print("ERROR al consultar usuario")
                    return
            }
            guard let birthday = try? queryResults2?.get(db_fecha_nacimiento)
                else {
                    print("ERROR en fecha tabla usurios")
                    return
            }
            
            
           
            let queryCredencial = objCredencial.table_credencial.select(objCredencial.credencial_id, objCredencial.fotografia!)
            guard let queryResultsFoto = try? db.pluck(queryCredencial)
                else {
                    print("consulta foto nula")
                    return
            }
            
 
            
            let sex = try queryResults2?.get(db_sexo)
            textConfigName.text = try queryResults2?.get(db_nombre)
            textConfigSurname1.text = try queryResults2?.get(db_primer_apellido)
            textConfigSurname2.text = try queryResults2?.get(db_segundo_apellido)
            if sex == "H" {
                textConfigSex.text = sexTypes[0]
            }
            else if sex == "M" {
                textConfigSex.text = sexTypes[1]
            }
            
            
       
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            textConfigBirthday.text = dateFormatter.string(from: birthday!)
            
            
            
            
        
            textConfigMail.text = try queryResults2?.get(db_correo)
            textConfigPhone.text = UserDefaults.standard.string(forKey: "phone")
            
           
            textConfigCommunity.text = comunidadSelected
            
         }
         catch let ex {
            print("ReadCentroDB error: \(ex)")
         }
        
    }
    
    func GuardaEdicionSocio()
    {
        
        print("estoy guardando")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /*textConfigName.text = UserDefaults.standard.string(forKey: "name") ?? ""
        textConfigSurname1.text = UserDefaults.standard.string(forKey: "surname1") ?? ""
        textConfigSurname2.text =  UserDefaults.standard.string(forKey: "surname2") ?? ""
        textConfigSex.text =  UserDefaults.standard.string(forKey: "sex") ?? ""
        textConfigBirthday.text = UserDefaults.standard.string(forKey: "birthday") ?? ""
        textConfigMail.text = UserDefaults.standard.string(forKey: "mail") ?? ""
        textConfigPhone.text = UserDefaults.standard.string(forKey: "phone") ?? ""*/
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
        sexPicker.tag = 1
        sexPicker.delegate = self
        
        textConfigSex.inputView = sexPicker
    }
    
    func createCommunityPicker() {
        let communityPicker = UIPickerView()
        communityPicker.tag = 2
        communityPicker.delegate = self
        
        textConfigCommunity.inputView = communityPicker
    }
    
    func createSexPickerToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let okButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(SettingsTableViewController.dismissKeyboard))
        toolbar.setItems([okButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        textConfigSex.inputAccessoryView = toolbar
    }
    
    func createCommunityPickerToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let okButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(SettingsTableViewController.dismissKeyboard))
        toolbar.setItems([okButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        textConfigCommunity.inputAccessoryView = toolbar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return sexTypes.count

        }
        else if pickerView.tag == 2 {
            //return communityTypes.count
            return comunidadViewData.count
        }
        else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView.tag == 1 {
            let titleData = sexTypes[row]
            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
            
            return myTitle
        }
        else {
            //let titleData = communityTypes[row]
            let titleData = comunidadViewData[row].nombre
            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
            
            return myTitle
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            selectedSex = sexTypes[row]
            textConfigSex.text = selectedSex
        }
        else {
            //selectedCommunity = communityTypes[row]
            selectedCommunity = comunidadViewData[row].nombre
            selectedComunityId = comunidadViewData[row].id
            textConfigCommunity.text = selectedCommunity
        }
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let option = indexPath.row
        //print("You tapped cell number \(indexPath.row).")
        //tableView.deselectRow(at: indexPath, animated: true)
        
        print("seccion" + String(indexPath.section.description))
        print("row" + String(indexPath.row))
        
       // performSegue(withIdentifier: "Arbit", sender: tableViewData[indexPath.row].sidurText)
    }
    
    // MARK: - Table view delegates

  /*  override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }*/
    
    /*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(section)
        if section == 3 {
            return tableViewData.count
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }*/
    
    /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       print("seccion" + String(indexPath.section))
        print("row" + String(indexPath.row))
      //  print("seccion" + String(indexPath.section))
        
       // if indexPath.section == 3 {
          /*  let cell = tableView.dequeueReusableCell(withIdentifier: "options", for: indexPath) as! OptionTableViewCell*/
            //cell.txtClass.text = "0"//String(tableViewData[indexPath.row].optionClass)
            //cell.txtPlace.text = "Hola"//tableViewData[indexPath.row].optionName
            //cell.option.isSelected = false //tableViewData[indexPath.row].selected
           // return cell
        //}
        return super.tableView(tableView, cellForRowAt: indexPath)
    }*/
    
   /* override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.section == 3 {
            let newIndexPath = IndexPath(row: 0, section: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath as IndexPath)
    }*/
    /*override func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
     
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
            return 44
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }*/
    
}
