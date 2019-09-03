//
//  ItemViewController.swift
//  Todoey
//
//  Created by Krishna Ajmeri on 8/27/19.
//  Copyright © 2019 Krishna Ajmeri. All rights reserved.
//

import UIKit
import RealmSwift

class ItemViewController: SwipeTableViewController {

	let realm = try! Realm()

	var listItems: Results<Item>?

	var selectedCategory : Category? {
		didSet {
			load()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.rowHeight = 80
		tableView.separatorStyle = .none
	}

	//MARK: TableView Datasource Methods

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return listItems?.count ?? 1
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = super.tableView(tableView, cellForRowAt: indexPath)

		if let item = listItems?[indexPath.row] {
			cell.textLabel?.text = item.title
			cell.accessoryType = item.done ? .checkmark : .none
		} else {
			cell.textLabel?.text = "No Items Added"
		}

		return cell
	}

	//MARK: TableView Delegate Methods

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		if let item = listItems?[indexPath.row] {
			do {
				try realm.write {
					item.done = !item.done
				}
			} catch {
				print("Error saving data done \(error)")
			}
		}

		tableView.reloadData()

		tableView.deselectRow(at: indexPath, animated: true)
	}

	//MARK: Add New Items

	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

		var textField = UITextField()
		let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

			if let currentCategory = self.selectedCategory {
				do {
					try self.realm.write {
						let newItem = Item()
						newItem.title = textField.text!
						newItem.dateCreated = Date()
						currentCategory.items.append(newItem)
					}
				} catch {
					print("Error saving new items, \(error)")
				}
			}

			self.tableView.reloadData()

		}

		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField = alertTextField
		}

		alert.addAction(action)

		present(alert, animated: true, completion: nil)
	}

	//MARK: Model Manipulation Methods

	func load() {

		listItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

		tableView.reloadData()
	}

	override func updateModel(at indexPath: IndexPath) {
		if let itemForDeletion = self.listItems?[indexPath.row] {
			do {
				try self.realm.write {
					self.realm.delete(itemForDeletion)
				}
			} catch {
				print("Error deleting item, \(error)")
			}
		}
	}
}

extension ItemViewController : UISearchBarDelegate {
	//MARK: Search Bar Methods

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

		listItems = listItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

		tableView.reloadData()

	}

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text?.count == 0 {
			load()

			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}
		}
	}
}
