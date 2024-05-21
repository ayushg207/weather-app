//
//  LocationDetailViewController.swift
//  WeatherApp
//
//  Created by Ayush Goyal on 20/05/24.
//

import UIKit

class LocationDetailViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var weatherDetail : WeatherDetail!
    var locationIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserIterface()
    }
    
        
    
    func updateUserIterface(){
        
        let pageViewController = UIApplication.shared.windows.first?.rootViewController as! PageViewController
        
        let weatherLocation = pageViewController.weatherLocations[locationIndex]
        weatherDetail = WeatherDetail(name : weatherLocation.name, latitude: weatherLocation.latitude, longitude: weatherLocation.longitude)
       
        
        weatherDetail.getData {
            DispatchQueue.main.async {
                self.dateLabel.text = String(describing: self.weatherDetail.dt!)
                self.placeLabel.text = self.weatherDetail.name
                self.temperatureLabel.text =  "\(self.weatherDetail.temp)°"
                self.summaryLabel.text = self.weatherDetail.description
                self.imageView.imageFrom(url: URL(string : self.weatherDetail.iconUrl)!)
            }
        }
    }
    
    override func prepare(for segue : UIStoryboardSegue, sender: Any?){
        let destination = segue.destination as! LocationListViewController
        let pageViewController = UIApplication.shared.windows.first?.rootViewController as! PageViewController
        destination.weatherLocations = pageViewController.weatherLocations
    }
    
    @IBAction func unwindFromLocationListViewController(segue : UIStoryboardSegue){
        let source = segue.source as! LocationListViewController
        locationIndex = source.selectedLocationIndex
        let pageViewController = UIApplication.shared.windows.first?.rootViewController as! PageViewController
        pageViewController.weatherLocations = source.weatherLocations
        pageViewController.setViewControllers([pageViewController.createLocationDetailViewController(forPage: locationIndex)], direction: .forward, animated: false)
    }
    

}

extension UIImageView{
  func imageFrom(url:URL){
    DispatchQueue.global().async { [weak self] in
      if let data = try? Data(contentsOf: url){
        if let image = UIImage(data:data){
          DispatchQueue.main.async{
            self?.image = image
          }
        }
      }
    }
  }
}
