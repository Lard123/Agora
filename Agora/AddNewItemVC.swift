//
//  AddNewItemVC.swift
//  Agora
//
//  Created by Varun Shenoy on 11/27/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//  TODO: Add checks if labesls/fields are empty
//

import UIKit
import ImagePicker
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftMessages

class AddNewItemVC: UIViewController, UITextViewDelegate, ImagePickerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var nameItemField: UITextField!
    
    @IBOutlet weak var startingBidField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var conditionButton: UIButton!
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var loadingGif: UIImageView!
    
    @IBOutlet weak var loadingView: UIView!
    
    var itemImages = [UIImage]()
    var imgURLs = [String:String]()
    let numberFormatter = NumberFormatter()
    
    var ref: FIRDatabaseReference!
    
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        ref = FIRDatabase.database().reference()
        collectionView.delegate = self
        collectionView.dataSource = self
        descriptionTextView.delegate = self
        descriptionTextView.text = "Description of item..."
        descriptionTextView.textColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.00)
        descriptionTextView.layer.borderColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.00).cgColor
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.startingBidField.delegate = self
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description of item..."
            textView.textColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.00)
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.00) {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func takePictures(_ sender: AnyObject) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 5
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        dismiss(animated: true, completion: nil)
        itemImages = images
        collectionView.reloadData()
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath as IndexPath)
        let img = cell.viewWithTag(1) as! UIImageView
        img.image = itemImages[indexPath.row]
        return cell
    }
    
    @IBAction func itemConditionTapped(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Select the appropriate condition for the item you intend to sell", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "New with Tags", style: .default, handler: {
            action in
            self.conditionLabel.text = "Selected Condition: New with Tags"
        }))
        alert.addAction(UIAlertAction(title: "Slightly Used", style: .default, handler: {
            action in
            self.conditionLabel.text = "Selected Condition: Slightly Used"

        }))
        alert.addAction(UIAlertAction(title: "Pre-owned", style: .default, handler: {
            action in
            self.conditionLabel.text = "Selected Condition: Pre-owned"
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.popoverPresentationController?.sourceView = sender as? UIView
        alert.popoverPresentationController?.sourceRect = sender.bounds
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func submitItem(_ sender: AnyObject) {
        //self.beginLoading()
        let itemName = nameItemField.text!
        let condition = conditionLabel.text!.replacingOccurrences(of: "Selected Condition: ", with: "")
        let description = descriptionTextView.text!
        print("description: " + description)
        if itemName.replacingOccurrences(of: " ", with: "") == "" {
            self.showAddItemError(text: "Please enter an item name.", headerText: "Add New Item Error")
            nameItemField.attributedPlaceholder = NSAttributedString(string:"Name of Item",
                                                                     attributes:[NSForegroundColorAttributeName: UIColor(red:0.99, green:0.24, blue:0.27, alpha:1.00)])
        } else if condition == "None" {
            self.showAddItemError(text: "Please enter the condition of your item.", headerText: "Add New Item Error")
        } else if description.replacingOccurrences(of: " ", with: "") == "Description of item..." {
            self.showAddItemError(text: "Please enter an item description.", headerText: "Add New Item Error")
        } else if startingBidField.text == "" || startingBidField.text == "0.00"{
            self.showAddItemError(text: "Please enter a valid starting bid for your item.", headerText: "Add New Item Error")
            startingBidField.attributedPlaceholder = NSAttributedString(string:"Starting Bid",
                                                                     attributes:[NSForegroundColorAttributeName: UIColor(red:0.99, green:0.24, blue:0.27, alpha:1.00)])
        }  else if itemImages.count == 0 {
            self.showAddItemError(text: "Please add some images for your item.", headerText: "Add New Item Error")
        } else {
            loadingGif.loadGif(name: "cube")
            UIView.animate(withDuration: 0.4) {
                self.loadingView.alpha = 1
            }
            let startingBid = NSString(format:"%.2f", Double(startingBidField.text!.replacingOccurrences(of: ",", with: ""))!) as String
            let itemRef = ref.child("items").childByAutoId()
            let userID = (FIRAuth.auth()?.currentUser?.uid)!
            imagesToURLs { (bool) in
                self.ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                    print("connected")
                    if let userDict = snapshot.value as? [String : AnyObject] {
                        let name = userDict["name"] as! String
                        let email = userDict["email"] as! String
                        let phone = userDict["phone"] as! String
                        let profileURL = userDict["image"] as! String
                        itemRef.setValue(["name": String(describing: itemName), "condition": String(describing: condition), "seller": String(describing: name), "bid": String(describing: startingBid), "description": String(describing: description), "sellerID": String(describing: userID), "email": String(describing: email), "phone": String(describing: phone), "seller_picture": String(describing: profileURL),"images": self.imgURLs])
                        print("urls")
                        print(self.imgURLs)
                        self.ref.child("users").child(userID).child("items").child(itemRef.key).setValue(itemRef.key)
                        let view = MessageView.viewFromNib(layout: .StatusLine)
                        view.button?.removeFromSuperview()
                        view.configureTheme(Theme.success)
                        var config = SwiftMessages.Config()
                        config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                        view.configureContent(title: "Success!", body: "Item successfully uploaded!")
                        view.configureTheme(backgroundColor: UIColor(red:0.00, green:0.69, blue:0.42, alpha:1.00), foregroundColor: UIColor.white)
                        SwiftMessages.show(config: config, view: view)
                        self.performSegue(withIdentifier: "unwind", sender: self)
                    }
                })
            }
        }
    }
    
    func showAddItemError(text: String, headerText: String) {
        let view = MessageView.viewFromNib(layout: .CardView)
        view.button?.removeFromSuperview()
        
        // Theme message elements with the warning style.
        view.configureTheme(.error)
        
        // Add a drop shadow.
        view.configureDropShadow()
        
        // Set message title, body, and icon. Here, we're overriding the default warning
        // image with an emoji character.
        view.configureContent(title: headerText, body: text)
        
        // Show the message.
        SwiftMessages.show(view: view)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //self.endLoading(vc: self, dismissVC: false)
        if (segue.identifier == "unwind") {
            let auction = segue.destination as! AuctionVC
            auction.loadedOnce = false
        }
    }
    
    func imagesToURLs(completionHandler:@escaping (Bool) -> ()) {
        for (index, img) in itemImages.enumerated() {
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("Items").child("\(imageName).jpg")
            let uploadData = UIImageJPEGRepresentation(img, 0.5)
            storageRef.put(uploadData!, metadata: nil, completion: { (metadata, error) in
                print("check")
                if error == nil {
                    if let imageUrl = metadata?.downloadURL()?.absoluteString {
                        self.imgURLs["image\(index + 1)"] = imageUrl
                        if index == self.itemImages.count - 1 {
                            completionHandler(true)
                        }
                    }
                }
            })
            print("wubalubadubdub")
            print(imgURLs)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var originalString = textField.text
        
        // Replace any formatting commas
        originalString = originalString?.replacingOccurrences(of: ",", with: "")
        
        var doubleFromString:  Double!
        
        if originalString!.isEmpty {
            originalString = string
            doubleFromString = Double(originalString!)
            doubleFromString! /= 100
        } else {
            if string.isEmpty {
                // Replace the last character for 0
                let loc = originalString!.characters.count - 1
                let range = NSMakeRange(loc, 1)
                let newString = (originalString! as NSString).replacingCharacters(in: range, with: "0")
                doubleFromString = Double(newString)
                doubleFromString! /= 10
            } else {
                originalString = originalString! + string
                doubleFromString = Double(originalString!)
                doubleFromString! *= 10
            }
            
        }
        
        let finalString = numberFormatter.string(from: doubleFromString as NSNumber)
        
        textField.text = finalString
        
        return false
    }

}
