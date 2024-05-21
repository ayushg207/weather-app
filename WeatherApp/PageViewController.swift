//
//  PageViewController.swift
//  WeatherApp
//
//  Created by Ayush Goyal on 21/05/24.
//

import UIKit
import CoreLocation

class PageViewController: UIPageViewController {
    
    var weatherLocations : [WeatherLocation] = []
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        loadLocations()
        
        setViewControllers([createLocationDetailViewController(forPage: 0)], direction: .forward , animated: false)
    }
    
                            
    func loadLocations(){
       
        guard let locationsEncoded = UserDefaults.standard.value(forKey: "weatherLocations") as? Data
        else {
            
            weatherLocations.append(WeatherLocation(name : "CURRENT LOCATION", latitude: 20.20, longitude : 20.20))
            print("Error in loading data")
            return
        }
        let decoder = JSONDecoder()
        if let weatherLocations = try? decoder.decode(Array.self, from : locationsEncoded) as [WeatherLocation] {
            self.weatherLocations = weatherLocations
        }
        else{
            print("Could not load data")
        }
        
        if weatherLocations.isEmpty {
            //TODO: Get User Location for the first element in weatherLocations
            weatherLocations.append(WeatherLocation(name : "CURRENT LOCATION", latitude: 20.20, longitude: 20.20))
        }
                
        
    }
                            
    
    
    func createLocationDetailViewController(forPage page:Int)->LocationDetailViewController{
        print("creating locationDetailViewController instance")
        let detailViewController = storyboard!.instantiateViewController(identifier: "LocationDetailViewController") as! LocationDetailViewController
        detailViewController.locationIndex = page
//        detailViewController.weatherLocation = weatherLocations[page]
        
        return detailViewController
    }

    
    func showAlert(_ error: Error) {
            let alert = UIAlertController(title: "Error",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default))
            present(alert, animated: true)
    }
}


extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let currentViewController = viewController as? LocationDetailViewController {
            if currentViewController.locationIndex > 0 {
                return createLocationDetailViewController(forPage: currentViewController.locationIndex - 1)
            }
        }
    
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? LocationDetailViewController {
            if currentViewController.locationIndex < weatherLocations.count - 1 {
                return createLocationDetailViewController(forPage: currentViewController.locationIndex + 1)
            }
        }
        return nil
    }
    
}

extension PageViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                             didUpdateLocations locations: [CLLocation]) {
        
            
            let userLocation: CLLocation = locations[0] // The first location in the array
            weatherLocations[0].latitude = userLocation.coordinate.latitude
            weatherLocations[0].longitude = userLocation.coordinate.longitude
        }

        func locationManager(_ manager: CLLocationManager,
                             didFailWithError error: Error) {
            print(error.localizedDescription)
            showAlert(error)
        }
}



