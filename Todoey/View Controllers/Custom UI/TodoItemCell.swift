//
//  TodoItemCellViewController.swift
//  Todoey
//
//  Created by Nikandr Margal on 1/16/19.
//  Copyright © 2019 Nikandr Margal. All rights reserved.
//

import Foundation
import UIKit

public class ToDoItemCell: UITableViewCell {
	var item: Item? {
		didSet {
			self.textLabel?.text = item?.title
		}
	}
}
