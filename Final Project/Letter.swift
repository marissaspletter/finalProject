//
//  Letter.swift
//  Final Project
//
//  Created by Marissa Spletter on 12/1/21.
//

import Foundation

struct LetterItem: Codable {
    var name: String
    var date: Date
    var notes: String
    var reminderSet: Bool
    var notificationID: String?
    var completed: Bool
    var timeToComplete: Date
}
