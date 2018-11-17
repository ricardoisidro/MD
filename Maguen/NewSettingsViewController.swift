//
//  NewSettingsViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/6/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

class NewSettingsViewController: UIViewController, UINavigationControllerDelegate {
    
    enum ImageSource {
        case photoLibrary
        case camera
    }

    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var imageTake: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = MaguenColors.black1
        btnPhoto.layer.cornerRadius = 0.5 * btnPhoto.bounds.size.width
        btnPhoto.clipsToBounds = true
        btnSave.layer.cornerRadius = 10
        btnPhoto.layer.masksToBounds = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let validString = UserDefaults.standard.string(forKey: "name") ?? ""
        let sessionisEmpty = (validString == "")
        if sessionisEmpty {
            btnSave.setTitle("GUARDAR CAMBIOS", for: .normal)
            btnSave.backgroundColor = MaguenColors.blue5
        }
        else {
            btnSave.setTitle("DESACTIVAR USUARIO", for: .normal)
            btnSave.backgroundColor = .orange
            
            let imageDecoded: Data = Data(base64Encoded: UserDefaults.standard.string(forKey: "photo") ?? "")!
            let avatarImage: UIImage = UIImage(data: imageDecoded) ?? #imageLiteral(resourceName: "img_foto_default")
            imageTake.image = avatarImage
        }
        
        
    }
    
    @IBAction func btnSaveorDiscard(_ sender: UIButton) {
        
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "surname1")
        UserDefaults.standard.removeObject(forKey: "surname2")
        UserDefaults.standard.removeObject(forKey: "sex")
        UserDefaults.standard.removeObject(forKey: "birthday")
        UserDefaults.standard.removeObject(forKey: "mail")
        UserDefaults.standard.removeObject(forKey: "phone")
        UserDefaults.standard.removeObject(forKey: "photo")
        
        self.tabBarController?.selectedIndex = 0
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - Camera methods
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func takePhoto(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
    }
    
    //MARK: - Saving Image here
    @IBAction func save(_ sender: AnyObject) {
        guard let selectedImage = imageTake.image else {
            print("Image not found!")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

}

extension NewSettingsViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        imageTake.image = selectedImage
    }
}
