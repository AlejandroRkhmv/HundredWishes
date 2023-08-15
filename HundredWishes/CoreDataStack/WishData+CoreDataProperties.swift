//
//  WishData+CoreDataProperties.swift
//  HundreedWishes
//
//  Created by Александр Рахимов on 13.08.2023.
//
//

import Foundation
import CoreData


extension WishData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WishData> {
        return NSFetchRequest<WishData>(entityName: "WishData")
    }

    @NSManaged public var createDate: Date?
    @NSManaged public var isDone: Bool
    @NSManaged public var order: Int64
    @NSManaged public var title: String?
    @NSManaged public var completeDate: Date?

}

extension WishData : Identifiable {

}
