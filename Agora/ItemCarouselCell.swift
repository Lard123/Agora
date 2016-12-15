//
//  ItemCarouselCell.swift
//  Agora
//
//  Created by Varun Shenoy on 12/13/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit

class ItemCarouselCell: UITableViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var container: UIScrollView!
    
    @IBOutlet weak var imgCounter: UILabel!
    
    @IBOutlet weak var pager: UIPageControl!
    
    var count = 0

    func setUpCell(imageURLs: [String]) {
        count = imageURLs.count
        container.delegate = self
        pager.size(forNumberOfPages: count)
        
        let scrollViewWidth:CGFloat = self.container.frame.width
        
        container.isPagingEnabled = true
        container.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        container.showsHorizontalScrollIndicator = false
        
        for (index, url) in imageURLs.enumerated() {
            let image = CustomImageView(/*frame: CGRect(x: CGFloat(index) * UIScreen.main.bounds.width, y:0,width:scrollViewWidth, height:scrollViewHeight)*/)
            image.loadImageUsingUrlString(urlString: url)
            image.contentMode = .scaleAspectFill
            self.container.addSubview(image)
            print("check")
            image.frame.size.width = scrollViewWidth
            image.frame.origin.x = CGFloat(index) * UIScreen.main.bounds.width
            
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = container.contentOffset.x/container.frame.size.width
        pager.currentPage = Int(page)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
