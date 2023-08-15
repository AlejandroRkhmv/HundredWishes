//
//  EditWishViewController.swift
//  HundreedWishes
//
//  Created by Александр Рахимов on 13.08.2023.
//

import UIKit

protocol EditWishViewControllerProtocol: AnyObject {
    func set(textOfWish: String)
}

final class EditWishViewController: UIViewController {
    
    var editWishPresenter: EditWishPresenterProtocol?
    var titleLabel = UILabel()
    let containerView = UIView()
    let textView = UITextView()
    let backDownButton = UIButton()
    let createButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "light")
        self.navigationItem.setHidesBackButton(true, animated: true)
        createTitleLabel()
        createBackButton()
        createCreateButton()
        editWishPresenter?.setTextForEditing()
        createContainerView()
        createTextView()
    }
}

// MARK: - NewWishViewControllerProtocol
extension EditWishViewController: EditWishViewControllerProtocol {
    func set(textOfWish: String) {
        self.textView.text = textOfWish
    }
}

// MARK: - UI
extension EditWishViewController {
    
    func createBackButton() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        backDownButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backDownButton)
        
        NSLayoutConstraint.activate([
            backDownButton.widthAnchor.constraint(equalToConstant: view.bounds.size.width / 5),
            backDownButton.heightAnchor.constraint(equalToConstant: 44),
            backDownButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backDownButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: 0)
        ])
        
        backDownButton.setTitle("Close", for: .normal)
        backDownButton.setTitleColor(UIColor(named: "gray"), for: .normal)
        backDownButton.setTitleColor(UIColor(named: "gray")?.withAlphaComponent(0.7), for: .highlighted)
        backDownButton.titleLabel?.font = UIFont(name: "Chalkduster", size: 15)
        backDownButton.addTarget(nil, action: #selector(backDownButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func backDownButtonTapped() {
        editWishPresenter?.goBack()
    }
    
    func createCreateButton() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            createButton.widthAnchor.constraint(equalToConstant: view.bounds.size.width / 5),
            createButton.heightAnchor.constraint(equalToConstant: 44),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            createButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: 0)
        ])
        
        createButton.setTitle("Done", for: .normal)
        createButton.setTitleColor(UIColor(named: "gray"), for: .normal)
        createButton.setTitleColor(UIColor(named: "gray")?.withAlphaComponent(0.7), for: .highlighted)
        createButton.titleLabel?.font = UIFont(name: "Chalkduster", size: 15)
        createButton.addTarget(nil, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func doneButtonTapped() {
        guard !textView.text.isEmpty,
              let wish = self.textView.text else { return }
        editWishPresenter?.createEdited(wish: wish)
        editWishPresenter?.goBackAfterEditing()
    }
    
    func createTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.size.width / 2),
            titleLabel.heightAnchor.constraint(equalToConstant: view.bounds.size.height * 0.2),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        
        titleLabel.text = "Edit wish"
        titleLabel.font = UIFont(name: "Chalkduster", size: 27)
        titleLabel.textColor = UIColor(named: "gray")
        titleLabel.textAlignment = .center
    }
    
    
    func createContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            containerView.heightAnchor.constraint(equalToConstant: view.bounds.size.width - 30)
        ])
        
        containerView.backgroundColor = UIColor(named: "light")
        containerView.layer.cornerRadius = 25
        containerView.layer.shadowColor = UIColor(named: "gray")?.cgColor
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowOpacity = 1
    }
    
    func createTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            textView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
        ])
        
        textView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.font = UIFont(name: "Chalkduster", size: 25)
        textView.textColor = UIColor(named: "идгу")
        textView.backgroundColor = UIColor(named: "light")
        textView.layer.cornerRadius = 25
        textView.delegate = self
    }
}

// MARK: - Extension UITextViewDelegate
extension EditWishViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.4) {
            self.containerView.frame.origin.y -= 110
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        guard textView == self.textView,
              let title = self.textView.text,
              title != "" else { return false }
        UIView.animate(withDuration: 0.4) {
            self.containerView.frame.origin.y += 110
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let currentText = textView.text,
              let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        guard updatedText.count <= 250 else { return false }
        return updatedText.count <= 250
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    func createMovingUpText() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(param:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(param:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func updateTextView(param: Notification) {
        let userInfo = param.userInfo
        let getKeyboardRect = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardFrame = self.view.convert(getKeyboardRect, to: view.window)
        
        if param.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: keyboardFrame.height * 0.1, right: 10)
            textView.scrollIndicatorInsets = textView.contentInset
        }
        
        textView.scrollRangeToVisible(textView.selectedRange)
    }
}
