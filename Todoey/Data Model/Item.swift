//
//  Item.swift
//  Todoey
//
//  Created by Krishna Ajmeri on 8/30/19.
//  Copyright © 2019 Krishna Ajmeri. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
	@objc dynamic var title = ""
	@objc dynamic var done = false
	@objc dynamic var dateCreated : Date?
	var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
