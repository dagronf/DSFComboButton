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

#if os(macOS)

import AppKit
import Foundation

@IBDesignable public class DSFComboButton: NSControl {

	/// The title for the button
	@IBInspectable public var title: String = "" {
		didSet {
			self.segmented?.setLabel(self.title, forSegment: 0)

			if let u = self.unified {
				u.title = self.title
				u.image = self.image
				if u.title.isEmpty {
					u.imagePosition = .imageOnly
				}
				else if u.image == nil {
					u.imagePosition = .noImage
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
			if let u = self.unified {
				u.image = self.image
				if u.title.isEmpty {
					u.imagePosition = .imageOnly
				}
				else if u.image == nil {
					u.imagePosition = .noImage
				}
				else {
					u.imagePosition = .imageLeading
				}
			}

			self.invalidateIntrinsicContentSize()
		}
	}

	/// Is the control enabled?
	@IBInspectable public var ib_isEnabled: Bool = true {
		didSet {
			self.isEnabled = self.ib_isEnabled
		}
	}

	// MARK: Style settings

	@objc public enum Style: Int {
		case split = 0
		case unified = 1
	}
	
	/// The appearance setting that determines how the button presents its menu.
	public var style: DSFComboButton.Style = .split {
		didSet {
			self.rebuild()
		}
	}

	/// The appearance setting that determines how the button presents its menu.
	///
	///   split == 0
	///   unified == 1
	@IBInspectable public var ib_style: Int = Style.split.rawValue {
		didSet {
			self.style = Style(rawValue: self.ib_style) ?? .split
		}
	}

	// MARK: Control size

	/// The size of the control
	///
	/// The value maps to the `NSControl.ControlSize` enum
	///   regular == 0
	///   small == 1
	///   mini == 2
	///   large == 3
	@IBInspectable public var ib_controlSize: UInt = 0 {
		didSet {
			self.controlSize = NSControl.ControlSize(rawValue: self.ib_controlSize) ?? .regular
			self.invalidateIntrinsicContentSize()
		}
	}

	// MARK: Text alignment

	public var textAlignment: NSTextAlignment = .center {
		didSet {
			self.segmented?.setAlignment(textAlignment, forSegment: 0)
		}
	}

	/// The alignment of the text/image within the control
	///
	///   left = 0 // Visually left aligned
	///   right = 1 // Visually right aligned
	///   center = 2 // Visually centered
	///   justified = 3 // Fully-justified. The last line in a paragraph is natural-aligned.
	///   natural = 4 // Indicates the default alignment for script
	@IBInspectable public var ib_textAlignment: NSInteger = NSTextAlignment.justified.rawValue {
		didSet {
			self.segmented?.setAlignment(NSTextAlignment(rawValue: ib_textAlignment)!, forSegment: 0)
		}
	}

	// MARK: - Image scaling

	/// The scaling behavior to apply to the button’s image.
	@IBInspectable public var ib_imageScaling: UInt = NSImageScaling.scaleProportionallyDown.rawValue {
		didSet {
			self.imageScaling = NSImageScaling(rawValue: self.ib_imageScaling)!
		}
	}

	/// The scaling behavior to apply to the button’s image.
	public var imageScaling: NSImageScaling = .scaleProportionallyDown {
		didSet {
			self.segmented?.setImageScaling(self.imageScaling, forSegment: 0)
			self.unified?.imageScaling = self.imageScaling
			self.invalidateIntrinsicContentSize()
		}
	}

	// MARK: Initializers
	
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
	
	// Private
	internal var segmented: NSSegmentedControl?
	internal var unified: DelayedMenuButton?
}

#endif
