//
//  Builder.swift
//  HundreedWishes
//
//  Created by Александр Рахимов on 09.07.2023.
//

import UIKit
import CoreData

protocol BuilderProtocol {
    func createStartViewController(router: RouterProtocol, context: NSManagedObjectContext?) -> UIViewController
    func createWwishesViewController(router: RouterProtocol, title: String, coordinates: [CGFloat], context: NSManagedObjectContext?) -> UIViewController
    func createNewWishViewController(router: RouterProtocol, title: String, coordinates: [CGFloat], context: NSManagedObjectContext?) -> UIViewController
    func createDetailWishViewController(router: RouterProtocol, wish: WishData, context: NSManagedObjectContext?) -> UIViewController
    func createEditWishViewController(router: RouterProtocol, wish: WishData, context: NSManagedObjectContext?) -> UIViewController
}

class Builder: BuilderProtocol {
    func createStartViewController(router: RouterProtocol, context: NSManagedObjectContext?) -> UIViewController {
        let startViewController = StartViewController()
        let startPresenter = StartPresenter(startViewController: startViewController, router: router)
        startPresenter.context = context
        startViewController.startPresenter = startPresenter
        return startViewController
    }
    
    func createWwishesViewController(router: RouterProtocol, title: String, coordinates: [CGFloat], context: NSManagedObjectContext?) -> UIViewController {
        let wishesViewController = WishesViewController()
        let wishesPresenter = WishesPresenter(wishesViewController: wishesViewController, router: router, title: title, coordinates: coordinates)
        wishesPresenter.context = context
        wishesViewController.wishesPresenter = wishesPresenter
        return wishesViewController
    }
    
    func createNewWishViewController(router: RouterProtocol, title: String, coordinates: [CGFloat], context: NSManagedObjectContext?) -> UIViewController {
        let newWishViewController = NewWishViewController()
        let newWishPresenter = NewWishPresenter(newWishViewController: newWishViewController, router: router, title: title, coordinates: coordinates)
        newWishPresenter.context = context
        newWishViewController.newWishPresenter = newWishPresenter
        return newWishViewController
    }
    
    func createDetailWishViewController(router: RouterProtocol, wish: WishData, context: NSManagedObjectContext?) -> UIViewController {
        let detailWishViewController = DetailWishViewController()
        let detailWishPresenter = DetailWishPresenter(detailWishViewController: detailWishViewController, router: router, wish: wish)
        detailWishPresenter.context = context
        detailWishViewController.detailWishPresenter = detailWishPresenter
        return detailWishViewController
    }
    
    func createEditWishViewController(router: RouterProtocol, wish: WishData, context: NSManagedObjectContext?) -> UIViewController {
        let editWishViewController = EditWishViewController()
        let editWishPresenter = EditWishPresenter(editWishViewController: editWishViewController, router: router, wish: wish)
        editWishPresenter.context = context
        editWishViewController.editWishPresenter = editWishPresenter
        return editWishViewController
    }
}
