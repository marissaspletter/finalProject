//
//  ListTableViewCell.swift
//  Final Project
//
//  Created by Marissa Spletter on 12/1/21.
//

import UIKit

protocol ListTableViewCellDelegate: class {
    func checkBoxToggle(sender: ListTableViewCell)
}

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    weak var delegate: ListTableViewCellDelegate?
    
    var letterItem: LetterItem! {
        didSet {
            nameLabel.text = letterItem.name
            checkBoxButton.isSelected = letterItem.completed
        }
    }
    
    @IBAction func checkToggled(_ sender: UIButton) {
        delegate?.checkBoxToggle(sender: self)
    }
}
