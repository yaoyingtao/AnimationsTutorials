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

// A delay function
func delay(seconds: Double, completion:@escaping ()->()) {
  let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
  
  DispatchQueue.main.asyncAfter(deadline: popTime) {
    completion()
  }
}

class ViewController: UIViewController {
  
  // MARK: IB outlets
  
  @IBOutlet var loginButton: UIButton!
  @IBOutlet var heading: UILabel!
  @IBOutlet var username: UITextField!
  @IBOutlet var password: UITextField!
  
  @IBOutlet var cloud1: UIImageView!
  @IBOutlet var cloud2: UIImageView!
  @IBOutlet var cloud3: UIImageView!
  @IBOutlet var cloud4: UIImageView!
  
  // MARK: further UI
  
  let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  let status = UIImageView(image: UIImage(named: "banner"))
  let label = UILabel()
  let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]
  
  var statusPosition = CGPoint.zero
  
  // MARK: view controller methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //set up the UI
    loginButton.layer.cornerRadius = 8.0
    loginButton.layer.masksToBounds = true
    
    spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
    spinner.startAnimating()
    spinner.alpha = 0.0
    loginButton.addSubview(spinner)
    
    status.isHidden = true
    status.center = loginButton.center
    view.addSubview(status)
    
    label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
    label.font = UIFont(name: "HelveticaNeue", size: 18.0)
    label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
    label.textAlignment = .center
    status.addSubview(label)
    
    statusPosition = status.center
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
//    heading.center.x  -= view.bounds.width
//    username.center.x -= view.bounds.width
//    password.center.x -= view.bounds.width

//    cloud1.alpha = 0.0
//    cloud2.alpha = 0.0
//    cloud3.alpha = 0.0
//    cloud4.alpha = 0.0
    
    loginButton.center.y += 30.0
    loginButton.alpha = 0.0
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let ani = CABasicAnimation(keyPath: "position.x");
    ani.fromValue = -view.center.x;
    ani.toValue = view.center.x;
    ani.duration = 0.5;
    
    self.heading.layer.add(ani, forKey: nil);
    ani.beginTime = CACurrentMediaTime() + 0.3;
    self.username.layer.add(ani, forKey: nil);
    ani.beginTime = CACurrentMediaTime() + 0.4;
    self.password.layer.add(ani, forKey: nil);
    
//    UIView.animate(withDuration: 0.5, animations: {
//      self.heading.center.x += self.view.bounds.width
//    })
//
//    UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
//      self.username.center.x += self.view.bounds.width
//    }, completion: nil)
//
//    UIView.animate(withDuration: 0.5, delay: 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
//      self.password.center.x += self.view.bounds.width
//    }, completion: nil)
    
    let alpAni = CABasicAnimation(keyPath: "opacity");
    alpAni.fromValue = 0.0;
    alpAni.toValue = 1.0;
    alpAni.duration = 0.5;
    
    alpAni.beginTime = CACurrentMediaTime() + 0.5;
    self.cloud1.layer.add(alpAni, forKey: nil);
    alpAni.beginTime = CACurrentMediaTime() + 0.7;
    self.cloud2.layer.add(alpAni, forKey: nil);
    alpAni.beginTime = CACurrentMediaTime() + 0.9;
    self.cloud3.layer.add(alpAni, forKey: nil);
    alpAni.beginTime = CACurrentMediaTime() + 0.5;
    self.cloud4.layer.add(alpAni, forKey: nil);

    
