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

enum TVCViewSection : Int {
	case Art = 0
	case Wiki = 1
	case OEIS = 2
	case Formula = 3
}

class WikiTVC: UIViewController , UITableViewDelegate, UITableViewDataSource  {
	private let headerId = "headerId"
	private let footerId = "footerId"
	private let desccellId = "desccellId"
	private let formcellId = "formcellId"
	private let oeiscellId = "oeiscellId"
	private let wikicellId = "wikicellId"

	static let wikiheight : CGFloat = 600.0
	private let artcell = NumeralSequenceArtCell()
	
	//Zwiwchenspeicher fuer Cell-Subviews
	private var uidesctemp : UIWebView? = nil
	private var uiformtemp : MTMathUILabel? = nil
	//private var uiwebtemp : UIWebView? = nil
	//private var uioeistemp : UIWebView? = nil
	private var uitubetemp : YouTubePlayerView? = nil
	
	private var htmldesc = ""
	private var formula : String = "\\forall n \\in \\mathbb{N} : n = n + 0"
	
	private var currnr : BigUInt = 2
	private var tester : NumTester? = nil
	private var wikiurl = ""
	private var oeisurl = ""
	private func GetExplanation() {
		let exp = Explain.shared.GetExplanation(nr: currnr)
		htmldesc = exp.html
		formula = exp.latex
	}
	
	func SetWikiURL(url : String, nr : BigUInt) {
		self.wikiurl = url
		self.oeisurl = OEIS.shared.oeisdefault
		self.tester = WikiLinks.shared.getTester(link: url)
		if self.tester != nil {
			self.oeisurl = OEIS.shared.Address(tester!.property()) 
		}
		self.currnr = nr
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case TVCViewSection.Art.rawValue:
			return 1
		case TVCViewSection.Wiki.rawValue:
			return 1
		case TVCViewSection.Formula.rawValue:
			return 1
		case TVCViewSection.OEIS.rawValue:
			return 1
		default:
			assert(false)
			return 0
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		guard let header = view as? UITableViewHeaderFooterView else { return }
		header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
		header.textLabel?.frame = header.frame
		header.textLabel?.textAlignment = .center
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case TVCViewSection.Art.rawValue:
			return nil
		case TVCViewSection.Wiki.rawValue:
			return "Wikipedia"
		case TVCViewSection.Formula.rawValue:
			return "Formula"
		case TVCViewSection.OEIS.rawValue:
			return "OEIS"
		default:
			assert(false)
			return nil
		}
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 40.0
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! CustomTableViewHeader
		return header
	}
	
	//
	// MARK :- Cell
	//
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let width = tableView.frame.size.width // - 20
		switch indexPath.section {
		case TVCViewSection.Art.rawValue:
			if artcell.expanded {
				return self.view.width
			}
			return 150.0
		case TVCViewSection.Wiki.rawValue:
			return NrViewController.wikiheight
		case TVCViewSection.OEIS.rawValue:
			return NrViewController.wikiheight
		case TVCViewSection.Formula.rawValue:
			return 100.0
		default:
			assert(false)
			return 100.0
		}
	}
	
	//private var expandednumerals = false
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? BaseNrTableCell else { return }
		switch indexPath.section {
		case TVCViewSection.Art.rawValue:
			artcell.expanded = !artcell.expanded
			tableView.beginUpdates()
			tableView.endUpdates()
			
		default:
			return
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		
		case TVCViewSection.Art.rawValue:
			artcell.nr = self.currnr
			artcell.tester = self.tester
			return artcell
		case TVCViewSection.Wiki.rawValue:
			if let cell = tableView.dequeueReusableCell(withIdentifier: wikicellId, for: indexPath) as? WikiTableCell {
				//uiwebtemp = cell.uiweb
				cell.SetWikiUrl(wiki: self.wikiurl)
				return cell
			}
		case TVCViewSection.OEIS.rawValue:
			if let cell = tableView.dequeueReusableCell(withIdentifier: oeiscellId, for: indexPath) as? OEISTableCell {
				//uioeistemp = cell.uiweb
				cell.SetOEISUrl(oeis: self.oeisurl)
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
		tv.register(WikiTableCell.self, forCellReuseIdentifier: self.wikicellId)
		tv.register(OEISTableCell.self, forCellReuseIdentifier: self.oeiscellId)
		
		return tv
	}()
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		GetExplanation()
		tv.reloadData()
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.addSubview(tv)
		setupAutoLayout()
	}
	func setupAutoLayout() {
		tv.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		tv.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		tv.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		tv.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}
}

