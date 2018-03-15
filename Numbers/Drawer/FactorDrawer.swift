//
//  FaktorDrawer.swift
//  PrimeTime
//
//  Created by Stephan Jancar on 06.08.16.
//  Copyright © 2016 esjot. All rights reserved.
//

import Foundation
import UIKit
import BigInt
import PrimeFactors


enum FaktorDrawType : Int {
	case circle = 0
	case tree   = 1
	case polygon = 2
	case ulam = 3
	//case lucky = 4
}

#if os(OSX)
	import Cocoa
	typealias PColor = NSColor
	typealias PBezierPath = NSBezierPath
	extension NSBezierPath {
		func addLineToPoint(_ pt : CGPoint) {
			self.line(to: pt)
		}
	}
#else
	import UIKit
	typealias PColor = UIColor
	typealias PBezierPath = UIBezierPath
#endif

class FaktorDrawerParam {
	
	var rect : CGRect! {
		didSet {
			
			let rx = rect.maxX - rect.minX
			let ry = rect.maxY - rect.minY
			radius = min(Double(rx),Double(ry))
			scalex = 1.0
			scaley = 1.0
		}
	}
	
	var imagenr : Int = 0		//Only for ulam
	var imagemax : Int = 0		//Only for ulam
	var withanimation = false
	var radius : Double = 1.0
	let pi = Double.pi
	var deltahue = 0.0
	var startTime: CFAbsoluteTime = 0.0
	var maxrekurs : UInt64 = 5
	var timeLimit = 0.0 // In Sekunden
	var rectLimit : UInt64 = 64  // Maxmimal zu zeichnendes Rechteck
	var scaley : CGFloat = 1.0
	var scalex : CGFloat = 1.0
	var ulamzoom : CGFloat = 1.0
	
	var bfactorback = false // false
	var bfactormultiple = true
	private var _factor : [UInt64] = [2]
	private var _nr : UInt64 = 2
	private var _count = 1
	
	var nr : UInt64 {
		set {
			_nr = newValue
			let factors = FactorCache.shared.Factor(p: BigUInt(newValue))
			_factor = []
			for f in factors {
				_factor.append(UInt64(f))
			}
			_count  = _factor.count
		}
		get { return _nr }
	}
	
	func PowerOf(_ teiler : UInt64) -> UInt64 {
		if _count == 0     { return 1 }
		//if (!bfactormultiple) { return 1 }
		var power = 0
		for i in 0..<_count {
			if _factor[i] == teiler { power = power + 1 }
		}
		return UInt64(power)
	}
	
	func HueRange(_ rekurs : Int) -> CGFloat {
		let prod = Product(rekurs)
		let hue = Double(prod) * deltahue
		return CGFloat(hue)
	}
	
	//Product ab diesem Teiler
	func Product(_ rekurs : Int) -> UInt64 {
		var prod : UInt64 = 1
		var index = rekurs
		while true {
			index = index + 1
			let teiler = Divisor(index-1)
			if teiler == 0 { return UInt64(prod) }
			prod = prod * teiler
		}
	}
	
	func Divisor(_ rekurs : Int) -> UInt64 { // 0 if at end
		
		if _count == 0 { return 0 }
		var lastteiler : UInt64 = 1
		if bfactormultiple {
			let j = (!bfactorback) ? rekurs : _count-1-rekurs
			if j<0       { return 0 }
			if j>=_count { return 0 }
			let teiler = _factor[j]
			return teiler
		}
		var i = 0
		var index = 0
		while true {
			let j = (!bfactorback) ? i : _count-1-i
			if j<0      { return 0 }
			if j>=_count { return 0 }
			let teiler = _factor[j]
			i = i + 1
			if teiler == lastteiler { continue }
			if index>=rekurs { return teiler }
			index = index + 1
			
			lastteiler = teiler
		}
	}
	
	fileprivate func DrawLimit(_ rekurs : UInt64) -> Bool
	{
		if (rekurs >= maxrekurs) { return true }
		if Divisor(Int(rekurs)) == 0 { return true }
		//let warning = true
		//return false
		let seconds = CFAbsoluteTimeGetCurrent() - startTime
		if (seconds > 5)
		{
			return true
		}
		if (timeLimit > 0.0) && (seconds > timeLimit)
		{
			return true
		}
		return false
	}
	
	private var _type : FaktorDrawType = .polygon //.tree // .circle
	
