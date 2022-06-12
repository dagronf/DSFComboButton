//
//  DelayedMenuButton.swift
//
//  Copyright © 2022 Darren Ford. All rights reserved.
//
//  MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#if os(macOS)

import AppKit
import Foundation

/// Button with a delayed menu like Safari Go Back & Forward buttons.
internal class DelayedMenuButton: NSButton {
	/// Click & Hold menu, appears after `NSEvent.doubleClickInterval` seconds.
	var delayedMenu: NSMenu?
}

internal extension DelayedMenuButton {
	override func mouseDown(with event: NSEvent) {
		// Run default implementation if delayed menu is not assigned
		guard self.delayedMenu != nil, isEnabled else {
			super.mouseDown(with: event)
			return
		}

		/// Run the popup menu if the mouse is down during `doubleClickInterval` seconds
		let delayedItem = DispatchWorkItem { [weak self] in
			self?.showDelayedMenu()
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(NSEvent.doubleClickInterval * 1000)), execute: delayedItem)

		/// Action will be set to nil if the popup menu runs during `super.mouseDown`
		let defaultAction = self.action

		// Run standard tracking
		super.mouseDown(with: event)

		// Restore default action if popup menu assigned it to nil
		self.action = defaultAction

		// Cancel popup menu once tracking is over
		delayedItem.cancel()
	}
}

internal extension DelayedMenuButton {
	func showDelayedMenu() {
		guard
			let delayedMenu = delayedMenu, delayedMenu.numberOfItems > 0, let window = window, let location = NSApp.currentEvent?.locationInWindow,
			let mouseUp = NSEvent.mouseEvent(
				with: .leftMouseUp, location: location, modifierFlags: [], timestamp: Date.timeIntervalSinceReferenceDate,
				windowNumber: window.windowNumber, context: NSGraphicsContext.current, eventNumber: 0, clickCount: 1, pressure: 0
			)
		else {
			return
		}

		// Cancel default action
		action = nil

		let minWidth = self.frame.width
		delayedMenu.minimumWidth = minWidth

		// Show the default menu
		delayedMenu.popUp(positioning: nil, at: .init(x: 0, y: bounds.height + 2), in: self)

		// Send mouse up when the menu is on screen
		window.postEvent(mouseUp, atStart: false)
	}
}

#endif
