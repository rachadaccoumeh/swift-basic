//
//  ViewController.swift
//  icloud backup test
//
//  Created by Telepaty 4 on 22/05/2023.
//
/*
import SwiftUI

struct ContentView: View {
	@State private var items: [String] = ["Item 1", "Item 2", "Item 3"]
	@State private var newItem = ""

	var body: some View {
		VStack {
			HStack {
				TextField("Enter item", text: $newItem)
					.textFieldStyle(RoundedBorderTextFieldStyle())
				
				Button(action: addItem) {
					Text("Add")
				}
			}
			.padding()

			List {
				ForEach(items, id: \.self) { item in
					Text(item)
				}
				.onDelete(perform: deleteItems)
			}
		}
	}

	func addItem() {
		items.append(newItem)
		newItem = ""
	}

	func deleteItems(at offsets: IndexSet) {
		items.remove(atOffsets: offsets)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}


*/
import SwiftUI
import CloudKit


struct ContentView: View {
	@State private var books: [Book] = []
	@State private var newBookTitle: String = ""

	private let db = SQLiteHelper()

	var body: some View {
		NavigationView {
			VStack {
				List {
					ForEach(books, id: \.id) { book in
						Text(book.title)
					}
					.onDelete(perform: deleteBooks)
				}

				HStack {
					TextField("New Book Title", text: $newBookTitle)
					Button(action: addBook) {
						Text("Add")
					}
				}
				HStack{
					Spacer()
					Button("backup", action: backup)
					Spacer()
					Button("restore", action: restore)
					Spacer()
				}
				.padding()
			}
			//.navigationTitle("My Library")
		}
		.onAppear {
			books = db.getAllBooks()
		}
	}

	private func addBook() {
		if !newBookTitle.isEmpty {
			db.addBook(title: newBookTitle)
			books = db.getAllBooks()
			newBookTitle = ""
		}
	}

	private func deleteBooks(offsets: IndexSet) {
		for index in offsets {
			let book = books[index]
			db.deleteBook(id: book.id)
		}
		books = db.getAllBooks()
	}
	private func backup(){
		// Create a CloudKit container reference
		let container = CKContainer(identifier: "iCloud.com.Telepaty.icloudExample")
		// Create a private database reference
		let privateDatabase = container.privateCloudDatabase
		// Specify the file URL of the exported database file
		let fileURL = URL(fileURLWithPath: getDatabasePath())
		// Create a record ID for the file record
		let fileRecordID = CKRecord.ID(recordName: "user id 1")
		// Create a record for the file
		let fileRecord = CKRecord(recordType: "sqlite", recordID: fileRecordID)
		// Create a file asset with the database file URL
		let fileAsset = CKAsset(fileURL: fileURL)
		fileRecord["databaseFile"] = fileAsset
		// Save the file record to the private database
		privateDatabase.save(fileRecord) { (record, error) in
			if let error = error {
				print("Error uploading database file: \(error.localizedDescription)")
				// Handle the error gracefully
			} else {
				print("Database file uploaded successfully")
				// Handle the successful upload
			}
		}

	}
	private func restore(){
		// Create a CloudKit container reference
		let container = CKContainer(identifier: "iCloud.com.Telepaty.icloudExample")
		// Create a private database reference
		let privateDatabase = container.privateCloudDatabase
		// Create a record ID for the file record
		let fileRecordID = CKRecord.ID(recordName: "user id 1")
		// Fetch the file record from the private database
		privateDatabase.fetch(withRecordID: fileRecordID) { (record, error) in
			if let error = error {
				print("Error fetching file record: \(error.localizedDescription)")
				// Handle the error gracefully
			} else if let fileAsset = record?["databaseFile"] as? CKAsset,
						let fileURL = fileAsset.fileURL {
				print("done            !!!!!!!!!!!\(fileURL)")
				// File downloaded successfully, now you have the file URL
				// Proceed with replacing the existing database file in your app's storage
			}
		}

	}
	func getDatabasePath() -> String {
//		guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//			return nil
//		}
//		let databaseURL = documentsDirectory.appendingPathComponent("mydatabase.sqlite3")
//		return databaseURL
		return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!+"/mydatabase.sqlite3";
	}

//	func getDatabaseName() -> String {
//		guard let databaseURL = getDatabasePath() else {
//			return ""
//		}
//		return databaseURL.lastPathComponent
//	}
}

struct Previews_ViewController_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
