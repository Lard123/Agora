//
//  ViewController.swift
//  Agora
//
//  Created by Varun Shenoy on 11/22/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase

class LogInVC: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        let videoURL: NSURL = Bundle.main.url(forResource: "login", withExtension: "mp4")! as NSURL
        
        player = AVPlayer(url: videoURL as URL)
        player.actionAtItemEnd = .none
        player.isMuted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1
        
        playerLayer.frame = view.frame
        
        view.layer.addSublayer(playerLayer)
        
        player.play()
        
        //loop video
        NotificationCenter.default.addObserver(self, selector: #selector(LogInVC.loopVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func loopVideo() {
        player.seek(to: kCMTimeZero)
        player.play()
    }
    
    @IBAction func signIn(_ sender: AnyObject) {
        let email = usernameField.text!
        let password = passwordField.text!
        if email == "" {
            SCLAlertView().showError("Login Error", subTitle: "Please enter an email.")
            usernameField.attributedPlaceholder = NSAttributedString(string:"EMAIL",
                                                                  attributes:[NSForegroundColorAttributeName: UIColor(red:0.99, green:0.24, blue:0.27, alpha:1.00)])
        } else if password == "" {
            SCLAlertView().showError("Login Error", subTitle: "Please enter an password.")
            passwordField.attributedPlaceholder = NSAttributedString(string:"PASSWORD",
                                                                     attributes:[NSForegroundColorAttributeName: UIColor(red:0.99, green:0.24, blue:0.27, alpha:1.00)])
        } else {
            self.beginLoading()
            FIRAuth.auth()?.signIn(withEmail: usernameField.text!, password: passwordField.text!) { (user, error) in
                if error == nil {
                    self.endLoading()
                    self.performSegue(withIdentifier: "toIntroVC", sender: self)
                } else {
                    self.endLoading()
                    let errText = (error?.localizedDescription)!
                    print(error)
                    if errText == "An internal error has occurred, print and inspect the error details for more information." {
                        SCLAlertView().showError("Form has been filled out incorrectly.", subTitle: "Check for errors in your entries.")
                    } else {
                        SCLAlertView().showError((error?.localizedDescription)!, subTitle: "Try again.")
                    }
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpWithFacebook(_ sender: AnyObject) {
        
    }


}

public extension UIViewController {
    @IBAction public func unwindToViewController (_ segue: UIStoryboardSegue){}
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func beginLoading() {
        let alert = UIAlertController(title: "Loading...", message: nil, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = .whiteLarge
        loadingIndicator.color = UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.00)
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func endLoading() {
        dismiss(animated: false, completion: nil)
    }
}


