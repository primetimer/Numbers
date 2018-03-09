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

class DrawingCells {
	private var artcell = TesterArtCell()
	private var dcells : [DrawTableCell?] = []
	private var scells : [SequenceCell] = []
	
	init() {
		#if false
			let scell = SequenceCell()
			scell.numtester = FibonacciTester()
			scells.append(scell)
			let dcell = DrawTableCell()
			dcell.numtester = FibonacciTester()
			dcell.expanded = false
			dcells.append(dcell)
			#else
		for t in Tester.shared.complete {
			let seqcell = SequenceCell()
			seqcell.numtester = t
			scells.append(seqcell)
			
			let dcell = DrawTableCell()
			dcell.numtester = t
			dcells.append(dcell)
			dcell.expanded = false
		}
		#endif
	}
	
	private var expanded : Bool = false
	var count : Int {
		get { return 2*scells.count+1 }
	}
	
	func Select(row : Int) {
		let cell = getCell(row: row)
		if let cell = cell as? TesterArtCell {
			if cell.expanded {
				CollapseCells()
			} else {
				ExpandCells()
			}
		}
		
		if let sindex = SequenceIndex(row: row) {
			SelectRow(index: sindex)
		}
	}
	//Neue Fassung
	
	private func SelectRow(index : Int) {
		for (i,dcell) in dcells.enumerated() {
			if i == index && dcell != nil {
				dcell?.expanded = !(dcell!.expanded)
			} else {
				dcell?.expanded = false
			}
		}
	}
	private func ExpandCells() {
		artcell.expanded = true
		for cell in scells {
			cell.expanded = true
		}
		for cell in dcells {
			cell?.expanded = false
		}
	}
	private func CollapseCells() {
		artcell.expanded = false
		for cell in scells {
			cell.expanded = false
		}
		for cell in dcells {
			cell?.expanded = false
		}
	}
	
	private func SequenceIndex(row : Int) -> Int? {
		if row == 0 { return nil }
		if row % 2 == 0 { return nil }
		return row / 2
	}
	private func DrawIndex(row : Int) -> Int? {
		if row == 0 { return nil }
		if row % 2 == 1 { return nil }
		return row / 2 - 1
	}
	func getCell(row : Int) -> UITableViewCell {
		if row == 0 { return artcell }
		if let sindex = SequenceIndex(row: row) {
			print ("row", row, "sindex", sindex, scells[sindex].numtester?.property())
			return scells[sindex]
		}
		if let dindex = DrawIndex(row: row) {
			print ("row", row, "dindex", dindex, dcells[dindex]?.numtester?.property())
			if let ans = dcells[dindex] {
				return ans
			}
		}
		let dummycell = DrawTableCell()
		return dummycell
	}
		/*
	func getCell(row : Int) -> UITableViewCell {
		if row == 0 { return artcell }
		
		return scells[row-1]
	}
	*/
		
	func getRowHeight(row: Int) -> CGFloat {
		var height = CGFloat(30)
		let cell = getCell(row: row)
		if cell.isHidden { return 0.0 }
		
		if cell is TesterArtCell {
			let h = expanded ? cell.contentView.width : 150.0
			return h
		}
		if let cell = cell as? SequenceCell {
			return height + 10
		}
		if let cell = cell as? DrawTableCell {
			height = cell.width
		}
		return height + 10.0
	}
	
	//private var _nr : BigUInt = 0
	var nr : BigUInt = 0 {
		didSet {
			if nr != oldValue {
				artcell.nr = nr
				for s in scells {
					s.nr = nr
					//s.isHidden = s.numtester?.isSpecial(n: nr) ?? true
				}
				for c in dcells {
					c?.nr = nr
					//c?.isHidden = c?.numtester?.isSpecial(n: nr) ?? true
				}
			}
		}
	}
}


