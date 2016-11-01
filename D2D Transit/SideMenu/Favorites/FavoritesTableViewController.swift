//
//  FavoritesTableViewController.swift
//  D2D Transit
//
//  Created by Bob K on 10/30/16.
//  Copyright © 2016 Ibrahim All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    var favoriteRoutes: [Route]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame:CGRect.zero)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        favoriteRoutes = DataManager.sharedInstance.favouritesArray
        self.tableView.reloadData() // In order to update table changes whenever view appears
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favoriteRoutes == nil ? 0 : (favoriteRoutes!.count == 0 ? 1 : favoriteRoutes!.count)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(favoriteRoutes!.count == 0)
        {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "noFavorties",for: indexPath)
            return cell
        }
        else
        {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "routeCell", for: indexPath) as! RouteTableViewCell
            let routeAtIndex = favoriteRoutes![indexPath.row]
            cell.providerTitleLabel.text = routeAtIndex.vehicleName() != nil ? routeAtIndex.type + " ( \(routeAtIndex.vehicleName()!) )" : routeAtIndex.type
            cell.fromLabel.text = routeAtIndex.fromOrigin()
            cell.toLabel.text = routeAtIndex.toDestination()
            cell.priceLabel.text = routeAtIndex.price
            let getGoingData = routeAtIndex.getGoingLabel()
            cell.getGoingLabel.text = getGoingData.text
            cell.getGoingLabel.textColor = getGoingData.color
            return cell
        }
    }
    
    //MARK: - UITableView Delegate Methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return favoriteRoutes!.count == 0 ? 44 : 120
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if favoriteRoutes!.count != 0
        {
            self.performSegue(withIdentifier: "toDetails", sender:self.favoriteRoutes![indexPath.row])
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        DataManager.sharedInstance.removeRouteFromFavoritesById(iD: favoriteRoutes![indexPath.row].iD)
        self.favoriteRoutes?.remove(at: indexPath.row)
         favoriteRoutes!.count > 1 ? self.tableView.deleteRows(at: [indexPath], with: .automatic) :self.tableView.reloadData()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toDetails"
        {
            let routeDetailsVC = segue.destination as! RouteDetailViewController
            routeDetailsVC.route = sender as! Route
        }
    }
    
    
}
