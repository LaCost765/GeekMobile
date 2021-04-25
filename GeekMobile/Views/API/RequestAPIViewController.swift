//
//  RequestAPIViewController.swift
//  GeekMobile
//
//  Created by Egor on 20.04.2021.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

class RequestAPIViewController: UIViewController {

    @IBOutlet weak var getFriendsButton: UIButton!
    @IBOutlet weak var getPhotosButton: UIButton!
    @IBOutlet weak var getGroupsButton: UIButton!
    @IBOutlet weak var getGroupsBySearchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    private let apiUrl = "https://api.vk.com/method"
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func getFriends(_ sender: Any) {
        
        let params: Parameters = [
            "fields" : "nickname",
            "count" : 10,
            "order" : "hints",
            "access_token" : UserSession.shared.vkToken ?? "",
            "v" : "5.130"
        ]
        
        NetworkManager.shared.makeRequest(url: "\(apiUrl)/friends.get", params: params)
            .subscribe(onNext: { data in
                
                print("Friends (10):")
                
                guard let json = try? JSON(data: data) else { return }
                json["response"]["items"].arrayObject?
                    .map { JSON($0) }
                    .forEach { friend in
                        
                        let name = friend["first_name"]
                        let surname = friend["last_name"]
                        print("-> \(name) \(surname)")
                    }
            })
            .disposed(by: bag)
    }
    
    @IBAction func getPhotos(_ sender: Any) {
        
        let params: Parameters = [
            "access_token" : UserSession.shared.vkToken ?? "",
            "v" : "5.130"
        ]
        
        NetworkManager.shared.makeRequest(url: "\(apiUrl)/photos.getAll", params: params)
            .subscribe(onNext: { data in
                
                print("Photos:")
                
                guard let json = try? JSON(data: data) else { return }
                json["response"]["items"].arrayObject?
                    .map { JSON($0) }
                    .forEach { photoObject in
                        
                        guard let photo = photoObject["sizes"].array?.last else { return }
                        
                        let url = photo["url"]
                        let sizes = "\(photo["width"]) x \(photo["height"])"
                        print("-> \(url) (\(sizes))")
                    }
            })
            .disposed(by: bag)
    }
    
    @IBAction func getGroups(_ sender: Any) {
        
        let params: Parameters = [
            "extended" : 1,
            "count" : 10,
            "access_token" : UserSession.shared.vkToken ?? "",
            "v" : "5.130"
        ]
        
        NetworkManager.shared.makeRequest(url: "\(apiUrl)/groups.get", params: params)
            .subscribe(onNext: { data in
                
                print("Groups (10):")
                
                guard let json = try? JSON(data: data) else { return }
                json["response"]["items"].arrayObject?
                    .map { JSON($0) }
                    .forEach { group in
                                                
                        let name = group["name"]
                        let id = group["id"]
                        print("-> \(name) (ID: \(id))")
                    }
            })
            .disposed(by: bag)
    }
    
    @IBAction func getGroupsBySearchQuery(_ sender: Any) {
        
        let params: Parameters = [
            "q" : searchTextField.text ?? "",
            "count" : 10,
            "access_token" : UserSession.shared.vkToken ?? "",
            "v" : "5.130"
        ]
        
        NetworkManager.shared.makeRequest(url: "\(apiUrl)/groups.search", params: params)
            .subscribe(onNext: { data in
                
                print("Groups (10):")
                
                guard let items = JSON(data)["response"]["items"].arrayObject else { return }
                items
                    .map { JSON($0) }
                    .forEach { group in
                                                
                        let name = group["name"]
                        let id = group["id"]
                        print("-> \(name) (ID: \(id))")
                    }
            })
            .disposed(by: bag)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
