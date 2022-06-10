//
//  Image+CreateByDrawing.swift
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

extension NSImage {
	/// Create a NSImage of a specific size, lock focus on it and call the drawing block
	/// - Parameters:
	///   - size: The resulting size of the image
	///   - isTemplate: If true, marks the returned image as a template image
	///   - drawingBlock: The block for drawing into the image, passing the drawing context
	/// - Returns: The resulting image
	/// - Throws: `DSFImageGeneratorError`
	static func CreateByLockingFocus(
		size: NSSize,
		isTemplate: Bool = false,
		_ drawingBlock: (NSRect) throws -> Void
	) rethrows -> NSImage {
		let image = NSImage(size: size)
		do {
			image.lockFocus()
			defer { image.unlockFocus() }
			try drawingBlock(NSRect(origin: .zero, size: size))
		}
		image.isTemplate = isTemplate
		return image
	}
}
