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

class TetraHedral : XCTestCase {
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testTetraHedral() {
		let t = TetrahedralTest()
		
		do {
			var lasttn = BigUInt(0)
			for n in 1...20 {
				let tn = n * (n+1) * (n+2) / 6
				let nr = BigUInt(tn)
				let isspecial = t.isSpecial(n: nr)
				if isspecial == false {
					print("Error:", n)
				}
				XCTAssert(isspecial == true)
				
				if lasttn > 0 {
					while lasttn < tn {
						let isspecialfalse = t.isSpecial(n: lasttn)
						XCTAssert(isspecialfalse == false)
						lasttn = lasttn + 1
					}
				}
				lasttn = nr + 1
				
				
			}
		}
		
		do {
			let tn = "101000682657062706"
			let nr = BigUInt(tn)! / BigUInt(6)
			let isspecial = t.isSpecial(n: nr)
			XCTAssert(isspecial == true)
			
			let isspecial1 = t.isSpecial(n: nr-1)
			XCTAssert(isspecial1 == false)
			
			let isspecial2 = t.isSpecial(n: nr+1)
			XCTAssert(isspecial2 == false)
		}
		do {
			let tn = "1000000000000000000"
			let nr = BigUInt(tn)!
			let isspecial = t.isSpecial(n: nr)
			XCTAssert(isspecial == false)
		}
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct results.
	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}
}
