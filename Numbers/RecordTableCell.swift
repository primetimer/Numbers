//
//  ViewController.swift
//  Numbers
//
//  Created by Stephan Jancar on 03.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import UIKit
import iosMath
import BigInt
import PrimeFactors
import YouTubePlayer
import GhostTypewriter

class RecordTableCell : BaseNrTableCell {
	
	private (set) var uitypewriter = TypewriterLabel()
	private var uiscrollv = UIScrollView()	
	var tester : RecordTester? = nil
	
	//var tableparent : UITableView? = nil
	//internal var expanded : Bool = false
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.accessoryType = .none
		
		/*
		for family in UIFont.familyNames
		{
		print("\(family)")
		for names: String in UIFont.fontNames(forFamilyName: family)
		{
		print("== \(names)")
		}
		}
		*/
		
		//uitypewriter.font = UIFont(name: "symbola", size: 12)
		//let font = UIFont(name: "1942report", size: 20)
		let font = UIFont(name: "courier", size: 20)
		uitypewriter.font = font
		
		uitypewriter.numberOfLines = 0
		
		uitypewriter.translatesAutoresizingMaskIntoConstraints = false
		uiscrollv.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(uiscrollv)
		uiscrollv.addSubview(uitypewriter)
		
		uiscrollv.leadingAnchor.constraint (equalTo: contentView.leadingAnchor, constant : 10.0).isActive = true
		uiscrollv.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant : -10.0 ).isActive = true
		uiscrollv.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 0.0).isActive = true
		uiscrollv.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 0.0).isActive = true
		uiscrollv.contentSize = CGSize(width: contentView.width, height: 1000.0)
		
		uitypewriter.leftAnchor.constraint (equalTo: uiscrollv.leftAnchor,constant: 0.0).isActive = true
		uitypewriter.topAnchor.constraint(equalTo: uiscrollv.topAnchor,constant: 0.0).isActive = true
		//uitypewriter.heightAnchor.constraint(equalTo: uiscrollv.heightAnchor).isActive = true
		uitypewriter.widthAnchor.constraint(equalTo: uiscrollv.widthAnchor).isActive = true
		
		//uitypewriter.heightAnchor.constraint(equalToConstant: 1000.0).isActive = true
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override var nr : BigUInt {
		didSet {
			print(nr,oldValue)
			if nr != oldValue {
				DisplayRecord()
			}
		}
	}
	
	private func DisplayRecord()
	{
		uitypewriter.text = nil
		if let tester = self.tester as? RecordTester {
			if let record = RecordChecker.shared.getInfo(tester: tester, nr: nr) {
				uitypewriter.text = record.info + record.value
				uitypewriter.startTypewritingAnimation(completion: nil)
			}
		}
		else { //Check all}
			if let record = RecordChecker.shared.getRecordInfo(nr: nr, notifier: nil) {
				uitypewriter.text = record.info + record.value
				uitypewriter.startTypewritingAnimation(completion: nil)
			}
		}
	}
}


