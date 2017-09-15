//
//  MainViewController.swift
//  QuranSpeechApp
//
//  Created by Hasan Sa on 06/06/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import UIKit

enum State {
  case recording
  case browsing
  
  mutating func update() {
    self = (self == .recording) ? .browsing : .recording
  }
  
  mutating func muliplier() -> CGFloat {
    update()
    return (self == .browsing) ? 0.25 : 0.95
  }
}

class MainViewController: UIViewController {
  
  @IBOutlet weak var recorderContainerView: UIView! {
    didSet {
      recorderContainerView.layer.cornerRadius = 5
      
    }
  }
  @IBOutlet weak var resultsContainerView: UIView! {
    didSet {
      resultsContainerView.layer.cornerRadius = 10
    }
  }
  
  @IBOutlet weak var recorderHeightConstraint: NSLayoutConstraint!
  
  var state: State  = .recording
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateViewHeightConstraint()
    addChildrenViewController()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }
}

// MARK: private
fileprivate extension MainViewController {
  
  func updateViewHeightConstraint() {
    let muliplier = state.muliplier()
    view.layoutIfNeeded()
    
    UIView.animate(withDuration: 0.75,
                   delay: 0.1,
                   usingSpringWithDamping: 0.6,
                   initialSpringVelocity: 0,
                   options: [],
                   animations: {
                    self.recorderHeightConstraint.constant = self.view.bounds.height * muliplier
                    self.view.layoutIfNeeded()
    },
                   completion: nil)
  }
  
  func addChildrenViewController() {
    
    func add(viewController: UIViewController, on containerView: UIView) {
      viewController.willMove(toParentViewController: self)
      viewController.view.frame = containerView.bounds
      viewController.view.layer.cornerRadius = containerView.layer.cornerRadius
      containerView.addSubview(viewController.view)
      addChildViewController(viewController)
      viewController.didMove(toParentViewController: self)
    }
    
    if let recorderVC = self.storyboard?.instantiateViewController(withIdentifier: "RecorderVC")
      as? RecorderViewController {
      recorderVC.delegate = self
      add(viewController: recorderVC, on: recorderContainerView)
    }
    
    if let resultsVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultsVC") as? ResultsViewController {
      resultsVC.delegate = self
      add(viewController: resultsVC, on: resultsContainerView)
    }
  }
}

extension MainViewController: ResizableDelegate {
  func shouldUpdateContainerView() {
    self.updateViewHeightConstraint()
  }
}
