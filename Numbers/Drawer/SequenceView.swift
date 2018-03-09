//
//  UlamView.swift
//  PrimeTime
//
//  Created by Stephan Jancar on 03.04.16.
//  Copyright © 2016 esjot. All rights reserved.
//

import UIKit
import BigInt

protocol EmitImage {
	func Emit(image :UIImage )
}

class SequenceView : DrawNrView, EmitImage {
	func Emit(image: UIImage) {
		imageview.image = image
		imageview.animationImages?.append(image)
	}
	
	private var _needRecalc : Bool = true
	override var frame : CGRect {
		set {
			super.frame = newValue
			setNeedsDisplay()
		}
		get { return super.frame }
	}
	
	var tester : NumTester? = nil
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func SetNumber(_ nextnr : UInt64) {
		super.SetNumber(nextnr)
		self.start = nextnr
	}
	
	var start : UInt64 = 2 {
		didSet {
			if oldValue != start { _needRecalc = true }
		}
	}

	private var workItem : DispatchWorkItem? = nil
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		if tester == nil { return }
		self.imageview.animationImages = []
		self.imageview.animationDuration = 2.0
		self.imageview.animationRepeatCount = 0
		workItem?.cancel()
		self.workItem = DispatchWorkItem {
			guard let worker = self.workItem else { return }
			let seqdrawer = SequenceDrawer(rect: rect, tester: self.tester!, nr: self.start)
			seqdrawer.emitdelegate = self
			let image = seqdrawer.draw()
			if !worker.isCancelled {
				self.workItem = nil
				DispatchQueue.main.async(execute: {
					self.imageview.image  = image
					self.imageview.startAnimating()
				})
			}
		}
		DispatchQueue.global(qos: .userInitiated).async(execute: workItem!)
	}
}

class SequenceDrawer {
	
	var Direction : Int = 1
	private var rect : CGRect!
	private var drawer : UlamDrawer!
	private var tester : NumTester!
	private var context : CGContext!
	private var drawnr : UInt64 = 0
	
	var bgcolor : UIColor? = nil
	var worker : DispatchWorkItem? = nil
	var emitdelegate : EmitImage? = nil
	var count = 100
	var ulammode = UlamType.square
	
	init(rect: CGRect, tester : NumTester, nr : UInt64) {
		self.drawnr = nr
		self.rect = rect
		self.tester = tester
		drawer = CreateDrawer(rect)
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
		context.setStrokeColor(UIColor.red.cgColor)
		context.setLineWidth(1.0);
		context.beginPath()
		drawer.draw_spiral(context)
		DrawNumbers(since: 0)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		return image
	}
	
	private func CreateDrawer(_ rect : CGRect) -> UlamDrawer {
		let drawer = UlamDrawer(pointcount: self.count, utype: self.ulammode)
		drawer.colored = false
		drawer.bprimesphere = false
		drawer.direction = self.Direction
		drawer.bprimesizing = false
		drawer.overscan = 1.0
		drawer.setZoom(1.0)
		drawer.SetWidth(rect)
		drawer.pstart = drawnr
		return drawer
	}
	
	private func DrawNumbers(since : Int)
	{
		guard let tester = tester else { return }
		for k in since ..< count {
			if worker?.isCancelled ?? false {
				return
			}
			let j = k // count - 1 - k
			let nr =  Int(drawnr) + j * Direction 
			if nr < 0 { break }
			if !tester.isSpecial(n: BigUInt(nr)) { continue }
			drawer.draw_number(context, ulamindex: j, p: UInt64(nr))
			guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
			emitdelegate?.Emit(image: image)
		}
	}
}

