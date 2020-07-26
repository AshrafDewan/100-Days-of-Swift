//
//  ViewController.swift
//  Project22
//
//  Created by Ashraf Dewan on 3/22/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var distanceReading: UILabel!
    var locationManager: CLLocationManager?
    //1
    var firstDetecting: Bool = true
    //
    //2
    @IBOutlet weak var nameLabel: UILabel!
    //
    //3
    @IBOutlet weak var circleView: UIImageView!
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        //3
        circleView.layer.cornerRadius = 128
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func addBeaconRegion(uuidString: String, major: CLBeaconMinorValue, minor: CLBeaconMinorValue,identifier: String) {
        let uuid = UUID(uuidString: uuidString)!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: identifier)
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func startScanning() {
        addBeaconRegion(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", major: 123, minor: 456, identifier: "MyBeacon")
        addBeaconRegion(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6", major: 123, minor: 456, identifier: "Radius Networks")
        addBeaconRegion(uuidString: "92AB49BE-4127-42F4-B532-90fAF1E26491", major: 123, minor: 456, identifier: "TwoCanoes")
    }
    
    func update(distance: CLProximity, name: String) {
        UIView.animate(withDuration: 1) { [weak self] in
            //2
            self?.nameLabel.text = "Beacon Name: \(name)"
            //
            switch distance {
            case .far:
                self?.view.backgroundColor = .blue
                self?.distanceReading.text = "FAR"
                //3
                self?.circleView.transform = CGAffineTransform(scaleX: 1, y: 1)
                //
            case .near:
                self?.view.backgroundColor = .orange
                self?.distanceReading.text = "NEAR"
                //3
                self?.circleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                //
            case .immediate:
                self?.view.backgroundColor = .red
                self?.distanceReading.text = "IMMEDIATE"
                //3
                self?.circleView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                //
            default:
                self?.view.backgroundColor = .gray
                self?.distanceReading.text = "UNKNOWN"
                //3
                self?.circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                //
            }
        }
    }
    //1
    func firstBeaconDetected() {
        if firstDetecting {
            firstDetecting = false
            let ac = UIAlertController(title: "First Detection", message: "Beacon Detected", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
    }
    //
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity,name: region.identifier)
            firstBeaconDetected()
        } else {
            update(distance: .unknown, name: "Beacon Name: Unknown")
        }
    }
}

