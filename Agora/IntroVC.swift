//
//  IntroVC.swift
//  Agora
//
//  Created by Varun Shenoy on 11/23/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftMessages

class IntroVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var targetMeter: UIProgressView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentAmountLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    var school = CustomPointAnnotation()
    var ref: FIRDatabaseReference!
    var loggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }

    override func viewWillAppear(_ animated: Bool) {
        getFundedData(completionHandler: { (bool) in
            
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if loggedIn {
            loggedIn = false
            let view = MessageView.viewFromNib(layout: .CardView)
            view.button?.removeFromSuperview()
            
            // Theme message elements with the success style.
            view.configureTheme(.success)
            
            // Add a drop shadow.
            view.configureDropShadow()
            
            // Set message title, body, and icon. Here, we're overriding the default warning
            // image with an emoji character.
            view.configureContent(title: "Logged In", body: "Successfully signed in as \(FIRAuth.auth()!.currentUser!.email!)")
            
            // Show the message.
            SwiftMessages.show(view: view)
        }
        self.mapView.delegate = self
        self.school.coordinate = CLLocationCoordinate2DMake(37.3196, -122.0092)
        self.school.imageName = "dusty.png"
        self.school.title = "Cupertino High School"
        self.school.subtitle = "10100 Finch Ave, Cupertino, CA 95014"
        self.mapView.addAnnotation(self.school)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.school.coordinate.latitude, longitude: self.school.coordinate.longitude), span: MKCoordinateSpanMake(0.075, 0.075))
        self.mapView.setRegion(region, animated: true)
        self.mapView.selectAnnotation(self.school, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "Location"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
        }
        else {
            anView!.annotation = annotation
        }
        let cpa = annotation as! CustomPointAnnotation
        anView!.image = UIImage(named: cpa.imageName)
        
        return anView
    }
    
    func getFundedData(completionHandler:@escaping (Bool) -> ()) {
        ref = FIRDatabase.database().reference()
        ref.child("stats").observeSingleEvent(of: .value, with: { (snapshot) in
            self.updateWithDict(snapshot: snapshot)
        })
    }
    
    func updateWithDict(snapshot: FIRDataSnapshot) {
        if let dict = snapshot.value as? [String : AnyObject] {
            print(dict)
            let currentAmount = dict["current"] as! Double
            let fullAmount = dict["goal"] as! Double
            let due = dict["due"] as! Double
            let dueDate = Date(timeIntervalSince1970: due)
            let today = Date()
            let daysLeft = self.daysBetween(start: today, end: dueDate)
            if daysLeft > 1 {
                self.dueDateLabel.text = "\(daysLeft) days left"
            } else if daysLeft == 1 {
                self.dueDateLabel.text = "\(daysLeft) day left"
            } else {
                self.dueDateLabel.text = "Fundraiser finished. Items can still be sold."
            }
            let scale = currentAmount/fullAmount
            self.targetMeter.setProgress(Float(scale), animated: true)
            let price = currentAmount as NSNumber
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            self.currentAmountLabel.text = formatter.string(from: price)! as String
        }
    }
    
    @IBAction func goToCupertinoHigh(_ sender: AnyObject) {
        let coordinate = CLLocationCoordinate2DMake(school.coordinate.latitude, school.coordinate.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "Cupertino High School"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

