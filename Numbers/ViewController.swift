//
//  ViewController.swift
//  Numbers
//
//  Created by Stephan Jancar on 03.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import UIKit
import iosMath

/*
class Explain {
	
	private var vc : ViewController!
	private var info0 = UILabel()
	private var math = MTMathUILabel()
	init(vc : UIViewController) {
		self.vc = vc
		info0.lineBreakMode = .byWordWrapping
		info0.numberOfLines = 0
		vc.view.addSubview(info0)
		
		
	}
	func setInfo(str: Str)
	
	func Layout(x0: CGFloat, y0: CGFloat) {
		
		
	}
	
	
	
}

*/

class DescTableCell: UITableViewCell {
	
	private (set) var uidesc = UITextView()
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(uidesc)
		uidesc.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class FormTableCell: UITableViewCell {
	private (set) var uimath = MTMathUILabel()
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(uimath)
		uimath.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
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


class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , UISearchBarDelegate  {
	
	private let headerId = "headerId"
	private let footerId = "footerId"
	private let desccellId = "desccellId"
	private let formcellId = "formcellId"
	
	lazy var uisearch: UISearchBar = UISearchBar()
	
	//Zwiwchenspeicher fuer Cell-Subviews
	private var uidesctemp : UITextView? = nil
	private var uiformtemp : MTMathUILabel? = nil
	
	private var desc : String = "A text"
	private var formula : String = "\\forall n \\in \\mathbb{N} : n = n + 0"
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return "Description"
		case 1:
			return "Formula"
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
		let width = tableView.frame.size.width - 20
		switch indexPath.section {
		case 0:
			if let temp = uidesctemp {
				temp.sizeToFit()
				let height = temp.sizeThatFits(CGSize(width:width, height: CGFloat.greatestFiniteMagnitude)).height
				return height + 20.0
			}
		case 1:
			if let temp = uiformtemp {
				temp.sizeToFit()
				let height = temp.sizeThatFits(CGSize(width:width, height: CGFloat.greatestFiniteMagnitude)).height
				return height + 20.0
			}
		default:
			break
		}
		return 150
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			if let cell = tableView.dequeueReusableCell(withIdentifier: desccellId, for: indexPath) as? DescTableCell {
				cell.uidesc.text = desc
				uidesctemp = cell.uidesc
				return cell
			}
		case 1:
			if let cell = tableView.dequeueReusableCell(withIdentifier: formcellId, for: indexPath) as? FormTableCell {
				cell.uimath.latex = formula
				uiformtemp = cell.uimath
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
		return tv
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
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
		let done: UIBarButtonItem  = UIBarButtonItem(title: "Search", style: UIBarButtonItemStyle.done, target: self, action: #selector(ViewController.doneButtonAction))
		
		var items = [UIBarButtonItem]()
		items.append(flexSpace)
		items.append(done)
		
		doneToolbar.items = items
		doneToolbar.sizeToFit()
		
		self.uisearch.inputAccessoryView = doneToolbar
	}
	
	@objc func doneButtonAction() {
		self.uisearch.resignFirstResponder()
	}
	
	func setupAutoLayout() {
		
		uisearch.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		uisearch.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		uisearch.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		//uisearch.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		tv.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		tv.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		tv.topAnchor.constraint(equalTo: uisearch.bottomAnchor).isActive = true
		tv.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	/*
	private func fillweb(n : UInt64) {
		let localfilePath = Bundle.main.url(forResource: "home", withExtension: "html");
		let myRequest = NSURLRequest(URL: localfilePath!);
		layout.web.loadRequest(myRequest);
		
	}
	*/
	
}

