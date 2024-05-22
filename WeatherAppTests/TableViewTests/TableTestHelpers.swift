//
//  TableTestHelpers.swift
//  WeatherAppTests
//
//  Created by Ayush Goyal on 22/05/24.
//

import Foundation
@testable import WeatherApp
import UIKit

func getRowCount(in tableView: UITableView, section : Int = 0) -> Int?{
    tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section)
}

func getCellAtRow(in tableView : UITableView, row : Int, section : Int = 0) -> UITableViewCell?{
    tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: row, section: section))
}

func deleteCellMock(in tableView : UITableView, row : Int){
    
    if let deleteFunction = tableView.dataSource?.tableView?(tableView, commit : .delete, forRowAt: IndexPath(row : row, section: 0)){
    }
}
