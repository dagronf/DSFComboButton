//
//  ViewController.swift
//  ComboButton
//
//  Created by Darren Ford on 7/6/2022.
//

import Cocoa

class ViewController: NSViewController {
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}

	@IBAction func doSomething(_ sender: Any?) {
		Swift.print("did something!")
	}

	@IBAction func pressed(_ sender: Any?) {
		Swift.print("Pressed!")
	}

	@IBAction func unifiedpressed(_ sender: Any?) {
		Swift.print("unifiedpressed!")
	}
}