	var type : FaktorDrawType {
		set {
			if newValue != _type {
				_type = newValue
			}
		}
		get {
			return _type
		}
	}
	
	func CreateDrawer(_ rect : CGRect) -> FaktorDrawer {
		switch (type) {
		case .circle:
			return FaktorDrawerCircle(param: self, rect: rect)
		case .tree:
			return FaktorDrawerTree(param: self, rect: rect)
		case .polygon:
			return FaktorDrawerPolygon(param: self, rect: rect)
		case .ulam:
			return FaktorDrawerUlam(param: self, rect: rect)
			//case .lucky:
			//	return FaktorDrawerLuckyUlam(param: self, rect: rect)
		}
	}
}

class FaktorDrawer : NSObject
{
	var param : FaktorDrawerParam!
	fileprivate var context : CGContext!
	
	init(param : FaktorDrawerParam, rect : CGRect) {
		super.init()
		self.param = param
		self.param.rect = rect
	}
	
	func CalcRekursLevel() -> Int{
		param.maxrekurs = 0		
		var index = 0
		var testpixel : UInt64 = 1
		var maxpixel = (param.rect.maxX - param.rect.minX) * (param.rect.maxY - param.rect.minY)
		maxpixel = maxpixel / 100
		while true {
			let teiler = DMax(index)
			if teiler == 0 { break }
			testpixel = testpixel * teiler
			if CGFloat(testpixel) > maxpixel { break }
			if CGFloat(testpixel) > 10000 { break }
			param.maxrekurs = param.maxrekurs + 1
			index = index + 1
		}
		//param.maxrekurs = max(1, param.maxrekurs)
		return Int(param.maxrekurs)
	}
	
	fileprivate func CalcDeltaHue() {
		param.deltahue = 0.66667
		var index = 0
		while true {
			let divisor = param.Divisor(index)
			if divisor == 0 { break }
			param.deltahue = param.deltahue / Double(divisor)
			index = index + 1
		}
		
	}
	
	func Radius(_ rekurs : Int) -> Double
	{
		var r = param.radius / 2.0
		if rekurs == 0 { return r }
		for _ in 0..<rekurs {
			r = r / 2.0
		}
		return r
	}
	
	func drawFaktor (_ rect : CGRect, context : CGContext) {
		
		param.startTime = CFAbsoluteTimeGetCurrent()
		param.rect = rect
		self.context = context
		CalcDeltaHue()
		
		let rx = rect.maxX - rect.minX
		let ry = rect.maxY - rect.minY
		let x = Double(rect.minX + rx / 2.0)
		let y = Double(rect.minY + ry / 2.0)
		
		DrawNumber(0, xpos: x, ypos: y, angle: 0.0, hue: 0.0)
		
		context.fillPath()
		context.strokePath()
	}
	fileprivate func GetXY(_ i: UInt64, teiler : UInt64, xpos: Double, ypos: Double, r : Double, angle : Double) -> [Double]
	{
		let theta = Double(i) / Double(teiler) * 2.0 * Double.pi + angle
		let x = r * cos(theta + angle) + xpos
		let y = r * sin(theta + angle) + ypos
		return [x,y]
		
	}
	
	fileprivate func DMax(_ rekurs : Int) -> UInt64
	{
		let teiler = param.Divisor(rekurs)
		return min(teiler,param.rectLimit)
	}
	
	func DrawPoint(_ rekurs : Int , xpos : Double,ypos : Double, radius : Double, hue : Double) {
		let color = PColor(hue : CGFloat(hue), saturation : 1.0, brightness : 1.0, alpha : 1.0)
		color.setStroke()
		color.setFill()
	}
	func DrawPrimeNumber(_ rekurs : Int, xpos : Double, ypos: Double, angle : Double, hue : Double)
	{
		let r = Radius(rekurs)
		let hrange = Double(param.HueRange(rekurs))
		let teiler1 = DMax(rekurs)
		if teiler1 == 0 { return }
		for i in 1...teiler1 {
			let h = hue + (Double(i)-1) / Double(teiler1) * hrange
			let pos = GetXY(i,teiler: teiler1,xpos: xpos,ypos: ypos,r: r,angle: angle)
			let pointr = Radius(rekurs)
			DrawPoint(rekurs, xpos: pos[0],ypos: pos[1],radius: pointr, hue : h)
		}
	}
	
