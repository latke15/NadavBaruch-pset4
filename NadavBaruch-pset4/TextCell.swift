//
//  NoteCell.swift
//  NadavBaruch-pset4
//
//  Created by Nadav Baruch on 20-11-16.
//  Copyright © 2016 Nadav Baruch. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    @IBOutlet weak var inputText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
