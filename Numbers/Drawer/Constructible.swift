//
//  UlamView.swift
//  PrimeTime
//
//  Created by Stephan Jancar on 03.04.16.
//  Copyright © 2016 esjot. All rights reserved.
//


//https://www.whitman.edu/Documents/Academics/Mathematics/Kuh.pdf
import UIKit
import BigInt

class ConstructibleView : DrawNrView, EmitImage {
	func Emit(image: UIImage) {
		DispatchQueue.main.async(execute: {
			self.imageview.image  = image
			self.imageview.animationImages?.append(image)
			self.imageview.startAnimating()
		})
	}
	
	override var frame : CGRect {
		set {
			super.frame = newValue
			setNeedsDisplay()
		}
		get { return super.frame }
	}
	
	private var tester = ConstructibleTester()
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
	
	private var start : UInt64 = 2
	
	private var workItem : DispatchWorkItem? = nil
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		
		self.imageview.animationImages = []
		self.imageview.image = nil
		self.imageview.animationDuration = 60.0
		self.imageview.animationRepeatCount = 0
		workItem?.cancel()
		self.workItem = DispatchWorkItem {
			guard let worker = self.workItem else { return }
			let drawer = ConstructibleDrawer(rect: rect, tester: self.tester, nr: self.start)
			drawer.emitdelegate = self
			let image = drawer.draw()
			if !worker.isCancelled {
				self.workItem = nil
				DispatchQueue.main.async(execute: {
					self.imageview.image  = image
					self.imageview.animationDuration = TimeInterval(self.imageview.animationImages?.count ?? 0)
					self.imageview.startAnimating()
				})
			}
		}
		DispatchQueue.global(qos: .userInitiated).async(execute: workItem!)
	}
}

class ConstructibleDrawer {
	
	var Direction : Int = 1
	private var rect : CGRect!
	
	private var tester : ConstructibleTester!
	private var context : CGContext!
	private var drawnr : UInt64 = 0
	
	var bgcolor : UIColor? = nil
	var worker : DispatchWorkItem? = nil
	var emitdelegate : EmitImage? = nil
	var count = 100
	var ulammode = UlamType.square
	
	init(rect: CGRect, tester : ConstructibleTester, nr : UInt64) {
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
		do {
			
			//context.setStrokeColor(UIColor.red.cgColor)
			//context.setFillColor(UIColor.green.cgColor)
			context.setLineWidth(2.0);
			context.beginPath()
			let a = CGPoint(x: 160,y:rect.height * 0.7)
			let b = CGPoint(x: 240,y:rect.height * 0.7)
			//for step in 1...10 {
			var ngon : [CGPoint] = []
			
			
			var nr = drawnr
			if drawnr % 3 == 0 {
				ngon = Triangle(a: a, b: b)
				nr = nr / 3
			} else if drawnr % 5 == 0 {
				ngon = Pentagon(a: a, b: b)
				nr = nr / 5
			} else if drawnr % 4 == 0 {
				ngon = Square(a: a, b: b)
				nr = nr / 4
			}
			if ngon.isEmpty { return nil }
			var n2 = ngon
			while nr % 2 == 0 {
				//FinalGon(pt: n2)
				CircleAround(pt: n2)
				nr = nr / 2
				n2 = n2gon(pt: n2)
			}
			DoDrawCmd()
			FinalGon(pt: n2)
			
			//	Step(a: a, b: b) //, step: step)
			guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
			emitdelegate?.Emit(image: image)
			//}
			//guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
			//emitdelegate?.Emit(image: image)
		}
		let image = UIGraphicsGetImageFromCurrentImageContext()
		return image
	}
	
	
	
	private func OnDrawn() {
		if emitdelegate == nil { return }
		guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
		emitdelegate?.Emit(image: image)
	}
	
	
	func dist(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
		let dx = a.x - b.x
		let dy = a.y - b.y
		let r = sqrt(dx*dx+dy*dy)
		return r
	}
	
	//Between two circles
	func Intersect(p1 : CGPoint, p2: CGPoint, r1: CGFloat, r2: CGFloat) -> (s1: CGPoint,s2: CGPoint) {
		let (dx,dy) = (p2.x-p1.x,p2.y-p1.y)
		let d = sqrt(dx*dx+dy*dy)
		let l = (r1*r1-r2*r2+d*d) / 2 / d
		let h = sqrt(r1*r1-l*l)
		
		let x = l/d * dx + h/d * dy + p1.x
		let y = l/d * dy - h/d * dx + p1.y
		let xx = l/d * dx - h/d * dy + p1.x
		let yy = l/d * dy + h/d * dx + p1.y
		
		let s1 = CGPoint(x: x, y: y)
		let s2 = CGPoint(x: xx, y: yy)
		return (s1,s2)
	}
	
