/*
 * Copyright (c) 2014-present Razeware LLC
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
func delay(seconds: Double, completion: @escaping ()-> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
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
    
    let spinner = UIActivityIndicatorView(style: .whiteLarge)
    let status = UIImageView(image: UIImage(named: "banner"))
    let label = UILabel()
    let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]
    
    var statusPosition = CGPoint.zero
    let info = UILabel()
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
        
        info.frame = CGRect(x: 0, y: loginButton.center.y + 60, width: view.frame.size.width, height: 30)
        info.backgroundColor = .clear
        info.font = UIFont(name: "HelveticaNeue", size: 12.0)
        info.textAlignment = .center
        info.textColor = .white
        info.text = "Tap on a field and enter username and password"
        view.insertSubview(info, belowSubview: loginButton)
    }
    
    func tintBackgroundColor(layer: CALayer, toColor: UIColor) {
        let changeBackground = CASpringAnimation(keyPath: "backgroundColor")
        
        changeBackground.fromValue = layer.backgroundColor
        changeBackground.toValue = toColor.cgColor
        
        changeBackground.duration = changeBackground.settlingDuration
        layer.add(changeBackground, forKey: nil)
        layer.backgroundColor = toColor.cgColor
    }
    
    func roundCorner(layer: CALayer, toRadius: CGFloat) {
        let corners = CASpringAnimation(keyPath: "cornerRadius")
        corners.fromValue = 3
        corners.toValue = toRadius
        corners.damping = 7
        corners.duration = corners.settlingDuration
        layer.add(corners, forKey: nil)
        layer.cornerRadius = toRadius
    }
    
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 0.0
        fadeIn.toValue = 1
        fadeIn.duration = 0.5
        fadeIn.fillMode = .backwards
        fadeIn.beginTime = CACurrentMediaTime() + 0.5
        cloud1.layer.add(fadeIn, forKey: nil)
        fadeIn.beginTime = CACurrentMediaTime() + 0.7
        cloud2.layer.add(fadeIn, forKey: nil)
        fadeIn.beginTime = CACurrentMediaTime() + 0.9
        cloud3.layer.add(fadeIn, forKey: nil)
        fadeIn.beginTime = CACurrentMediaTime() + 1.1
        cloud4.layer.add(fadeIn, forKey: nil)
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.5
        animationGroup.fillMode = .backwards
        animationGroup.delegate = self
        
        let fade = CABasicAnimation(keyPath: "opcatity")
        fade.fromValue = 0.25
        fade.toValue = 1
        
        let flyRight = CABasicAnimation(keyPath: "position.x")
        flyRight.fromValue = -view.bounds.size.width / 2
        flyRight.toValue = view.bounds.size.width / 2
        
        animationGroup.animations = [fade, flyRight]
        heading.layer.add(animationGroup, forKey: nil)
        
        animationGroup.setValue("form", forKey: "name")
        animationGroup.setValue(username.layer, forKey: "layer")
        animationGroup.beginTime = CACurrentMediaTime() + 0.3
        username.layer.add(animationGroup, forKey: nil)
        
        animationGroup.setValue(password.layer, forKey: "layer")
        animationGroup.beginTime = CACurrentMediaTime() + 0.4
        password.layer.add(animationGroup, forKey: nil)
        
        
    }
    
    // MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        groupAnimation.beginTime = CACurrentMediaTime() + 0.5
        groupAnimation.duration = 0.5
        groupAnimation.fillMode = .backwards
        // First animation for the animation group
        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.fromValue = 3.5
        scaleDown.toValue = 1
        // Second animation for the animation group
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fromValue = Float.pi / 4
        rotate.toValue = 0
        // Third animation for the animation group
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 0
        fade.toValue = 1
        
        groupAnimation.animations = [scaleDown, rotate, fade]
        loginButton.layer.add(groupAnimation, forKey: nil)
        
        animateCloud(layer: cloud1.layer)
        animateCloud(layer: cloud2.layer)
        animateCloud(layer: cloud3.layer)
        animateCloud(layer: cloud4.layer)
        
        let flyLeft = CABasicAnimation(keyPath: "position.x")
        flyLeft.fromValue = info.layer.position.x + view.frame.size.width
        flyLeft.toValue = info.layer.position.x
        flyLeft.duration = 5
        info.layer.add(flyLeft, forKey: "infoappear")
        
        let fadeLabelIn = CABasicAnimation(keyPath: "opacity")
        fadeLabelIn.fromValue = 0.2
        fadeLabelIn.toValue = 1
        fadeLabelIn.duration = 4.5
        info.layer.add(fadeLabelIn, forKey: "fadein")
        
        username.delegate = self
        password.delegate = self
    }
    
    func showMessage(index: Int) {
        label.text = messages[index]
        
        UIView.transition(with: status, duration: 0.33,
                          options: [.curveEaseOut, .transitionFlipFromBottom],
                          animations: {
                            self.status.isHidden = false
        },
                          completion: {_ in
                            //transition completion
                            delay(seconds: 2.0) {
                                if index < self.messages.count-1 {
                                    self.removeMessage(index: index)
                                } else {
                                    //reset form
                                    self.resetForm()
                                }
                            }
        }
        )
    }
    
    func removeMessage(index: Int) {
        
        UIView.animate(withDuration: 0.33, delay: 0.0,
                       animations: {
                        self.status.center.x += self.view.frame.size.width
        },
                       completion: {_ in
                        self.status.isHidden = true
                        self.status.center = self.statusPosition
                        
                        self.showMessage(index: index+1)
        }
        )
    }
    
    func resetForm() {
        UIView.transition(with: status, duration: 0.2, options: .transitionFlipFromTop,
                          animations: {
                            self.status.isHidden = true
                            self.status.center = self.statusPosition
        },
                          completion: nil
        )
        
        UIView.animate(withDuration: 0.2, delay: 0.0,
                       animations: {
                        self.spinner.center = CGPoint(x: -20.0, y: 16.0)
                        self.spinner.alpha = 0.0
                        self.loginButton.bounds.size.width -= 80.0
                        self.loginButton.center.y -= 60.0
        }) { _ in
            let tintColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
            self.tintBackgroundColor(layer: self.loginButton.layer, toColor: tintColor)
            self.roundCorner(layer: self.loginButton.layer, toRadius: 10)
        }
    }
    
    // MARK: further methods
    
    @IBAction func login() {
        view.endEditing(true)
        
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 0.0,
                       animations: {
                        self.loginButton.bounds.size.width += 80.0
        },
                       completion: {_ in
                        self.showMessage(index: 0)
        }
        )
        
        UIView.animate(withDuration: 0.33, delay: 0.0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.0,
                       animations: {
                        self.loginButton.center.y += 60.0
                        self.spinner.center = CGPoint(x: 40.0, y: self.loginButton.frame.size.height/2)
                        self.spinner.alpha = 1.0
        },
                       completion: nil
        )
        
        let tintColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
        tintBackgroundColor(layer: loginButton.layer, toColor: tintColor)
        roundCorner(layer: loginButton.layer, toRadius: 25)
    }
    
    func animateCloud(layer: CALayer) {
        let cloudSpeed = 60 / Double(view.layer.frame.size.width)
        
        let duration: TimeInterval = Double(view.layer.frame.size.width - layer.frame.origin.x) * cloudSpeed
        
        let cloudMove = CABasicAnimation(keyPath: "position.x")
        cloudMove.duration = duration
        cloudMove.toValue = self.view.bounds.width + layer.bounds.width / 2
        cloudMove.delegate = self
        cloudMove.setValue("cloud", forKey: "name")
        cloudMove.setValue(layer, forKey: "layer")
        layer.add(cloudMove, forKey: nil)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextField = (textField === username) ? password : username
        nextField?.becomeFirstResponder()
        return true
    }
    
}
extension ViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let name = anim.value(forKey: "name") as? String else { return }
        
        if name == "form" {
            let layer = anim.value(forKey: "layer") as? CALayer
            anim.setValue(nil, forKey: "layer")
            
            let pulse = CASpringAnimation(keyPath: "transform.scale")
            pulse.damping = 7.5
            pulse.fromValue = 1.25
            pulse.toValue = 1
            pulse.duration = pulse.settlingDuration
            layer?.add(pulse, forKey: nil)
        } else if name == "cloud" {
            guard let layer = anim.value(forKey: "layer") as? CALayer else { return }
            anim.setValue(nil, forKey: "layer")
            
            layer.position.x = -layer.bounds.width / 2
            
            delay(seconds: 0.5) {
                self.animateCloud(layer: layer)
            }
        }
        print("animation did finish")
    }
}
// MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let runningAnimation = info.layer.animationKeys() else {
            return
        }
        
        print(runningAnimation)
        info.layer.removeAnimation(forKey: "infoappear")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count < 5 {
            // add animation here
            let jump = CASpringAnimation(keyPath: "position.y")
            jump.fromValue = textField.layer.position.y + 1
            jump.toValue = textField.layer.position.y
            jump.initialVelocity = 100
            jump.mass =  10
            jump.stiffness = 1500
            jump.damping = 50
            jump.duration = jump.settlingDuration
            
            textField.layer.add(jump, forKey: nil)
            
            textField.layer.borderWidth = 3
            textField.layer.cornerRadius = 5
            textField.layer.borderColor = UIColor.clear.cgColor
            
            let flash = CASpringAnimation(keyPath: "borderColor")
            flash.damping = 7
            flash.stiffness = 200
            flash.fromValue = UIColor(red: 1.0, green: 0.27, blue: 0.0, alpha: 1.0).cgColor
            flash.toValue = UIColor.white.cgColor
            flash.duration = flash.settlingDuration
            textField.layer.add(flash, forKey: nil)
        }
    }
}
