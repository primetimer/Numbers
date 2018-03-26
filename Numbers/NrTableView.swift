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
import SafariServices
import BigFloat
import GhostTypewriter

enum NrViewSection : Int {
	case Numerals = 0
	case Formula = 2
	case DrawNumber = 1
	case Wiki = 3
	case NumberPhile = 4
}

class NrTableView : UITableView , UITableViewDelegate , UITableViewDataSource {
	private let headerId = "headerId"
	private let footerId = "footerId"
	//private let desccellId = "desccellId"
	private let recordCellId = "recordcellId"
	private let formcellId = "formcellId"
	private let wikicellId = "wikicellId"
	private let oeiscellId = "oeiscellId"
	private let tubecellId = "tubecellId"
	
	static let wikiheight : CGFloat = 400.0
	static let numberphileheight : CGFloat = 200.0
	let drawcells = DrawingCells()
	let numeralcells = NumeralCells()
	
	//Zwiwchenspeicher fuer Cell-Subviews
	private var uidesctemp : UIWebView? = nil
	private var uinumeraltemp : UILabel? = nil
	private var uiformtemp : MTMathUILabel? = nil
	private var uirecordtemp : TypewriterLabel? = nil
	private var uiwebtemp : UIWebView? = nil
	private var uitubetemp : YouTubePlayerView? = nil
	//private var htmldesc = ""
	var formula : String = "" // \\forall n \\in \\mathbb{N} : n = n + 0"
	var wikiadr : String = "wikipedia.de"
	
	var vc : NrViewController!
	init(vc : NrViewController) {
		super.init(frame: .zero, style: .plain)
		self.vc = vc
		
		self.translatesAutoresizingMaskIntoConstraints = false
		self.backgroundColor = .lightGray
		self.delegate = self
		self.dataSource = self
		self.register(CustomTableViewHeader.self, forHeaderFooterViewReuseIdentifier: self.headerId)
		self.register(FormTableCell.self, forCellReuseIdentifier: self.formcellId)
		self.register(RecordTableCell.self, forCellReuseIdentifier: self.recordCellId)
		
		self.register(WikiTableCell.self, forCellReuseIdentifier: self.wikicellId)
		self.register(OEISTableCell.self, forCellReuseIdentifier: self.oeiscellId)
		self.register(YoutTubeTableCell.self, forCellReuseIdentifier: self.tubecellId)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case NrViewSection.DrawNumber.rawValue:
			let ans = drawcells.count
			return ans //
		case NrViewSection.Numerals.rawValue:
			return NumeralCellType.allValues.count*2 - 1
		case NrViewSection.Formula.rawValue:
			return 1
		default:
			return 1
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return NrViewSection.NumberPhile.rawValue+1
	}
	
