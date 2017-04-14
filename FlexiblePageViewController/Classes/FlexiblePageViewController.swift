//
//  FlexiblePageViewController.swift
//  Pods
//
//  Created by mu29 on 04/14/2017.
//  Copyright (c) 2017 mu29. All rights reserved.
//

import UIKit

public protocol FlexiblePageViewDataSource: class {

  func numberOfData(in pageView: FlexiblePageViewController) -> Int
  func flexiblePageView(_ pageView: FlexiblePageViewController, dataAt index: Int) -> Any?

}

public protocol FlexiblePageViewDelegate: class {

  func flexiblePageView(_ pageView: FlexiblePageViewController, lastIndex index: Int)

}

public class FlexiblePageViewController: UIPageViewController,
  UIPageViewControllerDelegate,
  UIPageViewControllerDataSource {

  private var nextPageIndex: Int = 0
  private var previousPageIndex: Int = 0
  private var pendingIndex: Int = 0
  private var pages: [UIViewController] = []

  public weak var pageDataSource: FlexiblePageViewDataSource?
  public weak var pageDelegate: FlexiblePageViewDelegate?

  public var numberOfItemsPerPage: Int = 20
  public var didPageSelected: ((Int) -> Void)?
  public var currentIndex: Int = 0 {
    didSet {
      previousPageIndex = currentIndex % 3
      setPageContents()
    }
  }
  public var pageInfo: (storyboard: String, view: UIViewController.Type)? {
    didSet {
      guard let pageInfo = pageInfo else { return }
      pages = [
        viewController(pageInfo.view, at: pageInfo.storyboard),
        viewController(pageInfo.view, at: pageInfo.storyboard),
        viewController(pageInfo.view, at: pageInfo.storyboard)
      ]
      setPageContents()
      setViewControllers([pages[currentIndex % 3]], direction: .forward, animated: false, completion: nil)
    }
  }

  public init(options: [String : Any]? = nil) {
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
  }

  required public init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override open func viewDidLoad() {
    super.viewDidLoad()
    let index = currentIndex % 3
    guard pages.indices.contains(index) else { return }
    delegate = self
    dataSource = self
    setViewControllers([pages[index]], direction: .forward, animated: true, completion: nil)
    didPageSelected?(currentIndex)
  }

  public func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController? {
    guard currentIndex > 0 else { return nil }
    return pages[(currentIndex - 1) % 3]
  }

  public func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerAfter viewController: UIViewController
  ) -> UIViewController? {
    guard let dataSource = pageDataSource else { return nil }
    let numberOfData = dataSource.numberOfData(in: self)
    guard numberOfData - 1 > currentIndex else { return nil }
    if currentIndex == numberOfData - numberOfItemsPerPage / 2 {
      pageDelegate?.flexiblePageView(self, lastIndex: numberOfData - 1)
    }
    return pages[(currentIndex + 1) % 3]
  }

  public func pageViewController(
    _ pageViewController: UIPageViewController,
    willTransitionTo pendingViewControllers: [UIViewController]
  ) {
    nextPageIndex = pages.index(of: pendingViewControllers.first!) ?? 0
    let gap = nextPageIndex - previousPageIndex
    pendingIndex = currentIndex + (abs(gap) > 1 ? -abs(gap)/gap : gap)
  }

  public func pageViewController(
    _ pageViewController: UIPageViewController,
    didFinishAnimating finished: Bool,
    previousViewControllers: [UIViewController],
    transitionCompleted completed: Bool
  ) {
    guard completed else { return }
    previousPageIndex = nextPageIndex
    currentIndex = pendingIndex
    didPageSelected?(currentIndex)
  }

  func setPageContents() {
    guard let dataSource = pageDataSource else { return }
    for i in 0 ..< 3 {
      let index = currentIndex + i - 1
      guard let data = dataSource.flexiblePageView(self, dataAt: index) else { continue }
      let extras = ["data": data]
      pages[index % 3].set(extras)
    }
  }

  private func viewController(_ view: UIViewController.Type, at boardName: String?) -> UIViewController {
    let identifier = NSStringFromClass(view).components(separatedBy: ".").last!
    let boardName = boardName ?? "Main"
    let storyboard = UIStoryboard(name: boardName, bundle: nil)
    let view = storyboard.instantiateViewController(withIdentifier: identifier)

    return view
  }

}
