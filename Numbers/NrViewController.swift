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


class NrViewController: UIViewController , UISearchBarDelegate, NumberJump  {
	lazy var uisearch: UISearchBar = UISearchBar()
	var currnr : BigUInt = 0 {
		didSet {
			NumberModel.shared.currnr = currnr
			let searchisempty = uisearch.text?.isEmpty ?? true
			if !searchisempty { uisearch.text = String(currnr) }
			tv.numeralcells.nr = currnr
			tv.drawcells.nr = currnr
			if currnr != oldValue {
				GetExplanation()
			}
		}
	}
	func Jump(to: BigUInt) {
		currnr = to
		GetExplanation()
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
		//self.uisearch.text = String(currnr)		//Immedaite Update
		self.explanationWorker?.cancel()
		self.explanationWorker = DispatchWorkItem {
			let worker = self.explanationWorker
			let nr = self.currnr
			let exp = Explain.shared.GetExplanation(nr: nr, worker : worker)
			DispatchQueue.main.async(execute: {
			if worker?.isCancelled ?? false { return }
				//self.uisearch.text = String(nr)
				//self.htmldesc = exp.html
				self.tv.formula = exp.latex
				self.tv.wikiadr = exp.wikilink
				//self.tv.beginUpdates()
				do {
					let indexPath = IndexPath(item: 0, section: NrViewSection.Numerals.rawValue)
					self.tv.reloadRows(at: [indexPath], with: .none)
				}
				do {
					var indices : [IndexPath] = []
					for row in 0..<self.tv.drawcells.count {
						let indexPath = IndexPath(item: 0, section: NrViewSection.DrawNumber.rawValue)
						indices.append(indexPath)
					}
					self.tv.reloadRows(at: indices, with: .none)
				}
				do {
					let indexPath = IndexPath(item: 0, section: NrViewSection.Formula.rawValue)
					self.tv.reloadRows(at: [indexPath], with: .automatic)
				}
				do {
					let indexPath = IndexPath(item: 0, section: NrViewSection.Wiki.rawValue)
					self.tv.reloadRows(at: [indexPath], with: .none)
				}
				do {
					let indexPath = IndexPath(item: 0, section: NrViewSection.NumberPhile.rawValue)
					self.tv.reloadRows(at: [indexPath], with: .none)
				}
				//self.tv.endUpdates()
			})
		}
		DispatchQueue.global(qos: .userInitiated).async(execute: explanationWorker!)
		
	}

	lazy var tv: NrTableView = { return NrTableView(vc : self) }()
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		currnr = NumberModel.shared.currnr
		GetExplanation()
		tv.reloadData()
	}
	
	private var tempButton: UIBarButtonItem!
	private var backButton: UIBarButtonItem!
	private var fwdButton: UIBarButtonItem!
	
	private func CreateToolBar() {
		tempButton = UIBarButtonItem(title: "", style:.plain, target: self, action: nil)
		backButton = UIBarButtonItem(title: "Previous", style:.plain, target: self, action: #selector(backButtonAction))
		let flexibleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		fwdButton = UIBarButtonItem(title: "Next", style:.plain, target: self, action: #selector(fwdButtonAction))
		let items : [UIBarButtonItem] = [tempButton, backButton,  flexibleButton,fwdButton]
		self.setToolbarItems(items , animated: true)
	}
	
	private func LoopNext(direction : Int ) {
		explanationWorker?.cancel()
		self.explanationWorker = DispatchWorkItem {
			let worker = self.explanationWorker
			var nr = self.currnr
			repeat {
				if direction == -1 && nr == 0 { break }
				nr = direction == -1 ? nr - BigUInt(1) : nr + BigUInt(1)
				if worker?.isCancelled ?? false { break }
				let isdull = Tester.shared.isRealDull(n: nr,worker: worker) ?? false
				if !isdull { break }
			} while true
			let iscancelled = worker?.isCancelled ?? false
			if !iscancelled {
				DispatchQueue.main.async(execute: {
					self.currnr = nr
				})
			}
		}
		DispatchQueue.global(qos: .userInitiated).async(execute: explanationWorker!)
	}
	
	
	@objc func backButtonAction() {
		LoopNext(direction: -1)
	}
	@objc func fwdButtonAction() {
		LoopNext(direction: 1)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//self.navigationController?.setNavigationBarHidden(false, animated: false)
		navigationController?.isNavigationBarHidden = false
		navigationController?.isToolbarHidden = false
		
		CreateToolBar()
		uisearch.searchBarStyle = UISearchBarStyle.prominent
		uisearch.placeholder = "Your favorite number..."
		uisearch.sizeToFit()
		uisearch.isTranslucent = false
		uisearch.backgroundImage = UIImage()
		uisearch.keyboardType = .numberPad
		uisearch.delegate = self
		navigationItem.titleView = uisearch
		self.view.addSubview(tv)
		//self.view.addSubview(uisearch)
		
		setupAutoLayout()
		addDoneButtonOnKeyboard()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.toolbar.barStyle = .blackTranslucent
		navigationController?.toolbar.tintColor = .white
		navigationController?.toolbar.backgroundColor = .black
	}
	
	func addDoneButtonOnKeyboard() {
		let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
		doneToolbar.barStyle       = UIBarStyle.default
		let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		let done: UIBarButtonItem  = UIBarButtonItem(title: "Search", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
		let cancel: UIBarButtonItem  = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.cancelButtonAction))
		var items = [UIBarButtonItem]()
		items.append(cancel)
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
	@objc func cancelButtonAction() {
		self.uisearch.resignFirstResponder()
		self.uisearch.text = ""
	}

	func setupAutoLayout() {
		tv.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		tv.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		tv.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		tv.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

