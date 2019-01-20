//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nikandr Margal on 1/16/19.
//  Copyright © 2019 Nikandr Margal. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
	let realm = try! Realm()
	var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
//		self.tableView.register(CategoryCell.self, forCellReuseIdentifier: "CategoryCell")
		tableView.tableFooterView = UIView(frame: .zero)
		tableView.rowHeight = 80.0
		if let searchBar = tableView.subviews.first(where: {$0.isKind(of: UISearchBar.self)}) {
			tableView.contentOffset = CGPoint(x: 0, y: searchBar.frame.size.height)
		}
		loadCategories()
    }

	//MARK: - IBActions

	@IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
		addNewCategory()
	}

	func addNewCategory() {
		var textField = UITextField()
		let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
		let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
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
		let categoryRaw = textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
		if categoryRaw.count > 0 {
			//FIXME: add Category class with init
			let category = Category()
			category.name = categoryRaw
			save(category: category)
			let indexPath = IndexPath(row: (self.categories?.count ?? 1) - 1, section: 0)
			self.tableView.beginUpdates()
			self.tableView.insertRows(at: [indexPath], with: .automatic)
			self.tableView.endUpdates()
		}
	}

	//MARK: - TableView Data Source methods

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		if let category = categories?[indexPath.row] {
			cell.setLabelText(from: category)
		} else {
			cell.textLabel?.text = "No Categories Added"
		}
		return cell
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories?.count ?? 1
	}

	//MARK: - TableView Delegate methods

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "showItems", sender: self)

	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destination = segue.destination as! ToDoListViewController
		if let indexPath = tableView.indexPathForSelectedRow {
			destination.selectedCategory = categories?[indexPath.row]
			destination.navigationItem.title = categories?[indexPath.row].name
		}
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	//MARK: - Data manipulation methods

	func save(category: Category) {
		do {
			try realm.write {
				realm.add(category)
			}
		} catch {
			print("Error saving context: \(error)")
		}
	}

	func loadCategories() {
		categories = realm.objects(Category.self)
		tableView.reloadData()
	}

	override func updateModel(at indexPath: IndexPath) {
		guard let toDelete = self.categories?[indexPath.row] else {
			return
		}
		try! self.realm.write {
			self.realm.delete(toDelete)
		}
		tableView.beginUpdates()
		tableView.deleteRows(at: [indexPath], with: .automatic)
		tableView.endUpdates()
	}
}

//MARK: - Search Bar Delegate methods

extension CategoryViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		categories = categories?.filter("name CONTAINS[cd] %@", searchBar.text!)
			.sorted(byKeyPath: "name", ascending: true)
		tableView.reloadData()
	}

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText.count == 0 {
			loadCategories()
			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}
		}
	}
}

