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

class NrTableCell: UITableViewCell {
	
	private (set) var uinr = UITextView()
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(uinr)
		uinr.font = UIFont(name: "Arial", size: 18.0)
		//uinr.backgroundColor = .orange
		uinr.frame = CGRect(x: 10.0, y: 0, width: self.frame.width-80.0, height: self.frame.height)
		uinr.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
		//uinr.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
		uinr.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		uinr.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		//self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
		self.accessoryType = UITableViewCellAccessoryType.detailDisclosureButton
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class NrTableViewHeader: UITableViewHeaderFooterView {
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		//contentView.backgroundColor = .red
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


class MainViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , UISearchBarDelegate, UIScrollViewDelegate  {
	
	private let headerId = "nrheaderId"
	private let nrcellId = "nrcellId"
	
	lazy var uisearch: UISearchBar = UISearchBar()
	
	//Zwiwchenspeicher fuer Cell-Subviews
	private var uinrtemp : UITextView? = nil
	
	private var nrstr : String = "nr"
	private var _startnr : Int = 0
	private var startnr : Int {
		get { return _startnr }
		set { _startnr = max(0,newValue) }
	}
	
	private var lastnr : Int {
		get { return startnr + 400 }
	}
	private let pagesize : Int = 200
	
	func tableView(_ tableView: UITableView,
				   accessoryButtonTappedForRowWith indexPath: IndexPath) {

		let subvc = NrViewController()
		subvc.currnr = startnr  + indexPath.row
		self.navigationController?.pushViewController(subvc, animated: true)
	}
	
	private func scrollToRow(row : Int, at: UITableViewScrollPosition) {
		let indexPath = IndexPath(row: row, section: 0)
		self.tv.scrollToRow(at: indexPath, at: at, animated: false)
	}
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if decelerate == false {
			Repositioning()
		}
		
	}
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		Repositioning()
	}
	
	private func Repositioning()
	{
		guard let rows = self.tv.indexPathsForVisibleRows else { return }
		let firstrow = rows[0].row
		let lastrow = rows[rows.count-1].row
		if lastrow >= lastnr - startnr - pagesize / 2 {
			//self.lastnr += pagesize
			self.startnr += pagesize
			let newrow = lastrow - pagesize
			print(firstrow,lastrow,newrow)
			scrollToRow(row: newrow, at: .bottom)
		}
		if firstrow <= pagesize / 2 && startnr > 0 {
			//self.lastnr -= pagesize
			let difsize = min(startnr,pagesize)
			self.startnr -= difsize
			let newrow = firstrow + difsize
			print(firstrow,lastrow,newrow)
			scrollToRow(row: newrow, at: .top)
		}
	}
	
	/*
	func tableView(_ tableView: UITableView,
				   willDisplay cell: UITableViewCell,
				   forRowAt indexPath: IndexPath)
	{
		// At the bottom...
		let dif = lastnr - startnr
		let topVisibleIndexPath = self.tv.indexPathsForVisibleRows![0]
		if (indexPath.row == dif-1) {
			startnr = startnr + dif
			lastnr = lastnr + dif
			let row = topVisibleIndexPath.row - dif
			self.scrollToRow(row: row, at: .top)
			DispatchQueue.main.async { [unowned self] in
				self.tv.reloadData()
			}
		}
		if (indexPath.row == 0 && startnr > 0) {
			startnr = startnr - dif
			lastnr = lastnr - dif
			let row = topVisibleIndexPath.row + dif
			self.scrollToRow(row: row, at: .top)
			DispatchQueue.main.async { [unowned self] in
				self.tv.reloadData()
			}
		}
	}
	*/
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return lastnr - startnr
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "List of numbers"
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! NrTableViewHeader
		return header
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		return
	}

	//
	// MARK :- Cell
	//
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let width = tableView.frame.size.width - 20
		switch indexPath.section {
		case 0:
			if let temp = uinrtemp {
				let size = temp.sizeThatFits(CGSize(width:width, height: CGFloat.greatestFiniteMagnitude))
				let frame = CGRect(origin: CGPoint.zero, size: size)
				temp.frame = frame
				return size.height + 20.0
			}
		default:
			break
		}
		return 150
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let row = indexPath.row
		switch indexPath.section {
		case 0:
			if let cell = tableView.dequeueReusableCell(withIdentifier: nrcellId, for: indexPath) as? NrTableCell {
				let nr = startnr + row
				let spoken = SpokenNumber.shared.spoken(n: nr)
				let strnr = nr.formatnumber()
				let props = GetExplanation(nr: nr)
				cell.uinr.text = strnr + "\n" + spoken + "\n" + props
				
				uinrtemp = cell.uinr
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
		tv.register(NrTableViewHeader.self, forHeaderFooterViewReuseIdentifier: self.headerId)
		tv.register(NrTableCell.self, forCellReuseIdentifier: self.nrcellId)
		return tv
	}()
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		tv.reloadData()
	}
	
	private var myToolbar: UIToolbar!
	private var infoButton : UIBarButtonItem!
	
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
		let flexibleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		infoButton = UIBarButtonItem(title: "Info", style:.plain, target: self, action: #selector(infoAction))
		
		// add the buttons on the toolbar
		myToolbar.items = [flexibleButton,infoButton]
		
		// add the toolbar to the view.
		self.view.addSubview(myToolbar)
	}
	
	@objc func infoAction() {
		
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
		guard let nr = Int(text) else { return }
		startnr = nr
		scrollToRow(row: 0, at: .top)
		tv.reloadData()
		Repositioning()
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
	}
	
	private func GetExplanation(nr : Int) -> String {
		let exp = Explain.shared.GetExplanation(nr: nr)
		var ans = ""
		for p in exp.properties {
			ans.appendnl(p)
		}
		return ans
	}
}