	//Beetween two lines
	func Intersect (a1: CGPoint, a2: CGPoint, b1: CGPoint, b2: CGPoint) -> CGPoint {
		let (x1,x2,x3,x4) = (a1.x,a2.x,b1.x,b2.x)
		let (y1,y2,y3,y4) = (a1.y,a2.y,b1.y,b2.y)
		
		let x = (x1*y2-y1*x2)*(x3-x4) - (x1-x2)*(x3*y4-y3*x4)
		let y = (x1*y2-y1*x2)*(y3-y4) - (y1-y2)*(x3*y4-y3*x4)
		let d = (x1-x2)*(y3-y4)-(y1-y2)*(x3-x4)
		
		let p = CGPoint(x: x/d, y: y/d)
		return p
	}
	
	//Beetween line and circle
	private func Intersect0(r: CGFloat,p1: CGPoint,p2:CGPoint) -> (CGPoint,CGPoint) {
		let (dx,dy) = (p2.x-p1.x,p2.y-p1.y)
		let dr = sqrt(dx*dx+dy*dy)
		let D = p1.x*p2.y-p2.x*p1.y
		let sgn : CGFloat = dy < 0 ? -1 : 1
		let s = sqrt(r*r*dr*dr-D*D)
		let x1 = (D * dy + sgn * dx * s) / dr / dr
		let y1 = (-D * dx + abs(dy) * s) / dr / dr
		let x2 = (D * dy - sgn * dx * s) / dr / dr
		let y2 = (-D * dx - abs(dy) * s) / dr / dr
		return (CGPoint(x: x1, y: y1), CGPoint(x:x2,y:y2))
	}
	func Intersect(m: CGPoint, r: CGFloat,p1: CGPoint,p2:CGPoint) -> (CGPoint,CGPoint) {
		let p1t = CGPoint(x: p1.x - m.x, y: p1.y - m.y)
		let p2t = CGPoint(x: p2.x - m.x, y: p2.y - m.y)
		let (s1t,s2t) = Intersect0(r: r, p1: p1t, p2: p2t)
		let s1 = CGPoint(x: s1t.x + m.x, y: s1t.y + m.y)
		let s2 = CGPoint(x: s2t.x + m.x, y: s2t.y + m.y)
		return (s2,s1)
	}
	
	//One of the points is on the circle
	func Flip(m: CGPoint, r: CGFloat,p: CGPoint) -> CGPoint {
		
		let dx = m.x - p.x
		let dy = m.y - p.y
		let x = m.x + dx
		let y = m.y + dy
		return CGPoint(x: x, y: y)
	}
	
	
	func Midpoint(a: CGPoint, b: CGPoint) -> CGPoint {
		let r = dist(a,b)
		let (s1,s2) = Intersect(p1: a, p2: b, r1: r, r2: r)
		//Draw(s1, s2)
		//Draw( a, b)
		let m = Intersect(a1: a, a2: b, b1: s1, b2: s2)
		
		return m
	}
	
	func Perpendicular(a: CGPoint, b: CGPoint, p: CGPoint) -> (CGPoint,CGPoint) {
		let dx = b.x - a.x
		let dy = b.y - a.y
		if dx == 0 {
			let p1 = CGPoint(x:p.x - 1000,y:p.y)
			let p2 = CGPoint(x:p.x + 1000,y:p.y)
			return (p1,p2)
		}
		if dy == 0 {
			let p1 = CGPoint(x:p.x,y:p.y-1000)
			let p2 = CGPoint(x:p.x,y:p.y+1000)
			return (p1,p2)
		}
		let m = dy / dx
		let n = -1.0 / m
		let n1 = CGPoint(x: p.x + 1000 , y: p.y + 1000 * n)
		let n2 = CGPoint(x: p.x - 1000, y: p.y - 1000 * n)
		return (n1,n2)
		
	}
	
	func SetColor(step : Int, from : Int) {
		let dbri : CGFloat = 1.0 / CGFloat(from)
		let bri = CGFloat(step) * dbri
		let color = UIColor(hue: 0.0, saturation: 0.0, brightness: bri, alpha: 1.0)
		context.setStrokeColor(color.cgColor)
	}
	
	var cmd : [DrawCmd] = []
	private func DoDrawCmd() {
		
		let dbrightness = 1.0 / CGFloat(max(cmd.count,1))
		for i in 0..<cmd.count {
			var brightness = CGFloat(1) - CGFloat(i) * dbrightness
			for (index,c) in cmd.enumerated() {
				if index > i { break }
				let color = UIColor(hue: 0.0, saturation: 0.0, brightness: brightness, alpha: 1.0)
				color.setStroke()
				c.draw(context: context, color: color)
				brightness = brightness + dbrightness
			}
			OnDrawn()
		}
	}
	
