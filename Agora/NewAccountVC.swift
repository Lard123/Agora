//
//  NewAccountVC.swift
//  Agora
//
//  Created by Varun Shenoy on 11/24/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class NewAccountVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pictureButton: UIButton!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var phoneLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var reenterPasswordLabel: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    
    var ref: FIRDatabaseReference!
    
    var isSave = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        ref = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func makeNewAccount(_ sender: AnyObject) {
        let email = emailLabel.text!
        let password = passwordLabel.text!
        let phone = phoneLabel.text!
        let name = nameLabel.text!
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if error == nil {
                self.ref.child("users").child((user?.uid)!).setValue(["name": name, "email": email, "phone": phone, "image": self.imageToBase64(image: self.imageView.image!)])
                self.performSegue(withIdentifier: "unwindToLogin", sender: self)
            } else {
                let errText = (error?.localizedDescription)!
                print(error)
                if errText == "An internal error has occurred, print and inspect the error details for more information." {
                    SCLAlertView().showError("Form has been filled out incorrectly.", subTitle: "Check for errors in your entries.")
                } else {
                    SCLAlertView().showError((error?.localizedDescription)!, subTitle: "Try again.")
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func takePicture(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            action in
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
            action in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imageToBase64(image: UIImage) -> String {
        let imageData = UIImagePNGRepresentation(image)
        let base64String = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String!
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
