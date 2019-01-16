//
//  ViewController.swift
//  Todoey
//
//  Created by Nikandr Margal on 1/10/19.
//  Copyright © 2019 Nikandr Margal. All rights reserved.
//

import UIKit
import CoreData

//MARK: - Search Bar Delegate methods

extension ToDoListViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		let request: NSFetchRequest<Item> = Item.fetchRequest()
		request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		loadItems(with: request)
	}

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText.count == 0 {
			loadItems()
			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}
		}
	}
}

class ToDoListViewController: UITableViewController {

	var todoItems = [Item]()
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.register(ToDoItemCell.self, forCellReuseIdentifier: "ToDoItemCell")
		self.tableView.tableFooterView = UIView(frame: .zero)
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
			context.delete(todoItems[indexPath.row])
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
			let item = Item(context: context)
			item.title = toAdd
			item.done = false
			self.todoItems.append(item)
			saveItems()
			let indexPath = IndexPath(row: self.todoItems.count - 1, section: 0)
			self.tableView.beginUpdates()
			self.tableView.insertRows(at: [indexPath], with: .automatic)
			self.tableView.endUpdates()
		}
	}

	//MARK: - Model Manipulation Methods

	func saveItems() {
		do {
			try context.save()
		} catch {
			print("Error saving context: \(error)")
		}
	}

	func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
		do {
			todoItems = try context.fetch(request)
		} catch {
			print("Error fetching data from context: \(error)")
		}
		tableView.reloadData()
	}
}
