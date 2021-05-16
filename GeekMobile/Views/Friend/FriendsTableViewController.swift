//
//  FriendsTableViewController.swift
//  ClientVK
//
//  Created by Egor on 06.03.2021.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

class FriendsTableViewController: UITableViewController {
        
    private var friendsDict = [Character:[FriendViewModel]]()
    private var sortedKeys = [Character]()
    private let bag = DisposeBag()
    private let threadSafeAction = ThreadSafeAction(parallelsCount: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFriends()
            .subscribe(onNext: { [weak self] data in
                self?.parseFriends(data: data)
            })
            .disposed(by: bag)
    }
    
    func parseFriends(data: Data) {
                
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            guard let `self` = self else { return }
            
            ParserJSON.getFriends(data: data)
                .subscribe(onNext: { friend in
                    
                    self.threadSafeAction.call {
                        
                        guard let key = friend.name.first else { return }
                        
                        if self.friendsDict[key] == nil {
                            self.friendsDict[key] = []
                            self.sortedKeys.append(key)
                            self.sortedKeys.sort()
                        }
                         
                        self.friendsDict[key]!.append(FriendViewModel(model: friend))
                        self.friendsDict[key]!.sort { first, second in first.fullName.value < second.fullName.value }
                    }
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.tableView.reloadData()
                    }
                })
                .disposed(by: self.bag)
        }
    }
    
    func loadFriends() -> Observable<Data> {
        
        let params: Parameters = [
            VkAPI.Friend.fields.rawValue : "photo_200_orig",
            VkAPI.token.rawValue : UserSession.shared.vkToken ?? "",
            VkAPI.v.rawValue : VkAPI.Constants.v.rawValue
        ]
        
        return NetworkManager.shared.makeRequest(url: "\(VkAPI.Constants.url.rawValue)/friends.get", params: params)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return threadSafeAction.call { sortedKeys.count > 0 ? sortedKeys.count : 1 }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return threadSafeAction.call {
            
            if section >= sortedKeys.count {
                return 0
            }
            
            let key = sortedKeys[section]
            if friendsDict[key] != nil {
                return friendsDict[key]!.count
            }
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return threadSafeAction.call {
            if section >= sortedKeys.count {
                return nil
            }
            return sortedKeys[section].uppercased()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendTableViewCell
        
        let vm = threadSafeAction.call { () -> FriendViewModel? in
            
            let key = sortedKeys[indexPath.section]
            let index = indexPath.row
        
            guard let friendSet = friendsDict[key] else { return nil}
            if index >= friendSet.count {
                return nil
            }
            
            return friendSet[index]
        }
        
        if vm == nil {
            return UITableViewCell()
        }
        
        cell.configureViewModel(viewModel: vm!)

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//
//            friends.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
    

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
        if segue.identifier == "FriendPhotos" {
            guard let senderCell = sender as? FriendTableViewCell else { return }
            guard let vc = segue.destination as? PhotosViewController else { return }
            
            vc.viewModel = senderCell.viewModel
        }
    }
}
