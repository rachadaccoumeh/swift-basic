import UIKit

class MentionTextView: UITextView {
	var mentions: [NSRange: (mentionId: String, mentionDisplayName: String)] = [:]
	var isMentionSelected:Bool=false
	
	
	
	override func deleteBackward() {
		if let range = self.selectedTextRange {
			let selectionStart = self.offset(from: beginningOfDocument, to: range.start)
			var deletedLength = 1
			if let mentionRange = getMentionRange(for: selectionStart) {
				deletedLength = mentionRange.length
				self.textStorage.replaceCharacters(in: mentionRange, with: "")
				mentions.removeValue(forKey: getMentionRange(for: selectionStart)!)
			}else{
				super.deleteBackward()
			}
			let mentionsToBeChanged = getMentions(after: selectionStart)
			for mentionToBeChanged in mentionsToBeChanged {
				let newLocation = mentionToBeChanged.location - deletedLength
				let newRange = NSRange(location: newLocation, length: mentionToBeChanged.length)
				mentions[newRange] = mentions[mentionToBeChanged]
				mentions.removeValue(forKey: mentionToBeChanged)
			}
		}else{
			super.deleteBackward()
		}
	}
	
	
	override func closestPosition(to point: CGPoint) -> UITextPosition? {
		self.isMentionSelected=false
		guard let textRange = self.characterRange(at: point) else {
			return super.closestPosition(to: point)
		}
		let locationStart = self.offset(from: beginningOfDocument, to: textRange.start)
//		let locationEnd = self.offset(from: beginningOfDocument, to: textRange.end)
		if let mentionRange = getMentionRange(for: locationStart) {
			self.isMentionSelected=true
			return self.position(from: self.beginningOfDocument, offset: mentionRange.upperBound)
		}
		return super.closestPosition(to: point)
	}
	
	private func replaceSpacesWithNonBreakingSpace(_ input: String) -> String {
		let nonBreakingSpace = "\u{2000}"
		let result = input.replacingOccurrences(of: " ", with: nonBreakingSpace)
		return result
	}
	
	@objc func addMention(mentionId: String, mentionDisplayName: String) {
		if let range = self.selectedTextRange {
			let selectionStart = self.offset(from: beginningOfDocument, to: range.start)
			let mentionDisplayName = replaceSpacesWithNonBreakingSpace(mentionDisplayName)
			let attributedString = NSMutableAttributedString(attributedString: self.attributedText)
			var mentionsToBeChanged = getMentions(after: selectionStart)
			mentionsToBeChanged.sort { (mention1, mention2) -> Bool in
				return mention1.location > mention2.location
			}
			for mentionToBeChanged in mentionsToBeChanged {
				let newLocation = mentionToBeChanged.location + mentionDisplayName.count+2
				let newRange = NSRange(location: newLocation, length: mentionToBeChanged.length)
				mentions[newRange] = mentions[mentionToBeChanged]
				mentions.removeValue(forKey: mentionToBeChanged)
			}
			let mentionRange = NSRange(location: selectionStart, length: mentionDisplayName.count+2)
			mentions[mentionRange] = (mentionId, mentionDisplayName)
			let attributedStringNew = NSMutableAttributedString()
			attributedStringNew.append(NSAttributedString(string: "\u{2000}", attributes: [.foregroundColor: UIColor.label]))
			attributedStringNew.append(NSAttributedString(string: mentionDisplayName, attributes: [.foregroundColor: UIColor.blue]))
			attributedStringNew.append(NSAttributedString(string: "\u{2000}", attributes: [.foregroundColor: UIColor.label]))
			attributedString.insert(attributedStringNew, at: selectionStart)
			self.attributedText = attributedString
		}
	}
	
	private func getMentionRange(for location: Int) -> NSRange? {
		for (mentionRange, _) in mentions {
			if location > mentionRange.location && location <= mentionRange.upperBound {
				return mentionRange
			}
		}
		return nil
	}
	 
	private func getMentions(after index: Int) -> [NSRange] {
		var mentionsAfterIndex: [NSRange] = []
		for (mentionRange, _) in mentions {
			if mentionRange.location >= index {
				mentionsAfterIndex.append(mentionRange)
			}
		}
		return mentionsAfterIndex
	}
	
	private func mentionAtIndex(at index: Int) -> NSRange? {
		for (mentionRange, _) in mentions {
			if mentionRange.location == index-1 {
				return mentionRange
			}
		}
		return nil
	}
	
	private func removeMention(from range: NSRange) {
		mentions.removeValue(forKey: range)
	}
	
	override func insertText(_ text: String) {
		if let selectedRange = self.selectedTextRange {
			let selectionStart = self.offset(from: beginningOfDocument, to: selectedRange.start)
			let mentionsToBeChanged = getMentions(after: selectionStart)
			for mentionToBeChanged in mentionsToBeChanged {
				let newLocation = mentionToBeChanged.location + text.count
				let newRange = NSRange(location: newLocation, length: mentionToBeChanged.length)
				mentions[newRange] = mentions[mentionToBeChanged]
				mentions.removeValue(forKey: mentionToBeChanged)
			}
			if let mentionRange = mentionAtIndex(at: selectionStart+1) {
				self.textStorage.replaceCharacters(in: mentionRange, with: "")
				mentions.removeValue(forKey: mentionAtIndex(at: selectionStart+1)!)
				return
			}
			
		}
		super.insertText(text)
	}
	
	@objc func sendMessage() -> String {
		let attributedString = NSMutableAttributedString(attributedString: self.attributedText)
		let mentions = mentions.sorted { $0.key.location > $1.key.location }
		for (mentionRange, mentionInfo) in mentions {
			let mentionId = mentionInfo.mentionId
			let mentionReplacement = " @\(mentionId) "
			attributedString.replaceCharacters(in: mentionRange, with: mentionReplacement)
		}
		return attributedString.string
	}

}
