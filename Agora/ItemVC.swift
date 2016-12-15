//
//  ItemVC.swift
//  Agora
//
//  Created by Varun Shenoy on 12/13/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit
import MessageUI

class ItemVC: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var pageCounter: UILabel!
    
    @IBOutlet weak var carousel: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var item: Item!
    
    var refreshControl: UIRefreshControl!

    var customView: UIView!
    
    var count = 0
    
    var imageURLs = [String]()//["https://firebasestorage.googleapis.com/v0/b/agora-54dab.appspot.com/o/Items%2F58DC848E-E4BD-4396-B008-9A41B806EB46.jpg?alt=media&token=d9ff3355-8bc4-439e-b585-5e18850340fd", "https://firebasestorage.googleapis.com/v0/b/agora-54dab.appspot.com/o/Items%2FBE442CA2-07D6-4F3E-B032-F884B3FA69E8.jpg?alt=media&token=314ea0c9-5303-4bfb-835f-9963ad528b83", "https://firebasestorage.googleapis.com/v0/b/agora-54dab.appspot.com/o/Items%2FEFAFA62E-8BA0-406C-988B-E249F84AC4A9.jpg?alt=media&token=215d8c85-2f0e-4ce4-b5b3-afe9b4361464"]
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        imageURLs = item.imageURLs
        count = imageURLs.count
        carousel.delegate = self
        pageControl.numberOfPages = imageURLs.count
        pageCounter.text = "1 of \(count)"
        
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.clear
        self.tableView.insertSubview(refreshControl!, at: 0)
        
        loadCustomRefreshContents()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
            print("done")
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
        return 5
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "actionButtons", for: indexPath as IndexPath) as! ActionCell
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
            cell.setUpCell(seller: item.seller, itemName: item.name,vc: self)
            return cell
        } else if (indexPath.row == 3) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentHead", for: indexPath as IndexPath)
            return cell
        } else if (indexPath.row == 4) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath as IndexPath)
            return cell
        }
        return UITableViewCell()
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
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
