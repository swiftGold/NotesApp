//
//  UIColor+Extension.swift
//  NotesApp
//
//  Created by Сергей Золотухин on 02.02.2024.
//

import UIKit

extension UIColor {
    static func returnColor(from name: String) -> UIColor? {
        switch name.lowercased() {
        case "black":
            return .black
        case "cyan":
            return .cyan
        case "orange":
            return .orange
        case "green":
            return .green
        case "red":
            return .red
        default:
            return nil
        }
    }
}
