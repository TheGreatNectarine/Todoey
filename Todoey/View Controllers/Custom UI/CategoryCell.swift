//
//  CategoryCell.swift
//  Todoey
//
//  Created by Nikandr Margal on 1/18/19.
//  Copyright © 2019 Nikandr Margal. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
	func setLabelText(from category: Category) {
		textLabel?.text = category.name
	}
}

