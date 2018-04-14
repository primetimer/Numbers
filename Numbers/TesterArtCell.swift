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

class TesterArtCell : BaseNrTableCell, NumTesterEmission {
	
	
	private (set) var uiart = UIWordCloudView()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.selectionStyle = .none
		uiart.translatesAutoresizingMaskIntoConstraints = false
		contentView.autoresizingMask = [.flexibleHeight , .flexibleRightMargin ]
		contentView.addSubview(uiart)
		Constraints()
		
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		uiart.DrawCloud()
	}
	
	private func Constraints() {
		uiart.leadingAnchor.constraint (equalTo: contentView.leadingAnchor,constant: 0.0).isActive = true
		uiart.trailingAnchor.constraint (equalTo: contentView.trailingAnchor,constant: 0.0).isActive = true
		uiart.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 0.0).isActive = true
		uiart.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 0.0).isActive = true
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func NotifySpecial(t: NumTester, nr: BigUInt, special: Bool) {
		if special {
			uiart.AppendString(s: t.propertyString())
			uiart.DrawCloud()
		}

		
	}
	
	//private var testworker : [DispatchWorkItem] = []
	private func CreateTesterArt(n : BigUInt)
	{
		uiart.Clear()
		//testworker?.cancel()
		for t in Tester.shared.completetesters {
			let worker = TesterCache.shared.isSpecialAsync(tester: t, n: n, notify: self)
			/*
			if TesterCache.shared.isSpecial (tester: t, n: n) {
				uiart.AppendString(s: t.propertyString())
			}
			*/
		}
		uiart.DrawCloud()
	}
	
	override var nr : BigUInt {
		didSet {
			if nr != oldValue {
				CreateTesterArt(n: nr)
			}
		}
	}
}
