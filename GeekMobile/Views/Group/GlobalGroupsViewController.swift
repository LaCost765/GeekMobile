//
//  GlobalGroupsViewController.swift
//  ClientVK
//
//  Created by Egor on 08.03.2021.
//

import UIKit
import RxSwift
import Alamofire

class GlobalGroupsViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var groups: [GroupViewModel] = []
    private let bag = DisposeBag()
    private let searchSubject = BehaviorSubject(value: "")
    private let threadSafeAction = ThreadSafeAction(parallelsCount: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadGroupsWith()
            .subscribe(onNext: { [weak self] data in
                self?.parseGroups(data: data)
            })
            .disposed(by: bag)
        
        searchBar.delegate = self
        subscription()
    }
    
    func subscription() {
        
        searchSubject.debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] query in
                
                guard let `self` = self else { return }
                
                self.loadGroupsWith(searchQuery: query)
                    .subscribe(onNext: { [weak self] data in
                        self?.parseGroups(data: data)
                    })
                    .disposed(by: self.bag)
            }).disposed(by: bag)
    }
    
    func loadGroupsWith(searchQuery: String = " ") -> Observable<Data> {
        
        groups = []
        let params: Parameters = [
            VkAPI.Group.q.rawValue : searchQuery,
            VkAPI.count.rawValue : 100,
            VkAPI.token.rawValue : UserSession.shared.vkToken ?? "",
            VkAPI.v.rawValue : VkAPI.Constants.v.rawValue
        ]
        
        return NetworkManager.shared.makeRequest(url: "\(VkAPI.Constants.url.rawValue)/groups.search", params: params)
    }
    
    func parseGroups(data: Data) {
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            guard let `self` = self else { return }
            
            ParserJSON.getGroups(data: data)
                .subscribe(onNext: { group in
                    
                    self.threadSafeAction.call {
                        self.groups.append(GroupViewModel(model: group))
                    }
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.tableView.reloadData()
                    }
                })
                .disposed(by: self.bag)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return threadSafeAction.call { groups.count }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GlobalGroupCell", for: indexPath) as! GroupTableViewCell
                let vm = threadSafeAction.call { groups[indexPath.row] }

        cell.configureViewModel(viewModel: vm)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        performSegue(withIdentifier: "addGroup", sender: filteredData[indexPath.row])
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
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "addGroup" {
//            guard let userGroupsVC = segue.destination as? UserGroupsViewController,
//                  let group = sender as? GroupModel else {
//                return
//            }
//
//            //userGroupsVC.addNewGroup(group: group)
//        }
//    }
}

extension GlobalGroupsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        if searchText == "" {
            searchSubject.onNext(" ")
        } else {
            searchSubject.onNext(searchText)
        }
    }
}
