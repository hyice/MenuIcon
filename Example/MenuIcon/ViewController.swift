//
//  ViewController.swift
//  MenuIcon
//
//  Created by hyice on 03/12/2018.
//  Copyright (c) 2018 hyice. All rights reserved.
//

import UIKit
import MenuIcon

class ViewController: UIViewController {
    
    let menuIcon = MenuIcon(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        menuIcon.backgroundColor = UIColor(red: 0xdb/255.0, green: 0x58/255.0, blue: 0x3b/255.0, alpha: 1.0)
        menuIcon.lineColor = UIColor.white
//        menuIcon.lineWidth = 10
        view.addSubview(menuIcon)
        
        menuIcon.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: menuIcon, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: menuIcon, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0))
        menuIcon.addConstraint(NSLayoutConstraint(item: menuIcon, attribute: .width, relatedBy:.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200))
        menuIcon.addConstraint(NSLayoutConstraint(item: menuIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(iconTapped(sender:)))
        menuIcon.addGestureRecognizer(tap)
    }
    
    @objc func iconTapped(sender: UITapGestureRecognizer) {
        if menuIcon.isOpened {
            menuIcon.close()
        } else {
            menuIcon.open()
        }
    }

}

