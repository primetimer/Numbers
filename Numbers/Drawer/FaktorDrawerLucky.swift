//
//  FaktorDrawerUlam.swift
//  Numbers
//
//  Created by Stephan Jancar on 17.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit
import BigInt
import PrimeFactors

class LuckyView : DrawNrView {
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func SetNumber(_ nextnr : UInt64) {
		super.SetNumber(nextnr)
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		
		DispatchQueue.global().async {
			let images = self.CreateImages()
			
			DispatchQueue.main.async(execute: {
				self.imageview.animationImages = images
				self.imageview.image = images.last
				self.imageview.animationDuration = 5.0
				self.imageview.animationRepeatCount = 5
				self.imageview.startAnimating()
			})
		}
	}
	
	private func CreateImages()  -> [UIImage] {
		let rect = CGRect(x: 0, y: 0, width: 400.0, height: 400.0)
		var images : [UIImage] = []
		
		for imagenr in 0...10 {
			let lucky = LuckyDrawHelper(count: Int(self.nr))
			lucky.remove(level: imagenr)
			if imagenr == 10 {
				lucky.correct()
			}
			
			UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
			let context = UIGraphicsGetCurrentContext()
			context!.setStrokeColor(UIColor.red.cgColor)
			context!.setLineWidth(1.0);
			context!.beginPath()
			let drawer = LuckyDrawer(pointcount: Int(self.nr), utype: .square, lucky: lucky)
			drawer.pstart = 1
			//ulam.setZoom(param.ulamzoom)
			drawer.SetWidth(rect)
			drawer.bdrawspiral = true
			drawer.draw_spiral(context!)
			
			for i in 1...Int(self.nr) {
				drawer.draw_number(context!, ulamindex : i-1, p: UInt64(i))
			}
			
			let newimage  = UIGraphicsGetImageFromCurrentImageContext()
			images.append(newimage!)
			UIGraphicsEndImageContext()
		}
		return images
	}
}


class LuckyDrawHelper {
	private (set) var luck : [Bool] = []
	init(count : Int) {
		luck = Array(repeating: true, count: count+1)
	}
	
	private func findLucky(which : Int) -> Int? {
		if which <= 1 { return 2 }
		var count = 1
		for l in 1...luck.count-1 {
			if luck[l] == true {
				
				if count == which {
					return l
				}
				count = count + 1
			}
		}
		return nil
	}
	
	private func getNext(from : Int, step: Int)  -> Int? {
		var count = 0
		for i in from ... luck.count-1 {
			if luck[i] == true {
				count = count + 1
			}
			if count == step {
				return i
			}
		}
		return nil
	}
	func remove(which : Int) {
		var prev = 1
		while true {
			if let next = getNext(from: prev,step: which) {
				luck[next] = false
				prev = next
			} else {
				return
			}
		}
	}
	
	func remove(level : Int)
	{
		if level == 0 { return }
		for k in 1...level {
			guard let l = findLucky(which: k)  else { return }
			remove(which: l)
		}
	}
	
	func correct() {
		let test = LuckyTester()
		for i in 2..<luck.count {
			if test.isSpecial(n: BigUInt(i)) {
				luck[i] = true
			} else {
				luck[i] = false
			}
		}
	}
}
class LuckyDrawer : UlamDrawer {
	
	init(pointcount: Int, utype: UlamType, lucky: LuckyDrawHelper)
	{
		super.init(pointcount: pointcount, utype: utype)
		self.lucky = lucky
	}
	private var lucky : LuckyDrawHelper!
	
	override func getColor(_ p : UInt64) -> UIColor?
	{
		if lucky.luck[Int(p)] {
			return .red
		} else {
			return .cyan
		}
	}
}

/*
class FaktorDrawerLuckyUlam : FaktorDrawer {
	
	private var ulam : UlamDrawer!
	
	override func Radius(_ rekurs : Int) -> Double {
		return super.Radius(rekurs) / 2.0
	}
	
	
	override func drawFaktor(_ rect: CGRect, context: CGContext) {
		
		var count = Int(min(param.nr,1000))
		let lucky = LuckyDrawHelper(count: count)
		lucky.remove(level: param.imagenr)
		
		ulam = LuckyDrawer(pointcount: Int(count*2), utype: .square,lucky: lucky)
		ulam.pstart = 1
		ulam.colored = false
		ulam.setZoom(param.ulamzoom)
		
		ulam.SetWidth(rect)
		context.setStrokeColor(PColor.red.cgColor)
		context.setLineWidth(1.0);
		context.beginPath()
		
		//if r > 80 {
		ulam.draw_spiral(context)
		//}
		
		let m = Int(count)
		ulam.colored = true
		
		for i in 1...m {
			ulam.draw_number(context, ulamindex : i-1, p: UInt64(i))
			/*if !lucky.luck[i] {
			ulam.draw_number(context, ulamindex : i-1, p: UInt64(i))
			}*/
		}
	}
}
*/
