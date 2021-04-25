//
//  ViewControllerExtensions.swift
//  ClientVK
//
//  Created by Egor on 08.03.2021.
//

import UIKit

extension UIViewController {
    func convertImageToData(named name: String) -> Data? {
        guard let image = UIImage(named: name) else {
            return nil
        }
        
        return image.pngData()
    }
    
    func showNotificationAlert(title: String, message: String, buttonTitle: String, style: UIAlertAction.Style = .default) {
        
        let ok = UIAlertAction(title: buttonTitle, style: style)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(ok)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

extension UIView {
    
    var rootView: UIView {
        return self.superview?.rootView ?? self
    }
}
