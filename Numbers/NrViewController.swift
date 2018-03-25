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
	//case Description = 1
	case Numerals = 0
	case Formula = 2
	case DrawNumber = 1
	case Wiki = 3
	case NumberPhile = 4
}

class NrViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , UISearchBarDelegate, NumberJump  {
	private let initialnumber = BigUInt(13)
	private let headerId = "headerId"
	private let footerId = "footerId"
	//private let desccellId = "desccellId"
	private let recordCellId = "recordcellId"
	private let formcellId = "formcellId"
	private let wikicellId = "wikicellId"
	private let oeiscellId = "oeiscellId"
	private let tubecellId = "tubecellId"
	
	//private let drawcellId = "drawcellId"
	static let wikiheight : CGFloat = 400.0
	static let numberphileheight : CGFloat = 200.0
	private let drawcells = DrawingCells()
	private let numeralcells = NumeralCells()
	
	lazy var uisearch: UISearchBar = UISearchBar()
	
	//Zwiwchenspeicher fuer Cell-Subviews

	private var uidesctemp : UIWebView? = nil
	private var uinumeraltemp : UILabel? = nil
	private var uiformtemp : MTMathUILabel? = nil
	private var uirecordtemp : TypewriterLabel? = nil
	private var uiwebtemp : UIWebView? = nil
	private var uitubetemp : YouTubePlayerView? = nil
	//private var htmldesc = ""
	private var formula : String = "" // \\forall n \\in \\mathbb{N} : n = n + 0"
	private var wikiadr : String = "wikipedia.de"
	
	var currnr : BigUInt = 0 {
		didSet {
			NumberModel.shared.currnr = currnr
			numeralcells.nr = currnr
			drawcells.nr = currnr
			if currnr != oldValue {
				tv.beginUpdates()
				tv.endUpdates()
			}
		}
	}
	func Jump(to: BigUInt) {
		currnr = to
		GetExplanation()
		tv.reloadData()
		//let indexPath = IndexPath(row: 0, section: 0)
		//self.tv.scrollToRow(at: indexPath, at: .top, animated: false)
		tv.reloadData()
	}
	func WikiTVCJump(wikiurl: URL) {
		let subvc = WikiTVC()
		subvc.SetWikiURL(url: wikiurl.absoluteString, nr: self.currnr)
		self.navigationController?.pushViewController(subvc, animated: true)
	}
	func WikiJump(wikiurl: URL) {
		let safari = SFSafariViewController(url: wikiurl)
		self.present(safari, animated: true, completion: nil)
	}
	
