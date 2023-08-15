//
//  WishModel.swift
//  HundreedWishes
//
//  Created by Александр Рахимов on 10.07.2023.
//

import Foundation

public class WishModel: Codable {
    let title: String
    var date = Date()
    var isDone = false
    var order: Int
    
    init(title: String, order: Int) {
        self.title = title
        self.order = order
    }
}