//    UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: {
//      self.cloud1.alpha = 1.0
//    }, completion: nil)
//    
//    UIView.animate(withDuration: 0.5, delay: 0.7, options: [], animations: {
//      self.cloud2.alpha = 1.0
//    }, completion: nil)
//    
//    UIView.animate(withDuration: 0.5, delay: 0.9, options: [], animations: {
//      self.cloud3.alpha = 1.0
//    }, completion: nil)
//    
//    UIView.animate(withDuration: 0.5, delay: 1.1, options: [], animations: {
//      self.cloud4.alpha = 1.0
//    }, completion: nil)
    
    UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
        self.loginButton.center.y -= 30.0
        self.loginButton.alpha = 1.0
    }, completion: nil)

    animateCloud(cloud1)
    animateCloud(cloud2)
    animateCloud(cloud3)
    animateCloud(cloud4)
  }
  
  // MARK: further methods
  
  @IBAction func login() {

    UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [], animations: {
      self.loginButton.bounds.size.width += 80.0
    }, completion: nil)

    UIView.animate(withDuration: 0.33, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
      self.loginButton.center.y += 60.0
//      self.loginButton.backgroundColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
        
      self.spinner.center = CGPoint(x: 40.0, y: self.loginButton.frame.size.height/2)
      self.spinner.alpha = 1.0

    }, completion: {_ in
      self.showMessage(index: 0)
    })
    
    self.tintBackgroundColor(layer: self.loginButton.layer, toColor: UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0))
    roundCorners(layer: self.loginButton.layer, toRadius: 25);

    
  }

  func showMessage(index: Int) {
    label.text = messages[index]
    
    UIView.transition(with: status, duration: 0.33, options:
      [.curveEaseOut, .transitionFlipFromBottom], animations: {
        self.status.isHidden = false
      }, completion: {_ in
        //transition completion
        delay(seconds: 2.0) {
          if index < self.messages.count-1 {
            self.removeMessage(index: index)
          } else {
            //reset form
            self.resetForm()
          }
        }
    })
  }

  func removeMessage(index: Int) {
    UIView.animate(withDuration: 0.33, delay: 0.0, options: [], animations: {
      self.status.center.x += self.view.frame.size.width
    }, completion: {_ in
      self.status.isHidden = true
      self.status.center = self.statusPosition
      
      self.showMessage(index: index+1)
    })
  }

  func resetForm() {
    UIView.transition(with: status, duration: 0.2, options: .transitionFlipFromTop, animations: {
      self.status.isHidden = true
      self.status.center = self.statusPosition
    }, completion: nil)
    
    UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
      self.spinner.center = CGPoint(x: -20.0, y: 16.0)
      self.spinner.alpha = 0.0
//      self.loginButton.backgroundColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
      self.loginButton.bounds.size.width -= 80.0
      self.loginButton.center.y -= 60.0
    }, completion: nil)
    self.tintBackgroundColor(layer: self.loginButton.layer, toColor: UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0))
    roundCorners(layer: self.loginButton.layer, toRadius: 10);


  }
  
  func animateCloud(_ cloud: UIImageView) {
    let cloudSpeed = 60.0 / view.frame.size.width
    let duration = (view.frame.size.width - cloud.frame.origin.x) * cloudSpeed
    UIView.animate(withDuration: TimeInterval(duration), delay: 0.0, options: .curveLinear, animations: {
      cloud.frame.origin.x = self.view.frame.size.width
    }, completion: {_ in
      cloud.frame.origin.x = -cloud.frame.size.width
      self.animateCloud(cloud)
    })
  }
    
    func tintBackgroundColor(layer: CALayer, toColor: UIColor) {
        let backAni = CABasicAnimation(keyPath: "backgroundColor");
        backAni.fromValue = layer.backgroundColor
        backAni.toValue = toColor.cgColor;
        backAni.duration = 1.0;
        layer.add(backAni, forKey: nil);
        layer.backgroundColor = toColor.cgColor;
    }
    
    func roundCorners(layer: CALayer, toRadius: CGFloat) {
        let cornerAni = CABasicAnimation(keyPath: "cornerRadius");
        cornerAni.fromValue = layer.cornerRadius
        cornerAni.toValue = toRadius;
        cornerAni.duration = 0.33;
        layer.add(cornerAni, forKey: nil);
        layer.cornerRadius = toRadius;
    }
  
}

