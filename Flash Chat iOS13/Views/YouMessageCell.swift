//
//  YouMessageCell.swift
//  Flash Chat iOS13
//
//  Created by Omar Assidi on 21/12/2024.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import UIKit

class YouMessageCell: UITableViewCell {
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let corner = messageBubble.frame.size.height / 4
        messageBubble.layer.cornerRadius = corner
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
