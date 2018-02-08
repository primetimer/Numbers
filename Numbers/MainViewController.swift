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

class NrTableViewHeader: UITableViewHeaderFooterView {
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


class MainViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource , UISearchBarDelegate, UIScrollViewDelegate  {
	
	//private let headerId = "nrheaderId"
	private let nrcellcollectionId = "nrcellcollectionId"
	//private let drawcellId = "drawcellId"
	
	lazy var uisearch: UISearchBar = UISearchBar()
	
	//Zwiwchenspeicher fuer Cell-Subviews
	//private var uinrtemp : UITextView? = nil
	private var uidesctemp : UIWebView? = nil
	
	
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
	
	
	func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let subvc = NrViewController()
		subvc.currnr = BigUInt(startnr  + indexPath.row)
		self.navigationController?.pushViewController(subvc, animated: true)
	}
	
	/*
	private func scrollToRow(row : Int, at: UITableViewScrollPosition) {
		let indexPath = IndexPath(row: 0, section: row)
		self.tv.scrollToRow(at: indexPath, at: at, animated: false)
	}
	*/
	
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
		return
		/*
		guard let rows = self.tv.indexPathsForVisibleRows else { return }
		let firstrow = rows[0].section
		let lastrow = rows[rows.count-1].section
		if lastrow >= lastnr - startnr - pagesize / 2 {
			//self.lastnr += pagesize
			self.startnr += pagesize
			let newrow = lastrow - pagesize
			print(firstrow,lastrow,newrow)
			scrollToRow(row: newrow, at: .bottom)
		}
		if firstrow <= pagesize / 2 && startnr > 0 {
			let difsize = min(startnr,pagesize)
			self.startnr -= difsize
			let newrow = firstrow + difsize
			print(firstrow,lastrow,newrow)
			scrollToRow(row: newrow, at: .top)
		}
		*/
	}
	
	func collectionView(_ tableView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return lastnr - startnr
		 //return TableCellType.allValues.count
	}
	
	func numberOfSections(in tableView: UICollectionView) -> Int {
		return 1
		
	}
	
	func collectionView(_ tableView: UICollectionView, titleForHeaderInSection section: Int) -> String? {
		return String(section+startnr)
	}
	
	/*
	func collectionView(_ tableView: UICollectionView, viewForHeaderInSection section: Int) -> UIView? {
		let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! NrTableViewHeader
		return header
	}
	*/
	
	//
	// MARK :- Cell
	//
	func collectionView(_ tableView: UICollectionView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 40.0
		let width = tableView.frame.size.width - 20
		
		if let temp = uidesctemp {
			let size = temp.sizeThatFits(CGSize(width:width, height: CGFloat.greatestFiniteMagnitude))
			let frame = CGRect(origin: CGPoint.zero, size: size)
			temp.frame = frame
			return size.height + 20.0
		}
		return 150
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let section = indexPath.section
		let row = indexPath.row
		if section == 0 {
			if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nrcellcollectionId, for: indexPath) as? DescCollectionCell {
				uidesctemp = cell.uidesc
				let nr = startnr + row
				let spoken = SpokenNumber.shared.spoken(n: nr)
				let strnr = nr.formatnumber()
				let html = GetExplanation(nr: BigUInt(nr))
				cell.tableparent = collectionView
				cell.SetHtmlDesc(html: html)
				//cell.isUserInteractionEnabled = false
				return cell
			}
		}
		/*
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: drawcellId, for: indexPath) as? DrawTableCell {
			let type = TableCellType.allValues[row - 1]
			cell.type = type
			//uidrawtemp[row] = cell.uidraw
			cell.nr = BigUInt(startnr + section)
			if let test = cell.numtester {
				if test.isSpecial(n: cell.nr) {
					cell.accessoryType = .checkmark
				} else {
					cell.accessoryType = .none
				}
			}
			return cell
		}
		*/
		
		
		return UICollectionViewCell()
	}
	
	lazy var tv: UICollectionView = {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 20)
		layout.itemSize = CGSize(width: 120, height: 120)
		
		let tv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		tv.translatesAutoresizingMaskIntoConstraints = false
		tv.backgroundColor = .lightGray
		tv.delegate = self
		tv.dataSource = self
		tv.allowsSelection = true
		//tv.register(NrTableViewHeader.self, forHeaderFooterViewReuseIdentifier: self.headerId)
		//tv.register(NrTableCell.self, forCellReuseIdentifier: self.nrcellId)
		tv.register(DescCollectionCell.self, forCellWithReuseIdentifier: nrcellcollectionId)
		//tv.register(DrawTableCell.self, forCellReuseIdentifier: self.drawcellId)

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
		//print(iosMathVersionNumber)
		
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
		let done: UIBarButtonItem  = UIBarButtonItem(title: "Search", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction)) //#suspicour NrViewController #remove
		
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
		//scrollToRow(row: 0, at: .top)
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
	
	private func GetExplanation(nr : BigUInt) -> String {
		let exp = Explain.shared.GetExplanation(nr: nr)
		return exp.html
		/*
		var ans = ""
		for p in exp.properties {
		ans.appendnl(p)
		}
		
		return ans
		*/
	}
}

