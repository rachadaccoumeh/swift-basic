//
//  SQLiteHelper.swift
//  icloud backup test
//
//  Created by Telepaty 4 on 22/05/2023.
//

import Foundation
import SQLite

struct SQLiteHelper {
	private let dbConnection: Connection

	init() {
		// Create a connection to the SQLite database file
		let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
		let db = try! Connection("\(path)/mydatabase.sqlite3")
		self.dbConnection = db

		// Create a table if it doesn't exist
		let table = Table("books")
		let id = Expression<Int64>("id")
		let title = Expression<String>("title")

		try! dbConnection.run(table.create(ifNotExists: true) { t in
			t.column(id, primaryKey: true)
			t.column(title)
		})
	}

	func getAllBooks() -> [Book] {
		let table = Table("books")
		let id = Expression<Int64>("id")
		let title = Expression<String>("title")

		var books: [Book] = []

		do {
			for row in try dbConnection.prepare(table) {
				let book = Book(id:row[id], title: row[title])
				books.append(book)
			}
		} catch {
			print("Error retrieving books: \(error)")
		}

		return books
	}

	func addBook(title: String) {
		let table = Table("books")
		let titleExpression = Expression<String>("title")

		let insert = table.insert(titleExpression <- title)

		do {
			try dbConnection.run(insert)
		} catch {
			print("Error adding book: \(error)")
		}
	}

	func deleteBook(id: Int64) {
		let table = Table("books")
		let idExpression = Expression<Int64>("id")

		let book = table.filter(idExpression == id)
		let delete = book.delete()

		do {
			try dbConnection.run(delete)
		} catch {
			print("Error deleting book: \(error)")
		}
	}
	
}

