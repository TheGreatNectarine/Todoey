//
//  TodoItem.swift
//  Todoey
//
//  Created by Nikandr Margal on 1/14/19.
//  Copyright © 2019 Nikandr Margal. All rights reserved.
//

import Foundation

struct Item: Codable {
	var title: String
	var done: Bool

	init() {
		self.title = ""
		self.done = false
	}

	init(title: String, done: Bool) {
		self.title = title
		self.done = done
	}
}
