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

class FaktorDrawerUlam : FaktorDrawer {
	
	private var ulam : UlamDrawer!
	
	override func Radius(_ rekurs : Int) -> Double {
		return super.Radius(rekurs) / 2.0
	}
	
	override func drawFaktor(_ rect: CGRect, context: CGContext) {
		
		let r = Radius(0)
		var count = TheUlamBase.defcount
		if UInt64(count) > param.nr {
			count = Int(param.nr)
		}
		count = Int(pow(Double(param.nr),1.0 / 3.0 ))
		count = max(count,1000)
		
		ulam = UlamDrawer(pointcount: Int(count), utype: .square)
		ulam.pstart = 1
		ulam.colored = false
		ulam.setZoom(param.ulamzoom)
		
		ulam.SetWidth(rect)
		context.setStrokeColor(PColor.red.cgColor)
		context.setLineWidth(1.0);
		context.beginPath()
		
		if r > 80 {
			ulam.draw_spiral(context)
		}
		
		let divisors = FactorCache.shared.Divisors(p: BigUInt(param.nr))
		let m = divisors.count
		ulam.colored = true
		
		for i in 0..<m {
			let t = divisors[i]
			if /* t > 3600 || */ t < ulam.pstart {
				continue
			}
			let p = UInt64(t)
			let ulamindex = Int(p - ulam.pstart)
			ulam.draw_number(context, ulamindex : ulamindex, p: p)
		}
	}
	
	//fileprivate var divisors : [UInt64] = []
}
