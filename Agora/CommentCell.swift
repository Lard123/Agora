//
//  CommentCell.swift
//  Agora
//
//  Created by Varun Shenoy on 12/16/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    // outlets to user interface items in the view controller
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var profileImage: CustomImageView!
    
    var comment: Comment?
    var vc: ItemVC?
    
    func setUpCell(comment: Comment, vc: ItemVC) {
        
        //display this comment with its information and image
        self.vc = vc
        self.comment = comment
        profileImage.loadImageUsingUrlString(urlString: comment.pictureURL)
        commentLabel.text = comment.comment
        nameLabel.text = comment.name
        timeLabel.text = comment.timeStamp
    }
    
    // if the comment is tapped on, show the commenter's profile
    @IBAction func toUserDetail(_ sender: Any) {
        vc?.toUserVC(id: (comment?.userID)!)
    }

}
