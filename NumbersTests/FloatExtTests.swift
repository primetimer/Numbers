//
//  NumbersTests.swift
//  NumbersTests
//
//  Created by Stephan Jancar on 03.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import XCTest
import BigInt
import BigFloat
@testable import Numbers

extension BigInt : CustomDebugStringConvertible {
	public var debugDescription: String {
		return String(self)
	}
}

class FloatExtTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testcontinuedFractions() {
		let cf = [4, 2, 1, 3, 1, 2, 8, 2, 1, 3, 1, 2, 8, 2, 1, 3, 1, 2, 8, 2, 1, 3, 1, 2, 8, 2, 1, 3, 1, 2, 8, 2, 1, 3, 1, 2, 8, 2, 1, 3, 1, 2, 8, 2, 1, 3, 1, 2, 8, 2, 1, 3, 1, 2, 8, 2, 1, 3, 1, 2, 8, 2, 1, 3, 1, 2, 8, 2, 1, 3, 1, 2, 8, 2, 1, 3, 1, 2, 8, 2]
	
		
		var (h1,k1) = (BigUInt(1), BigUInt(0))
		var (h0,k0) = (BigUInt(0), BigUInt(1))
		for i in 0..<cf.count {
			let a = BigUInt(cf[i])
			let (h,k) = (a*h1+h0,a*k1+k0)
			(h0,k0) = (h1,k1)
			(h1,k1) = (h,k)
			let approx = BigFloat(BigInt(h)) / BigFloat(BigInt(k))
			let str = approx.asString(10, maxlen: 10, fix: 10)
		}
		let d19 = Double(h1) / Double(k1)
		let d19_2 = d19*d19
		XCTAssert(abs(d19_2-19.0) <= 0.0000000001)
	}
	
	func testcomputeSquareroot() {
		
		for fint in 2...19 {
			let f = BigFloat(fint)
			let f2 = BigFloat.sqrt(x: f)
			let a = ContinuedFractions.shared.getSeries(value: f2,upto : 100)
			let (n,d) = ContinuedFractions.shared.ValueRational(seq: a, count: 100)
			let approx = BigFloat(BigInt(n)) / BigFloat(BigInt(d))
			let approx2 = approx * approx
			let dif = BigFloat.abs(f - approx2)
			XCTAssert(dif <= BigFloat(Double(0.00001)))
		}
	}
	
	func testNomenator() {
		do {
			let f0 = 2
			let f = BigFloat.sqrt(x: BigFloat(f0))
			let a = ContinuedFractions.shared.getSeries(value: f)
			var ai : [BigInt] = []
			for i in a { ai.append(BigInt(i)) }
			let r = ContinuedFractions.shared.RationalSequence(seq: ai)
			XCTAssert(r[0].n == BigUInt(1))
			XCTAssert(r[1].n == BigUInt(3))
			XCTAssert(r[5].n == BigUInt(99))
			//https://oeis.org/A001333
		}
		do { //https://oeis.org/A002485
			let f = BigFloatConstant.pi
			let a = ContinuedFractions.shared.getSeries(value: f)
			var ai : [BigInt] = []
			for i in a { ai.append(BigInt(i)) }
			let r = ContinuedFractions.shared.RationalSequence(seq: ai)
			let soll = [3,7,15,1,292,1,1,1,2,1,3,1,14]
			for (index,s) in soll.enumerated() {
				XCTAssert(s == Int(a[index]))
			}
		}
	}
    
    func testExample() {
       let l = BigFloatConstant.pi * BigFloat(100)
		let f = l.FloorDown()
		let s = String(f.significand)
		XCTAssert( s == "314")
    }
	func testMersenne() {
		let ndig = 100
		let p = 77232917
		let m = BigInt(1) << p - 1
		let ten = BigFloat(10)
		let l2 = BigFloat.ln(x: BigFloat(2))
		let l10 = BigFloat.ln(x: BigFloat(10))
		let ppp = BigFloat(p)
		let l = l2 / l10 * ppp
		
		/*
		if l <= Double(count) {
				let ret = pow(10.0,l) - 1.0
				let dig = BigUInt(UInt64(ret))
				return dig
			}
		*/
		
		let frac = l - l.FloorDown()
		let frac2 = frac + BigFloat(ndig-1)
		let ret = BigFloat.pow(x: ten,y: frac2)
		let retf = ret.FloorDown()
		//let dig = retf.asString(10, maxlen: ndig, fix: 0)
		let (dig,fract) = retf.SplitIntFract()
		let digstr = String(dig)
		XCTAssert(digstr == "4673331833592310999883355855611155212513211028177144957985823385935679234805211772074843110997402088")
	}
}
