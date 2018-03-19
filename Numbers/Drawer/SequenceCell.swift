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
		self.accessoryType = .detailDisclosureButton
	}

	private (set) var isSpecial : Bool = false
	lazy var drawcell : DrawTableCell = {
		var d = DrawTableCell()
		d.numtester = numtester
		d.nr = self.nr
		d.isHidden = true
		return d
	}()
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
			if self.expanded {
				drawcell.nr = nr
			}
			
			UpdateUI()
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func UpdateUI() {
		guard let tester = numtester else { return }
		if self.imageView?.image == nil
		{
			let rect = CGRect(x: 0, y: 0, width: 100.0, height: 100.0)
			let drawer = SequenceDrawer(nr : 1, tester : tester, emitter : nil, worker: nil)
			drawer.bgcolor = UIColor.white
			let image = drawer.DrawNrImage(rect: rect)
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

