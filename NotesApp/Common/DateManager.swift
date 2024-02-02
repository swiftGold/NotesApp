//
//  DateManager.swift
//  NotesApp
//
//  Created by Сергей Золотухин on 30.01.2024.
//

import UIKit

protocol DateManagerProtocol {
    func fetchStringDate(date: Date) -> String
}

final class DateManager {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
}

extension DateManager: DateManagerProtocol {
    func fetchStringDate(date: Date) -> String {
        dateFormatter.dateFormat = "dd LLL HH:mm"
        dateFormatter.timeZone = .current
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
