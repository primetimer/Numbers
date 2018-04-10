//
//  SquareDrawer.swift
//  Numbers
//
//  Created by Stephan Jancar on 15.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit

class PolygonalView : DrawNrImageView {
	
	private var poly : Int = 4
	init (poly : Int) {
		super.init(frame: CGRect.zero)
		self.poly = poly
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		CreateImages()
	}
	
	private func CreateImages()  {
		let rect = CGRect(x: 0.0, y: 0.0, width: 400.0, height: 400.0)
		//var images : [UIImage] = []
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		defer { UIGraphicsEndImageContext() }
		guard let context = UIGraphicsGetCurrentContext() else { return }
		
		context.setStrokeColor(UIColor.black.cgColor)
		context.setLineWidth(1.0);
		context.beginPath()
		let pentagon = PolygonDrawer(nr: self.nr, poly: poly, rect: rect)
		pentagon.DrawNumber(context : context)
		let newimage  = UIGraphicsGetImageFromCurrentImageContext()
		imageview.image = newimage
	}
}

class PolygonDrawer : NSObject
{
	private var context : CGContext!
	private var nr : UInt64 = 1
	internal var rect : CGRect!
	internal var rx : CGFloat = 0
	internal var ry : CGFloat = 0
	private var sphere = SphereDrawer()
	
	private var pts : [(x:Double,y:Double)] = []
	private var _polyn = 0
	private var nth = 0
	private var secant : Double = 0.0
	private var polyn : Int {
		set {
			if _polyn == newValue { return }
			_polyn = newValue
			pts = []
			if _polyn <= 1 { return }
			let theta = Double.pi * 2.0 / Double(_polyn)
			for i in 0..._polyn {
				let x = sin(Double(i) * theta)
				let y = -cos(Double(i) * theta)
				pts.append((x:x, y: y))
			}
			let dx = pts[1].x-pts[0].x
			let dy = pts[1].y-pts[0].y
			self.secant = sqrt(dx*dx+dy*dy)
		}
		get { return _polyn }
	}
	
	init(nr : UInt64, poly: Int, rect : CGRect) {
		super.init()
		self.nr = nr
		self.rect = rect
		self.rx = rect.maxX - rect.minX
		self.ry = rect.maxY - rect.minY
		self.polyn = poly
		self.nth = Nth(nr: nr)
	}
	
	private func Count(nth: Int) -> Int {
		let c = nth * ((polyn - 2) * nth - ( polyn - 4)) / 2
		return c
	}
	
	private func Nth(nr : UInt64) -> Int {
		var n = 0
		repeat {
			let c = Count(nth: n)
			if c >= nr {
				return n
			}
			n = n + 1
		} while n<100
		return n
	}
	private func Radius() -> CGFloat
	{
		let r = sqrt(Double(nr))
		return rx / CGFloat(r)
	}
	func DrawPoint(xy: CGPoint, radius : CGFloat, hue : Double) {
		let color = PColor(hue : CGFloat(hue), saturation : 1.0, brightness : 1.0, alpha : 0.5)
		sphere.drawSphere(context, xy: xy, r: CGFloat(radius) / 2.0, col: [color])
		color.setStroke()
		color.setFill()
	}
	private func GetXYPoly(n: Int, ticks: Int , tickscale : Int) -> CGPoint
	{
		if ticks == 0 {
			let (x0,y0) = (pts[0].x,pts[0].y)
			let xx = self.rx / 2.0 * CGFloat(x0+0) + self.rx / 2.0
			let yy =  self.ry / 2.0 * CGFloat(y0+0) + self.ry / 2.0
			let xxx = (xx - rx / 2.0) * CGFloat(ticks) / CGFloat(tickscale) + rx / 2.0
			let yyy = yy * CGFloat(ticks) / CGFloat(tickscale)
			return CGPoint(x: xxx, y: yyy)
		} else {
			let m = n / ticks   //Nummer der Kante
			let tick = n % ticks
			let (x0,y0) = (pts[m].x,pts[m].y)
			let (x1,y1) = (pts[m+1].x,pts[m+1].y)
			let dx = (x1 - x0) / Double(ticks) * Double(tick)
			let dy = (y1 - y0) / Double(ticks) * Double(tick)
		
			let xx = self.rx / 2.0 * CGFloat(x0+dx) + self.rx / 2.0
			let yy =  self.ry / 2.0 * CGFloat(y0+dy) + self.ry / 2.0
		
			//Translate
			let xxx = (xx - rx / 2.0) * CGFloat(ticks) / CGFloat(tickscale) + rx / 2.0
			let yyy = yy * CGFloat(ticks) / CGFloat(tickscale)
			return CGPoint(x: xxx, y: yyy)
		}
	}
	
	func DrawNumber(context : CGContext)
	{
		self.context = context
		let maxk = nth-1
		if maxk<=0 { return }
		#if true
			var drawcount = 1
			let radius = CGFloat(secant) * rx / 2.0 / CGFloat(maxk) * CGFloat(maxk) / CGFloat(maxk+1)
			for l in 0...maxk {
				let k = l //maxk - l
				let hue = Double(k-1) / Double(maxk)
				if k == 0 {
					let pt = GetXYPoly(n:0, ticks: k, tickscale: maxk+1)
					let pt2 = CGPoint(x: pt.x, y: pt.y + radius * 3 / 4)
					DrawPoint(xy: pt2, radius: radius, hue: hue)
					continue
				}
				for n in  stride(from: k, through: (polyn-1)*k, by: 1)
				{
					if drawcount >= nr { break }
					drawcount = drawcount + 1
					let pt = GetXYPoly(n:n, ticks: k, tickscale: maxk+1)
					let pt2 = CGPoint(x: pt.x, y: pt.y + radius * 3 / 4)
					DrawPoint(xy: pt2, radius: radius, hue: hue)
					
					
				}
			}
		#else
			for l in 0...maxk {
				let k = maxk - l
				let hue = Double(k-1) / Double(maxk)
				for j in 0..<polyn*k
				{
					let n = j
					let pt = GetXYPoly(n:n, ticks: k, tickscale: maxk+1)
					let radius = CGFloat(secant) * rx / 2.0 / CGFloat(maxk) * CGFloat(maxk) / CGFloat(maxk+1)
					let pt2 = CGPoint(x: pt.x, y: pt.y + radius * 3 / 4)
					DrawPoint(xy: pt2, radius: radius, hue: hue)
				}
			}
		#endif
		return
	}
	
	private func GetXY(_ i: Int, _ j : Int) -> CGPoint
	{
		let x = CGFloat(i) * Radius() + Radius() / 2.0
		let y = CGFloat(j) * Radius() + Radius() / 2.0
		return CGPoint(x: x, y: y)
	}
}





