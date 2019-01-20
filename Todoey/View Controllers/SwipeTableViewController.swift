//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Nikandr Margal on 1/20/19.
//  Copyright © 2019 Nikandr Margal. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
		cell.delegate = self
		return cell
	}

	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
		guard orientation == .right else { return nil }
		let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
			self.updateModel(at: indexPath)
		}
		let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
			#warning("not implemented edit action")
		}
		deleteAction.image = UIImage(named: "delete-icon")
		return [deleteAction, editAction]
	}

	func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
		var options = SwipeTableOptions()
		options.expansionStyle = .destructive
		options.transitionStyle = .reveal
		return options
	}

	func updateModel(at indexPath: IndexPath) {
		fatalError("Each subclass SwipeTableViewController must override updateModel function.")
	}
}