	func DrawNumber(_ rekurs : Int, xpos : Double, ypos: Double, angle : Double, hue : Double)
	{
		let teiler1 = DMax(rekurs)
		let teiler2 = DMax(rekurs + 1)
		let huerange = Double(param.HueRange(rekurs))
		let r = Radius(rekurs)
		let blimit = param.DrawLimit(UInt64(rekurs))
		if (teiler2 == 0) || blimit || (r<1.0) {
			DrawPrimeNumber(rekurs, xpos: xpos, ypos: ypos, angle: angle, hue: hue)
			return
		}
		
		
		let a = angle
		for i in 1...teiler1 {
			let h = hue + (Double(i)-1) / (Double(teiler1)) * huerange
			let pos = GetXY(i,teiler: teiler1,xpos: xpos,ypos: ypos,r: r,angle: angle)
			DrawNumber(rekurs + 1, xpos: pos[0],ypos: pos[1],angle: a, hue: h)
		}
	}
}

class FaktorDrawerCircle : FaktorDrawer {
	
	
	override func Radius(_ rekurs : Int) -> Double {
		
		var r = param.radius / 4.0
		if rekurs == 0 { return r }
		for i in 0..<rekurs {
			let Divisor = DMax(i)
			//let t = tan (M_PI / Double(Divisor))
			let s = sin(Double.pi / Double(Divisor))
			r = r / 2.0 * s
		}
		return r
	}
	
	override func drawFaktor (_ rect : CGRect, context : CGContext)
	{
		super.drawFaktor(rect, context: context)
	}
	
	
	override func DrawPoint(_ rekurs: Int, xpos : Double,ypos : Double, radius : Double, hue : Double) {
		super.DrawPoint(rekurs, xpos: xpos, ypos: ypos, radius: radius, hue: hue)
		let r = max(radius,1.0)
		let rectangle = CGRect( x: CGFloat(xpos-r) * param.scalex, y: CGFloat(ypos-r) * param.scaley,
								width: CGFloat(2.0*r) * param.scalex , height: CGFloat(2.0*r) * param.scaley)
		let teiler = DMax(rekurs)
		context.fillEllipse(in: rectangle)
		if teiler <= 3 {
			PColor.black.setStroke()
			context.strokeEllipse(in: rectangle)
		}
		
		(context).fillPath()
		context.strokePath()
	}
	
	override func DrawNumber(_ rekurs: Int, xpos: Double, ypos: Double, angle: Double, hue: Double) {
		let t = param.Divisor(rekurs)
		var a = angle
		let p = param.PowerOf(t)
		if p > 1 { a = a + Double.pi / 4.0 }
		super.DrawNumber(rekurs, xpos: xpos, ypos: ypos, angle: a, hue: hue)
	}
	
}

class FaktorDrawerTree : FaktorDrawer {
	
	override func Radius(_ rekurs : Int) -> Double {
		
		return super.Radius(rekurs) / 2.0
	}
	
	override func drawFaktor (_ rect : CGRect, context : CGContext)
	{
		super.drawFaktor(rect, context: context)
	}
	
	override func CalcRekursLevel() -> Int {
		_ = super.CalcRekursLevel()
		param.maxrekurs = param.maxrekurs + 1
		return Int(param.maxrekurs)
	}
	
	override func DrawPoint(_ rekurs: Int , xpos : Double,ypos : Double, radius : Double, hue : Double) {
		super.DrawPoint(rekurs, xpos: xpos, ypos: ypos, radius: radius, hue: hue)
		let r = Radius(rekurs) / 2.0
		let sphere = SphereDrawer()
		let huerange = param.HueRange(rekurs)
		let col1 = PColor(hue: CGFloat(hue), saturation: 1.0, brightness: 1.0, alpha: 1.0)
		let col2 = PColor(hue: CGFloat(hue) + huerange, saturation: 1.0, brightness: 1.0, alpha: 1.0)
		let col = [col1,col2]
		let xy = CGPoint(x: CGFloat(xpos),y: CGFloat(ypos))
		sphere.drawSphere(context, xy: xy, r: CGFloat(r), col: col)
	}
	
	override func GetXY(_ i: UInt64, teiler : UInt64, xpos: Double, ypos: Double, r : Double, angle : Double) -> [Double]
	{
		let theta = Double(2*i+1) / Double(2*teiler) * Double.pi + angle
		let x = r * cos(theta + angle) + xpos
		let y = -r * sin(theta + angle) + ypos
		return [x,y]
		
	}
	
