//
//  TextTableViewCell.swift
//  FriendZone
//
//  Created by robert on 1/28/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

  @IBOutlet weak var textField: UITextField!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
