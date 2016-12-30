//
//  ItemVC.swift
//  Agora
//
//  Created by Varun Shenoy on 12/13/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit
import MessageUI
import Firebase
import FirebaseDatabase

class ItemVC: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var commentView: UIView!
    
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var pageCounter: UILabel!
    
    @IBOutlet weak var carousel: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var postButton: UIButton!
    
    var item: Item!
    
    var comments = [Comment]()
    
    var refreshControl: UIRefreshControl!

    var customView: UIView!
    
    var count = 0
    
    var imageURLs = [String]()
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        ref = FIRDatabase.database().reference()
        tableView.delegate = self
        tableView.dataSource = self
        imageURLs = item.imageURLs
        count = imageURLs.count
        carousel.delegate = self
        pageControl.numberOfPages = imageURLs.count
        pageCounter.text = "1 of \(count)"
        
        getComments()
        
        commentView.layer.borderWidth = 0.5
        commentView.layer.borderColor = UIColor(red:0.59, green:0.59, blue:0.60, alpha:1.00).cgColor
        
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.clear
        self.tableView.insertSubview(refreshControl!, at: 0)
        
        loadCustomRefreshContents()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        carousel.contentSize = CGSize(width: self.view.bounds.width * CGFloat(count), height: 200)
        carousel.showsHorizontalScrollIndicator = false
        
        
        for (index, url) in imageURLs.enumerated() {
            let image = CustomImageView()
            image.loadImageUsingUrlString(urlString: url)
            image.contentMode = .scaleAspectFill
            self.carousel.addSubview(image)
            image.frame.size.width = self.view.bounds.width
            image.frame.origin.x = CGFloat(index) * self.view.bounds.width
            image.frame.size.height = 200
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = carousel.contentOffset.x/carousel.frame.size.width
        pageControl.currentPage = Int(page)
        pageCounter.text = "\(Int(page) + 1) of \(count)"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func loadCustomRefreshContents() {
        let refreshContents = Bundle.main.loadNibNamed("RefreshContents", owner: self, options: nil)
        
        customView = refreshContents?[0] as! UIView
        customView.frame = refreshControl.bounds
        
        let loading = customView.viewWithTag(2) as! UIImageView
        loading.loadGif(name: "cube")
        
        refreshControl.addSubview(customView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 + comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicInfo", for: indexPath as IndexPath) as! ItemInfoCell
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
            cell.setUpCell(obj: item)
            return cell
        } else if (indexPath.row == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sellerInfo", for: indexPath as IndexPath) as! SellerInfoCell
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
            cell.setUpCell(seller: item.seller)
            return cell
        } else if (indexPath.row == 2) {
            if (FIRAuth.auth()?.currentUser?.uid)! as String != item.seller.id {
                let cell = tableView.dequeueReusableCell(withIdentifier: "actionButtons", for: indexPath as IndexPath) as! ActionCell
                cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
                cell.setUpCell(seller: item.seller, itemName: item.name,vc: self)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ownerActions", for: indexPath as IndexPath) as! OwnerActionsCell
                cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
                cell.setUpCell(itemID: item.firebaseKey, vc: self)
                return cell
            }
        } else if (indexPath.row == 3) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentHead", for: indexPath as IndexPath)
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath as IndexPath) as! CommentCell
            let comment = comments[indexPath.row - 4]
            cell.setUpCell(comment: comment)
            return cell
        }
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addComment(_ sender: AnyObject) {
        let userID = (FIRAuth.auth()?.currentUser?.uid)! as String
        let commentText = commentTextField.text!
        commentTextField.text = ""
        let comment = Comment(comment: commentText, userID: userID, timeStamp: 0.0)
        comment.getUserInfo()
        comments.append(comment)
        let ind = 3 + comments.count
        let path = IndexPath(row: ind, section: 0)
        self.view.endEditing(true)
        let commentRef = ref.child("items").child(item.firebaseKey).child("comments").childByAutoId()
        commentRef.setValue(["user": String(describing: userID), "comment": String(describing: commentText), "time": NSDate().timeIntervalSince1970])
        tableView.reloadData()
        tableView.scrollToRow(at: path, at: UITableViewScrollPosition.bottom, animated: true)
    }
    
    func getComments() {
        ref.child("items").child(item.firebaseKey).child("comments").observeSingleEvent(of: .value, with: { (snapshot) in
            //self.beginLoading()
            if let json = snapshot.value as? [String : AnyObject] {
                for dict in json {
                    if let dict = dict.value as? [String : AnyObject] {
                        print(dict)
                        let userID = dict["user"] as! String
                        let text = dict["comment"] as! String
                        let time = dict["time"] as! Double
                        let comment = Comment(comment: text, userID: userID, timeStamp: time)
                        comment.getUserInfo()
                        self.comments.append(comment)
                    }
                }
            }
            self.comments.sort(by: {$0.numericTimeStamp < $1.numericTimeStamp})
            self.tableView.reloadData()
        })

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddBid" {
            let vc = segue.destination as! AddBidVC
            vc.currentBid = item.cost
            vc.itemID = item.firebaseKey
            vc.userID = (FIRAuth.auth()?.currentUser?.uid)! as String
            vc.vc = self
        } else if segue.identifier == "toMarket" {
            print("prepared")
            let vc = segue.destination as! AuctionVC
            //self.view.addSubview(vc.view)
            vc.loadedOnce = false
        } else if segue.identifier == "toSeeBids" {
            let vc = segue.destination as! BidVC
            vc.item = item
        }
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
