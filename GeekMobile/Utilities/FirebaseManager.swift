//
//  FirebaseManager.swift
//  GeekMobile
//
//  Created by Egor on 13.03.2021.
//

import Foundation
import Firebase

class FirebaseManager {
    
    private var firestoreDB: Firestore
    private var storage: Storage
    private var userUID: String
    
    init(userUID: String) {
        
        firestoreDB = Firestore.firestore()
        storage = Storage.storage()
        
        self.userUID = userUID
    }
    
    func getUserName(by uid: String, callback: @escaping (String) -> Void) {
        
        let docRef = firestoreDB.collection("users").document("\(uid)")
        
        docRef.getDocument { (document, error) in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            
            if let document = document, document.exists,
               let name = document.get("name") as? String {
                
                callback(name)
            } else {
                print("User with uid \(uid) doesn't exist or he doesn't have name field")
            }
        }
    }
    
    func getUserProfilePhoto(callback: @escaping (Data?) -> Void) {
        
        // Create a reference with an initial file path and name
        let profileImageRef = storage.reference(withPath: "\(userUID)/profileImage.png")
        
        profileImageRef.getData(maxSize: 20 * 1024 * 1024) { data, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            callback(data)
        }
    }
    
    func uploadImage(imageData: Data, comletion:  (() -> Void)? = nil) {
        
        let ref = self.storage.reference().child("\(self.userUID)/profileImage.png")
        
        let uploadTask = ref.putData(imageData, metadata: nil) { metadata, error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            comletion?()
        }
    }
    
    func setDefaultPhotoForUser(completion: (() -> Void)? = nil) {
        // Add default user profile picture
        let ref = self.storage.reference().child("defaultImages/profileImage.png")
        
        ref.getData(maxSize: 20 * 1024 * 1024) { data, error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Error: no data")
                return
            }
            
            self.uploadImage(imageData: data, comletion: completion)
        }
    }
    
    func configureDefaultUserState(name: String) {
        
        let initData: [String:Any] = [
            "name": name,
            "friendsUIDs": []
        ]
        
        // Add document for user in firestore
        firestoreDB.collection("users").document(self.userUID).setData(initData) { err in
                        
            if let err = err {
                print("Error: \(err.localizedDescription)")
                return
            }
           
            self.setDefaultPhotoForUser(completion: self.signOut)
            
        }
    }
    
    func signOut() {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
