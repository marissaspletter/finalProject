//
//  DetailTableViewController.swift
//  Final Project
//
//  Created by Marissa Spletter on 11/30/21.
//

import UIKit
import UserNotifications

private let dateFormatter: DateFormatter = {
    print("📅 This is my date formatter")
    let dateFormatter = DateFormatter()
    //let timeFormatter = RelativeDateTimeFormatter
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

class DetailTableViewController: UITableViewController {
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteView: UITextView!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var compactDatePicker: UIDatePicker!
    @IBOutlet weak var timeToComplete: UIDatePicker!
    
    var letterItem: LetterItem!

    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesTextViewIndexPath = IndexPath(row: 0, section: 2)
    let notesRowHeight: CGFloat = 200
    let defaultRowHeight: CGFloat = 44

    override func viewDidLoad() {
        super.viewDidLoad()
        // show or hide the appropriate date picker
        if #available(iOS 14.0, *) { // use compact version
            datePicker = compactDatePicker
            datePicker.isHidden = false
            dateLabel.isHidden = true
        } else { // use old .wheel version
            compactDatePicker.isHidden = true
            dateLabel.isHidden = false
        }

        // setup foreground notification
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)

        // hide keyboard if we tap outside of a field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

        nameField.delegate = self

        if letterItem == nil {
            letterItem = LetterItem(name: "", date: Date().addingTimeInterval(24*60*60), notes: "", reminderSet: false, completed: false, timeToComplete: Date().addingTimeInterval(60*15))
            nameField.becomeFirstResponder()
        }
        //timeToComplete.countDownDuration = 60.0 * 15 //Fifteen minutes
        updateUserInterface()
    }

    @objc func appActiveNotification() {
        print("😮 The app just came to the foreground - cool!")
        updateReminderSwitch()
    }

    func updateUserInterface() {
        nameField.text = letterItem.name
        datePicker.date = letterItem.date
        timeToComplete.date = letterItem.timeToComplete
        noteView.text = letterItem.notes
        reminderSwitch.isOn = letterItem.reminderSet
        dateLabel.textColor = (reminderSwitch.isOn ? .black : .gray)
        dateLabel.text = dateFormatter.string(from: letterItem.date)
        datePicker.isEnabled = reminderSwitch.isOn
        enableDisableSaveButton(text: nameField.text!)
        updateReminderSwitch()
    }

    func updateReminderSwitch() {
        LocalNotificationManager.isAuthorized { (authorized) in
            DispatchQueue.main.async {
                if !authorized && self.reminderSwitch.isOn {
                    self.oneButtonAlert(title: "User Has Not Allowed Notifications", message: "To receive alerts for reminders, open the Settings app, select To Do List > Notifications > Allow Notifications.")
                    self.reminderSwitch.isOn = false
                }
                self.view.endEditing(true)
                self.dateLabel.textColor = (self.reminderSwitch.isOn ? .black : .gray)
                self.datePicker.isEnabled = self.reminderSwitch.isOn
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        letterItem = LetterItem(name: nameField.text!, date: datePicker.date, notes: noteView.text, reminderSet: reminderSwitch.isOn, completed: letterItem.completed, timeToComplete: timeToComplete.date)
    }

    func enableDisableSaveButton(text: String) {
        if text.count > 0 {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func reminderSwitchChanged(_ sender: UISwitch) {
        updateReminderSwitch()
    }

    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        self.view.endEditing(true)
        dateLabel.text = dateFormatter.string(from: sender.date)
    }

    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        enableDisableSaveButton(text: sender.text!)
    }
    

}

extension DetailTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            if #available(iOS 14.0, *) {
                return 0
            } else {
                return reminderSwitch.isOn ? datePicker.frame.height : 0
            }
        case notesTextViewIndexPath:
            return notesRowHeight
        default:
            return defaultRowHeight
        }
    }
}

extension DetailTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteView.becomeFirstResponder()
        return true
    }
}
