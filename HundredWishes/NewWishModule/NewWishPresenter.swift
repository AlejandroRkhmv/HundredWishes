//
//  NewWishPresenter.swift
//  HundreedWishes
//
//  Created by Александр Рахимов on 10.07.2023.
//

import Foundation
import CoreData

protocol NewWishPresenterProtocol: AnyObject {
    var newWishViewController: NewWishViewControllerProtocol { get }
    var router: RouterProtocol { get }
    var context: NSManagedObjectContext? { get }
    var title: String { get }
    var coordinates: [CGFloat] { get }
    
    init(newWishViewController: NewWishViewControllerProtocol, router: RouterProtocol, title: String, coordinates: [CGFloat])
    
    func setTitle()
    func goBack()
    func createNew(wish title: String)
}

class NewWishPresenter: NewWishPresenterProtocol {
    unowned var newWishViewController: NewWishViewControllerProtocol
    var router: RouterProtocol
    var context: NSManagedObjectContext?
    var title: String
    var coordinates: [CGFloat]
    
    required init(newWishViewController: NewWishViewControllerProtocol, router: RouterProtocol, title: String,  coordinates: [CGFloat]) {
        self.newWishViewController = newWishViewController
        self.router = router
        self.title = title
        self.coordinates = coordinates
    }
    
    func setTitle() {
        DispatchQueue.main.async {
            self.newWishViewController.set(title: self.title)
        }
    }
    
    func goBack() {
        router.popToStartViewController(coordinates: self.coordinates)
    }
    
    func createNew(wish title: String) {
        let newWish = WishModel(title: title, order: getCountOfWishesFromCoreData())
        saveNew(wish: newWish)
    }
    
    private func getCountOfWishesFromCoreData() -> Int {
        guard let context = self.context else { return 0 }
        let fetchRequest: NSFetchRequest<WishData> = WishData.fetchRequest()
        guard let wishesFromCD = try? context.fetch(fetchRequest) else {
            print(#function)
            return 0 }
        return wishesFromCD.count
    }
    
    private func saveNew(wish: WishModel) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let context = self.context else { return }
            let wishForCoreData = WishData(context: context)
            wishForCoreData.title = wish.title
            wishForCoreData.createDate = wish.date
            wishForCoreData.isDone = wish.isDone
            wishForCoreData.order = Int64(wish.order)
            do {
                try context.save()
            } catch {
                print(#function)
            }
        }
    }
}
