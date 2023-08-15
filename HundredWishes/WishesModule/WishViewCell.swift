//
//  WishViewCell.swift
//  HundreedWishes
//
//  Created by Александр Рахимов on 13.07.2023.
//

import UIKit
import Foundation

protocol WishViewCellProtocol {
    func configure(with wish: WishData)
}

class WishViewCell: UITableViewCell {
    
    let containerView = UIView()
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let doneLabel = UILabel()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        self.backgroundColor = UIColor(named: "light")
        createContainerView()
        createTitleLabel()
        createDoneLabel()
        createDateLabel()
    }

}

extension WishViewCell {
    func createContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        containerView.layer.cornerRadius = 25
        containerView.backgroundColor = UIColor(named: "light")
        containerView.layer.shadowColor = UIColor(named: "gray")?.cgColor
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowOpacity = 1
    }
    
    func createTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -50)
        ])
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "Chalkduster", size: 20)
        titleLabel.textColor = UIColor(named: "blue")
        titleLabel.textAlignment = .left
    }
    
    func createDoneLabel() {
        doneLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(doneLabel)
        
        NSLayoutConstraint.activate([
            doneLabel.widthAnchor.constraint(equalToConstant: 350),
            doneLabel.heightAnchor.constraint(equalToConstant: 35),
            doneLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            doneLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
        
        doneLabel.font = UIFont(name: "Chalkduster", size: 35)
        doneLabel.textColor = UIColor(named: "gray")?.withAlphaComponent(0.075)
        doneLabel.textAlignment = .right
    }
    
    func createDateLabel() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.widthAnchor.constraint(equalToConstant: 150),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
        
        dateLabel.font = UIFont(name: "Chalkduster", size: 15)
        dateLabel.textColor = UIColor(named: "gray")
        dateLabel.textAlignment = .left
    }
}

// MARK: - WishViewCellProtocol
extension WishViewCell: WishViewCellProtocol {
    func configure(with wish: WishData) {
        var dateForShowingOnCardWish: Date?
        if let date = wish.completeDate {
            dateForShowingOnCardWish = date
        } else {
            guard let date = wish.createDate else { return }
            dateForShowingOnCardWish = date
        }
        
        guard let date = dateForShowingOnCardWish else { return }
        var dateString = ""
        dateString = date.dateFormatter()
        DispatchQueue.main.async {
            self.titleLabel.text = wish.title
            self.dateLabel.text = dateString
            if wish.isDone {
                self.doneLabel.text = "COMPLETED"
            } else {
                self.doneLabel.text = ""
            }
        }
    }
    
   
}

extension Date {
    func dateFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
