//
//  AutoCompleteSearchViewController.swift
//  TaxiApp
//
//  Created by Loay on 6/24/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class AutoCompleteSearchViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate{

// Variables
    
    @IBOutlet weak var searchBar: RoundedShadowSearchBar!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var resultArray = [GMSAutocompletePrediction]()
    
// Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        AppDelegate.containerVC.getHomeViewController().resetDestinationField()
        dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        autoCompleteSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        autoCompleteSearch()
    }
    
    func autoCompleteSearch() {
        
        //let visibleRegion = mapView.projection.visibleRegion()
        //let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        let searchString = searchBar.text
        
        if searchString != "" {
            
            print(searchString as Any)
            GMSPlacesClient.shared().autocompleteQuery(searchString!, bounds: nil, filter: filter) { (result, error) in
                guard error == nil else {
                    print("Autocomplete error \(String(describing: error))")
                    return
                }
                if let res = result {
                    
                    print(res as Any)
                    self.resultArray = res
                }
            }
        }
        self.tableView.reloadData()
    }

}// End Class

extension AutoCompleteSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? ResultTableViewCell else {fatalError("Unable to dequeue cell")}
        
        cell.titleCell.text = resultArray[indexPath.row].attributedPrimaryText.string
        cell.descCell.text = resultArray[indexPath.row].attributedFullText.string
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        AppDelegate.containerVC.getHomeViewController().setDestinationTextField(result: resultArray[indexPath.row]) 
        dismiss(animated: true, completion: nil)
    }
}
