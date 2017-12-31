//
//  LuckyTester.swift
//  Numbers
//
//  Created by Stephan Jancar on 28.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt
import PrimeFactors

class LuckyArr {
	static public var shared = LuckyArr()
	private (set) var luckyarr : BitArray!
	let QMAX = 40000
	private (set) var last = 0
	
	fileprivate let queue = OperationQueue()

	private init() {
		luckyarr = BitArray(count:UInt64(QMAX*100), initval : false)
		let blockOperation = BlockOperation()
		blockOperation.addExecutionBlock {
			self.sieving()
		}
		queue.addOperation(blockOperation)
	}
	private func emit_result(_ n: Int) {
		luckyarr[n] = true
		last = n
		//print(n)
	}
	
	func sieving()	{
		var seq : [Int] = []
		var count : [Int] = []
		seq = Array(repeating: 0, count: QMAX)
		count = Array(repeating: 0, count: QMAX)
		
		var n = 5;
		seq[1] = 1
		seq[2] = 3
		emit_result(seq[1])
		emit_result(seq[2])
		count[2] = 0;
		var idx = 3;
		while idx < QMAX {
			var pos = 2;
			while true {
				if(pos >= idx || seq[pos] > idx){
					// we've run out of numbers to check
					// number is safe
					emit_result(n);
					seq[idx] = n;
					count[idx] = 0;
					n += 2;
					idx = idx + 1
					break;
				} else if (count[pos] == 0) {
					// this has been killed by seq[pos]
					// move to the next n
					n += 2;
					count[pos] = seq[pos]-1;
					break;
				}
				count[pos] = count[pos] - 1
				pos = pos + 1
			}
		}
	}
	
	/*
	private func compute() {
		let a = luckyarr!
		var remove = 2
		while true {
			var k = 0
	
			for j : Int in 1..<Int(maxvalue) {
				if a[j] == true {
					k = k + 1
					if k == remove {
						a[j] = false
						k = 0
					}
				}
			}
			for j in remove+1..<Int(maxvalue)
			{
				if a[j] == true {
					remove = j
					break
				}
			}
			if remove >= maxvalue / 2 {
				break
			}
		}
	}
	*/
	
	func test(n: Int) -> Bool {
		let ans = luckyarr[n]
		return ans
	}
}

class LuckyTester : NumTester {
	
	func isSpecial(n: BigUInt) -> Bool {
		if n >= LuckyArr.shared.last {
			return false
		}
		let ans = LuckyArr.shared.test(n: Int(n))
		return ans
	}
	
	func getDesc(n: BigUInt) -> String? {
		if isSpecial(n: n) {
			return String(n) + " is a lucky number"
		}
		return ""
	}
	
	func getLatex(n: BigUInt) -> String? {
		return ""
	}
	
	func property() -> String {
		return "Lucky"
	}
}
