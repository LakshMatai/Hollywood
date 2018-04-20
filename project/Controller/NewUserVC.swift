//
//  NewUserVC.swift
//  project
//
//  Created by Laksh on 15/04/18.
//  Copyright © 2018 Laksh. All rights reserved.
//

import UIKit

class NewUserVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var chosenImage: UIImageView!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBAction func addBtnPressed(_ sender: Any) {
        
        
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker,animated: true, completion: nil)
        }
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        chosenImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.chosenImage.layer.cornerRadius = self.chosenImage.frame.size.width/2
        self.chosenImage.clipsToBounds=true
        // Do any additional setup after loading the view.
    }


    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
