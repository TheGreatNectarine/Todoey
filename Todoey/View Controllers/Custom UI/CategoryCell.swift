//
//  CategoryCell.swift
//  Todoey
//
//  Created by Nikandr Margal on 1/18/19.
//  Copyright © 2019 Nikandr Margal. All rights reserved.
//

import Foundation
import UIKit

class CategoryCell: UITableViewCell {
	var category: Category? {
		didSet {
			self.textLabel?.text = category?.name
		}
	}
}
