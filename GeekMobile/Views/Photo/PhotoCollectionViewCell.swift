//
//  PhotoCollectionViewCell.swift
//  ClientVK
//
//  Created by Egor on 07.03.2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    private var liked: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(imageTapped(tapGestureRecognizer:)))
//        photo.isUserInteractionEnabled = true
//        photo.addGestureRecognizer(tapGestureRecognizer)
    }
    
//    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
//    {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
//
//        UIView.animate(withDuration: 4,
//                       delay: 0,
//                       usingSpringWithDamping: 0.5,
//                       initialSpringVelocity: 0,
//                       options: [],
//                       animations: {
//                        tappedImage.frame = CGRect(x: tappedImage.frame.origin.x, y: tappedImage.frame.origin.y, width: tappedImage.frame.width - 30, height: tappedImage.frame.height - 30)
//        })
//    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
                
        UIView.transition(with: likeButton, duration: 0.4, options: .transitionFlipFromLeft, animations: {
            switch self.liked {
            case false:
                let num = Int(self.likeButton.currentTitle ?? "0")! + 1
                self.likeButton.setTitle(String(num), for: .normal)
                self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.likeButton.setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: .normal)
            case true:
                let num = Int(self.likeButton.currentTitle ?? "0")! - 1
                self.likeButton.setTitle(String(num), for: .normal)
                self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                self.likeButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            }
            
            
            self.liked = !self.liked
        }, completion: nil)
    }
}
