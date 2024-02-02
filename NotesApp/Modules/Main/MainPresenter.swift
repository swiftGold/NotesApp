//
//  MainPresenter.swift
//  NotesApp
//
//  Created by Сергей Золотухин on 29.01.2024.
//

import Foundation

protocol MainPresenterProtocol {
    func viewDidLoad()
    func didTapCell(at index: Int)
    func addTask()
    func editButtonTapped(with model: TaskViewModel)
    func deleteButtonTapped(with model: TaskViewModel)
}

// MARK: - MainPresenter
final class MainPresenter {
    weak var viewController: MainViewControllerProtocol?
    
    private var testArray: [TaskViewModel] = []
    
    private let router: Router
    private let moduleBuilder: ModuleBuilderProtocol
    private let realmService: RealmServiceProtocol
    
    init(router: Router,
         moduleBuilder: ModuleBuilderProtocol,
         realmService: RealmServiceProtocol
    ) {
        self.router = router
        self.moduleBuilder = moduleBuilder
        self.realmService = realmService
    }
}

// MARK: - MainPresenterProtocol
extension MainPresenter: MainPresenterProtocol {
    func viewDidLoad() {
        getTasksArrayFromRealm()
        viewController?.showTasks(with: testArray)
    }
    
    func didTapCell(at index: Int) {
        let model = getRealmModedelsArray()[index]
        let showTaskDescriptionViewController = moduleBuilder.buildShowTaskDescriptionViewViewController(model)
        router.push(showTaskDescriptionViewController, animated: false)
    }
    
    func addTask() {
        let addTaskViewController = moduleBuilder.buildAddTaskViewViewController()
        router.push(addTaskViewController, animated: false)
    }
    
    func editButtonTapped(with model: TaskViewModel) {
        let object = TaskModelRM(taskViewModel: model)
        let array = getRealmModedelsArray()
        let index = findIndex(object, array)
        let findedObject = getRealmModedelsArray()[index]
        let showTaskDescriptionViewController = moduleBuilder.buildShowTaskDescriptionViewViewController(findedObject)
        router.push(showTaskDescriptionViewController, animated: false)
    }
    
    func deleteButtonTapped(with model: TaskViewModel) {
        let object = TaskModelRM(taskViewModel: model)
        let array = getRealmModedelsArray()
        let index = findIndex(object, array)
        let findedObject = getRealmModedelsArray()[index]
        
        realmService.delete(findedObject) { result in
            switch result {
                
            case .success():
                print("Deleted")
            case .failure(let error):
                print("Failure update - \(error.localizedDescription)")
            }
        }
        
        viewDidLoad()
    }
}

// MARK: - Private methods
private extension MainPresenter {
    func getTasksArrayFromRealm() {
        testArray = getRealmModedelsArray().map { TaskViewModel(title: $0.title, datetime: $0.date, color: $0.color, isBold: $0.isBold)}
    }
    
    func getRealmModedelsArray() -> [TaskModelRM] {
        let arrayFromRealm = Array(realmService.read(TaskModelRM.self))
        return arrayFromRealm
    }
    
    func findIndex(_ object: TaskModelRM, _ array: [TaskModelRM]) -> Int {
        var findedIndex = 0
        
        array.enumerated().forEach { index, value in
            if value.title == object.title && value.date == value.date {
                findedIndex = index
            }
        }
        
        return findedIndex
    }
}
