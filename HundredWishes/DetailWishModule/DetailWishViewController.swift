//
//  DetailWishViewController.swift
//  HundreedWishes
//
//  Created by Александр Рахимов on 10.08.2023.
//

import UIKit

protocol DetailWishViewControllerProtocol: AnyObject {
    var wishImage: UIImage? { get }
    func set(wish: WishData)
    func set(infoMessage: String)
}

final class DetailWishViewController: UIViewController {

    var detailWishPresenter: DetailWishPresenterProtocol?
    let parentView = UIView()
    let contentView = UIView()
    let createdDateLabel = UILabel()
    let completedDateLabel = UILabel()
    let wishTitleLabel = UILabel()
    let titltLabel = UILabel()
    let infoView = UIView()
    var blurEffectView: UIVisualEffectView?
    let infoMessageLabel = UILabel()
    let backButton = UIButton()
    let deleteButton = UIButton()
    let completedButton = UIButton()
    let saveWishImageButton = UIButton()
    let editButton = UIButton()
    var wishImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "light")
        
        setParentView()
        createTitleLabel()
        createBackButton()
        createDeleteButton()
        createCompletedButton()
        setContentView()
        createSaveWishImageButton()
        createEditWishButton()
        createWishTitle()
        createCreatedDateLabel()
        createCompletedDateLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        detailWishPresenter?.needWishData()
    }
}

// MARK: - UI
extension DetailWishViewController {
    
    func createTitleLabel() {
        titltLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titltLabel)

