//
//  ViewController.swift
//  HundreedWishes
//
//  Created by Александр Рахимов on 08.07.2023.
//

import UIKit

protocol StartViewControllerProtocol: AnyObject {
    func set(coordinates: [CGFloat])
    func set(counts: (Int, Int))
}

class StartViewController: UIViewController {
    
    var startPresenter: StartPresenterProtocol?
    let labelSize: CGFloat = 27
    let titltLabel = UILabel()
    let allWishesView = UIView()
    let allLabel = UILabel()
    let allCountWishesLabel = UILabel()
    let newWishPlusLabel = UILabel()
    let currentCountDoneWishesLabel = UILabel()
    let currentCountUndoneWishesLabel = UILabel()
    let newWishView = UIView()
    let newLabel = UILabel()
    let doneWishesView = UIView()
    let doneLabel = UILabel()
    let doneNumberLabel = UILabel()
    let undoneWishesView = UIView()
    let undoneLabel = UILabel()
    let undoneNumberLabel = UILabel()
    var coordinates = [CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        createTitleLabel()
        createAllWishesView()
        createNewWishView()
        createDoneWishesView()
        createUndoneWishesView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startPresenter?.setCoordinates()
        startPresenter?.needsCountsOfDoneAndUndoneWishes()
    }
}


// MARK: - StartViewControllerProtocol
extension StartViewController: StartViewControllerProtocol {
    func set(coordinates: [CGFloat]) {
        self.setBeforeOrigins(from: coordinates)
    }
    
    func set(counts: (Int, Int)) {
        self.currentCountDoneWishesLabel.text = "\(counts.0)"
        self.currentCountUndoneWishesLabel.text = "\(counts.1)"
    }
}

// MARK: - StartViewController UI and UIGestureRecognizerDelegate
extension StartViewController: UIGestureRecognizerDelegate {
    
    var delay: Double {
        0.1
    }
    
    func createTitleLabel() {
        titltLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titltLabel)

