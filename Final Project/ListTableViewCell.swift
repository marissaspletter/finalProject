//
//  ListTableViewCell.swift
//  Final Project
//
//  Created by Marissa Spletter on 12/1/21.
//

import UIKit

protocol ListTableViewCellDelegate: AnyObject {
    func checkBoxToggle(sender: ListTableViewCell)
}

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeCountLabel: UILabel!
    weak var delegate: ListTableViewCellDelegate?
    
    var letterItem: LetterItem! {
        didSet {
            nameLabel.text = letterItem.name
            timeCountLabel.text = "Estimated time: \(letterItem.timeToComplete)"
            checkBoxButton.isSelected = letterItem.completed
        }
    }
    
    @IBAction func checkToggled(_ sender: UIButton) {
        delegate?.checkBoxToggle(sender: self)
    }
}
