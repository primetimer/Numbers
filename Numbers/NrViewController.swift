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

class BaseNrCollectionCell : UICollectionViewCell {
	var nr : BigUInt = 0
	var tableparent : UICollectionView? = nil
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	/*
	override init(style:  UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.accessoryType = .disclosureIndicator
	}
	*/
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


class BaseNrTableCell : UITableViewCell {
	var nr : BigUInt = 0
	var tableparent : UITableView? = nil
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.accessoryType = .disclosureIndicator
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


class FormTableCell: BaseNrTableCell {
	private (set) var uimath = MTMathUILabel()
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		uimath.fontSize = 18.0
		contentView.addSubview(uimath)
		uimath.frame = CGRect(x: 10.0, y: 10.0, width: self.frame.width, height: self.frame.height)
		//uimath.fontSize = 15.0
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class CustomTableViewHeader: UITableViewHeaderFooterView {
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .orange
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class WikiTableCell: BaseNrTableCell , UIWebViewDelegate {
	private (set) var uiweb = UIWebView()
	private var wikiurl : String = ""
	func SetWikiUrl(wiki : String) {
		if wiki == wikiurl {
			return
		}
		wikiurl = wiki
		if let url = URL(string: wiki) {
			let request = URLRequest(url: url)
			uiweb.loadRequest(request)
			uiweb.delegate = self
		}
	}
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(uiweb)
		//uidesc.font = UIFont(name: "Arial", size: 18.0)
		uiweb.frame = CGRect(x: 10.0, y: 0, width: self.frame.width, height: NrViewController.wikiheight)
		uiweb.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
		uiweb.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
		uiweb.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		uiweb.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	func webViewDidFinishLoad(_ webView: UIWebView)
	{
		//print("Didload=",webView.frame)
		/*
		if let table = self.superview as? UITableView {
			let idx = IndexPath(row: 0, section: 2)
			table.reloadRows(at: [idx], with: .automatic)
		}
		*/
	}
}

//
// MARK :- FOOTER
//

/*
class CustomTableViewFooter: UITableViewHeaderFooterView {
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		
		contentView.backgroundColor = .green
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
*/



class NrViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , UISearchBarDelegate  {
	private let headerId = "headerId"
	private let footerId = "footerId"
	private let desccellId = "desccellId"
	private let formcellId = "formcellId"
	private let wikicellId = "wikicellId"
	//private let drawcellId = "drawcellId"
	static let wikiheight : CGFloat = 600.0
	private let drawcells = DrawingCells()
	private let numeralcells = NumeralCells()
	
	lazy var uisearch: UISearchBar = UISearchBar()
	
	//Zwiwchenspeicher fuer Cell-Subviews
	#if false
	private var uidesctemp : UITextView? = nil
	#else
	private var uidesctemp : UIWebView? = nil
	#endif
	private var uinumeraltemp : UILabel? = nil
	private var uiformtemp : MTMathUILabel? = nil
	private var uiwebtemp : UIWebView? = nil
	//private var uidrawtemp : FaktorView? = nil
	//private var uidrawtemp : [UIView?] = [nil,nil,nil,nil,nil]
	
	//private var desc : String = "A text"
	private var htmldesc = ""
	private var formula : String = "\\forall n \\in \\mathbb{N} : n = n + 0"
	private var wikiurl : String = "wikipedia.de"
	
	var currnr : BigUInt = 2
	private func GetExplanation() {
		let exp = Explain.shared.GetExplanation(nr: currnr)
		uisearch.text = String(currnr)
		htmldesc = exp.html
		formula = exp.latex
		wikiurl = exp.wikiurl
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 3 {
			return TableCellType.allValues.count
		}
		if section == 1 {
			return NumeralCellType.allValues.count
		}
		return 1
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 5
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return "Description"
		case 1:
			return "Numerals"
		case 2:
			return "Formula"
		case 3:
			return "Drawing"
		case 4:
			return "Wikipedia"
		default:
			return nil
		}
	}
	/*
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 150
	}
	*/
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! CustomTableViewHeader
		return header
	}
	
	//
	// MARK :- FOOTER
	//
	/*
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 150
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		
		let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerId) as! CustomTableViewFooter
		return footer
	}
	*/
	
