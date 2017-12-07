//
//  Explain.swift
//  Numbers
//
//  Created by Stephan Jancar on 07.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation

class Explain {
	
	static let shared = Explain()
	
	private var dict : [Int:Explanation] = [:]
	private init() {
		dict[0] = Explanation(nr: 0)
		dict[1] = Explanation(nr: 1)
	}
	
	func GetExplanation(nr : Int) -> Explanation {
		if let ex = dict[nr] {
			return ex
		}
		return Explanation(nr: nr)
	}	
}

class Explanation {
	
	internal (set) var nr : Int
	internal (set) var desc = ""
	internal (set) var latex = ""
	
	init(nr: Int) {
		self.nr = nr
		switch nr {
		case 0:
			Zero()
		case 1:
			One()
		case 2:
			Two()
		case 3:
			Three()
		case 4:
			Four()
		case 5:
			Five()
		case 6:
			Six()
		case 7:
			Seven()
		default:
			desc = String(nr)
		}
	}
	
	private func Zero() {
		nr = 0
		
		desc = desc + "Zero (0) is the first natural number."
		desc = desc + "Zero is the the additive neutral element."
		desc = desc + "\nIf you add zero to any number n, the reuslt is n itself."
		desc = desc + "\nIf you multiply any number by Zero, the result is zero."
		
		latex = "\\forall n \\in \\mathbb{N} : n = n + 0"
	}


	private func One() {
		nr = 1
		desc = "One (1) is the succesor of Zero."
		desc = desc + "\nIf you multiply any number n by One, the result is n itself."
		
		latex = "\\forall n \\in \\mathbb{N} : n = n\\cdot{1}"
	}
	
	private func Two() {
		nr = 2
		
		desc = desc + "Two (2) is the first prime number."
		desc = desc + "\n2 is the smallest prime nummber and the only odd prime number."
		
		latex = latex + "2 = 1 + 1\\\\"
		latex = latex + "n>0, n+n = n\\cdot{n}  \\rightarrow n = 2"
		latex = latex + "\\\\ \\sum_{k=0}^\\infty 1/2^k = 2 "
	}
	
	private func Three() {
		nr = 3
		
		desc = desc + "Three (3) is the first even prime number."
		
		latex = latex + "3 = 1 + 2\\\\"
		latex = latex + "F_0 = 2^{2^{0}} + 1 = 3 \\\\"
		latex = latex + "M_2 = 2^{2} - 1 = 3 \\\\ "
	}
	
	private func Four() {
		nr = 4
		
		desc = desc + "Four (4) is a square number."
		desc = desc + "\nIt is the smallest composite number."
		
		latex = latex + "4 = 2+2 = 2\\cdot{2} = 2^2\\\\"
	}
	
	private func Five() {
		nr = 5
		
		desc = desc + "Five (5) is a prime number."
		desc = desc + "\nFive is a Fibonacci number."
		
		latex = latex + "5 = 2+3 \\\\"
		latex = latex + "F_1 = 2^{2^{1}} + 1"
	}
	
	private func Six() {
		nr = 6
		desc = desc + "Six (6) is the smallest number which is neither a square nor a prime."
		latex = latex + "6 = 1\\cdot{2}\\cdot{3} = 3! \\\\"
		latex = latex + "2^1\\cdot({2^2-1}) = 6 "
	}
	
	private func Seven () {
		nr = 7
		desc = desc + "Seven (7) is a Mersenne prime"
		desc = desc + "\nThe heptagon can not be constructed by ruler and compass"
		
		latex = latex + "7 = M_3 = 2^3 - 1\\\\"
	}
}
