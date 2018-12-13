//
//  ActionSheetCell.swift
//  ADKActionSheet
//
//  Created by Work on 28/11/18.
//  Copyright © 2018 Work. All rights reserved.
//

import UIKit

class ActionSheetCell: UICollectionViewCell {
    
    @IBOutlet weak var imgAction: UIImageView!
    @IBOutlet weak var lblActionTitle: UILabel!
    @IBOutlet weak var leadingConstraintLblActionTitle: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
