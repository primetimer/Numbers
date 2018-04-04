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
	
	override func CreateImageDrawer(nr: UInt64, tester: NumTester?, worker: DispatchWorkItem?) -> ImageNrDrawer? {
		return FiboDrawer(nr: nr, tester: self.tester, emitter: self, worker: self.workItem)
	}
}

class FiboDrawer : ImageNrDrawer
{	
	private var pts : [(x:Double,y:Double)] = []
	private var nth = 0

	override init(nr : UInt64, tester : NumTester?, emitter : EmitImage?, worker: DispatchWorkItem?) {
		super.init(nr: nr, tester: tester, emitter: emitter, worker: worker)
		if tester is LucasTester {
			(astart,bstart) = (2,1)
		} else {
			(astart,bstart) = (1,1)
		}
		self.nth = Nth(nr: nr)
	}
	private var (astart,bstart) = (2,1)

	private func Fibo(nth: Int) -> Int {
		if nth <= 2 { return 1 }
		var (a,b) = (astart,bstart)
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
		
		var (a,b) = (astart,bstart)
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
	private func DrawNumber(context : CGContext)
	{
		let nth = Nth(nr: nr)
		let fendsum = Fibo(nth: nth) + Fibo(nth: nth-1)
		var f1 = CGFloat(bstart)
		var f0 = CGFloat(astart)
		var r1 = CGFloat(astart) * rect.width / CGFloat(fendsum) / 1.15

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
		
		var (x0,y0) = (x,y)
		var (x1,y1) = (x,y)
		var pts : [CGPoint] = []
		pts.append(CGPoint(x:x0,y:y0))
		
		var alpha = CGFloat(1.0)
		
		for i in 0..<nth {
			if worker?.isCancelled ?? false { return  }
			let r0 = r1
			let hue = CGFloat(i) / CGFloat(nth)
			let color = PColor(hue : CGFloat(hue), saturation : 1.0, brightness : 1.0, alpha : alpha)
			color.setFill()
			let drect = CGRect(x: x,y: y ,width: r0, height: r0)
			context.fill(drect)
			UIColor.white.setStroke()
			context.move(to: CGPoint(x:x0,y:y0))
			context.addLine(to: CGPoint(x:x1,y:y1))
			context.setLineWidth(2.0)
			context.strokePath()
			pts.append(CGPoint(x:x1,y:y1))
			
			let str = String(format: "%.0f",f0)
			str.drawCentered(in: drect)
			
			//Compute next coordinates
			r1 = f1 <= CGFloat(nr) ? r0 * f1/f0 : r0 * CGFloat(nr) / f0
			alpha = f1 <= CGFloat(nr) ? 1.0 : CGFloat(nr) / (f0+f1)
			(f1,f0) = (f0+f1,f1)
			switch orientation {
			case 0:
				x = x + r0
				y = y - r1 + r0
				(x0,y0) = (x+r1,y)
				(x1,y1) = (x,y+r1)
				orientation = 1
			case 1:	//Fuer 3-ten Durchlauf
				y = y - r1
				x = x - r1 + r0//Xende unverändert
				(x0,y0) = (x,y)
				(x1,y1) = (x+r1,y+r1)
				orientation = 2
			case 2: //Fuer 4-ten Durchlauf
				x = x - r1
				(x1,y1) = (x+r1,y)
				(x0,y0) = (x,y+r1)
				orientation = 3
			case 3:
				y = y + r0
				orientation = 0
				(x0,y0) = (x,y)
				(x1,y1) = (x+r1,y+r1)
			default:
				assert(false)
			}
			if emitter != nil {
				guard let newimage  = UIGraphicsGetImageFromCurrentImageContext() else { continue }
				emitter?.Emit(image: newimage)
			}
		}
	}
	
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
		DrawNumber(context : context)
		guard let newimage  = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
		emitter?.Emit(image: newimage)
		return newimage
	}
}





