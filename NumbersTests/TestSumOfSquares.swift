//
//  TetraHedral.swift
//  NumbersTests
//
//  Created by Stephan Jancar on 18.02.18.
//  Copyright © 2018 Stephan Jancar. All rights reserved.
//

import Foundation
import XCTest
import BigInt

@testable import Numbers

class TestSumOfSquares : XCTestCase {
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testSum() {
		let t = SumOfTwoSquaresTester()
		
		do {
			let n0 : BigUInt = 5
			let (a,b) = t.Express(n: n0)!
			let n = Int(a*a+b*b)
			print(a,b,a*a,b*b,String(a*a+b*b),n)
			
			XCTAssert(a*a+b*b == n0)
		}
		do {
			let n0 : BigUInt = 13
			let (a,b) = t.Express(n: n0)!
			let n = Int(a*a+b*b)
			print(a,b,a*a,b*b,a*a+b*b)
			XCTAssert(a*a+b*b == n0)
		}
		do {
			let n0 : BigUInt = 17
			let (a,b) = t.Express(n: n0)!
			let n = Int(a*a+b*b)
			print(a,b,a*a,b*b,a*a+b*b)
			XCTAssert(a*a+b*b == n0)
		}
		do {
			let n0 : BigUInt = 29
			let (a,b) = t.Express(n: n0)!
			let n = Int(a*a+b*b)
			print(a,b,a*a,b*b,a*a+b*b)
			XCTAssert(a*a+b*b == n0)
		}
		do {
			let n0 : BigUInt = 17*29
			let (a,b) = t.Express(n: n0)!
			let n = Int(a*a+b*b)
			print(a,b,a*a,b*b,a*a+b*b, n0)
			XCTAssert(a*a+b*b == n0)
		}
		var m : BigUInt = 29
		while m < 1000 {
			m = m + 4
			if m.isPrime() {
				let (a,b) = t.Express(n: m)!
				let n = Int(a*a+b*b)
				print(a,b,a*a,b*b,a*a+b*b)
				XCTAssert(a*a+b*b == m)
			}
		}
		
		do {
			let n0 : BigUInt = 4195470737
			let (a,b) = t.Express(n: n0)!
			let n = Int(a*a+b*b)
			print(a,b,a*a,b*b,a*a+b*b,n, n0)
			XCTAssert(a*a+b*b == n0)
		}
		for _ in 1...100 {
			let p = BigUInt(arc4random())
			if let(a,b) = t.Express(n: p) {
				let n = Int(a*a+b*b)
				print(a,b,a*a,b*b,a*a+b*b)
				XCTAssert(a*a+b*b == p)
			}
			
		}
	}
}
