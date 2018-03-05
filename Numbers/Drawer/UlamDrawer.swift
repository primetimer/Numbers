//
//  UlamDrawer.swift
//  PrimeTime
//
//  Created by Stephan Jancar on 16.04.16.
//  Copyright © 2016 esjot. All rights reserved.
//

import Foundation
import UIKit
import BigInt
import PrimeFactors

class UlamDrawer:  NSObject {
	
	var scalex = CGFloat(1.0)
	var scaley = CGFloat(1.0)
	private var _overscan : CGFloat = 1.0
	private var pointscale = CGFloat(0.75)

	var overscan : CGFloat {
		set {
			pointscale = pointscale / _overscan
			_overscan = newValue
			pointscale = pointscale * overscan
		}
		get { return _overscan }
	}
	
	private let pi = Double.pi
	private let phi = Double(sqrt(5.0) + 1.0 ) / 2.0
	
	fileprivate var size : CGFloat = 100.0
	var count : Int = 1
	var countbase : Int = 1
	
	var bsemiprimes = false
	var bprimesizing = false
	var bprimesphere = false
	var colored = false
	var ptspiral : TheUlamBase? = nil
	var rmax : Double =  1.0
	var offset = 0
	var bdrawspiral = false
	fileprivate var zoom : CGFloat = 1.0
	fileprivate var _pointwidth : CGFloat = 2.0
	fileprivate var pointwidth : CGFloat {
		set { _pointwidth = newValue }
		get { return max(_pointwidth,2.0) }
	}
	fileprivate var utype = UlamType.square
	fileprivate var _pstart : UInt64 = 2
	var pstart : UInt64  {
		set {
			_pstart = newValue
		}
		get { return _pstart }
	}
	var direction : Int = 1
	
	init (pointcount : Int, utype : UlamType) {
		super.init()
		self.utype = utype
		count = max(pointcount,2)
		
		countbase = count
		
		switch utype {
		case .square:
			ptspiral = theulamrect
		case .spiral:
			ptspiral = theulamspiral
		case .fibonacci:
			ptspiral = theulamexplode
		case .hexagon:
			ptspiral = theulamhexagon
		}
		//count = min(count,TheUlamBase.defcount)
	}
	
	internal func getColor(_ p : UInt64) -> UIColor?
	{
		if PrimeCache.shared.IsPrime(p: BigUInt(p)) {
			return .red
		}
		return .green
		/*
		if colored {
			let prev = p.PrevPrime()
			let next = prev.NextPrime()
			let hue = CGFloat(p.p-prev.p) / max(1.0,CGFloat(next.p-prev.p))
			let col = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
			return col
			
		}
		return UIColor.red
		*/
	}
	
	private func getPointSize(_ p: UInt64) -> CGFloat
	{
		return pointwidth
		/*
		if !bprimesizing { return pointwidth }
		if p.isPrime { return pointwidth }
		
		let pf = PFactor(x: p.p)
		let tau = pf.Tau()
		//assert (tau>2.0)
		let tauscale = CGFloat(log(tau) / log(2))
		//let count = CGFloat(pf.CountFaktor())
		let size = pointwidth / max(tauscale,1.0) * 2.0
		
		return max(size,1.0)
		*/
	}
	
	
	
	func setZoom(_ newzoom : CGFloat) //,  absolute : Bool = false)
	{
		zoom = zoom * newzoom
		//if (zoom < 0.1) { zoom = 1.0}
		count = Int(CGFloat(countbase) / zoom / zoom)
		pointwidth = size / sqrt(CGFloat(count)) * pointscale
		bdrawspiral = (count < 4000)
	}
	
	func SetWidth(_ rect: CGRect) {
		let w = rect.size.width
		let h = rect.size.height
		size = min(w,h)
		if (w<h) {
			scaley = h / w
			scalex = 1.0
		} else {
			scalex = w / h
			scaley = 1.0//###
		}
		pointwidth = size / sqrt(CGFloat(count)) * pointscale
		rmax = ptspiral!.Radius(count)
	}
	
	func getScreenXY(_ nr : Float) -> CGPoint {
		
		let spiral = getPoint(nr)
		let xp = CGFloat(spiral.x)
		let yp = CGFloat(spiral.y)
		let rm = rmax / Double(overscan)
		
		if (utype == .fibonacci)
		{
			var dtheta : Double = 2.0 * pi / phi / phi
			if direction < 0 { dtheta = -dtheta }
			let t = -dtheta * (Double(pstart*1) + Double(nr*0.0))
			let t1 = floor(t / 2.0 / pi)
			let t2 = t / 2.0 / pi - t1
			let theta = CGFloat(t2 * 2.0 * pi)
			
			let xp1 = xp * cos(theta) - yp * sin(theta)
			let yp1 = yp * cos(theta) + xp * sin(theta)
			let x = (xp1+CGFloat(rm)) * size / CGFloat(2*rm)
			let y = (yp1+CGFloat(rm)) * size / CGFloat(2*rm)
			
			return CGPoint(x: CGFloat(x*scalex), y: CGFloat(y*scaley))
		}
		
		let x = (xp+1.0*CGFloat(rm)) * size / CGFloat(2.0*rm)
		let y = (yp+1.0*CGFloat(rm)) * size / CGFloat(2.0*rm)
		return CGPoint(x: CGFloat(x*scalex), y: CGFloat(y*scaley))
	}
	
