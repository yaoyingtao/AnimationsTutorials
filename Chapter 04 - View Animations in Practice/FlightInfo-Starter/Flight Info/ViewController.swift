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

//
// Util delay function
//
func delay(seconds: Double, completion:@escaping ()->()) {
  let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
  
  DispatchQueue.main.asyncAfter(deadline: popTime) {
    completion()
  }
}

enum AnimationDirection:Int {
    case Positive = 1;
    case Negative = -1;
}

class ViewController: UIViewController {
  
  @IBOutlet var bgImageView: UIImageView!
  
  @IBOutlet var summaryIcon: UIImageView!
  @IBOutlet var summary: UILabel!
  
  @IBOutlet var flightNr: UILabel!
  @IBOutlet var gateNr: UILabel!
  @IBOutlet var departingFrom: UILabel!
  @IBOutlet var arrivingTo: UILabel!
  @IBOutlet var planeImage: UIImageView!
  
  @IBOutlet var flightStatus: UILabel!
  @IBOutlet var statusBanner: UIImageView!
  
  var snowView: SnowView!
  
  //MARK: view controller methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //adjust ui
    summary.addSubview(summaryIcon)
    summaryIcon.center.y = summary.frame.size.height/2
    
    //add the snow effect layer
    snowView = SnowView(frame: CGRect(x: -150, y:-100, width: 300, height: 50))
    let snowClipView = UIView(frame: view.frame.offsetBy(dx: 0, dy: 50))
    snowClipView.clipsToBounds = true
    snowClipView.addSubview(snowView)
    view.addSubview(snowClipView)
    
    //start rotating the flights
    changeFlightDataTo(londonToParis,animated: true)
  }
  
  //MARK: custom methods
  
  func changeFlightDataTo(_ data: FlightData, animated: Bool = false) {
    
    if animated {
        self.fadeImageView(imageView: bgImageView, toImage: UIImage(named: data.weatherImageName)!, showEffects: data.showWeatherEffects);
        
        let direction:AnimationDirection = data.isTakingOff ? .Positive : .Negative;
        cubeTransition(label: flightNr, text: data.flightNr, direction: direction);
        cubeTransition(label: gateNr , text: data.gateNr, direction: direction);
        
        let offsetDeparting = CGPoint(x: CGFloat(direction.rawValue * 80), y: 0.0)
        moveLabel(label: departingFrom, text: data.departingFrom, offset: offsetDeparting)
        let offsetArriving = CGPoint( x: 0.0, y: CGFloat(direction.rawValue * 50))
        moveLabel(label: arrivingTo, text: data.arrivingTo, offset: offsetArriving)
        
        cubeTransition(label: flightStatus, text: data.flightStatus, direction: direction);

    } else {
        bgImageView.image = UIImage(named: data.weatherImageName)
        snowView.isHidden = !data.showWeatherEffects
        flightNr.text = data.flightNr
        gateNr.text = data.gateNr
        departingFrom.text = data.departingFrom
        arrivingTo.text = data.arrivingTo
        flightStatus.text = data.flightStatus

    }
    
    // populate the UI with the next flight's data
    summary.text = data.summary



    
    // schedule next flight
    delay(seconds: 3.0) {
      self.changeFlightDataTo(data.isTakingOff ? parisToRome : londonToParis,animated: true)
    }
  }
    
    func fadeImageView(imageView: UIImageView, toImage: UIImage, showEffects: Bool) {
        
        UIView.transition(with: imageView, duration: 1.0, options: [.transitionCrossDissolve], animations: {
            imageView.image = toImage;
        }, completion: nil);
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseOut], animations: {
            self.snowView.alpha = showEffects ? 1.0 : 0.0;
        }, completion: nil);
    }
    
    func cubeTransition(label: UILabel, text: String, direction: AnimationDirection) {
        let tempLabel = UILabel(frame: label.frame);
        tempLabel.text = text;
        tempLabel.font = label.font;
        tempLabel.backgroundColor = label.backgroundColor;
        tempLabel.textColor = label.textColor;
        tempLabel.textAlignment = label.textAlignment;
        
        let offset = CGFloat(direction.rawValue) * label.bounds.height/2;
        let tranform = CGAffineTransform(scaleX: 1.0, y: 0.1).concatenating(CGAffineTransform(translationX: 0.0, y: offset));
        tempLabel.transform = tranform;
        
        label.superview?.addSubview(tempLabel);
        
        UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: { 
            tempLabel.transform = CGAffineTransform.identity;
            let tranform1 = CGAffineTransform(scaleX: 1.0, y: 0.1).concatenating(CGAffineTransform(translationX: 0.0, y: -offset));
            label.transform = tranform1;
        }, completion: {_ in
            label.text = tempLabel.text;
            label.transform = CGAffineTransform.identity;
            tempLabel.removeFromSuperview();
        });
    }
    
    func moveLabel(label: UILabel, text: String, offset: CGPoint) {
        let auxLabel = UILabel(frame: label.frame)
        auxLabel.text = text
        auxLabel.font = label.font
        auxLabel.textAlignment = label.textAlignment
        auxLabel.textColor = label.textColor
        auxLabel.backgroundColor = UIColor.clear
        auxLabel.transform = CGAffineTransform( translationX: offset.x, y: offset.y)
        auxLabel.alpha = 0
        view.addSubview(auxLabel)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: { 
            label.transform = CGAffineTransform( translationX: offset.x, y: offset.y)
            label.alpha = 0.0
        }, completion: nil);
        
        UIView.animate(withDuration: 0.25, delay: 0.1, options: [.curveEaseIn], animations: { 
            auxLabel.transform = CGAffineTransform.identity;
            auxLabel.alpha = 1.0;
        }) { _ in
            label.text = text;
            label.transform = CGAffineTransform.identity;
            label.alpha = 1.0;
            auxLabel.removeFromSuperview();
        }
     
    }
  
  
}
