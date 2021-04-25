//
//  GlobalGroupsViewController.swift
//  ClientVK
//
//  Created by Egor on 08.03.2021.
//

import UIKit

class GlobalGroupsViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var groups: [GroupModel] = []
    var filteredData: [GroupModel]!

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        self.groups = [
            GroupModel(title: "GeekBrains", subtitle: "Образование", image: convertImageToData(named: "GeekBrains")),
            GroupModel(title: "Apple", subtitle: "Технологии", image: convertImageToData(named: "Apple")),
            GroupModel(title: "Лентач", subtitle: "СМИ", image: convertImageToData(named: "Lentach")),
            GroupModel(title: "Книги", subtitle: "Литература", image: convertImageToData(named: "Books")),
            GroupModel(title: "UFC", subtitle: "Спорт", image: convertImageToData(named: "UFC")),
            GroupModel(title: "НИУ ВШЭ", subtitle: "Университет", image: convertImageToData(named: "HSE")),
            GroupModel(title: "Лепра", subtitle: "Юмор", image: convertImageToData(named: "Lepra")),
            GroupModel(title: "Meduza", subtitle: "СМИ", image: convertImageToData(named: "Meduza")),
        ]
        
        self.filteredData = self.groups
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GlobalGroupCell", for: indexPath) as! GroupTableViewCell
        
        cell.configureViewModel(viewModel: GroupViewModel(model: filteredData[indexPath.row]))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "addGroup", sender: filteredData[indexPath.row])
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addGroup" {
            guard let userGroupsVC = segue.destination as? UserGroupsViewController,
                  let group = sender as? GroupModel else {
                return
            }
         
            userGroupsVC.addNewGroup(group: group)
        }
    }
}

extension GlobalGroupsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            filteredData = groups
        } else {
            filteredData = []
            for group in groups {
                 
                if group.title.lowercased().contains(searchText.lowercased()) {
                    filteredData.append(group)
                }
            }
        }
        
        self.tableView.reloadData()
    }
}
