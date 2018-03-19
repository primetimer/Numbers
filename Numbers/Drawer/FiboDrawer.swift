//
//  SquareDrawer.swift
//  Numbers
//
//  Created by Stephan Jancar on 15.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit

class FiboView : DrawNrView {

	init () {
		super.init(frame: CGRect.zero)
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/*
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		CreateImages()
	}
	
	
	private func CreateImages()  {
		let rect = CGRect(x: 0.0, y: 0.0, width: 400.0, height: 400.0)

		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		defer { UIGraphicsEndImageContext() }
		guard let context = UIGraphicsGetCurrentContext() else { return }
		context.setStrokeColor(UIColor.black.cgColor)
		context.setLineWidth(1.0);
		context.beginPath()
		let fibodraw = FiboDrawer(nr: self.nr, rect: rect)
		fibodraw.DrawNumber(context : context)
		if let newimage  = UIGraphicsGetImageFromCurrentImageContext() {
			Emit(image: newimage)
			imageview.image = newimage
		}

	}
	*/
	
	override func CreateImageDrawer(nr: UInt64, tester: NumTester?, worker: DispatchWorkItem?) -> ImageNrDrawer? {
		return FiboDrawer(nr: nr, tester: self.tester, emitter: self, worker: self.workItem)
	}
}

class FiboDrawer : ImageNrDrawer
{
	//enum fiboOrientation  { case left,top,right, bottom }
	//private var context : CGContext!
	//private var nr : UInt64 = 1
	//internal var rect : CGRect!
	//var rx : CGFloat = { return rect.width }()
	//binternal var ry : CGFloat = { return self.rect.height }()
	//private var sphere = SphereDrawer()
	
	private var pts : [(x:Double,y:Double)] = []
	private var nth = 0

	override init(nr : UInt64, tester : NumTester?, emitter : EmitImage?, worker: DispatchWorkItem?) {
		super.init(nr: nr, tester: tester, emitter: emitter, worker: worker)
		self.nth = Nth(nr: nr)
	}
	/*
	init(nr : UInt64, rect : CGRect) {
		super.init()
		self.nr = nr
		self.rect = rect
		self.rx = rect.maxX - rect.minX
		self.ry = rect.maxY - rect.minY
		
	}
	*/
	
	private func Fibo(nth: Int) -> Int {
		if nth <= 2 { return 1 }
		var (a,b) = (1,1)
		var c = 0
		for _ in 3...nth {
			c = a + b
			a = b
			b = c
		}
		return c
	}
	
	private func Nth(nr : UInt64) -> Int {
		if nr <= 1 { return 1 }
		var nth = 2
		var (a,b) = (1,1)
		while nr > b {
			let c = a + b
			a = b
			b = c
			nth = nth + 1
		}
		return nth
	}
	private func Radius() -> CGFloat
	{
		let r = sqrt(Double(nr))
		return rect.width / CGFloat(r)
	}
	func DrawPoint(xy: CGPoint, radius : CGFloat, hue : Double, context : CGContext) {
		
		let color = PColor(hue : CGFloat(hue), saturation : 1.0, brightness : 1.0, alpha : 1.0)
		color.setFill()
		context.fill(CGRect(x: xy.x,y: xy.y ,width: radius, height: radius))
		//sphere.drawSphere(context, xy: xy, r: CGFloat(radius) / 2.0, col: [color])
		//color.setStroke()
		//color.setFill()
	}
	
	#if true
	private func DrawNumber(context : CGContext)
	{
		let nth = Nth(nr: nr)
		let fend = Fibo(nth: nth+1)
		var f1 = CGFloat(1.0)
		var f0 = CGFloat(1.0)
		let phi = CGFloat(Double(f1) / Double(nr))

		//var w = rect.width / CGFloat(fend)
		//var h = rect.width / CGFloat(fend) / CGFloat(phi)
		var r1 = rect.width / CGFloat(fend) / 1.15

		var orientation = nth % 2
		var x : CGFloat = rect.width * 2 / 3
		var y : CGFloat = rect.height * 2 / 3
		switch nth % 4 {
		case 0, 3:
				x = rect.width * 2 / 3
				y = rect.height * 2 / 3

			case 1,2:
				x = rect.width * 1 / 3
				y = rect.height * 1 / 3
		default:
			assert(false)
		}
		
		for i in 0..<nth {
			let r0 = r1
			if worker?.isCancelled ?? false { return  }
			let hue = CGFloat(i) / CGFloat(nth) //: 1.0 -  CGFloat(i) / CGFloat(nth)
			let color = PColor(hue : CGFloat(hue), saturation : 1.0, brightness : 1.0, alpha : 1.0)
			color.setFill()
			let drect = CGRect(x: x,y: y ,width: r0, height: r0)
			context.fill(drect)
			UIColor.white.setStroke()
			
			let str = String(describing: f0)
			str.drawCentered(in: drect)
			
			//let f = f1 - f0
			r1 = r0 * f1/f0
			(f1,f0) = (f0+f1,f1)
			
			switch orientation {
			case 0:	//Fuer 2-temn Durchlauf
				x = x + r0
				y = y - r1 + r0
				orientation = 1
			case 1:	//Fuer 3-ten Durchlauf
				y = y - r1
				x = x - r1 + r0//Xende unverändert
				orientation = 2
			case 2: //Fuer 4-ten Durchlauf
				x = x - r1
				orientation = 3
			case 3:
				y = y + r0
				orientation = 0
			default:
				assert(false)
			}
			if emitter != nil {
				guard let newimage  = UIGraphicsGetImageFromCurrentImageContext() else { continue }
				emitter?.Emit(image: newimage)
			}
		}
		
	}
	#endif
	
	private func GetXY(_ i: Int, _ j : Int) -> CGPoint
	{
		let x = CGFloat(i) * Radius() + Radius() / 2.0
		let y = CGFloat(j) * Radius() + Radius() / 2.0
		return CGPoint(x: x, y: y)
	}
	
	override func DrawNrImage(rect: CGRect) -> UIImage? {
		_ = super.DrawNrImage(rect: rect)
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		defer { UIGraphicsEndImageContext() }
		guard let context = UIGraphicsGetCurrentContext() else { return nil }
		context.setStrokeColor(UIColor.black.cgColor)
		context.setLineWidth(1.0);
		context.beginPath()
		//let fibodraw = FiboDrawer(nr: self.nr, rect: rect)
		DrawNumber(context : context)
		guard let newimage  = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
		emitter?.Emit(image: newimage)
		return newimage
	}
}