	func prime_color(_ p : UInt64) -> CGColor {
		return UIColor.red.cgColor
	}
	
	fileprivate func getPoint(_ x : Float) -> SpiralXY {
		return ptspiral!.getPoint(Int(x))
	}
	
	func draw_spiral(_ context : CGContext) -> Void {
		
		if count > TheUlamBase.defcount || colored  {
			bdrawspiral = false
		}
		if !bdrawspiral {
			return
		}
		
		if (utype == UlamType.fibonacci) {
			
			for j in 0...count-1  {
				
				let screenpt = getScreenXY(Float(j))
				switch j % 3
				{
				case 0:
					let color = UIColor(red: 153.0 / 250.0, green: 101.0 / 255.0, blue: 21.0 / 255.0, alpha: 1.0)
					//UIColor.blackColor()
					color.setFill()
				case 1:
					let color = UIColor.brown
					color.setFill()
				default:
					let color = UIColor.darkGray
					color.setFill()
				}
				
				let xw = pointwidth * scalex / 3.0 * pointscale
				let yw = pointwidth * scaley / 3.0 * pointscale
				
				
				context.fill(CGRect(x: screenpt.x,y: screenpt.y,width: xw,height: yw));
			}
			
			//CGContextAddPath(context, path.CGPath)
			context.strokePath()
			return
		}
		
		if count > 0 {
			for j in 1...count  {
				let screenpt = getScreenXY(Float(j))
				let screenprev = getScreenXY(Float(j-1))
				context.move(to: CGPoint(x: screenprev.x, y: screenprev.y))
				context.addLine(to: CGPoint(x: screenpt.x, y: screenpt.y))
				context.strokePath()
			}
		}
		context.strokePath()
	}
	
	
	private func drawSphere(_ context : CGContext, xy: CGPoint, p : UInt64 )
	{
		let r = getPointSize(p)
		var startPoint = CGPoint()
		startPoint.x = xy.x - r * 0.5
		startPoint.y = xy.y - r * 0.5
		var endPoint = CGPoint()
		endPoint.x = startPoint.x - r * 0.0
		endPoint.y = startPoint.y - r * 0.0
		let startRadius: CGFloat = 0
		let color = getColor(p)
		if color == nil { return }
		let colors = [UIColor.white.cgColor,color!.cgColor]
		let colorspace = CGColorSpaceCreateDeviceRGB()
		let locations: [CGFloat] = [0.0, 1.0]
		let gradient = CGGradient(colorsSpace: colorspace,colors: colors as CFArray, locations: locations)
		let endRadius : CGFloat = max(1.0,r )
		
		context.drawRadialGradient (gradient!, startCenter: xy,
									startRadius: startRadius, endCenter: endPoint, endRadius: endRadius,
									options: CGGradientDrawingOptions(rawValue: 0))
	}
	
	private func drawRect(_ context : CGContext, xy: CGPoint, p : UInt64 )
	{
		let r = getPointSize(p)
		var startPoint = CGPoint()
		startPoint.x = xy.x - r * 0.125
		startPoint.y = xy.y - r * 0.125
		let color = getColor(p)
		if color == nil { return }
		let rect = CGRect(x: startPoint.x,y: startPoint.y ,width: r * scalex , height: r)
		
		color?.setFill()
		context.fill(rect)
		if count < 200 && p <= 100  {
			let textcolor = UIColor.white
			textcolor.setStroke()
			let text = String(p)
			text.draw(in: rect, withAttributes: nil)
		}
	}
	
	func draw_number(_ context : CGContext, ulamindex : Int, p: UInt64) {
		
		let screenpt = getScreenXY(Float(ulamindex))
		let xstart = screenpt.x - pointwidth * scalex * pointscale / 2.0
		let ystart = screenpt.y - pointwidth * scaley * pointscale / 2.0
		
		let xy = CGPoint(x: xstart, y: ystart)
		if bprimesphere {
			drawSphere(context,xy: xy, p: p)
		} else {
			drawRect(context, xy: xy, p: p)
		}
	}
	
	func draw_primes(_ context: CGContext!, k0 : Int = 0, tlimit : CFTimeInterval = 5.0) -> Int
	{
		let starttime = CFAbsoluteTimeGetCurrent()
		let kstart = k0
		for k in kstart..<count
		{
			let deltatime = CFAbsoluteTimeGetCurrent() - starttime
			if (tlimit>0) && (deltatime > tlimit) { return k }
			let j = count - 1 - k
			if (direction < 0) && (pstart <=  UInt64(j+1))  { continue }
			let nr : UInt64 = UInt64( Int (pstart) + j * direction)
			let p = nr //PNumber(x: nr)
			if colored {
				draw_number(context, ulamindex: j, p: p)
				continue
			}
			if p.isPrime {
				draw_number(context, ulamindex: j, p: p)
				continue
			}
			/*
			if bsemiprimes {
				let c = CoupleNumber(x: nr)
				if c.iscouple {
					draw_number(context,ulamindex: j,p: p);
				}
			}
			*/
		}
		return 0
	}
}

