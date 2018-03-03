//
//  WikiCell.swift
//  Numbers
//
//  Created by Stephan Jancar on 02.03.18.
//  Copyright © 2018 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit
import BigInt
import YouTubePlayer

class YoutTubeTableCell: BaseNrTableCell , UIWebViewDelegate {
	private (set) var uitube = YouTubePlayerView()
	
	private var tubeurl : String = ""
	var jumper : NumberJump? = nil
	
	private func SetTubeUrl(tube : String) {
		if tube == tubeurl {
			return
		}
		self.tubeurl = tube
		if let myVideoURL = URL(string: self.tubeurl) {
			uitube.loadVideoURL(myVideoURL)
		}
		//uitube.loadVideoID(self.tubeurl)
	}
	
	func SetTubeNr(n: BigUInt)  {
		self.nr = n
		let tube = NumberphileLinks.shared.getTube(n: n)
		SetTubeUrl(tube: tube)
	}
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(uitube)
		uitube.translatesAutoresizingMaskIntoConstraints = false
		uitube.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0).isActive = true
		uitube.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant : 0.0).isActive = true
		uitube.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		uitube.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

