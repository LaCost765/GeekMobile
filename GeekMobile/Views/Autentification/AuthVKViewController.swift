//
//  AuthVKViewController.swift
//  GeekMobile
//
//  Created by Egor on 16.04.2021.
//

import UIKit
import WebKit
import Alamofire

class AuthVKViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet{
            webView.navigationDelegate = self
        }
        
    }
    
    private let authUrl: String = "https://oauth.vk.com/authorize"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initiateVkAuthForm()
    }
    
    func initiateVkAuthForm() {
        
        let params: Parameters = [
            "client_id" : "7826936",
            "display" : "mobile",
            "redirect_uri" : "https://oauth.vk.com/blank.html",
            "scope" : "262150",
            "response_type" : "token",
            "v" : "5.68"
        ]
        
        NetworkManager.shared.makeRequest(url: authUrl, params: params) { [weak self] request in
            self?.webView.load(request)
        }
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

extension AuthVKViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        guard let url = navigationResponse.response.url, url.path == "/blank.html",
              let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }

        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }

        let token = params["access_token"] ?? "NO TOKEN"

        print("TOKEN: \(token)")

        UserSession.shared.vkToken = token
        decisionHandler(.cancel)
        
        let vc = storyboard?.instantiateViewController(identifier: "MainTabBar") as! MainTabBarViewController
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
