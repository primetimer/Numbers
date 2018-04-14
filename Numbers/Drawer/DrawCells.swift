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


extension PropertyCells {
	
	private func contains(list : [UITableViewCell], cell : UITableViewCell) -> Bool {
		for rowcell in list {
			if rowcell === cell {
				return true
			}
		}
		return false
	}
	
	private func NeedShow(cell: PropertyCell) -> Bool {
		if selectionmode == .none { return false }
		if selectionmode == .expandall { return true }
		if cell.expanded { return true }
		if cell.isSpecial == nil { return true }
		return cell.isSpecial!
	}
	
	private func Path(_ row: Int) -> IndexPath {
		return IndexPath(row: row, section: NrViewSection.DrawNumber.rawValue)
	}
	
	func ComputeShownRows(tv: UITableView) {
		tv.beginUpdates()
		var newdraw : [UITableViewCell] = []
		for cell in scells {
			if NeedShow(cell: cell) {
				newdraw.append(cell)
				if cell.expanded {
					newdraw.append(cell.formulacell)
					newdraw.append(cell.drawcell)
				}
			}
		}
		
		#if true
		for i in 0..<newdraw.count {
			var debugstr = "newdraw:" + String(i)
			if let cell = newdraw[i] as? PropertyCell {
				debugstr = debugstr + cell.numtester!.property()
			}
			print(debugstr)
		}
		#endif
		
		//Delete Unused Rows
		var deleteIndices : [IndexPath] = []
		for (index,prev) in drawrows.enumerated() {
			if !contains(list: newdraw,cell: prev) {
				let delpath = Path(index+1)
				deleteIndices.append(delpath)
				#if true
				var debugstr = "Delete : " + String(index)
				if let scell = prev as? PropertyCell {
					debugstr = debugstr + scell.numtester!.property()
				}
				print(debugstr)
				#endif
			}
		}
		/* for row in deleteIndices {
			drawrows.remove(at: row.row)
		}
		*/
		tv.deleteRows(at: deleteIndices, with: .automatic)
		
		//Insert New Rows
		for (index,new) in newdraw.enumerated() {
			if !contains(list: drawrows, cell: new) {
				let inspath = Path(index+1)
				
				#if true
				var debugstr = "Insert : " + String(index)
				if let scell = new as? PropertyCell {
					debugstr = debugstr + scell.numtester!.property()
				}
				print(debugstr)
				#endif
				tv.insertRows(at: [inspath], with: .automatic)
			}
		}
		
		//Finished
		drawrows = newdraw
		tv.endUpdates()
	}
}

class PropertyCells {
	
	private var drawrows : [UITableViewCell] = []
	//rivate var tv : UITableView? = nil
	
	enum SelectionMode { case none, expand, expandall}
	private var selectionmode = SelectionMode.none {
		didSet {
			SetSelectionMode()
		}
	}
	private var artcell = TesterArtCell()
	private var scells : [PropertyCell] = []
	private let dummycell = UITableViewCell()
	
	var tv : UITableView? = nil
	init() {
		for t in Tester.shared.testers {
			let seqcell = PropertyCell()
			seqcell.expanded = false
			//seqcell.isHidden = true
			seqcell.numtester = t
			scells.append(seqcell)
		}
	}
	
	var count : Int {
		
		get {
			if selectionmode == .none { return 1 }
			return drawrows.count + 1
		}
	}
	
	private func SetSelectionMode() {
		switch selectionmode {
		case .none:
			artcell.expanded = false
			artcell.accessoryType = .disclosureIndicator
			for s in scells {
				//s.isHidden = true
				s.expanded = false
				//s.drawcell.isHidden = true
			}
		case .expand:
			artcell.expanded = true
			artcell.accessoryType = .disclosureIndicator
			/*
			for s in scells {
				if s.numtester?.isSpecial(n: self.nr) == true {
					s.isHidden = false
				} else if !s.expanded {
					s.isHidden = true
					s.expanded = false
					s.drawcell.isHidden = true
				}
			}
			*/
		case .expandall:
			artcell.expanded = true
			artcell.accessoryType = .none
			/*
			for s in scells {
				guard let tester = s.numtester else { continue }
				if tester.issubTester() && !tester.isSpecial(n: self.nr) {
					s.isHidden = true
				} else {
					s.isHidden = false
				}
			}
			*/
		}
		if let tv = self.tv {
			ComputeShownRows(tv: tv)
		}
	}
	
	func NextSelectionMode(tv: UITableView) {

		switch selectionmode {
		case .none:			
			selectionmode = .expand
			//tv.insertRows(at: indices, with: .automatic)
		case .expand:
			selectionmode = .expandall
		case .expandall:
		
			selectionmode = .none
			//tv.deleteRows(at: indices, with: .automatic)
		}
		ComputeShownRows(tv: tv)
	}
	
	func Select(row : Int, tv: UITableView) {
		if row == 0 {
			NextSelectionMode(tv: tv)
		}
		if let s = getCell(tv: tv, row: row) as? PropertyCell {
			if s.expanded == false {
				s.expanded = true
				//s.drawcell.isHidden = false
				s.drawcell.nr = nr
			} else {
				s.expanded = false
				//s.drawcell.isHidden = true
			}
		}
		
		ComputeShownRows(tv: tv)
	}
	/*
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
	*/
	
	func getCell(tv: UITableView, row : Int) -> UITableViewCell {

		if row == 0 { return artcell }
		return drawrows[row-1]
	}

	func getRowHeight(tv: UITableView, row: Int) -> CGFloat {
		var height = CGFloat(30)
		let cell = getCell(tv: tv,row: row)
		/*
		if cell.isHidden {
			assert(false)
			return 0.0
		}
		*/
		
		if let cell = cell as? TesterArtCell {
			let h = cell.expanded ? cell.contentView.width : 150.0
			return h
		}
		if let cell = cell as? PropertyCell {
			//return cell.getRowHeight()
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


