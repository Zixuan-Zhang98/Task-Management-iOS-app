//
//  Item.swift
//  Todoey
//
//  Created by 张子轩 on 8/6/19.
//  Copyright © 2019 Zixuan Zhang. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isComplete: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
