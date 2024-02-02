//
//  TaskModelRM.swift
//  NotesApp
//
//  Created by Сергей Золотухин on 30.01.2024.
//

import RealmSwift
import Foundation

final class TaskModelRM: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var color: String = ""
    @objc dynamic var isBold: Bool = false
        
    convenience init(taskViewModel: TaskViewModel) {
        self.init()
        title = taskViewModel.title
        date = taskViewModel.datetime
        color = taskViewModel.color
        isBold = taskViewModel.isBold
    }
}
