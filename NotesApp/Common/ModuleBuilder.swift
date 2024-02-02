//
//  ModuleBuilder.swift
//  NotesApp
//
//  Created by Сергей Золотухин on 29.01.2024.
//

protocol ModuleBuilderProtocol {
    func buildMainViewController() -> MainViewController
    func buildAddTaskViewViewController() -> AddTaskViewController
    func buildShowTaskDescriptionViewViewController(_ model: TaskModelRM) -> ShowTaskDescriptionViewController
}

final class ModuleBuilder {
    private var router: Router
    
    init(router: Router
    ) {
        self.router = router
    }
}

extension ModuleBuilder: ModuleBuilderProtocol {
    func buildShowTaskDescriptionViewViewController(_ model: TaskModelRM) -> ShowTaskDescriptionViewController {
        let viewController = ShowTaskDescriptionViewController()
        let dateManager = DateManager()
        let alertManager = AlertManager()
        let presenter = ShowTaskDescriptionPresenter(moduleBuilder: self,
                                                     router: router,
                                                     dateManager: dateManager,
                                                     taskModelRM: model,
                                                     alertManager: alertManager
        )
        viewController.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }
    
    func buildAddTaskViewViewController() -> AddTaskViewController {
        let viewController = AddTaskViewController()
        let dateManager = DateManager()
        let alertManager = AlertManager()
        let presenter = AddTaskPresenter(moduleBuilder: self,
                                         router: router,
                                         dateManager: dateManager,
                                         alertManager: alertManager
        )
        viewController.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }
    
    func buildMainViewController() -> MainViewController {
        let viewController = MainViewController()
        let realmService = RealmService()
        let presenter = MainPresenter(router: router,
                                      moduleBuilder: self,
                                      realmService: realmService
        )
        viewController.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }
}
