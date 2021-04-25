//
//  NewsTableViewController.swift
//  GeekMobile
//
//  Created by Egor on 25.03.2021.
//

import UIKit

class NewsTableViewController: UITableViewController {

    var news: [NewsItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        news = [
            NewsItemModel(text: "С 1 июля разработчики, продающие свои услуги через Google Play, получат льготу в виде снижения комиссии с 30 до 15%. Послабление будет распространяться только на первый заработанный $1 млн", image: convertImageToData(named: "Apple"), likes: 23, comments: 9, reposts: 5, views: 79),
            NewsItemModel(text: "UFC проводит один из главных турниров в своей истории. Драться будут: российский чемпион Петр Ян, друг (и преемник) Хабиба, лучшая в мире женщина-боец и «самый жесткий анимешник»", image: convertImageToData(named: "UFC"), likes: 32, comments: 13, reposts: 7, views: 110),
        ]
        
        tableView.reloadData()
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
        return news.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItem", for: indexPath) as! NewsItemTableViewCell
        
        cell.likesButton.setTitle(String(news[indexPath.row].likes), for: .normal)
        cell.commentsButton.setTitle(String(news[indexPath.row].comments), for: .normal)
        cell.repostsButton.setTitle(String(news[indexPath.row].reposts), for: .normal)
        cell.viewsButton.setTitle(String(news[indexPath.row].views), for: .normal)
        cell.content.text = news[indexPath.row].text
        cell.itemImage.image = UIImage(data: news[indexPath.row].image!)
        cell.itemImage.setNeedsDisplay()
        // Configure the cell...

        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
