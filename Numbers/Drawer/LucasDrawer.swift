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

extension CGFloat {
	func sgn() -> CGFloat {
		if self > 0 { return 1.0 }
		if self < 0 { return -1.0 }
		return 0.0
	}
}

class LucasView: DrawNrImageView {
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override var nr : BigUInt {
		didSet {
			maxlevel = Int(LucasTester.NIndex(n: BigUInt(nr))) - 1
			ry2 = ry / CGFloat(nr) / 4.0 * CGFloat(pow(2.0,Double(maxlevel)))
		}
	}

	private var (rx,ry,rx2,ry2) = (CGFloat(0),CGFloat(0),CGFloat(0),CGFloat(0))
	private var maxlevel = 10
	
	enum NodeType : Int { case black = 0 ,red = 1 ,blue = 2 }
	private var path : [UIBezierPath] = [UIBezierPath(),UIBezierPath(),UIBezierPath()]
	private var shapeLayer: [CAShapeLayer?] = [nil,nil,nil]
	
	private func addToPath(_ pt0 : CGPoint, _ pt1: CGPoint, type :NodeType) {
		path[type.rawValue].move(to: pt0)
		path[type.rawValue].addLine(to:  pt1)
		path[type.rawValue].addLine(to: CGPoint(x: pt1.x+1,y:pt1.y+1))
		path[type.rawValue].addLine(to: CGPoint(x: pt1.x+1, y:pt1.y-1))
			path[type.rawValue].addLine(to:  pt1)
	}
	
	private func DrawNode(type :NodeType, xy : CGPoint, level : Int, sign: CGFloat)
	{
		if level >= maxlevel { return }
		switch type {
		case .black:
			do {
				let type = NodeType.blue
				let x = xy.x + rx2
				let y = xy.y
				let pt1 = CGPoint(x:x,y:y)
				addToPath(xy,pt1,type: type)
				DrawNode(type: type, xy: pt1, level: level+1, sign: 1.0)
			}
			do {
				let type = NodeType.red
				let x = xy.x + rx2
				let y = xy.y + ry2 / 1.0
				let pt1 = CGPoint(x:x,y:y)
				addToPath(xy,pt1,type: type)
				DrawNode(type: type, xy: pt1, level: level+1, sign: 1.0)
			}
			do {
				let type = NodeType.red
				let x = xy.x +  rx2
				let y = xy.y -  ry2 / 1.0
				let pt1 = CGPoint(x:x,y:y)
				addToPath(xy,pt1,type: type)
				DrawNode(type: type, xy: pt1, level: level+1, sign: -1.0)
			}
		case .blue:
			do {
				let type = NodeType.blue
				let x = xy.x +  rx2
				let y = xy.y
				let pt1 = CGPoint(x:x,y:y)
				addToPath(xy,pt1,type: type)
				DrawNode(type: type, xy: pt1, level: level+1,sign: sign)
			}
			do {
				let frac = pow(2.0,-Double(level-1))
				let type = NodeType.red
				let x = xy.x + rx2
				let y = xy.y + ry2 * CGFloat(frac) * sign
				let pt1 = CGPoint(x:x,y:y)
				addToPath(xy,pt1,type: type)
				DrawNode(type: type, xy: pt1, level: level+1, sign: sign)
			}
		case .red:
			do {
				let type = NodeType.blue
				let x = xy.x + rx2
				let y = xy.y
				let pt1 = CGPoint(x:x,y:y)
				addToPath(xy,pt1,type: type)
				DrawNode(type: type, xy: pt1, level: level+1, sign: sign)
			}
		}
	}
	
	override var frame : CGRect {
		set {
			super.frame = newValue
			self.setNeedsDisplay() }
		get {
			return super.frame
		}
	}
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		self.rx = rect.width
		self.ry = rect.height
		self.rx2 = rx / CGFloat(maxlevel) / 1.0
		self.ry2 = ry / CGFloat(nr) / 2.0 * CGFloat(maxlevel)
		
		for i in 0...2 {
			path[i] = UIBezierPath()
			shapeLayer[i]?.removeFromSuperlayer()
		}
		let pt = CGPoint(x: 0, y: ry/2)
		DrawNode(type: .black, xy: pt, level: 1, sign: 0.0)
		
		for i in 0...2 {
		
			let shapeLayer = CAShapeLayer()
			shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
			let color =  i == 2 ? UIColor.red : UIColor.green
			//, UIColor(hue: CGFloat(i) / 3.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
			shapeLayer.strokeColor = color.cgColor
			shapeLayer.lineWidth = 8.0 / CGFloat(maxlevel)
			shapeLayer.path = path[i].cgPath
			self.layer.addSublayer(shapeLayer)
			self.shapeLayer[i] = shapeLayer
		// animate it
		
		//self.layer.addSublayer(shapeLayer)
		let animation = CABasicAnimation(keyPath: "strokeEnd")
		animation.fromValue = 0
		animation.duration = 2
		shapeLayer.add(animation, forKey: "MyAnimation")
		
		}
		// save shape layer
		
		//self.shapeLayer = shapeLayer
	}
}
	