        NSLayoutConstraint.activate([
            titltLabel.widthAnchor.constraint(equalToConstant: view.bounds.size.width),
            titltLabel.heightAnchor.constraint(equalToConstant: view.bounds.size.height * 0.2),
            titltLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            titltLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        titltLabel.text = "Your wish"
        titltLabel.font = UIFont(name: "Chalkduster", size: 27)
        titltLabel.textColor = UIColor(named: "gray")
        titltLabel.textAlignment = .center
    }
    
    func createBackButton() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: view.bounds.size.width / 5),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backButton.centerYAnchor.constraint(equalTo: titltLabel.centerYAnchor, constant: 0)
        ])
        
        backButton.setTitle("Close", for: .normal)
        backButton.setTitleColor(UIColor(named: "gray"), for: .normal)
        backButton.setTitleColor(UIColor(named: "gray")?.withAlphaComponent(0.7), for: .highlighted)
        backButton.titleLabel?.font = UIFont(name: "Chalkduster", size: 15)
        backButton.addTarget(nil, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func backButtonTapped() {
        detailWishPresenter?.goBack()
    }
    
    func createDeleteButton() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalToConstant: view.bounds.size.width / 5),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            deleteButton.centerYAnchor.constraint(equalTo: titltLabel.centerYAnchor, constant: 0)
        ])
        
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(UIColor(named: "gray"), for: .normal)
        deleteButton.setTitleColor(UIColor(named: "gray")?.withAlphaComponent(0.7), for: .highlighted)
        deleteButton.titleLabel?.font = UIFont(name: "Chalkduster", size: 15)
        deleteButton.addTarget(nil, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func deleteButtonTapped() {
        detailWishPresenter?.deleteCurrentWish()
        createInfoView()
        detailWishPresenter?.set(InfoMesage: "Your wish was deleted :((")
    }
    
    func createCompletedButton() {
        completedButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(completedButton)
        
        NSLayoutConstraint.activate([
            completedButton.widthAnchor.constraint(equalToConstant: view.bounds.size.width / 4),
            completedButton.heightAnchor.constraint(equalToConstant: 44),
            completedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completedButton.bottomAnchor.constraint(equalTo: parentView.topAnchor, constant: -5)
        ])
        
        completedButton.isHidden = detailWishPresenter!.isCompletedButtonAppears()
        completedButton.setTitle("Completed", for: .normal)
        completedButton.setTitleColor(UIColor(named: "gray"), for: .normal)
        completedButton.setTitleColor(UIColor(named: "gray")?.withAlphaComponent(0.7), for: .highlighted)
        completedButton.titleLabel?.font = UIFont(name: "Chalkduster", size: 15)
        completedButton.addTarget(nil, action: #selector(completedButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func completedButtonTapped() {
        detailWishPresenter?.makeWishCompleted()
        detailWishPresenter?.goBack()
    }
    
    func createSaveWishImageButton() {
        saveWishImageButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(saveWishImageButton)
        
        NSLayoutConstraint.activate([
            saveWishImageButton.widthAnchor.constraint(equalToConstant: view.bounds.size.width),
            saveWishImageButton.heightAnchor.constraint(equalToConstant: 44),
            saveWishImageButton.topAnchor.constraint(equalTo: parentView.bottomAnchor, constant: 5),
            saveWishImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        
        saveWishImageButton.setTitle("Save wish like Image", for: .normal)
        saveWishImageButton.setTitleColor(UIColor(named: "gray"), for: .normal)
        saveWishImageButton.setTitleColor(UIColor(named: "gray")?.withAlphaComponent(0.7), for: .highlighted)
        saveWishImageButton.titleLabel?.font = UIFont(name: "Chalkduster", size: 15)
        saveWishImageButton.addTarget(nil, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func saveButtonTapped() {
        parentView.backgroundColor = .clear
        self.wishImage = parentView.asImage()
        detailWishPresenter?.saveWishLikeImage()
        createInfoView()
        detailWishPresenter?.set(InfoMesage: "Your wish saved in gallery like image :))")
        parentView.backgroundColor = view.backgroundColor
    }
    
    func createEditWishButton() {
        editButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(editButton)
        
        NSLayoutConstraint.activate([
            editButton.widthAnchor.constraint(equalToConstant: view.bounds.size.width),
            editButton.heightAnchor.constraint(equalToConstant: 44),
            editButton.topAnchor.constraint(equalTo: saveWishImageButton.bottomAnchor, constant: 5),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        
        editButton.setTitle("Edit wish", for: .normal)
        editButton.setTitleColor(UIColor(named: "gray"), for: .normal)
        editButton.setTitleColor(UIColor(named: "gray")?.withAlphaComponent(0.7), for: .highlighted)
        editButton.titleLabel?.font = UIFont(name: "Chalkduster", size: 15)
        editButton.addTarget(nil, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func editButtonTapped() {
        detailWishPresenter?.goToEditWishViewController()
    }
    
    
    private func setParentView() {
        let sizeForParent = (((view.bounds.size.width / 10) * 9) / 4)
        parentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(parentView)
        
        NSLayoutConstraint.activate([
            parentView.widthAnchor.constraint(equalToConstant: sizeForParent * 4),
            parentView.heightAnchor.constraint(equalToConstant: sizeForParent * 5),
            parentView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            parentView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        ])
        
        parentView.backgroundColor = UIColor(named: "light")
        parentView.center = view.center
    }
    
    private func setContentView() {
        let sizeForContent = (((view.bounds.size.width / 10) * 8.5) / 4)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: sizeForContent * 4),
            contentView.heightAnchor.constraint(equalToConstant: sizeForContent * 5),
            contentView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor, constant: 0),
            contentView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: 0)
        ])
        
        contentView.backgroundColor = UIColor(named: "light")
        contentView.layer.cornerRadius = 25
        contentView.layer.shadowColor = UIColor(named: "gray")?.cgColor
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowOpacity = 1
    }
    
    private func createWishTitle() {
        wishTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(wishTitleLabel)
        
        NSLayoutConstraint.activate([
            wishTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            wishTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            wishTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            wishTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
        
        wishTitleLabel.textAlignment = .center
        wishTitleLabel.numberOfLines = 0
        wishTitleLabel.textColor = UIColor(named: "blue")
        wishTitleLabel.font = UIFont(name: "Chalkduster", size: 20)
    }
    
    private func createCreatedDateLabel() {
        createdDateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(createdDateLabel)
        
        NSLayoutConstraint.activate([
            createdDateLabel.heightAnchor.constraint(equalToConstant: 30),
            createdDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createdDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            createdDateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        
        createdDateLabel.textAlignment = .right
        createdDateLabel.textColor = UIColor(named: "gray")?.withAlphaComponent(0.5)
        createdDateLabel.font = UIFont(name: "Chalkduster", size: 20)
    }
    
    private func createCompletedDateLabel() {
        completedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(completedDateLabel)
        
        NSLayoutConstraint.activate([
            completedDateLabel.heightAnchor.constraint(equalToConstant: 30),
            completedDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            completedDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            completedDateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        
        completedDateLabel.textAlignment = .right
        completedDateLabel.textColor = UIColor(named: "gray")?.withAlphaComponent(0.75)
        completedDateLabel.font = UIFont(name: "Chalkduster", size: 20)
    }
    
    private func createInfoView() {
        createBlurScreen()
        
        infoView.translatesAutoresizingMaskIntoConstraints = false
        guard let blurEffectView = blurEffectView else { return }
        blurEffectView.contentView.addSubview(infoView)
        
        
        NSLayoutConstraint.activate([
            infoView.heightAnchor.constraint(equalToConstant: 200),
            infoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            infoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            infoView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0)
        ])
        
        infoView.backgroundColor = UIColor(named: "light")
        infoView.layer.cornerRadius = 25
        infoView.layer.shadowColor = UIColor(named: "gray")?.cgColor
        infoView.layer.shadowRadius = 5
        infoView.layer.shadowOffset = CGSize(width: 0, height: 0)
        infoView.layer.shadowOpacity = 1
        
        createInfoMessageLabel()
        
        Task {
            try? await dissapearInfoView()
        }
    }
    
    private func createInfoMessageLabel() {
        infoMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(infoMessageLabel)
        
        NSLayoutConstraint.activate([
            infoMessageLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 10),
            infoMessageLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 10),
            infoMessageLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -10),
            infoMessageLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -10)
        ])
        
        infoMessageLabel.font = UIFont(name: "Chalkduster", size: 20)
        infoMessageLabel.textColor = UIColor(named: "gray")
        infoMessageLabel.textAlignment = .center
        infoMessageLabel.numberOfLines = 0
    }
    
    private func createBlurScreen() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemThinMaterialLight)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = self.view.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        guard let blurEffectView = blurEffectView else { return }
        self.view.addSubview(blurEffectView)
        
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(tapOnBlurScreen))
        blurEffectView.contentView.addGestureRecognizer(gesture)
    }
    
    private func dissapearInfoView() async throws {
        try await Task.sleep(nanoseconds: 3_000_000_000)
        guard let blurEffectView = blurEffectView else { return }
        infoView.removeFromSuperview()
        blurEffectView.removeFromSuperview()
        detailWishPresenter?.goBack()
    }
    
    @objc
    func tapOnBlurScreen() {
        guard let blurEffectView = blurEffectView else { return }
        infoView.removeFromSuperview()
        blurEffectView.removeFromSuperview()
        detailWishPresenter?.goBack()
        detailWishPresenter?.tap = true
    }
}

// MARK: - DetailWishViewControllerProtocol
extension DetailWishViewController: DetailWishViewControllerProtocol {
    func set(wish: WishData) {
        self.wishTitleLabel.text = wish.title
        if wish.completeDate == nil {
            self.completedDateLabel.text = wish.createDate?.dateFormatter()
        } else {
            self.createdDateLabel.text = wish.createDate?.dateFormatter()
            self.completedDateLabel.text = wish.completeDate?.dateFormatter()
        }
    }
    
    func set(infoMessage: String) {
        infoMessageLabel.text = infoMessage
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

//// MARK: - SwiftUI Canvas
//import SwiftUI
//
//struct Provider: PreviewProvider {
//    static var previews: some View {
//        PresentView().edgesIgnoringSafeArea(.all)
//    }
//
//    struct PresentView: UIViewControllerRepresentable {
//
//        let viewController = DetailWishViewController()
//        func makeUIViewController(context: Context) -> some UIViewController {
//            return viewController
//        }
//
//        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        }
//    }
//}

