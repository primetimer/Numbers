//
//  FaktorView.swift
//  Numbers
//
//  Created by Stephan Jancar on 15.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit
import BigInt

extension UInt64 {
	func ClearBit(i: UInt64) -> UInt64{
		let i2 : UInt64 = ~(1<<i)
		return self & i2
	}
	func SetBit(i: UInt64) -> UInt64 {
		let i2 : UInt64 = (1<<i)
		return self | i2
	}
}

class DyckWord : CustomStringConvertible {

	var description: String {
		get {
			var outstr = ""
			var i = 0
			for d in dyck {
				i = i + 1
				outstr = outstr + "\n" + String(i) + ":"
				let xout = d
				var test : UInt64 = 1
				for _ in 0..<2*n {
					if xout & test == test {
						outstr = outstr + "1"
					} else {
						outstr = outstr + "0"
					}
					test = test * 2
				}
			}
			//print (xout, outstr + "\n")
			return outstr
		}
	}
	
	func bitString(x: UInt64) -> String {
		var outstr = ""
		let xout = x
		var test : UInt64 = 1
		for _ in 0..<2*n {
			if xout & test == test {
				outstr = outstr + "1"
			} else {
				outstr = outstr + "0"
			}
			test = test * 2
		}
		return outstr
	}
	
	var n : UInt64 = 0
	//var x : UInt64 = 0
	var n0 : UInt64 = 0
	var n1 : UInt64 = 0
	private var dyck : [UInt64] = []
	
	func GetWord(index : Int) -> UInt64 {
		if dyck.isEmpty {
			compute()
		}
		return dyck[index]
	}
	
	init(n: UInt64) {
		self.n = n
	}
	
	private func compute() {
		self.n0 = 1
		self.n1 = 0
		dyck = []
		LexDyckWord(x: 0, i: 1)
	}

	private func Dyck0(x: UInt64 , i: UInt64) -> UInt64 {
		let xx = x.ClearBit(i: i-1)
		self.n0 = self.n0+1
		LexDyckWord(x: xx, i: i)
		self.n0 = self.n0 - 1
		return xx
	}
	
	private func Dyck1(x: UInt64 , i: UInt64) -> UInt64 {
		let xx = x.SetBit(i: i-1)
		self.n1 = self.n1 + 1
		LexDyckWord(x: xx, i: i)
		self.n1 = self.n1 - 1
		return xx

	}
	
	func CreateRandom() -> UInt64
	{
		var n0 = 0
		//var n1 = 0
		var x : UInt64 = 0
		
		var h = 0
		for i in 0..<2*n {
			if h == 0 {
				x = x.ClearBit(i: i)
				h = h + 1
				n0 = n0 + 1
			} else if n0 >= self.n {
				x = x.SetBit(i: i)
				h = h - 1
			} else {
				let rnd = arc4random_uniform(2)
				if rnd == 0 {
					x = x.ClearBit(i: i)
					n0 = n0 + 1
					h = h + 1
				} else {
					x = x.SetBit(i: i)
					h = h - 1
				}
			}
		}
		return x
	}
	
	private func LexDyckWord(x: UInt64 , i: UInt64)
	{
		if n0<self.n && n1<self.n && n0>n1 {
			//print("Case 1")
			let x0 = Dyck0(x: x,i: i+1)
			let _ = Dyck1(x: x0,i: i+1)
		} else if n0<n && n1<n && n0==n1 {
			//print("Case 2")
			let _ = Dyck0(x: x, i: i+1)
		} else if n0<n && n1==n {
			//print("Case 3")
			let _ = Dyck0(x: x, i: i+1)
		} else if n0 == n && n1<n {
			//print("Case 4")
			let _ = Dyck1(x: x, i: i+1)
		} else {
			dyck.append(x)
			//print (description + "\n")
		}
	}
}

class CatalanView: DrawNrView {
	
	
	private let maxdraw : UInt64 = 132
	override init(frame: CGRect) {
		super.init(frame: frame)
		CreateDisplayLink()
		
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		CreateDisplayLink()
	}
	
