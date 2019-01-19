//
//  Item.swift
//  Todoey
//
//  Created by Nikandr Margal on 1/18/19.
//  Copyright © 2019 Nikandr Margal. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
	@objc dynamic var title = ""
	@objc dynamic var done = false
	@objc dynamic var dateCreated: Date?
	var parentCategory = LinkingObjects(fromType: Category.self, property: "items")

	/*init(title: String, done: Bool) {
		super.init()
		self.title = title
		self.done = done
	}

	required init() {
		super.init()
	}

	required init(realm: RLMRealm, schema: RLMObjectSchema) {
		super.init(realm: realm, schema: schema)
	}

	required init(value: Any, schema: RLMSchema) {
		super.init(value: value, schema: schema)
	}*/
}
