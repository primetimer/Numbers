//
//  NumberModel.swift
//  Numbers
//
//  Created by Stephan Jancar on 23.03.18.
//  Copyright © 2018 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt

class NumberModel {
	
	static let shared = NumberModel()
	private init() {
		currnr = BigUInt(initialnumber)
	}
	private let initialnumber = 229 //1112
	var currnr : BigUInt
}
