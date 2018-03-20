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
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	
	var uidraw : DrawNrView? = nil {
		willSet {
			uidraw?.removeFromSuperview()
		}
		didSet {
			LayoutUI()
		}
	}
	override var isHidden: Bool {
		willSet {
			self.uidraw?.isHidden = newValue
		}
	}
	
	var numtester : NumTester? = nil {
		didSet {
			if oldValue?.property() != numtester?.property() {
				uidraw = CreateDrawView()
				uidraw?.tester = numtester
				uidraw?.isHidden = true
			}
		}
	}
	private func CreateDrawView() -> DrawNrView {
		//return PolygonalView(poly: 6)
		//return DebugView()
		//return FibonacciSequenceView()
		//return CatalanView()
		//return ConstructibleView()
		if numtester is PrimeTester {
			let ulam = SequenceView()
			return ulam
		}
		if numtester is FibonacciTester {
			let ans = FiboView() //FibonacciSequenceView() //FiboView?
			return ans
		}
		if numtester is LucasTester {
			return FiboView() //LucasView()
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
		
		if numtester is AbundanceTester {
			let faktorview = FaktorView()
			faktorview.param.type = .ulam
			return faktorview
		}
		
		if numtester is CatalanTester {
			return CatalanView()
		}
		if numtester is MathConstantTester {
			return PiView()
		}
		if numtester is ConstructibleTester {
			return ConstructibleView()
		}
		let ans = SequenceView()
		return ans
	}

	override var nr : BigUInt {
		didSet {
			if oldValue == nr { return }
			if nr.isInt64() {
				uidraw?.nr = UInt64(nr)
			}
			uidraw?.setNeedsDisplay()
		}
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

