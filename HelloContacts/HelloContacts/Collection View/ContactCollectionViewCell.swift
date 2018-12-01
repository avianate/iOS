//
//  ContactCollectionViewCell.swift
//  HelloContacts
//
//  Created by Nate Graham on 8/14/18.
//  Copyright © 2018 Nate Graham. All rights reserved.
//

import UIKit

class ContactCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var contactImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = ""
        contactImage.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contactImage.layer.cornerRadius = 25
    }
}
