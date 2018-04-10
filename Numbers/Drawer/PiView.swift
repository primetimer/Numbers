//
//  UlamView.swift
//  PrimeTime
//
//  Created by Stephan Jancar on 03.04.16.
//  Copyright © 2016 esjot. All rights reserved.
//

import UIKit
import BigInt

class PiView : DrawNrImageView {
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.tester = MathConstantTester()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	override func draw(_ rect: CGRect) {
		if !needredraw { return }
		guard let tester = self.tester as? MathConstantTester else { assert(false); return }
		super.draw(rect)
		self.imageview.stopAnimating()
		self.imageview.animationImages = []
		self.imageview.animationDuration = 2.0
		self.imageview.animationRepeatCount = 1
		workItem?.cancel()
		self.workItem = DispatchWorkItem {
			guard let worker = self.workItem else { return }
			guard let tester = self.tester as? MathConstantTester else { return }
			let drawer = PiDrawer(rect: rect, tester: tester, nr: self.nr)
			drawer.emitdelegate = self
			drawer.worker = worker
			let image = drawer.draw()
			self.workItem = nil
			if !worker.isCancelled {
				DispatchQueue.main.async(execute: {
					
					self.imageview.image  = image
					self.imageview.startAnimating()
				})
			}
		}
		DispatchQueue.global(qos: .userInitiated).async(execute: workItem!)
	}
}

extension Dictionary {
	
	mutating func merge(with dictionary: Dictionary) {
		dictionary.forEach { updateValue($1, forKey: $0) }
	}
	
	func merged(with dictionary: Dictionary) -> Dictionary {
		var dict = self
		dict.merge(with: dictionary)
		return dict
	}
}
extension String {
	
	func drawVerticallyCentered(in rect: CGRect, withAttributes attributes: [NSAttributedStringKey : Any]? = nil) {
		let size = self.size(withAttributes: attributes)
		let centeredRect = CGRect(x: rect.origin.x, y: rect.origin.y + (rect.size.height-size.height)/2.0, width: rect.size.width, height: size.height)
		self.draw(in: centeredRect, withAttributes: attributes)
	}
	func drawCentered(in rect: CGRect, withAttributes attributes: [NSAttributedStringKey : Any]? = nil) {
		let size = self.size(withAttributes: attributes)
		let centeredRect = CGRect(x: rect.origin.x + (rect.size.width-size.width)/2.0, y: rect.origin.y + (rect.size.height-size.height)/2.0, width: size.width, height: size.height)
		self.draw(in: centeredRect, withAttributes: attributes)
	}
	func drawRight(in rect: CGRect, withAttributes attributes: [NSAttributedStringKey : Any]? = nil) {
		var paragraph : NSMutableParagraphStyle {
			get {
				let p = NSMutableParagraphStyle()
				p.alignment = .right
				p.lineHeightMultiple = 1.0
				//p.lineBreakMode = .byWordWrapping
				return p
			}
		}
		
		var attr : [NSAttributedStringKey : Any] = 	[NSAttributedStringKey.paragraphStyle:paragraph]
		if attributes != nil { attr.merge(with: attributes!) }
		//let size = self.size(withAttributes: attributes)
		//let rrect = CGRect(x: rect.origin.x + (rect.size.width-size.width)/2.0, y: rect.origin.y + (rect.size.height-size.height)/2.0, width: size.width, height: size.height)
		self.draw(in: rect, withAttributes: attr)
	}
}

class PiDrawer {
	
	var Direction : Int = 1
	private var rect : CGRect!
	private var tester : MathConstantTester!
	private var context : CGContext!
	private var drawnr : UInt64 = 0
	
	var bgcolor : UIColor? = nil
	var worker : DispatchWorkItem? = nil
	var emitdelegate : EmitImage? = nil
	var count = 100
	var ulammode = UlamType.square

	
	init(rect: CGRect, tester : MathConstantTester, nr : UInt64) {
		self.drawnr = nr
		self.rect = rect
		self.tester = tester
	}
	
	func draw() -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
		defer { UIGraphicsEndImageContext() }
		guard let context = UIGraphicsGetCurrentContext() else { return nil }
		if bgcolor != nil {
			bgcolor?.setFill()
			UIRectFill(rect)
		}
		self.context = context
		let count = 10
		let dx = rect.width / CGFloat(count)
		let dy = rect.height / CGFloat(count)
		guard let const = tester.getConstant(n: BigUInt(drawnr)) else { return nil}
		for i in 0..<count {
			for j in 0..<count {
				if worker?.isCancelled ?? false { return nil }
				context.setStrokeColor(UIColor.red.cgColor)
				context.setFillColor(UIColor.green.cgColor)
				context.setLineWidth(1.0);
				context.beginPath()
				
				var digit : Int {
					let n = i * count + j
					if n >= const.count {
						return 0
					} else {
						let c = String(Array(const)[n])
						return Int(c)!
					}
				}
				let hue = CGFloat(digit) / 10.0
				let color = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
				context.setStrokeColor(color.cgColor)
				context.setFillColor(color.cgColor)
				let x = CGFloat(j)*dx
				let y = CGFloat(i)*dy
				let r = CGRect(x: x, y: y, width: dx, height: dy)
				context.addEllipse(in: r)
				context.fillEllipse(in: r)
				let s = String(digit)
				let textcolor = UIColor.white
				textcolor.setStroke()
				s.drawCentered(in: r)
				
				context.strokePath()
				context.fillPath()
				guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
				emitdelegate?.Emit(image: image)
			}
		}
		
		let image = UIGraphicsGetImageFromCurrentImageContext()
		return image
	}
}

