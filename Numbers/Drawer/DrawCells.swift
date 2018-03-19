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
	
	enum SelectionMode { case none, expand, expandall}
	private var selectionmode = SelectionMode.none {
		didSet {
			SetSelectionMode()
		}
	}
	private var artcell = TesterArtCell()
	private var scells : [SequenceCell] = []
	private let dummycell = UITableViewCell()
	
	init() {
		for t in Tester.shared.complete {
			let seqcell = SequenceCell()
			seqcell.expanded = false
			seqcell.isHidden = true
			seqcell.numtester = t
			scells.append(seqcell)
		}
	}
	
	var count : Int {
		get { return 2*scells.count+1 }
	}
	
	private func SetSelectionMode() {
		switch selectionmode {
		case .none:
			artcell.expanded = false
			artcell.accessoryType = .disclosureIndicator
			for s in scells {
				s.isHidden = true
				s.expanded = false
				s.drawcell.isHidden = true
			}
		case .expand:
			artcell.expanded = true
			artcell.accessoryType = .disclosureIndicator
			for s in scells {
				if s.numtester?.isSpecial(n: self.nr) == true {
					s.isHidden = false
				} else if !s.expanded {
					s.isHidden = true
					s.expanded = false
					s.drawcell.isHidden = true
				}
			}
		case .expandall:
			artcell.expanded = true
			artcell.accessoryType = .none
			for s in scells {
				s.isHidden = false
			}
		}
	}
	
	func NextSelectionMode() {
		switch selectionmode {
		case .none:
			selectionmode = .expand
		case .expand:
			selectionmode = .expandall
		case .expandall:
			selectionmode = .none
		}
	}
	
	func Select(row : Int) {
		if row == 0 {
			NextSelectionMode()
			/*
				//Expand all property cells and hide all drawcells
			if artcell.expanded == false {
				artcell.expanded = true
				for s in scells {
					s.isHidden = false
					s.expanded = false
					s.drawcell.isHidden = true
				}
			} else {
				artcell.expanded = false
				for s in scells {
					s.isHidden = true
					s.expanded = false
					s.drawcell.isHidden = true
				}
			}
			return
			*/
		}
		if let s = getCell(row: row) as? SequenceCell {
			if s.expanded == false {
				s.expanded = true
				s.drawcell.isHidden = false
				s.drawcell.nr = nr
			} else {
				s.expanded = false
				s.drawcell.isHidden = true
			}
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
			return scells[sindex]
		}
		if let dindex = DrawIndex(row: row) {
			return scells[dindex].drawcell
		}
		assert(false)
		return dummycell
	}

	func getRowHeight(row: Int) -> CGFloat {
		var height = CGFloat(30)
		let cell = getCell(row: row)
		if cell.isHidden { return 0.0 }
		
		if let cell = cell as? TesterArtCell {
			let h = cell.expanded ? cell.contentView.width : 150.0
			return h
		}
		if let _ = cell as? SequenceCell {
			return height + 20
		}
		if let cell = cell as? DrawTableCell {
			height = cell.width
		}
		return height + 10.0
	}

	var nr : BigUInt = 0 {
		didSet {
			if nr == oldValue { return }
			artcell.nr = nr
			for s in scells {
				s.nr = nr
			}
			SetSelectionMode()
		}
	}
}


