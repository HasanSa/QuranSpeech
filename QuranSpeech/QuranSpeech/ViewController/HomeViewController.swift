//
//  HomeViewController.swift
//  QuranSpeech
//
//  Created by Hasan Sa on 06/05/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import UIKit
import BubbleTransition
import QuranSpeechEngine

class HomeViewController: UIViewController {
  
  @IBOutlet weak var transitionButton: UIButton!
  let transition = BubbleTransition()
  
  lazy var resultsCollectionViewController: ResultsTableViewController = {
      return self.storyboard?.instantiateViewController(withIdentifier: "ResultsTableVC")
  }() as! ResultsTableViewController
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    resultsCollectionViewController.willMove(toParentViewController: self)
    resultsCollectionViewController.view.frame = view.frame
    view.insertSubview(resultsCollectionViewController.view, belowSubview: transitionButton)
    addChildViewController(resultsCollectionViewController)
    resultsCollectionViewController.didMove(toParentViewController: self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }
  
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let controller = segue.destination as? SpeechRecognizerViewController {
      controller.delegate = self
      controller.transitioningDelegate = self
      controller.modalPresentationStyle = .custom
    }
  }
}

extension HomeViewController: SpeechRecognizerViewControllerDelegate {
  func didUpdate(speechText: String?) {
    resultsCollectionViewController.loadData(for: speechText)
  }
}

 // MARK: UIViewControllerTransitioningDelegate
extension HomeViewController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .present
    transition.startingPoint = transitionButton.center
    transition.bubbleColor = transitionButton.backgroundColor!
    return transition
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .dismiss
    transition.startingPoint = transitionButton.center
    transition.bubbleColor = transitionButton.backgroundColor!
    return transition
  }
}
