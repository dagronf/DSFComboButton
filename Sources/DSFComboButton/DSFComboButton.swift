//
//  DSFComboButton.swift
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

@IBDesignable public class DSFComboButton: NSControl {

	@objc public enum Style: UInt {
		case split = 0
		case unified = 1
	}
	
	/// The appearance setting that determines how the button presents its menu .
	@IBInspectable public var style: DSFComboButton.Style = .split {
		didSet {
			self.rebuild()
		}
	}
	
	/// The title for the button
	@IBInspectable public var title: String? = "" {
		didSet {
			self.segmented?.setLabel(self.title ?? "", forSegment: 0)

			if let u = self.unified {
				u.title = self.title ?? ""
				if u.title.isEmpty {
					u.imagePosition = .imageOnly
				}
				else {
					u.imagePosition = .imageLeading
				}
			}

			self.invalidateIntrinsicContentSize()
		}
	}
	
	/// The image for the button
	@IBInspectable public var image: NSImage? = nil {
		didSet {
			self.segmented?.setImage(self.image, forSegment: 0)
			self.unified?.image = self.image
			self.invalidateIntrinsicContentSize()
		}
	}
	
	/// The scaling behavior to apply to the button’s image.
	@IBInspectable public var imageScaling: NSImageScaling = .scaleProportionallyDown {
		didSet {
			self.segmented?.setImageScaling(self.imageScaling, forSegment: 0)
			self.unified?.imageScaling = self.imageScaling
			self.invalidateIntrinsicContentSize()
		}
	}
	
	@IBInspectable public var ib_style: UInt = Style.split.rawValue {
		didSet {
			self.style = Style(rawValue: self.ib_style) ?? .split
		}
	}
	
	// case regular = 0
	// case small = 1
	// case mini = 2
	// case large = 3
	
	@IBInspectable public var ib_controlSize: UInt = 0 {
		didSet {
			self.controlSize = NSControl.ControlSize(rawValue: self.ib_controlSize) ?? .regular
			self.invalidateIntrinsicContentSize()
		}
	}
	
	@IBInspectable public var ib_isEnabled: Bool = true {
		didSet {
			self.isEnabled = self.ib_isEnabled
		}
	}
	
	public init() {
		super.init(frame: .zero)
	}
	
	override public init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.setup()
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.setup()
	}
	
	/// Creates a combo button that displays both a title and image (split)
	public convenience init(title: String, image: NSImage, menu: NSMenu?, target: AnyObject?, action: Selector?) {
		self.init()
		self.style = .split
		self.title = title
		self.image = image
		self.target = target
		self.action = action
		self.menu = menu
		self.setup()
	}
	
	/// Creates a combo button that displays a title (split)
	public convenience init(title: String, menu: NSMenu?, target: Any?, action: Selector?) {
		self.init()
		self.style = .split
		self.title = title
		self.menu = menu
		self.setup()
	}
	
	/// Creates a combo button that displays an image (unified)
	public convenience init(image: NSImage, menu: NSMenu?, target: Any?, action: Selector?) {
		self.init()
		self.style = .unified
		self.image = image
		self.menu = menu
		self.setup()
	}
	
	override public func prepareForInterfaceBuilder() {
		self.setup()
		self.rebuild()
	}
	
	override public var intrinsicContentSize: NSSize {
		switch self.style {
		case .split: return self.segmented?.intrinsicContentSize ?? .zero
		case .unified: return self.segmented?.intrinsicContentSize ?? .zero
		}
	}
	
//	override public func awakeFromNib() {
//		self.segmented?.setMenu(self.menu, forSegment: 1)
//	}
	
	// Private
	internal var segmented: NSSegmentedControl?
	internal var unified: DelayedMenuButton?
}

public extension DSFComboButton {
	override var controlSize: NSControl.ControlSize {
		didSet {
			let f = NSFont.systemFont(ofSize: NSFont.systemFontSize(for: self.controlSize))
			
			self.segmented?.controlSize = self.controlSize
			self.segmented?.font = f
			self.segmented?.setWidth(min(16, f.pointSize * 1.3), forSegment: 1)
			
			self.unified?.controlSize = self.controlSize
			self.unified?.font = f

			self.invalidateIntrinsicContentSize()
		}
	}
	
	override var menu: NSMenu? {
		didSet {
			self.segmented?.setMenu(self.menu, forSegment: 1)
			self.unified?.delayedMenu = self.menu
			self.unified?.menu = self.menu
		}
	}
	
	override var isEnabled: Bool {
		didSet {
			self.segmented?.isEnabled = self.isEnabled
			self.unified?.isEnabled = self.isEnabled
		}
	}
	
	override var isHidden: Bool {
		didSet {
			self.segmented?.isHidden = self.isHidden
			self.unified?.isHidden = self.isHidden
		}
	}
}
