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

/*
protocol LuckyEmitter {
	func EmitLucky(n : Int)
	func StrokeOut(n: Int)
}
class LuckySieve {
	
	var luck: BitArray
	
	private func getNthLucky(g: Int) {
		var index = 1
		while true {
			if luck[index] == false {
				index = index + 1
				
			}
		}
		
	}
	init(count : Int, emitter : LuckyEmitter ) {
		luck = BitArray(count:UInt64(count+1), initval : true)
		emitter.EmitLucky(n: 1)
		for k in stride(from: 2, to: count, by : 2) {
			luck[k] = false
			emitter.StrokeOut(n: k)
		}
		for n in 2...count {
			//Find n-th Lucky
			let g : Int = {
				for k in 1...count {
					if luck[k] {
						return k
					}
				}
				return 0
			}()
			if g == 0 { return }
			emitter.EmitLucky(n: g)
			
			//Stroke out
			let
			let l = 1
			while l <
			while ul
			for l in 1...count {
				
				luck[k] = false
				emitter.StrokeOut(n: k)
			}
				
		}
		
	
		
		
	}
	
	
}

*/

class LuckyArr {
	static public var shared = LuckyArr()
	private (set) var luckyarr : BitArray!
	let maxlucky = 10000
	private (set) var last = 0
	private (set) var completed = false

	//private var asymptotic : Int = 0
	private init() {
		//asymptotic = Int(Double(maxlucky)/log(Double(maxlucky))) + 10
		luckyarr = BitArray(count:UInt64(maxlucky), initval : false)
		let dwi = DispatchWorkItem {
			self.sieving(self.maxlucky)
			self.completed = true
		}
		DispatchQueue.global(qos: .background).async(execute: dwi)
	}
	
	private func emit_result(_ n: Int) {
		luckyarr[n] = true
		last = n
		//print("n:" + String(n) + "\n seq " + String(describing: seq) + "\n count: " + String(describing: count))
	}
	
	private func sieving(_ maxlucky : Int) {
		var seq : [Int] = []
		var count : [Int] = []
		seq = Array(repeating: 0, count: maxlucky)
		count = Array(repeating: 0, count: maxlucky)
		var n = 5;
		seq[1] = 1
		seq[2] = 3
		emit_result(seq[1])
		emit_result(seq[2])
		count[2] = 0;
		var idx = 3;
		while true {
			var pos = 2
			while true {
				if n >= maxlucky {
					return
				}
				if(pos >= idx || seq[pos] > idx){
					// we've run out of numbers to check
					// number is safe
					if idx >= maxlucky {
						return
					}
					seq[idx] = n;
					emit_result(n);
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
			return WikiLinks.shared.getLink(tester: self, n: n)
		}
		return ""
	}
	
	func getLatex(n: BigUInt) -> String? {
		let lcount = Double(n) / Double(log(Double(n)))
		let lstr = String(lcount)
		let latex = "|\\{l_{<=" + String(n) + "} : \\text{l is lucky}\\}| \\sim \\frac{n}{log n} \\approx " + lstr
		return latex
	}
	
	func property() -> String {
		return "lucky"
	}
}

/*
#include <iostream>
#include <vector>
using namespace std;
typedef unsigned long long int ulong;

//======================================================================
// This program generates a b-file for the lucky numbers (A000959)
// Run "lucky <elems>" to print elements 1 through <elems>
// It uses a "virtual sieve" and requires O(<elems>) space
// It runs as fast of faster than an explicit sieving algorithm
int main(int argc, char* argv[])
{
	// Obtain number of elements from command line
	unsigned elems = argc <= 1 ? 10000 : atoi(argv[1]);
	
	// Create a vector for our seive
	vector<ulong> lucky;
	lucky.resize(elems);
	
	// Set and print the first two elements explicitly
	// Indexing from 0 simplifies the computation
	if (elems >= 1)
	{
		lucky[0] = 1;
		cout << "1 1" << endl;
	}
	if (elems >= 2)
	{
		lucky[1] = 3;
		cout << "2 3" << endl;
	}
	
	// g is the largest index with lucky[g] <= n+1
	unsigned g = 0;
	
	// Compute the nth lucky number for 2 <= n <= elems
	for (unsigned n = 2; n < elems; n++)
	{
		// Update g to largest index with lucky[g] <= n+1
		if (lucky[g+1] <= n+1) g++;
		
		// Now we are going to trace the position k of the nth
		// lucky number backwards through the sieving process.
		// k is the nth lucky number, so it is at position n
		// after all the sieves.
		ulong k = n;
		
		// If lucky[i] > n+1, the sieve on lucky[i] does not alter
		// the position of the nth lucky number, that is, does not
		// alter k. So we need to run backwards through the sieves
		// for which lucky[i] <= n+1. The last such sieve is the
		// sieve for lucky[g], by definition of g.
		
		// So, we run backwards through the sieves for lucky[g]
		// down to the sieve for lucky[1] = 3.
		for (unsigned i = g; i >= 1; i--)
		{
			// Here k is the position of the nth lucky number
			// after the sieve on lucky[i]. Adjust the position
			// prior to the sieve on lucky[i].
			k = k*lucky[i]/(lucky[i]-1);
		}
		
		// Here k is the position of the nth lucky number prior to
		// sieve on 3, that is, after the sieve on 2. Adjust the
		// position prior to the sieve on 2.
		k = 2*k;
		
		// Here k is the position of the nth lucky number prior to
		// the sieve on 2, that is, within the natural numbers
		// (1, 2, 3, ...) indexed from 0. So the nth lucky number is
		lucky[n] = k+1;
		
		// Adjust n for 1-indexing and print our new value
		cout << n+1 << " " << lucky[n] << endl;
	}
	
	// And we are done
	return 0;
}
*/
