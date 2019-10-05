//
//  Category.swift
//  Todoey
//
//  Created by 张子轩 on 8/6/19.
//  Copyright © 2019 Zixuan Zhang. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
