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

class SequenceCell: BaseNrTableCell {
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		CreateConstraints()
		self.accessoryType = .detailDisclosureButton
	}
	
	private func CreateConstraints() {
		#if false
		uilabel.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(uilabel)
		uilabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
		uilabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
		uilabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		uilabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		#endif
	}
	
	//private (set) var uilabel = UILabel()
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
		guard let tester = numtester else { return }
		if nr < BigUInt(Int32.max) && self.imageView?.image == nil
		{
			let rect = CGRect(x: 0, y: 0, width: 100.0, height: 100.0)
			let drawer = SequenceDrawer(rect: rect, tester: tester, nr: UInt64(nr))
			drawer.bgcolor = UIColor.white
			let image = drawer.draw()
			self.imageView?.backgroundColor = UIColor.white
			self.imageView?.image = image
		}
		if isSpecial {
			textLabel?.text = tester.property()
		} else {
			textLabel?.text = "not " + tester.property()
		}
		let oeis = OEIS.shared.OEISNumber(key: tester.property())
		self.detailTextLabel?.text = oeis
	}
}

