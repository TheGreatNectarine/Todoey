//
//  ViewController.swift
//  Todoey
//
//  Created by Nikandr Margal on 1/10/19.
//  Copyright © 2019 Nikandr Margal. All rights reserved.
//

import UIKit

class ToDoItemCell: UITableViewCell {
	var itemName: String? {
		didSet {
			self.textLabel?.text = itemName
		}
	}
}

class ToDoListViewController: UITableViewController {

	var todoItems = ["1", "2", "3"]
	let defaults = UserDefaults.standard

	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.register(ToDoItemCell.self, forCellReuseIdentifier: "ToDoItemCell")

		if let items = defaults.array(forKey: "TodoList") as? [String] {
			todoItems = items
		}
		// Do any additional setup after loading the view, typically from a nib.
	}

	//MARK: - TableView Datasource methods

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! ToDoItemCell
		cell.itemName = todoItems[indexPath.row]
		return cell
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return todoItems.count
	}

	//MARK: - TableView Delegate methods

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
			tableView.cellForRow(at: indexPath)?.accessoryType = .none
		} else {
			tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}

	//MARK: - IBActions

	@IBAction func addNewItemButtonPressed(_ sender: UIBarButtonItem) {
		var textField = UITextField()
		let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
		let action = UIAlertAction(title: "Add Todoey", style: .default) { (action) in
			//TODO: add empty string validation
			//FIXME: HELLO FIX
			//!!!: HE
			//???: adasd
			let toAdd = textField.text!
			self.todoItems.append(toAdd)
			self.defaults.set(self.todoItems, forKey: "TodoList")
			//TODO: add animation
			self.tableView.reloadData()
		}
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Type here"
			textField = alertTextField
		}
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
}
