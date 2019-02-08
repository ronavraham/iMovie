//
//  CommentRowCell.swift
//  iMovie
//
//  Created by admin on 08/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class CommentRowCell: UITableViewCell {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
