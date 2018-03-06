//
//  Tester.swift
//  Numbers
//
//  Created by Stephan Jancar on 10.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt
import PrimeFactors

protocol NumberSequencerProt {
	func Next(n: BigUInt) -> BigUInt?
	func Prev(n: BigUInt) -> BigUInt?
	func StartSequence(count : Int) -> [BigUInt]
	func Neighbor(n: BigUInt,count : Int) -> [BigUInt]
}

class PrimeSequence : NumberSequencer {
	let start = [2,3,5,7,11,13,17,19,23,29,31]
	init() {
		super.init(tester: PrimeTester())
	}
	
	override func StartSequence(count: Int) -> [BigUInt] {
		if count >= start.count {
			return super.StartSequence(count: count)
		}
		var ans : [BigUInt] = []
		for n in start {
			ans.append(BigUInt(n))
		}
		return ans
	}
}

class NumberSequencer : NumberSequencerProt {
	private let tester : NumTester!
	init(tester : NumTester) {
		self.tester = tester
	}
	
	func Neighbor(n: BigUInt, count: Int) -> [BigUInt] {
		var ans : [BigUInt] = []
		if tester.isSpecial(n: n) {
			ans.append(n)
		}
		var nn : BigUInt = n
		for _ in 0..<count {
			guard let next = Next(n: nn) else { return ans }
			ans.append(next)
			nn = next
		}
		return ans
	}
	
	private let distance = 200
	func Next(n: BigUInt) -> BigUInt? {
		for i in 1...distance {
			let p = n + BigUInt(i)
			if tester.isSpecial(n: p) {
				return p
			}
		}
		return nil
	}
	
	func Prev(n: BigUInt) -> BigUInt? {
		for i in 1...distance {
			if n >= BigUInt(i) {
				let p = n - BigUInt(i)
				if tester.isSpecial(n: p) {
					return p
				}
			}
		}
		return nil
	}
	
	func StartSequence(count: Int) -> [BigUInt] {
		let ans = Neighbor(n: BigUInt(0), count: count)
		return ans
	}
}


