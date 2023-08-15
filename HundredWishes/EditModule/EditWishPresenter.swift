//
//  EditWishPresenter.swift
//  HundreedWishes
//
//  Created by Александр Рахимов on 13.08.2023.
//

import Foundation
import CoreData

protocol EditWishPresenterProtocol: AnyObject {
    var editWishViewController: EditWishViewControllerProtocol { get }
    var router: RouterProtocol { get }
    var context: NSManagedObjectContext? { get }
    var wish: WishData { get }
    
    init(editWishViewController: EditWishViewControllerProtocol, router: RouterProtocol, wish: WishData)
    
    func goBack()
    func goBackAfterEditing()
    func setTextForEditing()
    func createEdited(wish title: String)
}

class EditWishPresenter: EditWishPresenterProtocol {
    unowned var editWishViewController: EditWishViewControllerProtocol
    var router: RouterProtocol
    var context: NSManagedObjectContext?
    var wish: WishData
    
    required init(editWishViewController: EditWishViewControllerProtocol, router: RouterProtocol, wish: WishData) {
        self.editWishViewController = editWishViewController
        self.router = router
        self.wish = wish
    }
    
    func goBack() {
        router.pop()
    }
    
    func goBackAfterEditing() {
        router.popToDetailWishViewController(wish: self.wish)
    }
    
    func setTextForEditing() {
        guard let title = self.wish.title else { return }
        editWishViewController.set(textOfWish: title)
    }
    
    func createEdited(wish title: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let context = self.context else { return }
            let fetchRequest: NSFetchRequest<WishData> = WishData.fetchRequest()
            guard let wishesFromCoreData = try? context.fetch(fetchRequest) else {
                print(#function)
                return }
            for wish in wishesFromCoreData {
                if wish.createDate == self.wish.createDate {
                    wish.title = title
                    self.wish.title = title
                }
            }
            do {
                try context.save()
            } catch {
                print("Error save context after delete")
            }
        }
    }
}
