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

extension NumTester {
	
	func CreateDrawView() -> DrawNrView {
		if self is PrimeTester {
			return PrattView()
			let ulam = SequenceView()
			return ulam
		}
		if self is AudioActiveTester {
			let ans = ConwayView()
			return ans
		}
		if self is FibonacciTester {
			let ans = FiboView() //FibonacciSequenceView() //FiboView?
			return ans
		}
		if self is LucasTester {
			return FiboView() //LucasView()
		}
		if self is CompositeTester {
			let faktorview = FaktorView()
			faktorview.param.type = .polygon
			return faktorview
		}
		if self is LuckyTester {
			let luckyview = LuckyView()
			return luckyview
		}
		if self is TriangleTester {
			return PolygonalView(poly: 3)
		}
		if self is SquareTester {
			return PolygonalView(poly: 4)
		}
		if self is PentagonalTester {
			return PolygonalView(poly: 5)
		}
		if self is HexagonalTester {
			return PolygonalView(poly : 6)
		}
		if self is PalindromicTester {
			return PalindromeView()
		}
		if self is PlatonicTester {
			return PlatonicView()
		}
		if self is DullTester {
			return DullView()
		}
		
		if self is AbundanceTester {
			let faktorview = FaktorView()
			faktorview.param.type = .ulam
			return faktorview
		}
		
		if self is CatalanTester {
			return CatalanView()
		}
		if self is MathConstantTester {
			return PiView()
		}
		if self is ConstructibleTester {
			return ConstructibleView()
		}
		let ans = SequenceView()
		return ans
	}

}

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
	
	var numtester : NumTester? = nil {
		didSet {
			if oldValue?.property() != numtester?.property() {
				self.uidraw = numtester?.CreateDrawView()
				self.uidraw?.tester = numtester
				//uidraw?.isHidden = true
			}
		}
	}
	
	override var nr : BigUInt {
		didSet {
			if oldValue == nr { return }
			uidraw?.nr = nr
			uidraw?.setNeedsDisplay()
		}
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

