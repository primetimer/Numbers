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

class TestConway : XCTestCase {
	
	private var conway : ConwayActive!
	override func setUp() {
		super.setUp()
		conway = ConwayActive.shared
		
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	private func printElems(elems: [ConwayPrimordial]) -> Bool {
		var complete : Bool = true
		var str = ""
		for e in elems {
			if let c = e as? ConwayElem {
				str = str + c.name
			} else {
				str = str + e.src
				complete = false
			}
		}
		print(str)
		return complete
	}
	
	func testBasics() {
		var s = "3" //"121"
		//s = "121"
		//s = "32111"
		/*
		var t = s
		for i in 1...10 {
			t = ConwayElem.LookandSay(look: t)
			print(i,":",t)
		}
		*/
		
		while true {
			let elems = conway.Compose(s: s)
			if printElems(elems: elems) {
				print("Fround for:",s)
				//break
			}
			s = ConwayElem.LookandSay(look: s)
		}
	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}
}
