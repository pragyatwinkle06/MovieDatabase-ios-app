//
//  OptionCell.swift
//  movie_Database
//
//  Created by Tata on 29/06/24.
//

import UIKit

class OptionCell: UITableViewCell {

    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
            textLabel?.textColor = .black
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            // Configure the view for the selected state
        }
    
}
