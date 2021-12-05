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

private let dateFormatter: DateFormatter = {
    print("📅 This is my date formatter")
    let dateFormatter = DateFormatter()
    //let timeFormatter = RelativeDateTimeFormatter
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    dateFormatter.dateFormat = "HH, mm"
    return dateFormatter
}()

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeCountLabel: UILabel!
    weak var delegate: ListTableViewCellDelegate?
    
    var letterItem: LetterItem! {
        didSet {
            nameLabel.text = letterItem.name
//            let timeFormatted = dateFormatter.string(from: letterItem.timeToComplete).prefix(5)
//            let secFormatted = timeFormatted.suffix(3)
//            let hrFormatted = timeFormatted.prefix(1)
//            timeCountLabel.text = "Estimated time: \(hrFormatted) hours, \(secFormatted) seconds"
            let formattedTime = (dateFormatter.string(from: letterItem.timeToComplete))
            timeCountLabel.text = "Estimated time: \(formattedTime.prefix(2)) hr. \(formattedTime.suffix(3)) sec. "
            checkBoxButton.isSelected = letterItem.completed
        }
    }
    
    @IBAction func checkToggled(_ sender: UIButton) {
        delegate?.checkBoxToggle(sender: self)
    }
}
