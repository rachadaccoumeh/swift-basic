//
//  TableViewCell.swift
//  test
//
//  Created by Telepaty1 on 2/16/23.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var itemViewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
