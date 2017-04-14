//
//  ContentViewController.swift
//  FlexiblePageViewController
//
//  Created by mu29 on 04/14/2017.
//  Copyright (c) 2017 mu29. All rights reserved.
//

import UIKit
import FlexiblePageViewController

class ContentViewController: UIViewController {

  @IBOutlet weak var contentLbl: UILabel!

  var content: String = ""

  // Need to receive data from pager
  override func set(_ extras: [String : Any]) {
    content = extras["data"] as? String ?? ""
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    contentLbl.text = content
  }

}
