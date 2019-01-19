//
//  Category.swift
//  Todoey
//
//  Created by Nikandr Margal on 1/18/19.
//  Copyright © 2019 Nikandr Margal. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
	@objc dynamic var name: String = ""
	let items = List<Item>()
}
