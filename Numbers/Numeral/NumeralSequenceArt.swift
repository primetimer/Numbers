//
//  DescCell.swift
//  Numbers
//
//  Created by Stephan Jancar on 01.01.18.
//  Copyright © 2018 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit
import BigInt

class NumeralSequenceArtCell: BaseNrTableCell {
	private (set) var uiart = UIWordCloudView()
	override func setNeedsLayout() {
		uiart.DrawCloud()
	}
	private var refresh = true
	var tester : NumTester? = nil {
		didSet {
			if oldValue == nil {
				refresh = true
			}
			if tester == nil {
				return
			}
			if tester?.property() == oldValue?.property() {
				refresh = true
			}
		}
	}
	
	override var nr : BigUInt {
		didSet {
			if nr == oldValue && refresh == false {
				return
			}
			refresh = false
			CreateArt()
		}
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		uiart.translatesAutoresizingMaskIntoConstraints = false
		self.selectionStyle = .none
		//uiart.contentMode = .center
		contentView.addSubview(uiart)
		LayoutUI()
	}
	
	private func LayoutUI() {
		//contentView.translatesAutoresizingMaskIntoConstraints = false
		if expanded {
			self.accessoryType = .none
		} else {
			self.accessoryType = .disclosureIndicator
		}
		
		uiart.leadingAnchor.constraint (equalTo: contentView.leadingAnchor,constant: 0.0).isActive = true
		uiart.trailingAnchor.constraint (equalTo: contentView.trailingAnchor,constant: 0.0).isActive = true
		uiart.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 0.0).isActive = true
		uiart.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 0.0).isActive = true
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func CreateArt()
	{
		let sequencecount = 10
		uiart.Clear()
		guard let tester = self.tester else { return }
		let sequencer = NumberSequencer(tester: tester)
		let sequence = sequencer.Neighbor(n: self.nr, count: sequencecount)
		for n in sequence {
			uiart.AppendString(s: String(n))
		}
		if sequence.count < sequencecount {
			let first = sequencer.StartSequence(count: sequencecount)
			for n in first {
				uiart.AppendString(s: String(n))
			}
		}
		uiart.DrawCloud()
	}
}

