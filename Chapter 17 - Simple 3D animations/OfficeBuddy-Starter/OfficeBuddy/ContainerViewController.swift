/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import QuartzCore

class ContainerViewController: UIViewController {
  
  let menuWidth: CGFloat = 80.0
  let animationTime: TimeInterval = 0.5
  
  let menuViewController: UIViewController!
  let centerViewController: UIViewController!
  
  var isOpening = false
  
  init(sideMenu: UIViewController, center: UIViewController) {
    menuViewController = sideMenu
    centerViewController = center
    super.init(nibName: nil, bundle: nil)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    view.backgroundColor = UIColor.black
    setNeedsStatusBarAppearanceUpdate()
    
    addChildViewController(centerViewController)
    view.addSubview(centerViewController.view)
    centerViewController.didMove(toParentViewController: self)
    
    addChildViewController(menuViewController)
    view.addSubview(menuViewController.view)
    menuViewController.didMove(toParentViewController: self)
    
    menuViewController.view.layer.anchorPoint.x = 1.0;
    menuViewController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: view.frame.height)
    
    let panGesture = UIPanGestureRecognizer(target:self, action:Selector("handleGesture:"))
    view.addGestureRecognizer(panGesture)
    
    setToPercent(0.0)
  }
  
  func handleGesture(_ recognizer: UIPanGestureRecognizer) {
    
    let translation = recognizer.translation(in: recognizer.view!.superview!)
    
    var progress = translation.x / menuWidth * (isOpening ? 1.0 : -1.0)
    progress = min(max(progress, 0.0), 1.0)
    
    switch recognizer.state {
    case .began:
      let isOpen = floor(centerViewController.view.frame.origin.x/menuWidth)
      isOpening = isOpen == 1.0 ? false: true
        
      menuViewController.view.layer.shouldRasterize = true
      menuViewController.view.layer.rasterizationScale = UIScreen.main.scale
      
    case .changed:
      self.setToPercent(isOpening ? progress: (1.0 - progress))
      self.menuViewController.view.layer.shouldRasterize = false
    case .ended: fallthrough
    case .cancelled: fallthrough
    case .failed:
      
      var targetProgress: CGFloat
      if (isOpening) {
        targetProgress = progress < 0.5 ? 0.0 : 1.0
      } else {
        targetProgress = progress < 0.5 ? 1.0 : 0.0
      }
      
      UIView.animate(withDuration: animationTime, animations: {
        self.setToPercent(targetProgress)
        }, completion: {_ in
          
      })
      
    default: break
    }
  }
  
  func toggleSideMenu() {
    let isOpen = floor(centerViewController.view.frame.origin.x/menuWidth)
    let targetProgress: CGFloat = isOpen == 1.0 ? 0.0: 1.0
    
    UIView.animate(withDuration: animationTime, animations: {
      self.setToPercent(targetProgress)
      }, completion: { _ in
        self.menuViewController.view.layer.shouldRasterize = false
    })
  }
  
  func setToPercent(_ percent: CGFloat) {
    centerViewController.view.frame.origin.x = menuWidth * CGFloat(percent)
//    menuViewController.view.frame.origin.x = menuWidth * CGFloat(percent) - menuWidth
    menuViewController.view.layer.transform = menuTransformForPercent(percent);
    menuViewController.view.alpha = CGFloat(max(0.2, percent))
    
  }
    
    func menuTransformForPercent(_ percent: CGFloat) -> CATransform3D{
        var identy = CATransform3DIdentity;
        identy.m34 = -1.0/1000;
        let remaindPercent = 1 - percent;
        let angle = remaindPercent * CGFloat(-M_PI_2);
        let rotateTranform = CATransform3DRotate(identy, angle, 0.0, 1.0, 0.0);
        let translateTranfoem = CATransform3DTranslate(identy, menuWidth*percent, 0, 0);
        return CATransform3DConcat(rotateTranform, translateTranfoem);
        
    }
  
}
