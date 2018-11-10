//
//  AskLoginViewController.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/8/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

class AskLoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        loginView.backgroundColor = MaguenColors.black1
        loginView.layer.cornerRadius = 10
        loginView.layer.masksToBounds = true
        btnOK.layer.cornerRadius = 10
        btnOK.layer.masksToBounds = true
        btnOK.backgroundColor = MaguenColors.blue1
        btnCancel.layer.cornerRadius = 10
        btnCancel.layer.masksToBounds = true
        btnCancel.backgroundColor = MaguenColors.blue2
        
        txtUsuario.delegate = self
        txtPassword.delegate = self
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.underlinedWhenSelected()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.underlineWhenNonSelected()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtUsuario:
            txtPassword.becomeFirstResponder()
        case txtPassword:
            txtPassword.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func cancelLogin(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func makeLogin(_ sender: UIButton) {
        /*if let popUpVC = self.tabBarController?.storyboard?.instantiateViewController(withIdentifier: "CardViewController") {
            self.tabBarController?.present(popUpVC, animated: true)
            print("Terminar modal")
        }*/
        //tabBarController?.performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
    }
}
