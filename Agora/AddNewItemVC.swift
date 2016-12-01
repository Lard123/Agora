//
//  AddNewItemVC.swift
//  Agora
//
//  Created by Varun Shenoy on 11/27/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit
import ImagePicker
import FirebaseDatabase
import Firebase

class AddNewItemVC: UIViewController, UITextViewDelegate, ImagePickerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var nameItemField: UITextField!
    
    @IBOutlet weak var startingBidField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var conditionLabel: UILabel!
    
    var itemImages = [UIImage]()
    
    var ref: FIRDatabaseReference!
    
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
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func submitItem(_ sender: AnyObject) {
        print("pass")
        self.beginLoading()
        var imgStore = Dictionary<String, Any>()
        for (ind, img) in itemImages.enumerated() {
            imgStore["image\(ind + 1)"] = imageToBase64(image: UIImage(data: UIImageJPEGRepresentation(img, 0.5)!)!)
        }
        let userID = (FIRAuth.auth()?.currentUser?.uid)!
        let startingBid = startingBidField.text!
        let itemName = nameItemField.text!
        let condition = conditionLabel.text!
        let description = descriptionTextView.text!
        let itemRef = ref.child("items").childByAutoId()
        itemRef.setValue(["name": String(describing: itemName), "condition": String(describing: condition), "seller": String(describing: userID), "bid": String(describing: startingBid), "description": String(describing: description), "images": imgStore])
        self.ref.child("users").child(userID).child("items").childByAutoId().setValue(["item": String(describing: itemRef.key)])
        self.endLoading(vc: self, dismissVC: true)
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
