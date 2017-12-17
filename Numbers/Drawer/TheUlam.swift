//
//  TheUlam.swift
//  PrimeTime
//
//  Created by Stephan Jancar on 11.04.16.
//  Copyright © 2016 esjot. All rights reserved.
//

import Foundation

enum UlamType : Int {
	case square = 0, spiral = 1, fibonacci = 2, hexagon = 3
}

let theulamrect = TheUlamRect()
let theulamspiral = TheUlamRound()
let theulamexplode = TheUlamExplode()
let theulamhexagon = TheUlamHexagon()

typealias SpiralXY = (x: Float, y: Float)

class TheUlamBase  {
	
	static let defcount = 3600 //##
	var count = defcount + 1
	//private var pt : [SpiralXY] = []
	
	func Radius(_ count : Int) -> Double
	{
		return sqrt(Double(count))
	}
	
	func getPoint(_ n: Int) -> SpiralXY {
		assert(false) // Please Override
		let pt = (x: Float(0.0), y: Float(0.0))
		return pt
	}
}

class TheUlamRound : TheUlamBase {
	static let sharedInstance = TheUlamRound()
	
	let pi = Float(4.0 * atan(1.0))
	
	override func getPoint(_ n: Int) -> SpiralXY {
		let i = n + 1
		let r = sqrt(Float(i))
		let theta =  pi * r * 2.0
		let x = cos(theta)*r
		let y = -sin(theta)*r
		let p = (x: x, y: y)
		return p
		
	}
	
	
}

class TheUlamExplode : TheUlamBase {
	static let sharedInstance = TheUlamExplode()
	
	let pi = Double(4.0 * atan(1.0))
	let phi = Double(sqrt(5.0) + 1.0 ) / 2.0
	var dtheta = Double(0.0)
	
	
	fileprivate override init() {
		
		super.init()
		self.dtheta =  2.0 * pi / phi / phi
	}
	
	override func getPoint(_ n: Int) -> SpiralXY {
		let i = n
		let r = sqrt(Double(i))
		let theta =  Double(n) * dtheta
		//if (theta > 2.0 * pi) { theta = theta - 2 * pi }
		let x = cos(theta)*r
		let y = -sin(theta)*r
		let p = (x: Float(x), y: Float(y))
		return p
	}
	
}

class TheUlamHexagon : TheUlamBase {
	static let sharedInstance = TheUlamExplode()
	
	fileprivate override init() {
		super.init()
	}
	
	override func getPoint(_ n: Int) -> SpiralXY {
		
		#if false
			if n == 0 { return (x: 0.0, y: 0.0) }
			let n3 = round(sqrt( Double(n) / 3.0 ))
			let layer = Int(n3)
			let firstIdxInLayer = 3*layer*(layer-1) + 1
			let side = (n - firstIdxInLayer) / layer; // note: this is integer division
			let idx  = (n - firstIdxInLayer) % layer;
			var xp =  Double(layer) * cos( Double(side - 1) * M_PI / 3.0)
			xp = xp + Double(idx + 1) * cos( Double(side + 1) * M_PI / 3.0 );
			var yp = -Double(layer) * sin( Double(side - 1) * M_PI / 3.0 )
			yp = yp - Double(idx + 1) * sin( Double(side + 1) * M_PI / 3.0 )
			let p = (x: Float(2*xp), y: Float(2*yp))
			return p
		#endif
		#if true //Sechseck
			let h : [Double] = [  1, 1, 0, -1, -1, 0, 1, 1, 0 ]
			if n == 0 { return (x: 0.0, y: 0.0) }
			let n3 = round(sqrt( Double(n) / 3.0 ))
			let layer = Int(n3)
			let firstIdxInLayer = 3*layer*(layer-1) + 1
			let side = (n - firstIdxInLayer) / layer; // note: this is integer division
			let idx  = (n - firstIdxInLayer) % layer;
			
			var hx = Double(layer)*h[side+0]
			hx = hx + Double(idx+1) * h[side+2]
			var hy = Double(layer)*h[side+1]
			hy = hy + Double(idx+1) * h[side+3]
			
			let xp = hx - hy * 0.5
			let yp = hy * sqrt(0.75)
			let p = (x: Float(1.5*xp), y: Float(1.5*yp))
			return p
		#endif
	}
	
}



class TheUlamRect : TheUlamBase {
	static let sharedInstance = TheUlamRect()
	/*
	private override init() {
	
	super.init()
	var x = 0
	var y = 0
	//var n = 0
	//var p = (x: Float(x), y: Float(y))
	//pt.append(p)
	
	
	for n in 1...count-1
	{
	
	let w2 = sqrt(Double(n))
	let w = ( w2 + 1.0 ) / 2.0
	let m : Int = Int(floor(w))
	let k : Int = n - 4 * m * ( m - 1 )
	
	if k <= 2 * m {
	x = m
	y = k - m
	} else if  k <= 4*m  {
	x = 3 * m - k
	y = m
	} else if k <= 6*m {
	x = -m
	y = 5 * m - k
	} else if k <= 8*m {
	x = k - 7 * m
	y = -m
	}
	
	/*
	Index to position
	-----------------
	n -> (x,y)
	
	0 -> (0,0)
	
	for n > 0,
	
	sqrt(n)+1
	m = floor( --------- )
	2
	
	k = n - 4m(m-1)
	
	1 <= k <= 2m -> (x,y) = (m,k-m)
	
	2m <= k <= 4m -> (x,y) = (3m-k,m)
	
	4m <= k <= 6m -> (x,y) = (-m,5m-k)
	
	6m <= k <= 8m -> (x,y) = (k-7m,-m)
	
	
	Position to index
	-----------------
	(x,y) -> n
	
	m = max(|x|,|y|)
	
	x = m  -> n = 4m(m-1) +  m + y    except if y = -m
	
	y = m  -> n = 4m(m-1) + 3m - x
	
	x = -m -> n = 4m(m-1) + 5m - y
	
	y = -m -> n = 4m(m-1) + 7m + x
	*/
	
	let p = (x: Float(2*x), y: Float(2*y))
	pt.append(p)
	}
	return
	
	#if false
	for ii in 0...count-1 {
	let i = 2*ii + 1
	for _ in 1...i {
	x = x + 1
	n = n + 1
	let p = (x: Float(x), y: Float(y))
	pt.append(p)
	}
	for _ in 1...i {
	y = y - 1
	n = n + 1
	let p = (x: Float(x), y: Float(y))
	pt.append(p)
	}
	for _ in 1...i+1 {
	x = x - 1
	n = n + 1
	let p = (x: Float(x), y: Float(y))
	pt.append(p)
	}
	for _ in 1...i+1 {
	y = y + 1
	n = n + 1
	let p = (x: Float(x), y: Float(y))
	pt.append(p)
	}
	
	if (n > count) {
	break
	}
	}
	#endif
	}
	*/
	override func getPoint(_ n : Int) -> SpiralXY
	{
		let w2 = sqrt(Double(n))
		let w = ( w2 + 1.0 ) / 2.0
		let m : Int = Int(floor(w))
		let k : Int = n - 4 * m * ( m - 1 )
		var x = 0
		var y = 0
		
		if k <= 2 * m {
			x = m
			y = k - m
		} else if  k <= 4*m  {
			x = 3 * m - k
			y = m
		} else if k <= 6*m {
			x = -m
			y = 5 * m - k
		} else if k <= 8*m {
			x = k - 7 * m
			y = -m
		}
		let p = (x: Float(2*x), y: Float(2*y))
		
		return p
	}
}





