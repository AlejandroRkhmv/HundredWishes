//
//  StartPresenter.swift
//  HundreedWishes
//
//  Created by Александр Рахимов on 09.07.2023.
//

import Foundation
import CoreData

protocol StartPresenterProtocol: AnyObject {
    var startViewController: StartViewControllerProtocol { get }
    var router: RouterProtocol { get }
    var coordinates: [CGFloat]? { get set }
    var counts: (Int, Int) { get }
    
    init(startViewController: StartViewControllerProtocol, router: RouterProtocol)
    
    func goToNewWishViewController(title: String)
    func goToWishesViewController(title: String)
    func setCoordinates()
    func needsCountsOfDoneAndUndoneWishes()
}

class StartPresenter: StartPresenterProtocol {
    unowned var startViewController: StartViewControllerProtocol
    var router: RouterProtocol
    var context: NSManagedObjectContext?
    var coordinates: [CGFloat]?
    var counts = (0, 0)
    
    required init(startViewController: StartViewControllerProtocol, router: RouterProtocol) {
        self.startViewController = startViewController
        self.router = router
    }
    
    func goToNewWishViewController(title: String) {
        guard let coordinates = self.coordinates else { return }
        router.goToNewWishViewController(title: title, coordinates: coordinates)
    }
    
    func goToWishesViewController(title: String) {
        guard let coordinates = self.coordinates else { return }
        router.goToWishesViewController(title: title, coordinates: coordinates)
    }
    
    func setCoordinates() {
        guard let coordinates = self.coordinates else { return }
        startViewController.set(coordinates: coordinates)
    }
    
    func needsCountsOfDoneAndUndoneWishes() {
        self.getCurrentCountDoneAndUndoneWishesFromCoreData()
        DispatchQueue.main.async {
            self.startViewController.set(counts: self.counts)
        }
    }
    
    private func getCurrentCountDoneAndUndoneWishesFromCoreData() {
        guard let context = self.context else { return }
        let fetchRequest: NSFetchRequest<WishData> = WishData.fetchRequest()
        guard let wishesFromCoreData = try? context.fetch(fetchRequest) else {
            print(#function)
            return }
        
        self.fillCountsOfDoneAndUndoneWishes(wishesFromCoreData: wishesFromCoreData)
    }
    
    private func fillCountsOfDoneAndUndoneWishes(wishesFromCoreData array: [WishData]) {
        var tempCounts = (0, 0)
        for wish in array {
            if wish.isDone {
                tempCounts.0 += 1
            } else {
                tempCounts.1 += 1
            }
        }
        self.counts.0 = tempCounts.0
        self.counts.1 = tempCounts.1
    }
}
