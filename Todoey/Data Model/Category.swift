//
//  Category.swift
//  Todoey
//
//  Created by Krishna Ajmeri on 8/30/19.
//  Copyright © 2019 Krishna Ajmeri. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
	@objc dynamic var name = ""
	let items = List<Item>()
}