	var explanationWorker : DispatchWorkItem? = nil
	private func GetExplanation() {
		self.explanationWorker = DispatchWorkItem {
			self.explanationWorker?.cancel()
			let nr = self.currnr
			let exp = Explain.shared.GetExplanation(nr: nr)
			DispatchQueue.main.async(execute: {
				self.uisearch.text = String(nr)
				//self.htmldesc = exp.html
				self.formula = exp.latex
				self.wikiadr = exp.wikilink
				do {
					let indexPath = IndexPath(item: 0, section: NrViewSection.DrawNumber.rawValue)
					self.tv.reloadRows(at: [indexPath], with: .top)
				}
				do {
					let indexPath = IndexPath(item: 0, section: NrViewSection.Formula.rawValue)
					self.tv.reloadRows(at: [indexPath], with: .top)
				}
				/*
				do {
					let indexPath = IndexPath(item: 1, section: NrViewSection.Formula.rawValue)
					self.tv.reloadRows(at: [indexPath], with: .top)
				}
				*/
				self.tv.beginUpdates()
				self.tv.endUpdates()
			})
		}
		DispatchQueue.global(qos: .userInitiated).async(execute: explanationWorker!)
		
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
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let width = tableView.frame.size.width // - 20
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
				return NrViewController.wikiheight
			}
		case NrViewSection.NumberPhile.rawValue:
			return NrViewController.numberphileheight
		default:
			assert(false)
		}
		return 150
	}
	
	/*
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		if let cell = tableView.cellForRow(at: indexPath) as? DrawTableCell {
			if cell.expanded {
				tableView.beginUpdates()
				cell.expanded = false
				tableView.deselectRow(at: indexPath, animated: true)
				tableView.endUpdates()
				return nil
			}
		}
		return indexPath
	}
	*/
	
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
				self.present(safari, animated: true, completion: nil)
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
				WikiJump(wikiurl: typeurl)
			}
		}
		if let scell = cell as? SequenceCell {
			guard let property = scell.numtester?.property() else { return }
			let wiki = WikiLinks.shared.Address(key:property)
			guard let url = URL(string: wiki) else { return }
			WikiTVCJump(wikiurl: url)
		}
	}
	
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
				cell.jumper = self
				cell.SetWikiUrl(wiki: self.wikiadr)
				return cell
			}
		case NrViewSection.NumberPhile.rawValue:
			if let cell = tableView.dequeueReusableCell(withIdentifier: tubecellId, for: indexPath) as? YoutTubeTableCell {
				uitubetemp = cell.uitube
				cell.jumper = self
				cell.SetTubeNr(n: currnr)
				return cell
			}
		default:
			assert(false)
		}
		return UITableViewCell()
	}
	
	lazy var tv: UITableView = {
		let tv = UITableView(frame: .zero, style: .plain)
		tv.translatesAutoresizingMaskIntoConstraints = false
		tv.backgroundColor = .lightGray
		tv.delegate = self
		tv.dataSource = self
		tv.register(CustomTableViewHeader.self, forHeaderFooterViewReuseIdentifier: self.headerId)
		tv.register(FormTableCell.self, forCellReuseIdentifier: self.formcellId)
		tv.register(RecordTableCell.self, forCellReuseIdentifier: self.recordCellId)
		
		tv.register(WikiTableCell.self, forCellReuseIdentifier: self.wikicellId)
		tv.register(OEISTableCell.self, forCellReuseIdentifier: self.oeiscellId)
		tv.register(YoutTubeTableCell.self, forCellReuseIdentifier: self.tubecellId)
		return tv
	}()
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		currnr = NumberModel.shared.currnr
		GetExplanation()
		tv.reloadData()
	}
	
	private var myToolbar: UIToolbar!
	private var tempButton: UIBarButtonItem!
	private var backButton: UIBarButtonItem!
	private var fwdButton: UIBarButtonItem!
	
	private func CreateToolBar() {
		// make uitoolbar instance
		let frame = CGRect(x: 0, y: self.view.bounds.height - 44.0, width: self.view.width, height: 40.0)
		myToolbar = UIToolbar(frame: frame)
		
		// set the position of the toolbar
		//myToolbar.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height-20.0)
		
		// set the color of the toolbar
		myToolbar.barStyle = .blackTranslucent
		myToolbar.tintColor = .white
		myToolbar.backgroundColor = .black
		
		// make a button
		tempButton = UIBarButtonItem(title: "", style:.plain, target: self, action: nil)
		backButton = UIBarButtonItem(title: "Previous", style:.plain, target: self, action: #selector(backButtonAction))
		let flexibleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		fwdButton = UIBarButtonItem(title: "Next", style:.plain, target: self, action: #selector(fwdButtonAction))
		
		// add the buttons on the toolbar
		myToolbar.items = [tempButton, backButton,  flexibleButton,fwdButton]
		
		// add the toolbar to the view.
		self.view.addSubview(myToolbar)
	}
	
	@objc func backButtonAction() {
		var nr = currnr
		repeat {
			if currnr == 0 { break }
			nr = nr - 1
		} while Tester.shared.isDull(n: nr)
		currnr = nr
		GetExplanation()
		tv.beginUpdates()
		tv.endUpdates()
		//tv.reloadData()
		//let indexPath = IndexPath(row: 0, section: 0)
		//self.tv.scrollToRow(at: indexPath, at: .top, animated: false)
	}
	@objc func fwdButtonAction() {
		var nr = currnr
		repeat {
			nr = nr + 1
		} while Tester.shared.isRealDull(n: nr)
		currnr = nr
	
		GetExplanation()
		tv.beginUpdates()
		tv.endUpdates()

		//tv.reloadData()
		//let indexPath = IndexPath(row: 0, section: 0)
		//self.tv.scrollToRow(at: indexPath, at: .top, animated: false)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		CreateToolBar()
		uisearch.searchBarStyle = UISearchBarStyle.prominent
		uisearch.placeholder = " Search..."
		uisearch.sizeToFit()
		uisearch.isTranslucent = false
		uisearch.backgroundImage = UIImage()
		uisearch.keyboardType = .numberPad
		uisearch.delegate = self
		navigationItem.titleView = uisearch
		self.view.addSubview(tv)
		self.view.addSubview(uisearch)
		setupAutoLayout()
		addDoneButtonOnKeyboard()
	}
	
	func addDoneButtonOnKeyboard() {
		let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
		doneToolbar.barStyle       = UIBarStyle.default
		let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		let done: UIBarButtonItem  = UIBarButtonItem(title: "Search", style: UIBarButtonItemStyle.done, target: self, action: #selector(NrViewController.doneButtonAction))
		var items = [UIBarButtonItem]()
		items.append(flexSpace)
		items.append(done)
		doneToolbar.items = items
		doneToolbar.sizeToFit()
		self.uisearch.inputAccessoryView = doneToolbar
	}
	
	@objc func doneButtonAction() {
		self.uisearch.resignFirstResponder()
		guard let text = uisearch.text else { return }
		guard let nr = BigUInt(text) else { return }
		currnr = nr
		GetExplanation()
		tv.reloadData()
		let indexPath = IndexPath(row: 0, section: 0)
		self.tv.scrollToRow(at: indexPath, at: .top, animated: false)
	}
	
	func setupAutoLayout() {
		uisearch.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		uisearch.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		uisearch.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		tv.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		tv.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		tv.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		tv.bottomAnchor.constraint(equalTo: myToolbar.topAnchor).isActive = true
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

