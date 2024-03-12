//
//  UserModel.swift
//  Tagilov_BinomTech_TestTask
//
//  Created by Владимир on 12.03.2024.
//

import Foundation

struct UserModel {
    let name: String
    let imageData: Data
    let lastSeenDate: Date
    let observerMethod: ObserverMethod
    
    func getLastSeenTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: lastSeenDate)
    }
    func getLastSeenDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: lastSeenDate)
    }
}

enum ObserverMethod: String {
    case GPS
}
