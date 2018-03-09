//
//  DrawCell.swift
//  Numbers
//
//  Created by Stephan Jancar on 17.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit
import BigInt


/*
extension Tester {
	static var propertymap : [String:TableCellType] = [
		PrimeTester().property():		.Prime,
		CompositeTester().property():	.Faktor,
		FibonacciTester().property():	.Fibo,
		TriangleTester().property():	.Triangular,
		SquareTester().property():		.Square,
		PentagonalTester().property():	.Pentagonal,
		HexagonalTester().property():	.Hexagonal,
		PalindromicTester().property():	.Palindromic,
		AbundanceTester().property():	.Abundant,
		LucasTester().property():		.Lucas,
		CatalanTester().property():		.Catalan,
		LuckyTester().property():		.Lucky
	]
	
	func DrawCellType(property : String) -> TableCellType? {
		if let type = Tester.propertymap[property] {
			return type
		}
		return nil
	}
}
extension NumTester {
	func DrawCellType() -> TableCellType? {
		return Tester.shared.DrawCellType(property: self.property())
	}
}

enum TableCellType : Int {
	case None = -1
	case Prime = 0
	case Fibo = 1
	case Triangular = 2
	case Square = 3
	case Pentagonal = 4
	case Hexagonal = 5
	case Palindromic = 6
	case Abundant = 7
	case Faktor = 8
	case Lucas = 9
	case Catalan = 10
	case Lucky = 11
	
	static let allValues : [TableCellType] = [Faktor,Palindromic,Prime,Fibo,Triangular,Square,Pentagonal,Hexagonal,Abundant,Lucas,Catalan,Lucky]
}
*/

class SequenceCell: BaseNrTableCell {
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		CreateConstraints()
		self.accessoryType = .detailDisclosureButton
	}
	
	private func CreateConstraints() {
		uilabel.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(uilabel)
		uilabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
		uilabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
		uilabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		uilabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
	}
	
	private (set) var uilabel = UILabel()
	private (set) var isSpecial : Bool = false
	
	var numtester : NumTester? = nil {
		didSet {
			isSpecial = numtester?.isSpecial(n: nr) ?? false
			UpdateUI()
		}
	}
	
	override var nr : BigUInt {
		didSet {
			if nr == oldValue { return }
			isSpecial = numtester?.isSpecial(n: nr) ?? false
			UpdateUI()
		}
	}
	override var expanded: Bool {
		didSet {
			self.isHidden = !expanded
		}
	}
	

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func UpdateUI() {
		self.isHidden = !isSpecial
		let p = numtester?.property() ?? ""
		if isSpecial {
			uilabel.text = p
		} else {
			uilabel.text = "not " + p
		}

	}
}

