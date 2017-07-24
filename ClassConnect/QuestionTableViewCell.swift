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
    @IBOutlet var barrierView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        questionText.backgroundColor = UIColor.white
        questionText.layer.cornerRadius = 5.0
        questionText.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
