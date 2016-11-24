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

class IntroVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var targetMeter: UIProgressView!
    @IBOutlet weak var mapView: MKMapView!
    
    var school = CustomPointAnnotation()
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let pic = value?["image"] as! String
            print(pic)
            let img = self.base64ToImage(base64String: pic)
            self.backgroundImage.image = img
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        targetMeter.setProgress(0, animated: false)
        targetMeter.setProgress(0.5, animated: true)
        mapView.delegate = self
        school.coordinate = CLLocationCoordinate2DMake(37.3196, -122.0092)
        school.imageName = "dusty.png"
        school.title = "Cupertino High School"
        school.subtitle = "10100 Finch Ave, Cupertino, CA 95014"
        self.mapView.showAnnotations([school], animated: true)
        self.mapView.selectAnnotation(school, animated: true)
        // Do any additional setup after loading the view.
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
    
    @IBAction func goToCupertinoHigh(_ sender: AnyObject) {
        let coordinate = CLLocationCoordinate2DMake(school.coordinate.latitude, school.coordinate.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "Directions to Cupertino High School"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func base64ToImage(base64String: String) -> UIImage {
        let decodedData = NSData(base64Encoded: base64String, options: .ignoreUnknownCharacters)
        let decodedimage = UIImage(data: decodedData as! Data)
        return decodedimage!
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
