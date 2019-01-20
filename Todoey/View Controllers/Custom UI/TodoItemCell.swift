//
//  TodoItemCellViewController.swift
//  Todoey
//
//  Created by Nikandr Margal on 1/16/19.
//  Copyright © 2019 Nikandr Margal. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
	func setLabelText(from item: Item) {
		textLabel?.text = item.title
	}
}


