//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nikandr Margal on 1/16/19.
//  Copyright © 2019 Nikandr Margal. All rights reserved.
//

import UIKit
import CoreData

//MARK: - Search Bar Delegate methods

extension CategoryViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		let request: NSFetchRequest<Category> = Category.fetchRequest()
		request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
		request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
		loadCategories(with: request)
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

class CategoryViewController: UITableViewController {

	var categories = [Category]()
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.register(CategoryCell.self, forCellReuseIdentifier: "CategoryCell")
		self.tableView.tableFooterView = UIView(frame: .zero)
		loadCategories()
		if let searchBar = tableView.subviews.first(where: {$0.isKind(of: UISearchBar.self)}) {
			self.tableView.contentOffset = CGPoint(x: 0, y: searchBar.frame.size.height)
		}
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
			let category = Category(context: context)
			category.name = categoryRaw
			self.categories.append(category)
			saveCategories()
			let indexPath = IndexPath(row: self.categories.count - 1, section: 0)
			self.tableView.beginUpdates()
			self.tableView.insertRows(at: [indexPath], with: .automatic)
			self.tableView.endUpdates()
		}
	}

	//MARK: - TableView Data Source methods

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
		let category = categories[indexPath.row]
		cell.category = category
		return cell
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories.count
	}

	//MARK: - TableView Delegate methods

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "showItems", sender: self)

	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destination = segue.destination as! ToDoListViewController
		if let indexPath = tableView.indexPathForSelectedRow {
			destination.selectedCategory = categories[indexPath.row]
			destination.navigationItem.title = categories[indexPath.row].name
		}
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			context.delete(categories[indexPath.row])
			categories.remove(at: indexPath.row)
			saveCategories()
			tableView.beginUpdates()
			tableView.deleteRows(at: [indexPath], with: .automatic)
			tableView.endUpdates()
		}
	}

	//MARK: - Data manipulation methods

	func saveCategories() {
		do {
			try context.save()
		} catch {
			print("Error saving context: \(error)")
		}
	}

	func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
		do {
			categories = try context.fetch(request)
		} catch {
			print("Error fetching data from context: \(error)")
		}
		tableView.reloadData()
	}
}