	#if true
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let art = cell as? NumeralArtCell {
			art.layoutIfNeeded()
		}
		if let art = cell as? TesterArtCell {
			art.layoutIfNeeded()
		}
		if let cell = cell as? DrawTableCell {
			cell.layoutIfNeeded()
			cell.uidraw?.setNeedsDisplay()
		}
		
	}
	#endif
	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		guard let header = view as? UITableViewHeaderFooterView else { return }
		header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
		header.textLabel?.frame = header.frame
		header.textLabel?.textAlignment = .center
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case NrViewSection.Numerals.rawValue:
			return "Numerals"
		case NrViewSection.Formula.rawValue:
			return "Formulas" //, Records & Digits"
		case NrViewSection.DrawNumber.rawValue:
			return "Properties"
		case NrViewSection.Wiki.rawValue:
			return "Wikipedia"
		case NrViewSection.NumberPhile.rawValue:
			return "Numberphile"
		default:
			return nil
		}
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 30.0
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! CustomTableViewHeader
		return header
	}
	
	override func beginUpdates() {
		print("BeginUpdates")
		super.beginUpdates()
	}
	override func endUpdates() {
		print("Endupdates")
		super.endUpdates()
	}
		
	
	
	var heightdict : [IndexPath:CGFloat] = [:]
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		let h = HeightForRow(indexPath: indexPath)
		#if true //Only Debug
		if let hdict = heightdict[indexPath] {
			if h != hdict {
				print("Heightchange : " ,indexPath,h,hdict)
			}
		}
		heightdict[indexPath] = h
			#endif
		return h
	}
	
	func HeightForRow(indexPath: IndexPath) -> CGFloat {
		
		let width = self.frame.size.width // - 20
		let row = indexPath.row
		switch indexPath.section {
			/*
			case NrViewSection.Description.rawValue:
			if let temp = uidesctemp {
			temp.frame.size = CGSize(width : width, height: 1.0)
			temp.frame.size = temp.sizeThatFits(.zero)
			uidesctemp?.frame = temp.frame
			return temp.frame.height //+ 20.0
			}
			*/
		case NrViewSection.Numerals.rawValue:
			
			if numeralcells.getCell(row: row).isHidden {
				return 0.0
			}
			let h = numeralcells.getRowHeight(row: row)
			return h
			
		case NrViewSection.DrawNumber.rawValue:
			if drawcells.getCell(row: row).isHidden {
				return 0.0
			}
			let h = drawcells.getRowHeight(row: row)
			return h
		case NrViewSection.Formula.rawValue:
			//return 100.0
			switch row {
			case 0:
				if let temp = uiformtemp {
					temp.sizeToFit()
					let height = temp.sizeThatFits(CGSize(width:width, height: CGFloat.greatestFiniteMagnitude)).height
					return height + 20.0
				}
			case 1:
				if let temp = uirecordtemp {
					temp.sizeToFit()
					let height = temp.sizeThatFits(CGSize(width:width, height: CGFloat.greatestFiniteMagnitude)).height
					return min(100.0,height + 20.0)
				}
			default:
				assert(false)
			}
		case NrViewSection.Wiki.rawValue:
			if uiwebtemp != nil {
				return NrTableView.wikiheight
			}
		case NrViewSection.NumberPhile.rawValue:
			return NrTableView.numberphileheight
		default:
			assert(false)
		}
		return 150
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let _ = tableView.cellForRow(at: indexPath) as? BaseNrTableCell else { return }
		switch indexPath.section {
		case NrViewSection.Numerals.rawValue:
			numeralcells.Expand(row: indexPath.row)
			tableView.beginUpdates()
			tableView.endUpdates()
		case NrViewSection.DrawNumber.rawValue:
			drawcells.Select(row: indexPath.row)
			tableView.beginUpdates()
			tableView.endUpdates()
		case NrViewSection.Wiki.rawValue:
			guard (tableView.cellForRow(at: indexPath) as? WikiTableCell) != nil else  { return }
			
			if let url = URL(string: self.wikiadr) {
				let safari = SFSafariViewController(url: url)
				vc.present(safari, animated: true, completion: nil)
			}
		default:
			break
		}
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? BaseNrTableCell else { return }
		tableView.beginUpdates()
		cell.expanded = false
		tableView.endUpdates()
	}
	
	func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) else  { return }
		if let ncell = cell as? NumeralCell {
			let type = ncell.type
			let typeadr = type.asWiki()
			if let typeurl = URL(string: typeadr) {
				vc.WikiJump(wikiurl: typeurl)
			}
		}
		if let scell = cell as? SequenceCell {
			guard let property = scell.numtester?.property() else { return }
			let wiki = WikiLinks.shared.Address(key:property)
			guard let url = URL(string: wiki) else { return }
			vc.WikiTVCJump(wikiurl: url)
		}
	}
	
	/*
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
	if let art = cell as? NumeralArtCell {
	art.layoutIfNeeded()
	}
	if let art = cell as? TesterArtCell {
	art.layoutIfNeeded()
	}
	if let cell = cell as? DrawTableCell {
	cell.layoutIfNeeded()
	cell.uidraw?.setNeedsDisplay()
	}
	
	}
	*/
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let row = indexPath.row
		switch indexPath.section {
		case NrViewSection.Numerals.rawValue:
			let cell = numeralcells.getCell(row: row)
			return cell
		case NrViewSection.Formula.rawValue:
			if let cell = tableView.dequeueReusableCell(withIdentifier: formcellId, for: indexPath) as? FormTableCell {
				cell.tableparent = tableView
				cell.uimath.latex = formula
				uiformtemp = cell.uimath
				return cell
			}
		case NrViewSection.DrawNumber.rawValue:
			let row = indexPath.row
			let cell = drawcells.getCell(row: row)
			return cell
			
		case NrViewSection.Wiki.rawValue:
			if let cell = tableView.dequeueReusableCell(withIdentifier: wikicellId, for: indexPath) as? WikiTableCell {
				uiwebtemp = cell.uiweb
				cell.accessoryType = .disclosureIndicator
				cell.jumper = vc
				cell.SetWikiUrl(wiki: self.wikiadr)
				return cell
			}
		case NrViewSection.NumberPhile.rawValue:
			if let cell = tableView.dequeueReusableCell(withIdentifier: tubecellId, for: indexPath) as? YoutTubeTableCell {
				uitubetemp = cell.uitube
				cell.jumper = vc
				cell.SetTubeNr(n: vc.currnr)
				return cell
			}
		default:
			assert(false)
		}
		return UITableViewCell()
	}
	
	
}
