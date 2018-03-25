//
//  SpokenNumber.swift
//  Numbers
//
//  Created by Stephan Jancar on 11.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt

class SpokenNumber {
	static let shared = SpokenNumber()
	private init() {
		
	}

	let small = ["ze\u{200B}ro", "one", "two", "three", "four", "five", "six", "se\u{200B}ven", "eight", "nine",
				 "ten", "eleven", "twelve", "thir\u{00AD}teen", "four\u{00AD}teen", "fif\u{00AD}teen", "six\u{00AD}teen", "seven\u{00AD}teen",
	"eigh\u{00AD}teen", "nine\u{00AD}teen"]
	
	let tens = [ "", "", "twen\u{00AD}ty", "thir\u{00AD}ty", "for\u{00AD}ty", "fif\u{00AD}ty", "six\u{00AD}ty", "seven\u{00AD}ty", "eigh\u{00AD}ty", "nine\u{00AD}ty" ]
	let bigger = [ "", "thou\u{00AD}sand", "mi\u{00AD}llion", "bi\u{00AD}llion" , "tri\u{00AD}llion", "qua\u{00AD}drillion", "quin\u{00AD}tilion","sex\u{00AD}tillion","sep\u{00AD}tillion","oct\u{00AD}illion","No\u{00AD}nillion","De\u{00AD}cillion","Undecillion",   "Duo\u{00AD}decillion","Tre\u{00AD}decillion","Quattuor\u{00AD}decillion","Quin\u{00AD}decillion","Sex\u{00AD}decillion","Septen\u{00AD}decillion","Octo\u{00AD}decillion","Novem\u{00AD}decillion","Vigin\u{00AD}tillion"]
	let hundred = "hun\u{00AD}dred"
	let soft = "\u{00AD}"
	func spoken(n: BigUInt) -> String {
		if n < 20 { return small[Int(n)] }
		if n < 100 {
			var str = tens[Int(n) / 10]
			if n % 10 > 0 {
				str = str + soft + small[Int(n) % 10]
			}
			return str
		}
		if n < 1000 {
			var ans = small[Int(n) / 100] + " " + soft + hundred
			if n % 100 > 0 {
				ans = ans + " and " + spoken(n: n % 100)
			}
			return ans
		}
		
		var (divisor,pot) = (BigUInt(1),0)
		while n / (1000*divisor) > 0 {
			divisor = divisor * 1000
			pot += 3
		}
		let nn = n / divisor
		var ans = spoken(n: nn) + " " + bigger[pot/3]
		if n % divisor > 0 {
			ans = ans + ", " + spoken(n: n % divisor)
		}
		return ans
	}
}