        NSLayoutConstraint.activate([
            titltLabel.widthAnchor.constraint(equalToConstant: view.bounds.size.width),
            titltLabel.heightAnchor.constraint(equalToConstant: view.bounds.size.height * 0.2),
            titltLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            titltLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        titltLabel.text = "Wishes tend to come true"
        titltLabel.font = UIFont(name: "Chalkduster", size: 20)
        titltLabel.textColor = UIColor(named: "gray")
        titltLabel.textAlignment = .center
    }
    
    // MARK: - without this function, only the last gesture in the gesture array works
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - to return categories on their places
    private func categoriesOriginsCoordinates() -> [CGFloat] {
        let allY = allWishesView.frame.origin.y
        let newY = newWishView.frame.origin.y
        let doneY = doneWishesView.frame.origin.y
        let undoneY = undoneWishesView.frame.origin.y
        return [allY, newY, doneY, undoneY]
    }
    
    private func setBeforeOrigins(from origins: [CGFloat]) {
        UIView.animate(withDuration: 1, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: UIView.AnimationOptions.curveLinear) {
            self.allWishesView.frame.origin.y = origins[0]
            self.newWishView.frame.origin.y = origins[1]
            self.doneWishesView.frame.origin.y = origins[2]
            self.undoneWishesView.frame.origin.y = origins[3]
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.navigationItem.title = "Wishes tend to come true"
        }
    }
        
    func createAllWishesView() {
        allWishesView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(allWishesView)
        
        NSLayoutConstraint.activate([
            allWishesView.widthAnchor.constraint(equalToConstant: view.bounds.size.width),
            allWishesView.heightAnchor.constraint(equalToConstant: view.bounds.size.height),
            allWishesView.topAnchor.constraint(equalTo: titltLabel.bottomAnchor, constant: -30),
            allWishesView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        
        allWishesView.layer.cornerRadius = 25
        allWishesView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        allWishesView.backgroundColor = UIColor(named: "light")
        allWishesView.layer.shadowColor = UIColor(named: "gray")?.cgColor
        allWishesView.layer.shadowRadius = 25
        allWishesView.layer.shadowOffset = CGSize(width: 0, height: 0)
        allWishesView.layer.shadowOpacity = 1
        
        createAllCountWishesLabel()
        createAllLabel()
        addGestureForAll()
    }
    
    private func createAllLabel() {
        allLabel.translatesAutoresizingMaskIntoConstraints = false
        allWishesView.addSubview(allLabel)
        
        NSLayoutConstraint.activate([
            allLabel.widthAnchor.constraint(equalToConstant: view.bounds.size.width),
            allLabel.heightAnchor.constraint(equalToConstant: view.bounds.size.height * 0.2),
            allLabel.topAnchor.constraint(equalTo: allWishesView.topAnchor, constant: 0),
            allLabel.centerXAnchor.constraint(equalTo: allWishesView.centerXAnchor, constant: 0)
        ])
        
        allLabel.text = "Wishes"
        allLabel.font = UIFont(name: "Chalkduster", size: labelSize)
        allLabel.textColor = UIColor(named: "blue")
        allLabel.textAlignment = .center
    }
    
    private func addGestureForAll() {
        let gestureAll = UITapGestureRecognizer(target: self, action: #selector(allWishesTap(gesture:)))
        gestureAll.delegate = self
        self.view.addGestureRecognizer(gestureAll)
    }
    
    @objc
    private func allWishesTap(gesture: UITapGestureRecognizer) {
        let coordinates = categoriesOriginsCoordinates()
        if allLabel.frame.contains(gesture.location(in: allLabel)) {
            UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.0, options: .curveLinear) { [weak self] in
                guard let self = self else { return }
                self.allWishesView.frame.origin = CGPoint(x: 0, y: 0)
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(800)) {
                    guard let title = self.allLabel.text else { return }
                    self.startPresenter?.coordinates = coordinates
                    self.startPresenter?.goToWishesViewController(title: title)
                }
            }
            UIView.animate(withDuration: 1, delay: delay) {
                self.newWishView.frame.origin = CGPoint(x: 0, y: 1000)
            }
            UIView.animate(withDuration: 1, delay: delay) {
                self.doneWishesView.frame.origin = CGPoint(x: 0, y: 1000)
            }
            UIView.animate(withDuration: 1, delay: delay) {
                self.undoneWishesView.frame.origin = CGPoint(x: 0, y: 1000)
            }
        }
    }
    
    private func createAllCountWishesLabel() {
        allCountWishesLabel.translatesAutoresizingMaskIntoConstraints = false
        allWishesView.addSubview(allCountWishesLabel)
        
        NSLayoutConstraint.activate([
            allCountWishesLabel.widthAnchor.constraint(equalToConstant: view.bounds.size.width),
            allCountWishesLabel.heightAnchor.constraint(equalToConstant: view.bounds.size.height * 0.2),
            allCountWishesLabel.topAnchor.constraint(equalTo: allWishesView.topAnchor, constant: 0),
            allCountWishesLabel.centerXAnchor.constraint(equalTo: allWishesView.centerXAnchor, constant: -10)
        ])
        
        allCountWishesLabel.text = "100"
        allCountWishesLabel.font = UIFont(name: "Chalkduster", size: 150)
        allCountWishesLabel.textColor = UIColor(named: "gray")?.withAlphaComponent(0.05)
        allCountWishesLabel.textAlignment = .right
    }
    
    func createNewWishView() {
        newWishView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newWishView)
        
        NSLayoutConstraint.activate([
            newWishView.widthAnchor.constraint(equalToConstant: view.bounds.size.width),
            newWishView.heightAnchor.constraint(equalToConstant: view.bounds.size.height),
            newWishView.topAnchor.constraint(equalTo: allWishesView.bottomAnchor, constant: -view.bounds.size.height * 0.79),
            newWishView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        
        newWishView.layer.cornerRadius = 25
        newWishView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        newWishView.backgroundColor = UIColor(named: "light")
        newWishView.layer.shadowColor = UIColor(named: "gray")?.cgColor
        newWishView.layer.shadowRadius = 25
        newWishView.layer.shadowOffset = CGSize(width: 0, height: 0)
        newWishView.layer.shadowOpacity = 1
        
        createNewWishesPlusLabel()
        createNewLabel()
        addGestureForNew()
    }
    
    private func createNewLabel() {
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newWishView.addSubview(newLabel)
        
        NSLayoutConstraint.activate([
            newLabel.widthAnchor.constraint(equalToConstant: view.bounds.size.width),
            newLabel.heightAnchor.constraint(equalToConstant: view.bounds.size.height * 0.2),
            newLabel.topAnchor.constraint(equalTo: newWishView.topAnchor, constant: 0),
            newLabel.centerXAnchor.constraint(equalTo: newWishView.centerXAnchor, constant: 0)
        ])
        
        newLabel.text = "New wish"
        newLabel.font = UIFont(name: "Chalkduster", size: labelSize)
        newLabel.textColor = UIColor(named: "blue")
        newLabel.textAlignment = .center
    }
    
    private func addGestureForNew() {
        let gestureNew = UITapGestureRecognizer(target: self, action: #selector(newWishesTap(gesture:)))
        gestureNew.delegate = self
        self.view.addGestureRecognizer(gestureNew)
    }
    
    @objc
    private func newWishesTap(gesture: UITapGestureRecognizer) {
        let coordinates = categoriesOriginsCoordinates()
        if newLabel.frame.contains(gesture.location(in: newLabel)) {
            UIView.animate(withDuration: 1, delay: delay) {
                self.allWishesView.frame.origin = CGPoint(x: 0, y: 1000)
            }
            UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.0, options: .curveLinear) { [weak self] in
                guard let self = self else { return }
                self.newWishView.frame.origin = CGPoint(x: 0, y: 0)
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(900)) {
                    guard let title = self.newLabel.text else { return }
                    self.startPresenter?.coordinates = coordinates
                    self.startPresenter?.goToNewWishViewController(title: title)
                }
            }
            UIView.animate(withDuration: 1, delay: delay) {
                self.doneWishesView.frame.origin = CGPoint(x: 0, y: 1000)
            }
            UIView.animate(withDuration: 1, delay: delay) {
                self.undoneWishesView.frame.origin = CGPoint(x: 0, y: 1000)
            }
        }
    }
    
    private func createNewWishesPlusLabel() {
        newWishPlusLabel.translatesAutoresizingMaskIntoConstraints = false
        newWishView.addSubview(newWishPlusLabel)
        
        NSLayoutConstraint.activate([
            newWishPlusLabel.widthAnchor.constraint(equalToConstant: view.bounds.size.width),
            newWishPlusLabel.heightAnchor.constraint(equalToConstant: view.bounds.size.height * 0.2),
            newWishPlusLabel.topAnchor.constraint(equalTo: newWishView.topAnchor, constant: 0),
            newWishPlusLabel.centerXAnchor.constraint(equalTo: newWishView.centerXAnchor, constant: -10)
        ])
        
        newWishPlusLabel.text = "+"
        newWishPlusLabel.font = UIFont(name: "Chalkduster", size: 150)
        newWishPlusLabel.textColor = UIColor(named: "gray")?.withAlphaComponent(0.05)
        newWishPlusLabel.textAlignment = .right
    }
    
    func createDoneWishesView() {
        doneWishesView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneWishesView)
        
        NSLayoutConstraint.activate([
            doneWishesView.widthAnchor.constraint(equalToConstant: view.bounds.size.width),
            doneWishesView.heightAnchor.constraint(equalToConstant: view.bounds.size.height),
            doneWishesView.topAnchor.constraint(equalTo: newWishView.bottomAnchor, constant: -view.bounds.size.height * 0.79),
            doneWishesView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        
        doneWishesView.layer.cornerRadius = 25
        doneWishesView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        doneWishesView.backgroundColor = UIColor(named: "light")
        doneWishesView.layer.shadowColor = UIColor(named: "gray")?.cgColor
        doneWishesView.layer.shadowRadius = 25
        doneWishesView.layer.shadowOffset = CGSize(width: 0, height: 0)
        doneWishesView.layer.shadowOpacity = 1
        
        createCurrentCountDoneWishesLabel()
        createDoneLabel()
        addGestureForDone()
    }
    
    private func createDoneLabel() {
        doneLabel.translatesAutoresizingMaskIntoConstraints = false
        doneWishesView.addSubview(doneLabel)
        
        NSLayoutConstraint.activate([
            doneLabel.widthAnchor.constraint(equalToConstant: view.bounds.size.width),
            doneLabel.heightAnchor.constraint(equalToConstant: view.bounds.size.height * 0.2),
            doneLabel.topAnchor.constraint(equalTo: doneWishesView.topAnchor, constant: 0),
            doneLabel.centerXAnchor.constraint(equalTo: doneWishesView.centerXAnchor, constant: 0)
        ])
        
        doneLabel.text = "Сompleted"
        doneLabel.font = UIFont(name: "Chalkduster", size: labelSize)
        doneLabel.textColor = UIColor(named: "blue")
        doneLabel.textAlignment = .center
    }
    
    private func createCurrentCountDoneWishesLabel() {
        currentCountDoneWishesLabel.translatesAutoresizingMaskIntoConstraints = false
        doneWishesView.addSubview(currentCountDoneWishesLabel)
        
        NSLayoutConstraint.activate([
            currentCountDoneWishesLabel.widthAnchor.constraint(equalToConstant: view.bounds.size.width),
            currentCountDoneWishesLabel.heightAnchor.constraint(equalToConstant: view.bounds.size.height * 0.2),
            currentCountDoneWishesLabel.topAnchor.constraint(equalTo: doneWishesView.topAnchor, constant: 0),
            currentCountDoneWishesLabel.centerXAnchor.constraint(equalTo: doneWishesView.centerXAnchor, constant: -10)
        ])

        currentCountDoneWishesLabel.font = UIFont(name: "Chalkduster", size: 150)
        currentCountDoneWishesLabel.textColor = UIColor(named: "blue")?.withAlphaComponent(0.075)
        currentCountDoneWishesLabel.textAlignment = .right
    }
    
    private func addGestureForDone() {
        let gestureDone = UITapGestureRecognizer(target: self, action: #selector(doneWishesTap(gesture:)))
        gestureDone.delegate = self
        self.view.addGestureRecognizer(gestureDone)
    }
    
    @objc
    private func doneWishesTap(gesture: UITapGestureRecognizer) {
        let coordinates = categoriesOriginsCoordinates()
        if doneLabel.frame.contains(gesture.location(in: doneLabel)) {
            UIView.animate(withDuration: 1, delay: delay) {
                self.allWishesView.frame.origin = CGPoint(x: 0, y: 1000)
            }
            UIView.animate(withDuration: 1, delay: delay) {
                self.newWishView.frame.origin = CGPoint(x: 0, y: 1000)
            }
            UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.0, options: .curveLinear) { [weak self] in
                guard let self = self else { return }
                self.doneWishesView.frame.origin = CGPoint(x: 0, y: 0)
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(950)) {
                    guard let title = self.doneLabel.text else { return }
                    self.startPresenter?.coordinates = coordinates
                    self.startPresenter?.goToWishesViewController(title: title)
                }
            }
            UIView.animate(withDuration: 1, delay: delay) {
                self.undoneWishesView.frame.origin = CGPoint(x: 0, y: 1000)
            }
        }
    }
    
    func createUndoneWishesView() {
        undoneWishesView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(undoneWishesView)
        
        NSLayoutConstraint.activate([
            undoneWishesView.widthAnchor.constraint(equalToConstant: view.bounds.size.width),
            undoneWishesView.heightAnchor.constraint(equalToConstant: view.bounds.size.height),
            undoneWishesView.topAnchor.constraint(equalTo: doneWishesView.bottomAnchor, constant: -view.bounds.size.height * 0.79),
            undoneWishesView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        
        undoneWishesView.layer.cornerRadius = 25
        undoneWishesView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        undoneWishesView.backgroundColor = UIColor(named: "light")
        undoneWishesView.layer.shadowColor = UIColor(named: "gray")?.cgColor
        undoneWishesView.layer.shadowRadius = 25
        undoneWishesView.layer.shadowOffset = CGSize(width: 0, height: 0)
        undoneWishesView.layer.shadowOpacity = 1
        
        createCurrentCountUndoneWishesLabel()
        createUndoneLabel()
        addGestureForUndone()
    }
    
    private func createUndoneLabel() {
        undoneLabel.translatesAutoresizingMaskIntoConstraints = false
        undoneWishesView.addSubview(undoneLabel)
        
        NSLayoutConstraint.activate([
            undoneLabel.widthAnchor.constraint(equalToConstant: view.bounds.size.width),
            undoneLabel.heightAnchor.constraint(equalToConstant: view.bounds.size.height * 0.2),
            undoneLabel.topAnchor.constraint(equalTo: undoneWishesView.topAnchor, constant: 0),
            undoneLabel.centerXAnchor.constraint(equalTo: undoneWishesView.centerXAnchor, constant: 0)
        ])
        
        undoneLabel.text = "Unfulfilled"
        undoneLabel.font = UIFont(name: "Chalkduster", size: labelSize)
        undoneLabel.textColor = UIColor(named: "blue")
        undoneLabel.textAlignment = .center
    }
    
    private func createCurrentCountUndoneWishesLabel() {
        currentCountUndoneWishesLabel.translatesAutoresizingMaskIntoConstraints = false
        undoneWishesView.addSubview(currentCountUndoneWishesLabel)
        
        NSLayoutConstraint.activate([
            currentCountUndoneWishesLabel.widthAnchor.constraint(equalToConstant: view.bounds.size.width),
            currentCountUndoneWishesLabel.heightAnchor.constraint(equalToConstant: view.bounds.size.height * 0.2),
            currentCountUndoneWishesLabel.topAnchor.constraint(equalTo: undoneWishesView.topAnchor, constant: 0),
            currentCountUndoneWishesLabel.centerXAnchor.constraint(equalTo: undoneWishesView.centerXAnchor, constant: -10)
        ])

        currentCountUndoneWishesLabel.font = UIFont(name: "Chalkduster", size: 150)
        currentCountUndoneWishesLabel.textColor = UIColor(named: "blue")?.withAlphaComponent(0.075)
        currentCountUndoneWishesLabel.textAlignment = .right
    }
    
    private func addGestureForUndone() {
        let gestureUndone = UITapGestureRecognizer(target: self, action: #selector(undoneWishesTap(gesture:)))
        gestureUndone.delegate = self
        self.view.addGestureRecognizer(gestureUndone)
    }
    
    @objc
    private func undoneWishesTap(gesture: UITapGestureRecognizer) {
        let coordinates = categoriesOriginsCoordinates()
        if undoneLabel.frame.contains(gesture.location(in: undoneLabel)) {
            UIView.animate(withDuration: 1, delay: delay) {
                self.allWishesView.frame.origin = CGPoint(x: 0, y: 1000)
            }
            UIView.animate(withDuration: 1, delay: delay) {
                self.newWishView.frame.origin = CGPoint(x: 0, y: 1000)
            }
            UIView.animate(withDuration: 1, delay: delay) {
                self.doneWishesView.frame.origin = CGPoint(x: 0, y: 1000)
            }
            UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveLinear) { [weak self] in
                guard let self = self else { return }
                self.undoneWishesView.frame.origin = CGPoint(x: 0, y: 0)
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                    guard let title = self.undoneLabel.text else { return }
                    self.startPresenter?.coordinates = coordinates
                    self.startPresenter?.goToWishesViewController(title: title)
                }
            }
        }
    }
}
