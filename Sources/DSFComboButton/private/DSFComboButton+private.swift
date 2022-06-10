//
//  DSFComboButton+private.swift
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

import AppKit
import Foundation

extension DSFComboButton {

	func setup() {
		self.wantsLayer = true
		self.layer!.masksToBounds = false
		self.translatesAutoresizingMaskIntoConstraints = false
		self.stringValue = ""
		self.isEnabled = true
		self.controlSize = .regular
		self.rebuild()
	}

	func rebuild() {
		self.segmented = nil
		self.unified = nil
		self.subviews.forEach { $0.removeFromSuperview() }
		if self.style == .split {
			self.configureSplit()
		}
		else {
			self.configureUnified()
		}
		self.invalidateIntrinsicContentSize()
	}

	func configureSplit() {
		let sc = NSSegmentedControl()

		sc.setAccessibilityLabel("Combo Button")

		sc.wantsLayer = true
		sc.trackingMode = .momentary
		sc.translatesAutoresizingMaskIntoConstraints = false
		sc.segmentCount = 2
		sc.controlSize = self.controlSize
		sc.isEnabled = self.isEnabled
		sc.font = NSFont.systemFont(ofSize: NSFont.systemFontSize(for: self.controlSize))

		sc.setImage(self.image, forSegment: 0)
		sc.setImageScaling(.scaleProportionallyDown, forSegment: 0)
		sc.setLabel(self.title ?? "", forSegment: 0)
		sc.setImage(__ArrowImage, forSegment: 1)

		let f = NSFont.systemFont(ofSize: NSFont.systemFontSize(for: self.controlSize))
		sc.setWidth(min(16, f.pointSize * 1.3), forSegment: 1)

		sc.target = self
		sc.action = #selector(self.segmentedDidSelect(_:))

		self.addSubview(sc)

		self.addConstraint(NSLayoutConstraint(item: sc, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
		self.addConstraint(NSLayoutConstraint(item: sc, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
		self.addConstraint(NSLayoutConstraint(item: sc, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
		self.addConstraint(NSLayoutConstraint(item: sc, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))

		sc.invalidateIntrinsicContentSize()

		self.segmented = sc
	}

	func configureUnified() {
		let dropdown = DelayedMenuButton()

		dropdown.setAccessibilityLabel("Combo Button")
		dropdown.translatesAutoresizingMaskIntoConstraints = false
		dropdown.wantsLayer = true
		dropdown.isBordered = true
		dropdown.title = self.title ?? ""
		dropdown.image = self.image

		if dropdown.title.count == 0 {
			dropdown.imagePosition = .imageOnly
		}
		else if dropdown.image != nil {
			dropdown.imagePosition = .imageLeading
		}
		else {
			dropdown.imagePosition = .noImage
		}
		dropdown.imageScaling = self.imageScaling
		dropdown.setButtonType(.momentaryPushIn)
		dropdown.bezelStyle = .regularSquare
		dropdown.allowsMixedState = false
		dropdown.controlSize = self.controlSize
		dropdown.delayedMenu = self.menu
		dropdown.isEnabled = self.isEnabled

		let f = NSFont.systemFont(ofSize: NSFont.systemFontSize(for: self.controlSize))
		dropdown.controlSize = self.controlSize
		dropdown.font = f

		dropdown.target = self
		dropdown.action = #selector(unifiedDidSelect(_:))

		self.addSubview(dropdown)

		self.addConstraint(NSLayoutConstraint(item: dropdown, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
		self.addConstraint(NSLayoutConstraint(item: dropdown, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
		self.addConstraint(NSLayoutConstraint(item: dropdown, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
		self.addConstraint(NSLayoutConstraint(item: dropdown, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))

		dropdown.invalidateIntrinsicContentSize()

		self.unified = dropdown
	}

	@objc private func unifiedDidSelect(_ sender: NSButton) {
		if let t = self.target as? NSObject, let a = self.action {
			t.perform(a, with: self)
		}
	}


	@objc private func segmentedDidSelect(_ sender: NSSegmentedControl) {
		if sender.selectedSegment == 0, let t = self.target as? NSObject, let a = self.action {
			t.perform(a, with: self)
		}
		else if sender.selectedSegment == 1 {
			let w = self.frame.width - self.frame.height
			if let menu = self.menu {
				menu.popUp(
					positioning: menu.item(at: 0),
					at: CGPoint(x: w, y: -8),
					in: self
				)
			}
		}
	}

}

// The arrow image
private let __ArrowImage = NSImage.CreateByLockingFocus(size: CGSize(width: 5, height: 5), isTemplate: true) { drawingRect in
	let bezierPath = NSBezierPath()
	bezierPath.move(to: NSPoint(x: 0.5, y: 3.5))
	bezierPath.line(to: NSPoint(x: 2.5, y: 1.5))
	bezierPath.line(to: NSPoint(x: 4.5, y: 3.5))
	NSColor.black.setStroke()
	bezierPath.lineWidth = 1
	bezierPath.stroke()
}
