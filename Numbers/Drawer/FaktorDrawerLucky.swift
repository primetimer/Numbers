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

class FaktorDrawerLuckyUlam : FaktorDrawer {
	
	private var ulam : UlamDrawer!
	
	override func Radius(_ rekurs : Int) -> Double {
		return super.Radius(rekurs) / 2.0
	}
	
	override func drawFaktor(_ rect: CGRect, context: CGContext) {
		
		var count = min(param.nr,1000)
		
		//count = Int(pow(Double(param.nr),1.0 / 3.0 ))
		//count = max(count,100)
		
		ulam = UlamDrawer(pointcount: Int(count), utype: .square)
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
		
		let m = max(100,param.nr)
		ulam.colored = true
		
		let luckytester = LuckyTester()
		for i in 1..<m {
			if luckytester.isSpecial(n: BigUInt(i)) {
				let ulamindex = Int(i - ulam.pstart)
				ulam.draw_number(context, ulamindex : ulamindex, p: i)
			}
		}
	}
	
	//fileprivate var divisors : [UInt64] = []
}
