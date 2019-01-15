//
//  ViewController.swift
//  Todoey
//
//  Created by Nikandr Margal on 1/10/19.
//  Copyright © 2019 Nikandr Margal. All rights reserved.
//

import UIKit

class ToDoItemCell: UITableViewCell {
	var item: Item? {
		didSet {
			self.textLabel?.text = item?.title
		}
	}
}

class ToDoListViewController: UITableViewController {

	var todoItems = [Item]()
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

	override func viewDidLoad() {
		super.viewDidLoad()

		self.tableView.register(ToDoItemCell.self, forCellReuseIdentifier: "ToDoItemCell")
		self.tableView.tableFooterView = UIView(frame: .zero)

		todoItems.append(Item(title: "1", done: false))
		todoItems.append(Item(title: "2", done: false))
		todoItems.append(Item(title: "3", done: false))

		loadItems()
	}

	//MARK: - TableView Datasource methods

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! ToDoItemCell
		let item = todoItems[indexPath.row]
		cell.item = item
		cell.accessoryType = item.done ? .checkmark : .none
		return cell
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return todoItems.count
	}

	//MARK: - TableView Delegate methods

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		todoItems[indexPath.row].done = !todoItems[indexPath.row].done
		tableView.reloadData()
		tableView.deselectRow(at: indexPath, animated: true)
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			todoItems.remove(at: indexPath.row)
			saveItems()
			tableView.beginUpdates()
			tableView.deleteRows(at: [indexPath], with: .automatic)
			tableView.endUpdates()
		}
	}

	//MARK: - IBActions

	@IBAction func addNewItemButtonPressed(_ sender: UIBarButtonItem) {
		addNewToDoItem()
	}

	func addNewToDoItem() {
		var textField = UITextField()
		let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
		let action = UIAlertAction(title: "Add Todoey", style: .default) { (action) in
			self.addNewItemActionHandler(for: textField)
		}
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Type here"
			textField = alertTextField
		}
		alert.addAction(action)
		present(alert, animated: true) {
			print(textField.text!)
		}
	}

	func addNewItemActionHandler(for textField: UITextField) {
		let toAdd = textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
		if toAdd.count > 0 {
			self.todoItems.append(Item(title: toAdd, done: false))
			saveItems()
			let indexPath = IndexPath(row: self.todoItems.count - 1, section: 0)
			self.tableView.beginUpdates()
			self.tableView.insertRows(at: [indexPath], with: .automatic)
			self.tableView.endUpdates()
		}
	}
	//MARK: Model Manipulation Methods
	func saveItems() {
		do {
			let encoder = PropertyListEncoder()
			let data = try encoder.encode(todoItems)
			try data.write(to: dataFilePath!)
		} catch {
			print("Error saving items: \(error)")
		}
	}

	func loadItems() {
		do {
			let decoder = PropertyListDecoder()
			let data = try Data(contentsOf: dataFilePath!)
			todoItems = try decoder.decode([Item].self, from: data)
		} catch {
			print("Error loading items: \(error)")
		}
	}
}
