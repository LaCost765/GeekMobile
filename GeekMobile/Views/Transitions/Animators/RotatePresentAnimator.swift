//
//  RotatePresentAnimator.swift
//  GeekMobile
//
//  Created by Egor on 02.04.2021.
//

import UIKit

class RotatePresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        let containerViewFrame = transitionContext.containerView.frame
        
        source.view.layer.anchorPoint = CGPoint(x: 0, y: 0)
        destination.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        transitionContext.containerView.addSubview(destination.view)

        destination.view.frame = containerViewFrame
        source.view.frame = containerViewFrame
        
        destination.view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        UIView
            .animate(withDuration: self.transitionDuration(using: transitionContext),
                     animations: {
                        
                        destination.view.transform = .identity
                        source.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        }) { finished in
            source.view.removeFromSuperview()
            transitionContext.completeTransition(finished)
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        print("Transition did end with result: \(transitionCompleted)")
    }
}