	private func CircleAround(pt : [CGPoint]) -> CGPoint {
		var (x,y) = (CGFloat(0),CGFloat(0))
		for p in pt {
			x = x + p.x
			y = y + p.y
		}
		x = x / CGFloat(pt.count)
		y = y / CGFloat(pt.count)
		let ans = CGPoint(x: x, y: y)
		let r = dist(pt[0], ans)
		cmd.append(CircleCmd(ans, r: r))
		return ans
	}
	
	private func n2gon(pt : [CGPoint]) -> [CGPoint] {
		var (x,y) = (CGFloat(0),CGFloat(0))
		for p in pt {
			x = x + p.x
			y = y + p.y
		}
		x = x / CGFloat(pt.count)
		y = y / CGFloat(pt.count)
		let m = CGPoint(x: x, y: y)
		let r = dist(pt[0], m)
		
		var n2gon : [CGPoint] = []
		for i in 0..<pt.count {
			var i1 = i + pt.count / 2
			i1 = i1 % pt.count
			var i2 = i1 + 1
			i2 = i2 % pt.count
			
			let a = pt[i1]
			let b = pt[i2]
			let p = pt[i]
			//cmd.append(CircleCmd(p, r: r))
			let c = Flip(m: m, r: r, p: p)
			print(i,p,i1,a,i2,b,"c=",c)
			//n2gon.append(a)
			n2gon.append(c)
			n2gon.append(b)
			
			cmd.append(LineCmd(a,c))
			cmd.append(LineCmd(c,b))
			
		}
	
	/*
	var p0  = n2gon.last!
	for p in n2gon {
	cmd.append(LineCmd(p0,p))
	p0 = p
	}
	*/
	
	return n2gon
}

func Square(a: CGPoint, b: CGPoint) -> [CGPoint] {
	cmd = []
	let ab = dist(a, b)
	cmd.append(TextCmd("A", at: a))
	cmd.append(TextCmd("B", at: b))
	cmd.append(LineCmd(a, b))
	let (pa1,pa2) = Perpendicular(a: a, b: b, p: a)
	cmd.append(LineCmd(pa1,pa2))
	let (pb1,pb2) = Perpendicular(a: a, b: b, p: b)
	cmd.append(LineCmd(pb1,pb2))
	cmd.append(CircleCmd(a, r: ab))
	cmd.append(CircleCmd(b, r: ab))
	let (c,_) = Intersect(m: a, r: ab, p1: pa1, p2: pa2)
	cmd.append(LineCmd(a,c))
	let (d,_) = Intersect(m: b, r: ab, p1: pb1, p2: pb2)
	cmd.append(LineCmd(b,d))
	cmd.append(TextCmd("C", at: c))
	cmd.append(TextCmd("D", at: d))
	
	return [a,c,d,b]
	
}

private func FinalGon(pt : [CGPoint])
{
	UIColor.green.setFill()
	context.beginPath()
	context.move(to: pt.last!)
	for p in pt {
		context.addLine(to: p)
	}
	context.closePath()
	context.drawPath(using: .fill)
}


func Triangle(a: CGPoint, b: CGPoint) -> [CGPoint] {
	cmd = []
	let ab = dist(a, b)
	cmd.append(LineCmd(a, b))
	cmd.append(TextCmd("A", at: a))
	cmd.append(TextCmd("B", at: b))
	cmd.append(CircleCmd( a, r: ab))
	cmd.append(CircleCmd( b, r: ab))
	let (s1,s2) = Intersect(p1: a, p2: b, r1: ab, r2: ab)
	cmd.append(LineCmd(s1,s2,limited: false))
	cmd.append(TextCmd("C", at: s1))
	let c = s1
	cmd.append(LineCmd(a, c))
	cmd.append(LineCmd(c, b))
	
	return [a,b,c]
}

func Pentagon(a: CGPoint, b: CGPoint) -> [CGPoint] {
	cmd = []
	let ab = dist(a, b)
	cmd.append(LineCmd(a, b))
	cmd.append(TextCmd("A", at: a))
	cmd.append(TextCmd("B", at: b))
	
	cmd.append(CircleCmd( a, r: ab))
	cmd.append(CircleCmd( b, r: ab))
	let (s1,s2) = Intersect(p1: a, p2: b, r1: ab, r2: ab)
	cmd.append(LineCmd(s1,s2,limited: false))
	let c = Midpoint(a: a, b: b)
	cmd.append(LineCmd(a, c))
	
	
	cmd.append(TextCmd("C", at: c))
	
	//SetColor(step: 2, from: step)
	
	let (d,dd) = Intersect(m: c, r: ab, p1: s1, p2: s2)
	
	cmd.append(CircleCmd( c, r: ab))
	cmd.append(LineCmd( d, dd))
	cmd.append(LineCmd( a,  d))
	cmd.append(TextCmd("D", at: d))
	cmd.append(TextCmd("D'", at: dd))
	//if step <= 2 { return }
	//SetColor(step: 3, from: step)
	let r2 = dist( a, c)
	cmd.append(CircleCmd( a, r: r2))
	let (e,_) = Intersect(m: a, r: r2, p1: a, p2: d)
	cmd.append(LineCmd(a,e))
	cmd.append(TextCmd("E", at: e))
	let (t1,t2) = Perpendicular(a: a, b: e, p: e)
	cmd.append(LineCmd( t1, t2))
	let ddist = dist(d,  dd)
	cmd.append(CircleCmd(d, r: ddist))
	//if step <= 3 {	return	}
	//SetColor(step: 3, from: step)
	let (f,g) = Intersect(m: d, r: ddist, p1: t1, p2: t2)
	cmd.append(LineCmd( f,  g))
	cmd.append(LineCmd( f,  d))
	cmd.append(TextCmd("F",at: f))
	cmd.append(TextCmd("G",at: g))
	let da = dist(a, d)
	
	//Circle Z
	//if step <= 4 {	return	}
	//SetColor(step: 4, from: step)
	cmd.append(CircleCmd(d, r: da))
	let (zfd,_) = Intersect(m: d, r: da, p1: f, p2: d)
	let (_,zgd) = Intersect(m: d, r: da, p1: g, p2: d)
	let ff = zfd
	let gg = zgd
	cmd.append(LineCmd(d,f))
	cmd.append(LineCmd(d,g))
	cmd.append(LineCmd(d,ff))
	cmd.append(LineCmd(d,gg))
	cmd.append(TextCmd("F'", at: ff))
	cmd.append(TextCmd("G'", at: gg))
	//if step <= 5 {	return	}
	//SetColor(step: 5, from: step)
	let d_a_ff = dist(a, ff)
	cmd.append(CircleCmd( ff, r: d_a_ff))
	let (_,h) = Intersect(p1: d, p2: ff, r1: da, r2: d_a_ff)
	cmd.append(TextCmd("H", at: h))
	
	let d_ff_h = dist(ff, h)
	cmd.append(CircleCmd(h, r: d_ff_h))
	let (_,i) = Intersect(p1: d, p2: h, r1: da, r2: d_ff_h)
	cmd.append(TextCmd("I",at:i))
	context.setStrokeColor(UIColor.cyan.cgColor)
	//if step <= 6 { return }
	//SetColor(step: step, from: step)
	cmd.append(LineCmd( a,  ff))
	cmd.append(LineCmd( ff,  h))
	cmd.append(LineCmd( h,  i))
	cmd.append(LineCmd(i, gg))
	cmd.append(LineCmd(gg,  a))
	
	return [a,ff,h,i,gg]
}
}

