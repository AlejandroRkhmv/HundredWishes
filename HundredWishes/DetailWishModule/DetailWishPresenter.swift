//
//  DetailWishPresenter.swift
//  HundreedWishes
//
//  Created by Александр Рахимов on 10.08.2023.
//

import Foundation
import CoreData

protocol DetailWishPresenterProtocol: AnyObject {
    var detailWishViewController: DetailWishViewControllerProtocol { get }
    var router: RouterProtocol { get }
    var wish: WishData { get set }
    var tap: Bool { get set }
    
    init(detailWishViewController: DetailWishViewControllerProtocol, router: RouterProtocol, wish: WishData)
    
    func deleteCurrentWish()
    func saveWishLikeImage()
    func isCompletedButtonAppears() -> Bool
    func makeWishCompleted()
    func goBack()
    func goToEditWishViewController()
    func needWishData()
    func set(InfoMesage: String)
}

class DetailWishPresenter: DetailWishPresenterProtocol {
    unowned var detailWishViewController: DetailWishViewControllerProtocol
    var router: RouterProtocol
    var wish: WishData
    var context: NSManagedObjectContext?
    var tap = false
    
    required init(detailWishViewController: DetailWishViewControllerProtocol, router: RouterProtocol, wish: WishData) {
        self.detailWishViewController = detailWishViewController
        self.router = router
        self.wish = wish
    }
    
    func deleteCurrentWish() {
        guard let context = self.context else { return }
        let fetchRequest: NSFetchRequest<WishData> = WishData.fetchRequest()
        guard let wishesFromCoreData = try? context.fetch(fetchRequest) else {
            print(#function)
            return }
        for wish in wishesFromCoreData {
            if wish.createDate == self.wish.createDate {
                context.delete(wish)
            }
        }
        do {
            try context.save()
        } catch {
            print("Error save context after delete")
        }
        deleteWishFromCurrentWishesArray()
    }
    
    private func deleteWishFromCurrentWishesArray() {
        if let wishesViewController = router.navigationController.viewControllers[router.navigationController.viewControllers.count - 2] as? WishesViewController {
            guard let wishes = wishesViewController.wishesPresenter?.wishesFromCoreData else { return }
            for (index, wish) in wishes.enumerated() {
                if wish.createDate == self.wish.createDate {
                    wishesViewController.wishesPresenter?.wishesFromCoreData.remove(at: index)
                    wishesViewController.wishesTableView.reloadData()
                }
            }
        }
    }
    
    func saveWishLikeImage() {
        DispatchQueue.main.async {
            guard let wishImage = self.detailWishViewController.wishImage else { return }
            let imageSaver = ImageSaver()
            imageSaver.writeToPhotoAlbum(image: wishImage)
        }
    }
    
    func isCompletedButtonAppears() -> Bool {
        return self.wish.isDone
    }
    
    func makeWishCompleted() {
        guard let context = self.context else { return }
        let fetchRequest: NSFetchRequest<WishData> = WishData.fetchRequest()
        guard let wishesFromCoreData = try? context.fetch(fetchRequest) else {
            print(#function)
            return }
        
        for wish in wishesFromCoreData {
            if wish.createDate == self.wish.createDate {
                wish.isDone = true
                wish.completeDate = Date()
            }
        }
        do {
            try context.save()
        } catch {
            print("Error save context after change isDone flag")
        }
        
        changeWishStatus()
    }
    
    private func changeWishStatus() {
        if let wishesViewController = router.navigationController.viewControllers[router.navigationController.viewControllers.count - 2] as? WishesViewController {
            if wishesViewController.titltLabel.text == "Unfulfilled" {
                removeWishCompletedInCurrentWishesArrayFromUfulfilledScreen()
            } else {
                makeWishCompletedInCurrentWishesArrayInAllWishesScreen()
            }
        }
    }
    
    private func makeWishCompletedInCurrentWishesArrayInAllWishesScreen() {
        if let wishesViewController = router.navigationController.viewControllers[router.navigationController.viewControllers.count - 2] as? WishesViewController {
            guard let wishes = wishesViewController.wishesPresenter?.wishesFromCoreData else { return }
            for wish in wishes {
                if wish.createDate == self.wish.createDate {
                    wish.isDone = true
                    wishesViewController.wishesTableView.reloadData()
                }
            }
        }
    }
    
    private func removeWishCompletedInCurrentWishesArrayFromUfulfilledScreen() {
        if let wishesViewController = router.navigationController.viewControllers[router.navigationController.viewControllers.count - 2] as? WishesViewController {
            guard let wishes = wishesViewController.wishesPresenter?.wishesFromCoreData else { return }
            for (index, wish) in wishes.enumerated() {
                if wish.createDate == self.wish.createDate {
                    wishesViewController.wishesPresenter?.wishesFromCoreData.remove(at: index)
                    wishesViewController.wishesTableView.reloadData()
                }
            }
        }
    }
    
    func goBack() {
        if !tap {
            router.pop()
        }
    }
    
    func goToEditWishViewController() {
        router.goToEditWishViewController(wish: self.wish)
    }
    
    func needWishData() {
        self.detailWishViewController.set(wish: self.wish)
    }
    
    func set(InfoMesage: String) {
        DispatchQueue.main.async {
            self.detailWishViewController.set(infoMessage: InfoMesage)
        }
    }
}
