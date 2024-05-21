//
//  LocationViewController.swift
//  WeatherApp
//
//  Created by Ayush Goyal on 20/05/24.
//

import UIKit
import CoreLocation

class LocationListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
 
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var locationTextField: UITextField!
    
    var weatherLocations : [WeatherLocation] = []
    var selectedLocationIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func saveLocations(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(weatherLocations){
            UserDefaults.standard.set(encoded,forKey: "weatherLocations")
        } else {
            print("Error : Saving in encoding the code ")
        }
            
    }
    
    override func prepare(for segue : UIStoryboardSegue, sender : Any?){
        selectedLocationIndex = tableView.indexPathForSelectedRow!.row
        saveLocations()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let address = locationTextField.text ?? ""
        forwardGeocoding(address) { [weak self] coordinate in
            guard let `self` = self else { return }
            self.weatherLocations.append(WeatherLocation(name : address, latitude: coordinate.latitude, longitude: coordinate.longitude))
            self.tableView.reloadData()
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
        }
        else {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    
    func forwardGeocoding(_ address: String, completed: @escaping (_ coordinate : CLLocationCoordinate2D) -> ()){
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
                if error != nil {
                    print("Failed to retrieve location")
                    return
                }
                
                var location: CLLocation?
                
                if let placemarks = placemarks, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                
                if let location = location {
                    let coordinate = location.coordinate
                    completed(coordinate)
                }
                else
                {
                    print("No Matching Location Found")
                }
            })
        }
    
}



extension LocationListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherLocations.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for : indexPath)
        cell.textLabel?.text = weatherLocations[indexPath.row].name
        cell.detailTextLabel?.text = "Lat:\(weatherLocations[indexPath.row].latitude) Long:\(weatherLocations[indexPath.row].longitude)"
        return cell
    }
    
    func tableView(_ tableView : UITableView, commit editingStyle : UITableViewCell.EditingStyle, forRowAt indexPath : IndexPath){
        
        if editingStyle == .delete {
            weatherLocations.remove(at : indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
        
    
    func tableView(_ tableView : UITableView, moveRowAt sourceIndexPath : IndexPath, to destinationIndexPath : IndexPath){
        
        let itemToMove = weatherLocations[sourceIndexPath.row]
        weatherLocations.remove(at : sourceIndexPath.row)
        weatherLocations.insert(itemToMove, at : destinationIndexPath.row)
    }
}


