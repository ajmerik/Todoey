//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Krishna Ajmeri on 8/30/19.
//  Copyright © 2019 Krishna Ajmeri. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

	let realm = try! Realm()

	var categories : Results<Category>?

	override func viewDidLoad() {
		super.viewDidLoad()

		load()

		tableView.rowHeight = 80

		tableView.separatorStyle = .none
	}

	//MARK: - TableView Datasource Methods

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return categories?.count ?? 1
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = super.tableView(tableView, cellForRowAt: indexPath)

		cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"

		guard let categoryColor = UIColor(hexString: categories?[indexPath.row].color ?? "1D9BF6") else {fatalError()}

		cell.backgroundColor = categoryColor
		cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)

		return cell
	}

	//MARK: - TableView Delegate Methods

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		performSegue(withIdentifier: "goToItems", sender: self)

		tableView.deselectRow(at: indexPath, animated: true)

	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		let destinationVC = segue.destination as! ItemViewController

		if let indexPath = tableView.indexPathForSelectedRow {
			destinationVC.selectedCategory = categories?[indexPath.row]
		}
	}

	//MARK: - Add New Categories

	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

		var textField = UITextField()
		let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)

		let action = UIAlertAction(title: "Add Category", style: .default) { (action) in

			let newCategory = Category()
			newCategory.name = textField.text!
			newCategory.color = UIColor.randomFlat.hexValue()

			self.save(category: newCategory)
		}

		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new category"
			textField = alertTextField
		}

		alert.addAction(action)

		present(alert, animated: true, completion: nil)
	}

	//MARK: - Data Manipulation Methods

	func save(category: Category) {
		do {
			try realm.write {
				realm.add(category, update: false)
			}
		} catch {
			print("Error saving context: \(error)")
		}

		tableView.reloadData()
	}

	func load() {

		categories = realm.objects(Category.self)

		tableView.reloadData()
	}

	override func updateModel(at indexPath: IndexPath) {
		if let categoryForDeletion = self.categories?[indexPath.row] {
			do {
				try self.realm.write {
					self.realm.delete(categoryForDeletion)
				}
			} catch {
				print("Error deleting category, \(error)")
			}
		}
	}

}
