//
//  SideMenuViewController.swift
//  D2D Transit
//
//  Created by Bob K on 10/29/16.
//  Copyright © 2016 Ibrahim All rights reserved.
//

import UIKit

protocol sideMenuViewControllerDelegate {
    func menuSelectedWithIndex(index: Int)
}

class SideMenuViewController: UIViewController,UITableViewDataSource,  UITableViewDelegate {
    
    var delegate: sideMenuViewControllerDelegate?
    @IBOutlet weak var sideMenuTableView: UITableView!
    var sideMenuItems = ["❤️  Favorites ","🌐  Providers","🔧   Settings"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - tableView DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.sideMenuTableView.dequeueReusableCell(withIdentifier: "sideMenuCell", for: indexPath)
        
        (cell.viewWithTag(1) as! UILabel).text = sideMenuItems[indexPath.row]
        
        return cell
    }
    
    //MARK: - tableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sideMenuViewController?.hideMenuViewController()
        if indexPath.row != 2
        {
            self.delegate?.menuSelectedWithIndex(index: indexPath.row)
        }
        else
        {
            UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)            
        }
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
