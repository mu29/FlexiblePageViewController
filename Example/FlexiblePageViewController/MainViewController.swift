//
//  MainViewController.swift
//  FlexiblePageViewController
//
//  Created by mu29 on 04/14/2017.
//  Copyright (c) 2017 mu29. All rights reserved.
//

import UIKit
import FlexiblePageViewController

class MainViewController: UIViewController {

  @IBOutlet weak var pageLbl: UILabel!

  var pageContainer: FlexiblePageViewController!
  var contents: [String] = []
  var page = 0
  let contentDataSource = ContentDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()
    loadData(at: page) {
      self.setPager()
    }
  }

  private func setPager() {
    pageContainer = FlexiblePageViewController()
    pageContainer.pageDataSource = self
    pageContainer.pageDelegate = self
    pageContainer.numberOfItemsPerPage = 10
    pageContainer.didPageSelected = didPageSelected
    pageContainer.pageInfo = (storyboard: "Main", view: ContentViewController.self)
    view.addSubview(pageContainer.view)
    view.sendSubview(toBack: pageContainer.view)
  }

  func didPageSelected(index: Int) {
    pageLbl.text = "Page \(index + 1)"
  }

  func loadData(at page: Int, onComplete: (() -> Void)? = nil) {
    contentDataSource.loadData(at: page) {
      self.contents.append(contentsOf: $0)
      self.page += 1
      onComplete?()
    }
  }

}

extension MainViewController: FlexiblePageViewDataSource, FlexiblePageViewDelegate {

  func numberOfData(in pageView: FlexiblePageViewController) -> Int {
    return contents.count
  }

  func flexiblePageView(_ pageView: FlexiblePageViewController, dataAt index: Int) -> Any? {
    guard contents.indices.contains(index) else { return nil }
    return contents[index]
  }

  func flexiblePageView(_ pageView: FlexiblePageViewController, lastIndex index: Int) {
    loadData(at: page)
  }

}
