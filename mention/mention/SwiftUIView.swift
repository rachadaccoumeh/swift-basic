//
//  SwiftUIView.swift
//  mention
//
//  Created by Telepaty 4 on 20/07/2023.
//

import SwiftUI

struct SwiftUIView: View {
	@State private var text: String = ""
	
	var body: some View {
		MentionTextViewWrapper(text: $text, onCommit: {
			// Handle any actions you want to perform when editing ends
			print("Editing ended.")
		})
		.frame(minHeight: 100, maxHeight: 200) // Adjust the size as needed
		Button(action: {
			// Perform an action using the updated text
			print("Text content:", text)
		}) {
			Text("Submit")
		}
		.padding()
	}
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
