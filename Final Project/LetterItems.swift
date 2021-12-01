//
//  LetterItems.swift
//  Final Project
//
//  Created by Marissa Spletter on 12/1/21.
//

import Foundation
import UserNotifications

class LetterItems {
    var itemsArray: [LetterItem] = []
    
    func loadData(completed: @escaping ()->() ) {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("letters").appendingPathExtension("json")
        
        guard let data = try? Data(contentsOf: documentURL) else {return}
        let jsonDecoder = JSONDecoder()
        do {
            itemsArray = try jsonDecoder.decode(Array<LetterItem>.self, from: data)
        } catch {
            print("😡 ERROR: Could not load data \(error.localizedDescription)")
        }
        completed()
    }
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("letters").appendingPathExtension("json")
        
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(itemsArray)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("😡 ERROR: Could not save data \(error.localizedDescription)")
        }
        setNotifications()
    }

    func setNotifications() {
        guard itemsArray.count > 0 else {
            return
        }
         // remove all notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // and let's re-create them with the updated data that we just saved
        for index in 0..<itemsArray.count {
            if itemsArray[index].reminderSet {
                let letterItem = itemsArray[index]
                itemsArray[index].notificationID = LocalNotificationManager.setCalendarNotification(title: letterItem.name, subtitle: "", body: letterItem.notes, badgeNumber: nil, sound: .default, date: letterItem.date)
            }
        }
    }
}

