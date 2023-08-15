//
//  WishesPresenter.swift
//  HundreedWishes
//
//  Created by Александр Рахимов on 09.07.2023.
//

import Foundation
import CoreData

protocol WishesPresenterProtocol: AnyObject {
    var wishesViewController: WishesViewControllerProtocol { get }
    var router: RouterProtocol { get }
    var context: NSManagedObjectContext? { get set }
    var title: String { get }
    var coordinates: [CGFloat] { get }
    var wishesFromCoreData: [WishData] { get set }
    
    init(wishesViewController: WishesViewControllerProtocol, router: RouterProtocol, title: String, coordinates: [CGFloat])
    
    func needsWishes()
    func goBack()
    func saveWishesAfterMoving()
    func goToDetailWishViewController(wish: WishData)
}

class WishesPresenter: WishesPresenterProtocol {
    unowned var wishesViewController: WishesViewControllerProtocol
    var router: RouterProtocol
    var context: NSManagedObjectContext?
    var title: String
    var coordinates: [CGFloat]
    var wishesFromCoreData = [WishData]()
    
    required init(wishesViewController: WishesViewControllerProtocol, router: RouterProtocol, title: String, coordinates: [CGFloat]) {
        self.wishesViewController = wishesViewController
        self.router = router
        self.title = title
        self.coordinates = coordinates
    }
    
    func needsWishes() {
        DispatchQueue.main.async {
            self.getWishesFromCoreDataAndFillWishesArray()
            self.wishesViewController.set(title: self.title)
            self.wishesViewController.reloadTable()
        }
    }
    
    private func getWishesFromCoreDataAndFillWishesArray() {
        guard let context = self.context else { return }
        let fetchRequest: NSFetchRequest<WishData> = WishData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        guard let wishesFromCoreData = try? context.fetch(fetchRequest) else {
            print(#function)
            return }
        let orderedWishesFomCoreData = wishesFromCoreData.sorted(by: { $0.order < $1.order })
        Task {
            await self.fill(wishesFromCoreData: orderedWishesFomCoreData)
        }
    }
    
    private func fill(wishesFromCoreData array: [WishData]) async {
        guard let type = setWishesType() else { return }
        switch type {
        case .all:
            self.wishesFromCoreData = array
        case .done:
            var doneWishes = [WishData]()
            for wish in array {
                if wish.isDone {
                    doneWishes.append(wish)
                }
            }
            self.wishesFromCoreData = doneWishes
        case .undone:
            var undoneWishes = [WishData]()
            for wish in array {
                if !wish.isDone {
                    undoneWishes.append(wish)
                }
            }
            self.wishesFromCoreData = undoneWishes
        }
    }
    
    private func setWishesType() -> WishesType? {
        let type = WishesType(rawValue: self.title)
        return type
    }
    
    func goBack() {
        router.popToStartViewController(coordinates: self.coordinates)
    }
    
    func saveWishesAfterMoving() {
        guard let context = self.context else { return }
        
        for (index, wish) in self.wishesFromCoreData.enumerated() {
            wish.order = Int64(index)
        }
        do {
            try context.save()
            wishesViewController.reloadTable()
        } catch {
            print(#function)
        }
    }
    
    func goToDetailWishViewController(wish: WishData) {
        router.goToDetailWishViewController(wish: wish)
    }
}
