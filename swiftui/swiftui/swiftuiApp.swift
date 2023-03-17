//
//  swiftuiApp.swift
//  swiftui
//
//  Created by Telepaty 4 on 16/03/2023.
//

import SwiftUI

@main
struct swiftuiApp: App {
    var body: some Scene {
        WindowGroup {
            ContactCell(contactName: "contact name",imageUrl: URL(string: ""), hasViva: true,saved: true) {
                print("saving")
            } sendAction: {
                
            }

        }
    }
}
