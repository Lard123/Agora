//
//  CommentCell.swift
//  Agora
//
//  Created by Varun Shenoy on 12/16/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var profileImage: CustomImageView!
    
    func setUpCell(comment: Comment) {
        profileImage.loadImageUsingUrlString(urlString: comment.pictureURL)
        commentLabel.text = comment.comment
        nameLabel.text = comment.name
        timeLabel.text = comment.timeStamp
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
