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
			//print(i,str)
		}
		let d19 = Double(h1) / Double(k1)
		let d19_2 = d19*d19
		XCTAssert(abs(d19_2-19.0) <= 0.0000000001)
	}
	
	func testcompouteSquareroot() {
		
		let f = BigFloat(5)
		let f2 = BigFloat.sqrt(x: f)
		let a = ContinuedFractions.shared.getSeries(value: f2)
		for i in 1...10 {
			let (n,d) = ContinuedFractions.shared.ValueRational(seq: a, count: i)
			let approx = BigFloat(BigInt(n)) / BigFloat(BigInt(d))
			
			let s = approx.asString(10, maxlen: 10, fix: 10)
			//let approx2 = approx * approx
			//let s2 = approx2.asString(10, maxlen: 10, fix: 10)
			print(i,String(n),String(d),s)
		}
		/*
		var a: [BInt] = []
		let n = 5
		let bf2 = BigFloat.sqrt(x: BigFloat(n))
		var (a0,x) = (BigInt(0),bf2)
		for _ in 0...10 {
			(a0,x) = x.SplitIntFract()
			a.append(Int(a0))
			print(a)
			x = BigFloat(1) / x
		}
		*/
		
		
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
		
		print(dig)
	}
    
	
    
}
