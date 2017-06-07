//
//  QuestionTableViewCell.swift
//  ClassConnect
//
//  Created by Nguyen Do on 6/6/17.
//  Copyright © 2017 Nguyen Do. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet var questionText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
