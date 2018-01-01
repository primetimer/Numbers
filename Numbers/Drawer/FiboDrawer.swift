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
	private var _imageview : UIImageView? = nil
	var imageview : UIImageView {
		get {
			if _imageview == nil {
				let rect = CGRect(x: 0, y: 0 , width: frame.width, height: frame.height)
				_imageview = UIImageView(frame:rect)
				_imageview?.backgroundColor = self.backgroundColor
				addSubview(_imageview!)
			}
			return _imageview!
		}
	}
	*/
	
	
	
	/*
	private var nr : UInt64 = 1
	func SetNumber(_ nextnr : UInt64) {
		self.nr = nextnr
	}
	*/
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		CreateImages()
	}
	
	private func CreateImages()  {
		let rect = CGRect(x: 0.0, y: 0.0, width: 400.0, height: 400.0)
		//var images : [UIImage] = []
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		guard let context = UIGraphicsGetCurrentContext() else { return }
		context.setStrokeColor(UIColor.black.cgColor)
		context.setLineWidth(1.0);
		context.beginPath()
		let fibodraw = FiboDrawer(nr: self.nr, rect: rect)
		fibodraw.DrawNumber(context : context)
		let newimage  = UIGraphicsGetImageFromCurrentImageContext()
		//images.append(newimage!)
		UIGraphicsEndImageContext()
	
		//imageview.animationImages = images
		imageview.image = newimage
	}
}

class FiboDrawer : NSObject
{
	enum fiboOrientation  { case left,top,right, bottom }
	private var context : CGContext!
	private var nr : UInt64 = 1
	internal var rect : CGRect!
	internal var rx : CGFloat = 0
	internal var ry : CGFloat = 0
	private var sphere = SphereDrawer()
	
	private var pts : [(x:Double,y:Double)] = []
	private var nth = 0

	init(nr : UInt64, rect : CGRect) {
		super.init()
		self.nr = nr
		self.rect = rect
		self.rx = rect.maxX - rect.minX
		self.ry = rect.maxY - rect.minY
		self.nth = Nth(nr: nr)
	}
	
	private func Fibo(nth: Int) -> Int {
		if nth <= 2 { return 1 }
		var (a,b) = (1,1)
		var c = 0
		for i in 3...nth {
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
		return rx / CGFloat(r)
	}
	func DrawPoint(xy: CGPoint, radius : CGFloat, hue : Double) {
		
		let color = PColor(hue : CGFloat(hue), saturation : 1.0, brightness : 1.0, alpha : 1.0)
		color.setFill()
		context.fill(CGRect(x: xy.x,y: xy.y ,width: radius, height: radius))
		//sphere.drawSphere(context, xy: xy, r: CGFloat(radius) / 2.0, col: [color])
		//color.setStroke()
		//color.setFill()
	}
	
	func DrawNumber(context : CGContext)
	{
		self.context = context
		let nth = Nth(nr: nr)
		let f1 = Fibo(nth: nth+1)
		
		let phi = CGFloat(Double(f1) / Double(nr))
		var w = rx
		var h = w / CGFloat(phi)
		var orientation = fiboOrientation.left
		
		var x : CGFloat = 0.0
		var y : CGFloat = ry / 2 - h / 2
		
		
		for i in 0...nth {
			let hue = i % 2 == 0 ? CGFloat(i) / CGFloat(nth) : 1.0 -  CGFloat(i) / CGFloat(nth)
			let color = PColor(hue : CGFloat(hue), saturation : 1.0, brightness : 1.0, alpha : 1.0)
			color.setFill()
			context.fill(CGRect(x: x,y: y ,width: w, height: h))
			
			switch orientation {
			case .left:
				x = x + h
				w = w - h
				orientation = .top
			case .top:
				y = y + w
				h = h - w
				orientation = .right
			case .right:
				w = w - h
				orientation = .bottom
			case .bottom:
				h = h - w
				orientation = .left
			}
		}
	}
	
	private func GetXY(_ i: Int, _ j : Int) -> CGPoint
	{
		let x = CGFloat(i) * Radius() + Radius() / 2.0
		let y = CGFloat(j) * Radius() + Radius() / 2.0
		return CGPoint(x: x, y: y)
	}
}





