import SwiftUI

struct MentionTextViewWrapper: UIViewRepresentable {
	@Binding var text: String
	var onCommit: () -> Void
	
	func makeUIView(context: Context) -> MentionTextView {
		let textView = MentionTextView()
		textView.delegate = context.coordinator
		return textView
	}
	
	func updateUIView(_ uiView: MentionTextView, context: Context) {
		uiView.text = text
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	class Coordinator: NSObject, UITextViewDelegate {
		var parent: MentionTextViewWrapper
		
		init(_ parent: MentionTextViewWrapper) {
			self.parent = parent
		}
		
		func textViewDidChange(_ textView: UITextView) {
			parent.text = textView.text
		}
		
		func textViewDidEndEditing(_ textView: UITextView) {
			parent.onCommit()
		}
	}
}

// Example usage in SwiftUI View
struct ContentView: View {
	@State private var text: String = ""
	
	var body: some View {
		VStack {
			MentionTextViewWrapper(text: $text, onCommit: {
				// Handle any actions you want to perform when editing ends
			})
			// You can add other SwiftUI views here
		}
	}
}