	//
	// MARK :- Cell
	//
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let width = tableView.frame.size.width // - 20
		switch indexPath.section {
		case 0:
			if let temp = uidesctemp {
				temp.frame.size = CGSize(width : width, height: 1.0)
				temp.frame.size = temp.sizeThatFits(.zero)
				uidesctemp?.frame = temp.frame
				return temp.frame.height //+ 20.0
			}
		case 1:
			let row = indexPath.row
			let tablerow = numeralcells.cells[row]
			let label = tablerow.uilabel
			let width = label.width
			label.sizeToFit()
			let height = label.sizeThatFits(CGSize(width:width, height: CGFloat.greatestFiniteMagnitude)).height
			return height + 20.0
			
			
		case 2:
			if let temp = uiformtemp {
				temp.sizeToFit()
				let height = temp.sizeThatFits(CGSize(width:width, height: CGFloat.greatestFiniteMagnitude)).height
				return height + 20.0
			}
		case 3:
			let row = indexPath.row
			let tablerow = drawcells.cells[row]
			tablerow.isHidden = tablerow.isSpecial ? false : true
			if !tablerow.isSpecial { return 0.0 }
			if let temp = drawcells.cells[row].uidraw {
				//let size = CGSize(width: self.view.width, height: self.view.width)
				//let frame = CGRect(origin: CGPoint.zero, size: size)
				let height = temp.bottom
				return height
			}
		case 4:
			if uiwebtemp != nil {
				return NrViewController.wikiheight
			}
		default:
			assert(false)
		}
		return 150
	}
	
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
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) as? DrawTableCell {
			if cell.expanded {
				tableView.beginUpdates()
				cell.expanded = false
				tableView.endUpdates()
				cell.expanded = false
				tableView.deselectRow(at: indexPath, animated: true)
				return
			}
			tableView.beginUpdates()
			cell.expanded = true
			tableView.endUpdates()
		}
	}
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) as? DrawTableCell {
			tableView.beginUpdates()
			cell.expanded = false
			tableView.endUpdates()
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			if let cell = tableView.dequeueReusableCell(withIdentifier: desccellId, for: indexPath) as? DescTableCell {
				uidesctemp = cell.uidesc
				cell.tableparent = tableView
				cell.SetHtmlDesc(html: self.htmldesc)
				return cell
			}
		case 1:
			let row = indexPath.row
			let cell = numeralcells.cells[row]
			cell.nr = currnr
			cell.selectionStyle = .none
			return cell
			
		case 2:
			if let cell = tableView.dequeueReusableCell(withIdentifier: formcellId, for: indexPath) as? FormTableCell {
				cell.tableparent = tableView
				cell.uimath.latex = formula
				uiformtemp = cell.uimath
				return cell
			}
		case 3:
			let row = indexPath.row
			let cell = drawcells.cells[row]
			cell.nr = currnr
			cell.selectionStyle = .none
			return cell
			/*
			if let cell = tableView.dequeueReusableCell(withIdentifier: drawcellId, for: indexPath) as? DrawTableCell {
				let row = indexPath.row
				cell.type = row
				uidrawtemp[row] = cell.uidraw
				cell.nr = currnr
				return cell
			}
			*/
		case 4:
			if let cell = tableView.dequeueReusableCell(withIdentifier: wikicellId, for: indexPath) as? WikiTableCell {
				uiwebtemp = cell.uiweb
				cell.SetWikiUrl(wiki: self.wikiurl)
				return cell
			}
		default:
			break
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
		//tv.register(CustomTableViewFooter.self, forHeaderFooterViewReuseIdentifier: self.footerId)
		tv.register(DescTableCell.self, forCellReuseIdentifier: self.desccellId)
		tv.register(FormTableCell.self, forCellReuseIdentifier: self.formcellId)
		tv.register(WikiTableCell.self, forCellReuseIdentifier: self.wikicellId)
		//tv.register(DrawTableCell.self, forCellReuseIdentifier: self.drawcellId)
		return tv
	}()
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
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
		myToolbar.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height-20.0)
		
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
		if currnr <= 0 { return }
		currnr = currnr - 1
		GetExplanation()
		tv.reloadData()
		let indexPath = IndexPath(row: 0, section: 0)
		self.tv.scrollToRow(at: indexPath, at: .top, animated: false)
	}
	@objc func fwdButtonAction() {
		if currnr <= 0 { currnr = 0 }
		currnr = currnr + 1
		GetExplanation()
		tv.reloadData()
		let indexPath = IndexPath(row: 0, section: 0)
		self.tv.scrollToRow(at: indexPath, at: .top, animated: false)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		CreateToolBar()
		print(iosMathVersionNumber)
		
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

