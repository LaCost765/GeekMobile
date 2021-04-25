//
//  CustomSegue.swift
//  GeekMobile
//
//  Created by Egor on 03.04.2021.
//

import UIKit

class CustomSegue: UIStoryboardSegue {

    var startFrame: CGRect!
    
    override func perform() {
                
        destination.view.frame = startFrame
        source.view.superview?.addSubview(destination.view)
        
        guard let photoVC = destination as? AnimatedPhotosViewController else { return }
        
        let origPhotoFrame = photoVC.foregroundImageView.frame
        photoVC.foregroundImageView.frame = CGRect(x: 0, y: 0, width: startFrame.width, height: startFrame.height)
                
        UIView.animate(withDuration: 0.5, animations: {
            self.destination.view.frame = self.source.view.frame
            photoVC.foregroundImageView.frame = origPhotoFrame
        }, completion: { finished in
            self.source.navigationController?.pushViewController(self.destination, animated: false)
        })
    }
}
