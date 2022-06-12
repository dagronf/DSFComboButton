//
//  ViewController.swift
//  Doco Demo
//
//  Created by Darren Ford on 12/6/2022.
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

	@IBAction func splitButtonAction(_ sender: Any) {
		Swift.print("Selected split button")
	}

	@IBAction func splitMenuAction(_ sender: NSMenuItem) {
		Swift.print("Selected menu item: \(sender.title)")
	}

	@IBAction func unifiedButtonAction(_ sender: Any) {
		Swift.print("Selected unified button")
	}

	@IBAction func unifiedMenuAction(_ sender: NSMenuItem) {
		Swift.print("Selected menu item: \(sender.title)")
	}
}

