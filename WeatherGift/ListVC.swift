//
//  ListVC.swift
//  WeatherGift
//
//  Created by oliver naser on 10/16/17.
//  Copyright © 2017 oliver naser. All rights reserved.
//

import UIKit

class ListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var locationsArray = [String]()
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToPageVC" {
            let destination = segue.destination as! PageVC
            currentPage = (tableView.indexPathForSelectedRow?.row)!
            destination.currentPage = currentPage
            destination.locationsArray = locationsArray
        }
    }
    
    @IBAction func editBarBUttonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing == true {
            tableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    
    
}

extension ListVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        cell.textLabel?.text = locationsArray[indexPath.row]
        return cell
    }
    
    //MARK:- TableView editing funcitons
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
             locationsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        func tableview(_ tableView: UITableView , moveRowAt sourceIndexPath: IndexPath , to destinationIndexPath: IndexPath) {
            let itemToMove = locationsArray[sourceIndexPath.row]
            locationsArray.remove(at: sourceIndexPath.row)
            locationsArray.insert(itemToMove, at: destinationIndexPath.row)
        }
        //MARK:- Tableview methods to freeze first cell
        func tableView(_ tableView: UITableView , canEditRowAt indexPath: IndexPath) -> Bool {
            return (indexPath.row != 0 ? true : false)
        }
        
        func tableView(_ tableView: UITableView , canMoveRowAt indexPath: IndexPath) -> Bool {
            return (indexPath.row != 0 ? true : false)
        }
        
        func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
            return (proposedDestinationIndexPath.row == 0 ? sourceIndexPath : proposedDestinationIndexPath)
            
        }
    }
}
