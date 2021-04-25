//
//  FriendsTableViewController.swift
//  ClientVK
//
//  Created by Egor on 06.03.2021.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    private var friends: [FriendModel] = [
        FriendModel(name: "Женя", surname: "Петров"),
        FriendModel(name: "Света", surname: "Смирнова"),
        FriendModel(name: "Катя", surname: "Матвеева"),
        FriendModel(name: "Никита", surname: "Орлов"),
        FriendModel(name: "Коля", surname: "Иванов"),
        FriendModel(name: "Оксана", surname: "Минина"),
        FriendModel(name: "Владимир", surname: "Путин"),
        FriendModel(name: "Алла", surname: "Пугачева"),
        FriendModel(name: "Верка", surname: "Сердючка"),
        FriendModel(name: "Филипп", surname: "Киркоров"),
        FriendModel(name: "Иосиф", surname: "Сталин"),
        FriendModel(name: "Николай", surname: "Романов"),
        FriendModel(name: "Олег", surname: "Тинькофф"),
        FriendModel(name: "Евгений", surname: "Понасенков"),
        FriendModel(name: "Алексей", surname: "Навальный"),
    ]
    
    private var friendsDict = [Character:[FriendModel]]()
    private var sortedKeys = [Character]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for friend in friends {
            
            guard let char = friend.surname.first else { continue }
            
            if friendsDict[char] == nil {
                friendsDict[char] = []
                sortedKeys.append(char)
                sortedKeys.sort()
            }
            
            friendsDict[char]!.append(friend)
            friendsDict[char]!.sort { first, second in first.surname < second.surname}
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sortedKeys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section >= sortedKeys.count {
            return 0
        }
        
        let key = sortedKeys[section]
        
        if friendsDict[key] == nil {
            return 0
        } else {
            return friendsDict[key]!.count
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sortedKeys[section].uppercased()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendTableViewCell

        let friend = friendsDict[sortedKeys[indexPath.section]]?[indexPath.row]
        
        let name = friend?.name ?? ""
        let surname = friend?.surname ?? ""
        cell.configureViewModel(viewModel: FriendViewModel(model: FriendModel(name: name, surname: surname, photosCount: 8)))
        
        cell.setProfileImage(with: "https://i.pravatar.cc/300")
        cell.viewModel?.loadImages()

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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            friends.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
            
            let friendPhotos = senderCell.getPhotos()
            vc.photos = friendPhotos
        }
    }
}
