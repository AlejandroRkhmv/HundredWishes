//
//  Router.swift
//  HundreedWishes
//
//  Created by Александр Рахимов on 09.07.2023.
//

import UIKit
import CoreData

protocol RouterProtocol {
    var navigationController: UINavigationController { get set }
    var builder: BuilderProtocol { get set }
    var context: NSManagedObjectContext? { get }
    
    init(navigationController: UINavigationController, builder: BuilderProtocol, context: NSManagedObjectContext?)
    
    func pop()
    func popToStartViewController(coordinates: [CGFloat])
    func popToDetailWishViewController(wish: WishData)
    func openStartViewController()
    func goToWishesViewController(title: String, coordinates: [CGFloat])
    func goToNewWishViewController(title: String, coordinates: [CGFloat])
    func goToDetailWishViewController(wish: WishData)
    func goToEditWishViewController(wish: WishData)
}

class Router: RouterProtocol {
    var navigationController: UINavigationController
    var builder: BuilderProtocol
    var context: NSManagedObjectContext?
    
    required init(navigationController: UINavigationController, builder: BuilderProtocol, context: NSManagedObjectContext?) {
        self.navigationController = navigationController
        self.builder = builder
        self.context = context
    }
    
    func pop() {
        navigationController.popViewController(animated: false)
    }
    
    func popToStartViewController(coordinates: [CGFloat]) {
        navigationController.popViewController(animated: false)
        guard let startViewController = navigationController.viewControllers.last as? StartViewController else { return }
        startViewController.startPresenter?.coordinates = coordinates
    }
    
    func popToDetailWishViewController(wish: WishData) {
        navigationController.popViewController(animated: false)
        guard let detailWishViewController = navigationController.viewControllers.last as? DetailWishViewController else { return }
        detailWishViewController.detailWishPresenter?.wish = wish
    }
    
    func openStartViewController() {
        let startViewController = builder.createStartViewController(router: self, context: context)
        navigationController.viewControllers.append(startViewController)
    }
    
    func goToWishesViewController(title: String, coordinates: [CGFloat]) {
        let wishesViewController = builder.createWwishesViewController(router: self, title: title, coordinates: coordinates, context: context)
        navigationController.pushViewController(wishesViewController, animated: false)
    }
    
    func goToNewWishViewController(title: String, coordinates: [CGFloat]) {
        let newWishViewController = builder.createNewWishViewController(router: self, title: title, coordinates: coordinates, context: context)
        navigationController.pushViewController(newWishViewController, animated: false)
    }
    
    func goToDetailWishViewController(wish: WishData) {
        let detailWishViewController = builder.createDetailWishViewController(router: self, wish: wish, context: context)
        navigationController.pushViewController(detailWishViewController, animated: false)
    }
    
    func goToEditWishViewController(wish: WishData) {
        let editWishViewController = builder.createEditWishViewController(router: self, wish: wish, context: context)
        navigationController.pushViewController(editWishViewController, animated: false)
    }
}
