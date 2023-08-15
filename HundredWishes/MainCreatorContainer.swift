//
//  MainCreatorContainer.swift
//  HundreedWishes
//
//  Created by Александр Рахимов on 09.07.2023.
//

import UIKit

protocol MainCreatorContainerProtocol {
    func setNavigationControllerInWindow() -> UINavigationController
}

class MainCreatorContainer: MainCreatorContainerProtocol {
    private let navigationController = UINavigationController()
    private let builder = Builder()
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext
    
    func setNavigationControllerInWindow() -> UINavigationController {
        let router = Router(navigationController: navigationController, builder: builder, context: context)
        router.openStartViewController()
        return self.navigationController
    }
}
