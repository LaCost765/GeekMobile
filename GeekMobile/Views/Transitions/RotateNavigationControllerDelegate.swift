//
//  RotateNavigationControllerDelegate.swift
//  GeekMobile
//
//  Created by Egor on 02.04.2021.
//

import UIKit

class RotateNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    let interactiveTransition = RotateInteractiveTransition()
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
                              -> UIViewControllerInteractiveTransitioning? {
        
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
                self.interactiveTransition.viewController = toVC
                return RotatePresentAnimator()
            } else if operation == .pop {
                if navigationController.viewControllers.first != toVC {
                    self.interactiveTransition.viewController = toVC
                }
                return RotateDismissAnimator()
            }
            return nil
    }
}
