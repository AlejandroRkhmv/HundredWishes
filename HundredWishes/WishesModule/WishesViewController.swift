//
//  WishesViewController.swift
//  HundreedWishes
//
//  Created by Александр Рахимов on 09.07.2023.
//

import UIKit

protocol WishesViewControllerProtocol: AnyObject {
    func set(title: String)
    func reloadTable()
}

class WishesViewController: UIViewController {
    
    var wishesPresenter: WishesPresenterProtocol?
    let labelSize: CGFloat = 27
    let titltLabel = UILabel()
    let backDownButton = UIButton()
    let deleteButton = UIButton()
    let wishesTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "light")
        
        createTitleLabel()
        createBackButton()
        createWishesTableView()
        setDelegateAndRegisterCell()
        wishesPresenter?.needsWishes()
    }
    
    func setDelegateAndRegisterCell() {
        wishesTableView.register(WishViewCell.self, forCellReuseIdentifier: String(describing: WishViewCell.self))
        wishesTableView.delegate = self
        wishesTableView.dataSource = self
        wishesTableView.dragDelegate = self
        wishesTableView.dropDelegate = self
        wishesTableView.dragInteractionEnabled = true
        wishesTableView.showsVerticalScrollIndicator = false
        wishesTableView.separatorStyle = .none
        wishesTableView.selectionFollowsFocus = false
    }
}

// MARK: - WishesViewControllerProtocol
extension WishesViewController: WishesViewControllerProtocol {
    func set(title: String) {
        self.titltLabel.text = title
    }
    
    func reloadTable() {
        self.wishesTableView.reloadData()
    }
}

// MARK: - WishesViewController UI
extension WishesViewController {
    
    func createBackButton() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        backDownButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backDownButton)
        
        NSLayoutConstraint.activate([
            backDownButton.widthAnchor.constraint(equalToConstant: view.bounds.size.width / 5),
            backDownButton.heightAnchor.constraint(equalToConstant: 44),
            backDownButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backDownButton.centerYAnchor.constraint(equalTo: titltLabel.centerYAnchor, constant: 0)
        ])
        
        backDownButton.setTitle("Close", for: .normal)
        backDownButton.setTitleColor(UIColor(named: "gray"), for: .normal)
        backDownButton.setTitleColor(UIColor(named: "gray")?.withAlphaComponent(0.7), for: .highlighted)
        backDownButton.titleLabel?.font = UIFont(name: "Chalkduster", size: 15)
        backDownButton.addTarget(nil, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func backButtonTapped() {
        wishesPresenter?.goBack()
    }
    
    func createTitleLabel() {
        titltLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titltLabel)

        NSLayoutConstraint.activate([
            titltLabel.widthAnchor.constraint(equalToConstant: view.bounds.size.width / 2),
            titltLabel.heightAnchor.constraint(equalToConstant: view.bounds.size.height * 0.2),
            titltLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            titltLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        titltLabel.font = UIFont(name: "Chalkduster", size: labelSize)
        titltLabel.textColor = UIColor(named: "gray")
        titltLabel.textAlignment = .center
    }
    
    func createWishesTableView() {
        wishesTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(wishesTableView)
        
        NSLayoutConstraint.activate([
            wishesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            wishesTableView.topAnchor.constraint(equalTo: titltLabel.bottomAnchor, constant: -40),
            wishesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            wishesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        wishesTableView.backgroundColor = UIColor(named: "light")
    }
}

// MARK: - UITableViewDelegate
extension WishesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let wishes = wishesPresenter?.wishesFromCoreData else { return }
        wishesPresenter?.goToDetailWishViewController(wish: wishes[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let mover = wishesPresenter?.wishesFromCoreData.remove(at: sourceIndexPath.row) else { return }
        wishesPresenter?.wishesFromCoreData.insert(mover, at: destinationIndexPath.row)
        wishesPresenter?.saveWishesAfterMoving()
    }
}

// MARK: - UITableViewDataSource
extension WishesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let wishesCount = wishesPresenter?.wishesFromCoreData.count else { return 0 }
        return wishesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WishViewCell.self), for: indexPath) as? WishViewCell,
              let wishes = wishesPresenter?.wishesFromCoreData else { return UITableViewCell() }
        cell.configure(with: wishes[indexPath.row])
        return cell
    }
}

extension WishesViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = wishesPresenter?.wishesFromCoreData[indexPath.row]
        return [dragItem]
    }
}

extension WishesViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return true
    }
}