	override func DrawNumber(_ rekurs: Int, xpos: Double, ypos: Double, angle: Double, hue: Double) {
		
		let teiler1 = DMax(rekurs)
		//let teiler2 = DMax(rekurs + 1)
		let huerange = Double(param.HueRange(rekurs))
		let r = Radius(rekurs)
		let blimit = param.DrawLimit(UInt64(rekurs))
		if  blimit || (r<1.0) { return }
		
		let divisor = param.Divisor(rekurs)
		if divisor > teiler1 {
			DrawPoint(rekurs, xpos: xpos, ypos: ypos, radius: r, hue: hue)
			DrawNumber(rekurs + 1, xpos: xpos, ypos: ypos, angle: angle, hue: hue + huerange)
			return
		}
		
		for i in 0..<teiler1
		{
			let h = hue + huerange * Double(i) / Double(teiler1)
			param.scalex = 1.0
			param.scaley = 1.0
			context.move(to: CGPoint(x: CGFloat(xpos) * param.scalex, y: CGFloat(ypos) * param.scaley))
			let xy = GetXY(i, teiler: teiler1, xpos: xpos, ypos: ypos, r: r, angle: angle)
			//print(xpos,ypos,xy[0],xy[1],angle)
			
			let color = PColor(hue: CGFloat(h),saturation: 1.0,brightness: 1.0,                                        alpha: 1.0)
			color.setStroke()
			context.addLine(to: CGPoint(x: CGFloat(xy[0]) * param.scalex, y: CGFloat(xy[1]) * param.scaley))
			context.setLineWidth(1.0)
			context.strokePath()
			
			let da =  (Double(2*i)-Double(teiler1-1)) / Double(teiler1-1) * Double.pi / 4.0  // -0.5 / 2
			
			DrawNumber(rekurs+1, xpos: xy[0], ypos:xy[1] , angle: angle + da, hue: h)
		}
	}
}

class FaktorDrawerPolygon : FaktorDrawer {
	
	override func Radius(_ rekurs : Int) -> Double {
		return super.Radius(rekurs) / 2.0
	}
	
	override func DrawPoint(_ rekurs: Int, xpos : Double,ypos : Double, radius : Double, hue : Double) {
		super.DrawPoint(rekurs, xpos: xpos, ypos: ypos, radius: radius, hue: hue)
	}
	
	override func DrawNumber(_ rekurs: Int, xpos: Double, ypos: Double, angle: Double, hue: Double) {
		
		let t = param.Divisor(rekurs)
		var a = angle
		let p = param.PowerOf(t)
		let blimit = param.DrawLimit(UInt64(rekurs))
		if p > 1 { a = a + Double.pi / 4 }
		if !blimit {
			super.DrawNumber(rekurs, xpos: xpos, ypos: ypos, angle: a, hue: hue)
		}
		
		let d = DMax(rekurs)
		let r = Radius(rekurs) / 2.0
		
		
		//Linienzug
		let color = PColor(hue: CGFloat(hue),saturation: 1.0,brightness: 1.0,alpha: 0.8)
		color.setStroke()
		color.setFill()
		
		context.saveGState()
		let huerange = param.HueRange(rekurs)
		let colorend = PColor(hue: CGFloat(hue) + CGFloat(huerange), saturation : 1.0, brightness : 1.0, alpha: 1.0)
		let colorspace = CGColorSpaceCreateDeviceRGB()
		let locations: [CGFloat] = [0.0, 1.0]
		let colarr = [color.cgColor, colorend.cgColor]
		let gradient = CGGradient(colorsSpace: colorspace,colors: colarr as CFArray, locations: locations)
		
		let path = PBezierPath()
		path.lineWidth = CGFloat(p)
		for i in 0...d {
			let xy = GetXY(i, teiler: d, xpos: xpos, ypos: ypos, r: r, angle: a)
			let pt = CGPoint(x: xy[0], y: xy[1])
			if i==0 {
				path.move(to: pt)
			}
			else {
				path.addLine(to: pt)
			}
		}
		if d>2 {
			path.fill()
		} else {
			path.stroke()
		}
		path.addClip()
		let rect = path.bounds
		
		context.drawLinearGradient(gradient!, start: CGPoint(x: rect.midX, y: rect.minY), end: CGPoint(x: rect.midX, y: rect.maxY), options: CGGradientDrawingOptions(rawValue: 0))
		context.restoreGState()
		
	}
}


