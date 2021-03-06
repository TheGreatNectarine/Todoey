//
//  ViewController.swift
//  Todoey
//
//  Created by Nikandr Margal on 1/10/19.
//  Copyright © 2019 Nikandr Margal. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController {

	let realm = try! Realm()
	var todoItems: Results<Item>?
	var selectedCategory: Category? {
		didSet {
			loadItems()
		}
	}
	
	@IBOutlet weak var searchBar: UISearchBar!

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.tableFooterView = UIView(frame: .zero)
		tableView.rowHeight = 80.0
		tableView.separatorStyle = .none

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.contentOffset = CGPoint(x: 0, y: searchBar.frame.size.height)
		guard let color = selectedCategory?.cellColor else {
			fatalError("no color")
		}
		updateNavBarAndSearchBar(withHexCode: color)

	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		updateNavBarAndSearchBar(withHexCode: "ID9BF6")
	}

	//MARK: - NavBar Setup Methods

	func updateNavBarAndSearchBar(withHexCode hexCode: String) {
		guard let navBar = navigationController?.navigationBar else {
			fatalError()
		}
		guard let color = UIColor(hexString: hexCode) else {
			fatalError()
		}
		navBar.barTintColor = color
		navBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
		navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)]
		searchBar.barTintColor = color
	}

	//MARK: - TableView Datasource methods

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		if let item = todoItems?[indexPath.row] {
			print(item)
			cell.setLabelText(from: item)
			cell.backgroundColor = UIColor(hexString: item.cellColor!)?
				.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)/3.0)
			cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor!, isFlat: true)
			cell.accessoryType = item.done ? .checkmark : .none
		} else {
			print("nil")
			cell.textLabel?.text = "No Todoeys Yet"
		}
		return cell
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return todoItems?.count ?? 1
	}

	//MARK: - TableView Delegate methods

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let item = todoItems?[indexPath.row] {
			do {
				try realm.write {
					item.done = !item.done
				}
			} catch {
				print("Error updating completion: \(error)")
			}
		}
		tableView.reloadRows(at: [indexPath], with: .automatic)
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			if let toDelete = todoItems?[indexPath.row] {
				try! realm.write {
					realm.delete(toDelete)
				}
			}
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
		if let category = selectedCategory {
			let toAdd = textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
			if toAdd.count > 0 {
				//FIXME: add Item class with init
				let item = Item()
				item.title = toAdd
				item.done = false
				item.cellColor = category.cellColor
				item.dateCreated = Date()
				save(item: item, for: category)
				let indexPath = IndexPath(row: (self.todoItems?.count ?? 1) - 1, section: 0)
				self.tableView.beginUpdates()
				self.tableView.insertRows(at: [indexPath], with: .automatic)
				self.tableView.endUpdates()
			}
		}
	}

	//MARK: - Data Manipulation Methods

	func save(item: Item, for category: Category) {
		do {
			try realm.write {
				realm.add(item)
				category.items.append(item)
			}
		} catch {
			print("Error saving with realm: \(error)")
		}
	}

	func loadItems() {
		todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
		tableView.reloadData()
	}

	override func updateModel(at indexPath: IndexPath) {
		guard let toDelete = self.todoItems?[indexPath.row] else {
			return
		}
		try! self.realm.write {
			self.realm.delete(toDelete)
		}

	}
}

//MARK: - Search Bar Delegate methods

extension ToDoListViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!)
			.sorted(byKeyPath: "dateCreated", ascending: true)
		tableView.reloadData()
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


