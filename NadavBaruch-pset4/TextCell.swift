//
//  NoteCell.swift
//  NadavBaruch-pset4
//
//  Created by Nadav Baruch on 20-11-16.
//  Copyright © 2016 Nadav Baruch. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {
    @IBOutlet weak var inputText: UILabel!
    @IBOutlet weak var checkSwitch: UISwitch!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
