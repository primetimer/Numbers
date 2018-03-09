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

class DrawTableCell: BaseNrTableCell {
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		LayoutUI()
	}
	
	private func LayoutUI() {
		guard let draw = uidraw else { return }
				draw.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(draw)

		draw.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
		draw.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
		draw.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		draw.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		self.accessoryType = .none
	}
	
	private (set) var isSpecial : Bool = false
	//private (set) var numtester : NumTester? = nil
	
	var uidraw : DrawNrView? = nil {
		willSet {
			uidraw?.removeFromSuperview()
		}
		didSet {
			LayoutUI()
		}
	}
	
	override var expanded: Bool {
		willSet {
			if newValue == true && newValue != expanded {
				uidraw?.isHidden = true
			}
		}
		didSet {
			self.isHidden = !expanded
			if expanded {
				
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100), execute: {
					self.uidraw?.setNeedsDisplay()
					self.uidraw?.isHidden = false
				})
			}
			
		}
	}
	
	var numtester : NumTester? = nil {
		didSet {
			if numtester?.property() != oldValue?.property() {
				uidraw = CreateDrawView()
				uidraw?.setNeedsDisplay()
			}
		}
	}
	
	private func CreateDrawView() -> DrawNrView {
		if numtester is FibonacciTester {
			let ans = SequenceView()
			ans.tester = numtester //FiboView()
			return ans
		}
		if numtester is CompositeTester {
			let faktorview = FaktorView()
			faktorview.param.type = .polygon
			return faktorview
		}
		if numtester is LuckyTester {
			let luckyview = LuckyView()
			return luckyview
		}
		if numtester is TriangleTester {
			return PolygonalView(poly: 3)
		}
		if numtester is SquareTester {
			return PolygonalView(poly: 4)
		}
		if numtester is PentagonalTester {
			return PolygonalView(poly: 5)
		}
		if numtester is HexagonalTester {
			return PolygonalView(poly : 6)
		}
		if numtester is PalindromicTester {
			return PalindromeView()
		}
		if numtester is PrimeTester {
			let ulam = UlamView()
			if nr <= BigUInt(Int64.max) {
				ulam.start = UInt64(nr)
			}
			return ulam
		}
		if numtester is AbundanceTester {
			let faktorview = FaktorView()
			faktorview.param.type = .ulam
			return faktorview
		}
		if numtester is LucasTester {
			return LucasView()
		}
		if numtester is CatalanTester {
			return CatalanView()
		}
		let ans = SequenceView()
		ans.tester = numtester
		return ans
	}

	
	/*
	var type : TableCellType = TableCellType.None {
		didSet {
			if oldValue == type { return }
			switch type {
			case .Fibo:
				uidraw = FiboView()
				numtester = FibonacciTester()
			case .Faktor:
				let faktorview = FaktorView()
				faktorview.param.type = .polygon
				uidraw = faktorview
				numtester = FactorTester()
			case .Lucky:
				let luckyview = LuckyView()
				//faktorview.param.type = .lucky
				uidraw = luckyview
				numtester = LuckyTester()
			case .Triangular:
				uidraw = PolygonalView(poly: 3)
				numtester = TriangleTester()
			case .Square:
				uidraw = PolygonalView(poly: 4)
				numtester = SquareTester()
			case .Pentagonal:
				uidraw = PolygonalView(poly: 5)
				numtester = PentagonalTester()
			case .Hexagonal:
				uidraw = PolygonalView(poly: 6)
				numtester = HexagonalTester()
			case .Palindromic:
				uidraw = PalindromeView()
				numtester = PalindromicTester()
			case .None:
				break
			case .Prime:
				let ulam = UlamView()
				if nr <= BigUInt(Int64.max) {
					ulam.start = UInt64(nr)
					uidraw = ulam
				}
				numtester = PrimeTester()
			case .Abundant:
				let faktorview = FaktorView()
				faktorview.param.type = .ulam
				uidraw = faktorview
				numtester = AbundanceTester()
			case .Lucas:
				uidraw = LucasView()
				numtester = LucasTester()
			case .Catalan:
				uidraw = CatalanView()
				numtester = CatalanTester()
				
			}
			if let test = numtester {
				isSpecial = test.isSpecial(n: nr)
			}
			self.setNeedsDisplay()
		}
	}
	*/

	override var nr : BigUInt {
		didSet {
			if oldValue == nr { return }
			if let test = numtester  {
				isSpecial = test.isSpecial(n: nr)
			}
			if !isSpecial {
				uidraw?.isHidden = true
				return
			}
			if nr.isInt64() {
				uidraw?.SetNumber(UInt64(nr))
			}
			uidraw?.isHidden = false
			uidraw?.setNeedsDisplay()
		}
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

