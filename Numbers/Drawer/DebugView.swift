//
//  SquareDrawer.swift
//  Numbers
//
//  Created by Stephan Jancar on 15.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit
import BigInt

class DebugView : DrawNrImageView {
	init () {		
		super.init(frame: CGRect.zero)
		self.tester = PrimeTester()
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	struct DrawProt {
		var index = 0
		var rect = CGRect.zero
		var nrstr  = ""
	}
	static var _prot = DrawProt()
	
	override func CreateImageDrawer(nr: UInt64, tester: NumTester?, worker: DispatchWorkItem?) -> ImageNrDrawer? {
		return DebugDrawer(nr: nr, tester: tester!, emitter: self, worker: worker)
	}
}

class DebugDrawer : ImageNrDrawer
{
	private var d_str = ""
	
	override init(nr: UInt64, tester: NumTester?, emitter: EmitImage?, worker: DispatchWorkItem?) {
		super.init(nr: nr, tester: tester, emitter: emitter, worker: worker)
	}
	private func Font(fontsize : CGFloat) -> UIFont {
		return UIFont.systemFont(ofSize: fontsize)
	}
	private func Attributes(fontsize : CGFloat, color : UIColor ) -> [NSAttributedStringKey: Any] {
		let font = Font(fontsize:fontsize)
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .center

		let attributes = [NSAttributedStringKey.paragraphStyle  :  paragraphStyle,
						  NSAttributedStringKey.font: font,
						  NSAttributedStringKey.foregroundColor : color]
		return attributes
	}
	override func DrawNrImage(rect : CGRect) -> UIImage? {
		_ = super.DrawNrImage(rect: rect)
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		defer { UIGraphicsEndImageContext() }
		guard let context = UIGraphicsGetCurrentContext() else { return nil }
		context.setStrokeColor(UIColor.black.cgColor)
		context.setLineWidth(1.0);
		context.beginPath()
		
		DebugView._prot.index = DebugView._prot.index + 1
		DebugView._prot.rect = rect
		DebugView._prot.nrstr = String(nr)
			
		d_str = String(DebugView._prot.nrstr) + "\n" + String(DebugView._prot.index) + "\n" + String(describing: DebugView._prot.rect)
			print(d_str)
		DrawNumber(context: context)
		
		let image = UIGraphicsGetImageFromCurrentImageContext()
		return image
	}

	
	private func DrawNumber(context : CGContext)
	{
		let w = rect.width
		let dy = rect.height / 3
		var y : CGFloat = 0
		do {
			let attributes = Attributes(fontsize: 20.0, color : .white)
			let attrString = NSAttributedString(string: d_str,attributes: attributes)
			let rt = CGRect(x: 0, y: y , width: w, height: dy)
			attrString.draw(in: rt)
			y = y + dy
		}
		if let text = tester?.property() {
			let attributes = Attributes(fontsize: 20.0, color : .white)
			let attrString = NSAttributedString(string: text,attributes: attributes)
			let rt = CGRect(x: 0, y: y , width: w, height: dy)
			attrString.draw(in: rt)
			y = y + dy
		}
	}
}





