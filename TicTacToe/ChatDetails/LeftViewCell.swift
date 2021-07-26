//
//  LeftViewCell.swift
//  ChatSample
//
//  Created by Hafiz on 20/09/2019.
//  Copyright © 2019 Nibs. All rights reserved.
//

import UIKit

class LeftViewCell: UITableViewCell {

    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var textMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageContainerView.rounded(radius: 12)
        messageContainerView.backgroundColor = UIColor(red: 32/255, green: 192/255, blue: 243/255, alpha: 0.5)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    func configureCell(message: Message) {
        textMessageLabel.text = message.text
    }
    
}
