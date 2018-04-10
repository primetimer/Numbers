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

class TestPratt : XCTestCase {
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testRandom() {
		let pratt = PrattTester()
		let prime = PrimeTester()
		for _ in 1 ... 1000 {
			let n = arc4random()
			let pratttest = pratt.isSpecial(n: BigUInt(n))
			let primetest = prime.isSpecial(n: BigUInt(n))
			XCTAssert(pratttest == primetest)
		}

	}
	
	func testPratt() {
		
		let pratt = PrattTester()
		let prime = PrimeTester()
		for n in 2 ... 1000 {
			let pratttest = pratt.isSpecial(n: BigUInt(n))
			let primetest = prime.isSpecial(n: BigUInt(n))
			XCTAssert(pratttest == primetest)
			
		}
		
		do {
			let n = BigUInt(229)
			let p = PrattCertficate(nr: n)
			let cert = p.LatexCertfificate()
			print(cert)
		}
		do {
			let n = BigUInt(7919)
			let p = PrattCertficate(nr: n)
			let cert = p.LatexCertfificate()
			print(cert)
		}
	}
}