protocol DrawCmd {
	func draw(context : CGContext,color : UIColor)
}

struct LineCmd : DrawCmd {
	var a: CGPoint!
	var b: CGPoint!
	init(_ a: CGPoint, _ b: CGPoint, limited : Bool = true) {
		if limited {
			self.a = a
			self.b = b
			return
		}
		let dx = b.x - a.x
		let dy = b.y - a.y
		if dx == 0 {
			self.a = CGPoint(x:a.x,y:a.y - 1000.0)
			self.b = CGPoint(x:a.x, y: a.y + 1000.0)
			return
		}
		let m = dy / dx
		self.a = CGPoint(x: a.x + 1000 , y: a.y + 1000 * m)
		self.b = CGPoint(x: a.x - 1000, y: b.y - 1000 * m)
	}
	
	func draw(context : CGContext,color : UIColor) {
		context.move(to: a)
		context.addLine(to: b)
		context.strokePath()
	}
}

struct CircleCmd : DrawCmd {
	
	var a : CGPoint!
	var r : CGFloat = 0.0
	init(_ a: CGPoint, r: CGFloat) {
		self.a = a
		self.r = r
	}
	
	func draw(context: CGContext, color: UIColor) {
		let rcircle = CGRect(x: a.x-r, y: a.y-r, width: 2*r, height: 2*r)
		context.addEllipse(in: rcircle)
		context.strokePath()
	}
}

struct TextCmd : DrawCmd {
	var at: CGPoint!
	var str : String!
	
	init(_ str : String, at : CGPoint) {
		self.at = at
		self.str = str
	}
	
	func draw(context: CGContext, color: UIColor) {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .center
		
		let attributes = [NSAttributedStringKey.paragraphStyle  :  paragraphStyle,
						  NSAttributedStringKey.font            :   UIFont.systemFont(ofSize: 12.0),
						  NSAttributedStringKey.foregroundColor : UIColor.white,
						  ]
		
		let attrString = NSAttributedString(string: str,attributes: attributes)
		attrString.draw(at: at)
	}
}