	var displayLink : CADisplayLink? = nil
	private func CreateDisplayLink() {
			displayLink = CADisplayLink(target: self, selector: #selector(DisplayUpdate))
			displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
	}
	
	@objc func DisplayUpdate() {
		self.setNeedsDisplay()
		self.clearsContextBeforeDrawing = false
	}
	
	private let catalan = CatalanTester()

	override func SetNumber(_ nextnr : UInt64) {
		if nextnr == self.nr { return }
		displayLink?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
		displayLink = nil
		while !shapeLayer.isEmpty {
			ClearShapes()
		}
		super.SetNumber(nextnr)
		let n = nextnr //min(nextnr,maxdraw)
		self.nth = catalan.Nth(n: BigUInt(n))
		dyck = DyckWord(n: UInt64(nth))
		if catalan.isSpecial(n: BigUInt(Int(n))) {
			CreateDisplayLink()
		}
	}
	
	var dyck : DyckWord = DyckWord(n:0)
	private var (rx,ry) = (CGFloat(0),CGFloat(0))
	private var nth = 0

	//private var path : [UIBezierPath] = []
	private var shapeLayer: [CAShapeLayer] = []
	
	/*
	private func addToPath(_ pt0 : CGPoint, _ pt1: CGPoint, index : Int) {
		path[index].move(to: pt0)
		path[index].addLine(to:  pt1)
		path[index].addLine(to: CGPoint(x: pt1.x+1,y:pt1.y+1))
		path[index].addLine(to: CGPoint(x: pt1.x+1, y:pt1.y-1))
		path[index].addLine(to:  pt1)
	}
	*/
	
	private func addToPath(_ pt0 : CGPoint, _ pt1: CGPoint, path: UIBezierPath) {
		path.move(to: pt0)
		path.addLine(to:  pt1)
		path.addLine(to: CGPoint(x: pt1.x+1,y:pt1.y+1))
		path.addLine(to: CGPoint(x: pt1.x+1, y:pt1.y-1))
		path.addLine(to:  pt1)
	}
	
	private func ClearShapes(from: Int = 0) {
		if shapeLayer.count > from {
			for i in from..<shapeLayer.count {
				let dellayer = shapeLayer[i]
				dellayer.removeFromSuperlayer()
			}
			while shapeLayer.count > from {
				shapeLayer.removeLast()
			}
		}
	}
	
	private func DrawMountain(_ indexpos : UInt64)
	{
		let dx = rx / CGFloat(nth) / 2
		let dy = ry / CGFloat(nth+1)
		let path = UIBezierPath()
		
		drawcounter = (drawcounter + 1) % self.nr
		var word : UInt64 = 0
		var y : CGFloat = 0.0
		var hue : CGFloat = 0.0
		if self.nr > maxdraw {
			word = dyck.CreateRandom()
			hue = CGFloat(word) / CGFloat(nr) 
			y = CGFloat(arc4random()) / CGFloat(Int32.max) * dy
		} else {
			word = dyck.GetWord(index: Int(indexpos))
			hue = CGFloat(indexpos) / CGFloat(nr)
			y = hue * dy
		}
		
		let color = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)		
		var test : UInt64 = 1
		for i in 0..<2*nth {
			let x = CGFloat(i) * dx
			let pt0 = CGPoint(x:x,y:ry-y)
			if word & test == 0 {
				y = y + dy
			} else {
				y = y - dy
			}
			let pt1 = CGPoint(x: x+dx, y: ry-y)
			addToPath(pt0,pt1, path: path)
			test = test * 2
		}
		
		let newlayer = CAShapeLayer()
		shapeLayer.insert(newlayer, at: 0)
		ClearShapes(from: 132)
		
		//shapeLayer[index].removeFromSuperlayer()
		//shapeLayer[index] = CAShapeLayer()
		newlayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
		newlayer.strokeColor = color.cgColor
		//newlayer.lineWidth = CGFloat(lw)
		newlayer.path = path.cgPath //[index].cgPath
		let animation = CABasicAnimation(keyPath: "strokeEnd")
		animation.fromValue = 0
		animation.duration = 1
		newlayer.add(animation, forKey: "MyAnimation")
		self.layer.addSublayer(newlayer)
	}
	
	var drawcounter : UInt64 = 0
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		if self.nth == 0 { return }
		if !catalan.isSpecial(n: BigUInt(nr)) { return }
	
		if self.rx != rect.width || self.ry != rect.height {
				ClearShapes()
				self.drawcounter = 0
		}
		self.rx = rect.width
		self.ry = rect.height
		
		DrawMountain(drawcounter)
	}
}


	
