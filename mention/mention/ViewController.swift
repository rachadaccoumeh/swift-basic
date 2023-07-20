//
//  ViewController.swift
//  mention
//
//  Created by Telepaty 4 on 14/07/2023.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var mentionTextView: MentionTextView!
	override func viewDidLoad() {
		super.viewDidLoad()
	
		
	}
	var mentionId:Int=111110
	var index = 0
	
	@IBAction func sendButtonClicked(_ sender: Any) {
		textView.text=mentionTextView.sendMessage()
	}

	@IBAction func mentionClicked(_ sender: Any) {
		mentionId+=1
		index+=1
		mentionTextView.addMention(mentionId: "\(mentionId)", mentionDisplayName: "user‎ \(index)")
	}
	
}

