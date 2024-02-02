//
//  ShowTaskDescriptionPresenter.swift
//  NotesApp
//
//  Created by Сергей Золотухин on 30.01.2024.
//

import Foundation

protocol ShowTaskDescriptionPresenterProtocol {
    func viewDidLoad()
    func editTask(with model: TaskModel)
    func deleteTask()
}

// MARK: - ShowTaskDescriptionPresenter
final class ShowTaskDescriptionPresenter {
    weak var viewController: ShowTaskDescriptionProtocol?
    private let realmService = RealmService()
    private let moduleBuilder: ModuleBuilderProtocol
    private let router: Router
    private let dateManager: DateManagerProtocol
    private let alertManager: AlertManagerProtocol
    
    private var taskModelRM: TaskModelRM
    
    init(moduleBuilder: ModuleBuilderProtocol,
         router: Router,
         dateManager: DateManagerProtocol,
         taskModelRM: TaskModelRM,
         alertManager: AlertManagerProtocol
    )
    {
        self.moduleBuilder = moduleBuilder
        self.router = router
        self.dateManager = dateManager
        self.taskModelRM = taskModelRM
        self.alertManager = alertManager
    }
}

// MARK: - ShowTaskDescriptionPresenterProtocol impl
extension ShowTaskDescriptionPresenter: ShowTaskDescriptionPresenterProtocol {
    func viewDidLoad() {
        let taskViewModel = TaskViewModel(title: taskModelRM.title,
                                          datetime: taskModelRM.date,
                                          color: taskModelRM.color,
                                          isBold: taskModelRM.isBold
        )
        viewController?.showView(taskViewModel)
    }
    
    func editTask(with model: TaskModel) {
        if model.title.isEmpty {
            alertManager.showAlertWithVC(title: Names.alertTitle, message: Names.alertMessage, vc: viewController)
        } else {
            let object = taskModelRM
            let dateString = dateManager.fetchStringDate(date: Date())
            let editedTitle: [String : Any?] = [Names.title: model.title]
            let editedDate: [String : Any?] = [Names.date: dateString]
            let editedColor: [String : Any?] = [Names.color: model.color]
            let editedIsBold: [String : Any?] = [Names.isBold: model.isBold]
            
            updateObject(object, editedTitle)
            updateObject(object, editedDate)
            updateObject(object, editedColor)
            updateObject(object, editedIsBold)
            
            let vc = moduleBuilder.buildMainViewController()
            router.push(vc, animated: false)
        }
    }
    
    func deleteTask() {
        let object = taskModelRM
        
        realmService.delete(object) { result in
            switch result {
                
            case .success():
                print("Deleted")
            case .failure(let error):
                print("Failure update - \(error.localizedDescription)")
            }
        }
        
        let vc = moduleBuilder.buildMainViewController()
        router.push(vc, animated: false)
    }
}

// MARK: - Private methods
private extension ShowTaskDescriptionPresenter {
    func updateObject(_ object: TaskModelRM, _ array: [String : Any?]) {
        realmService.update(object, with: array) { result in
            switch result {
                
            case .success():
                print("success")
            case .failure(let error):
                print("Failure update - \(error.localizedDescription)")
            }
        }
    }
}
