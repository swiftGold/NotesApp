//
//  AddTaskPresenter.swift
//  NotesApp
//
//  Created by Сергей Золотухин on 29.01.2024.
//

import Foundation
import RealmSwift

protocol AddTaskPresenterProtocol {
    func addTask(with model: TaskModel)
}

// MARK: - AddTaskPresenter
final class AddTaskPresenter {
    weak var viewController: AddTaskProtocol?
    private let realmService = RealmService()
    private let moduleBuilder: ModuleBuilderProtocol
    private let router: Router
    private let dateManager: DateManagerProtocol
    private let alertManager: AlertManagerProtocol
    
    init(moduleBuilder: ModuleBuilderProtocol,
         router: Router,
         dateManager: DateManagerProtocol,
         alertManager: AlertManagerProtocol
    )
    {
        self.moduleBuilder = moduleBuilder
        self.router = router
        self.dateManager = dateManager
        self.alertManager = alertManager
    }
}

// MARK: - AddTaskPresenterProtocol
extension AddTaskPresenter: AddTaskPresenterProtocol {
    func addTask(with model: TaskModel) {
        if model.title.isEmpty {
            alertManager.showAlertWithVC(title: Names.alertTitle, message: Names.alertMessage, vc: viewController)
        } else {
            let currentDate = Date()
            let dateString = dateManager.fetchStringDate(date: currentDate)
            let taskViewModel = TaskViewModel(title: model.title,
                                              datetime: dateString,
                                              color: model.color,
                                              isBold: model.isBold
            )
            
            let mainViewController = moduleBuilder.buildMainViewController()
            let object = TaskModelRM(taskViewModel: taskViewModel)
            
            realmService.create(object) { [unowned self] result in
                switch result {
                case .success:
                    print("Success created new TASK")
                    router.push(mainViewController, animated: true)
                case .failure(let error):
                    print("Failure - \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - Private methods
private extension AddTaskPresenter {
    
}
