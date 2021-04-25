//
//  RotateDismissAnimator.swift
//  GeekMobile
//
//  Created by Egor on 02.04.2021.
//

import UIKit

class RotateDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        
        UIView
            .animate(withDuration: self.transitionDuration(using: transitionContext),
                     animations: {
                        
                        destination.view.transform = .identity
                        destination.view.frame = transitionContext.containerView.frame
                        source.view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        }) { finished in
                if finished && !transitionContext.transitionWasCancelled {
                    source.removeFromParent()
                } else if transitionContext.transitionWasCancelled {
                    source.view.transform = .identity
                    destination.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                    source.view.frame = transitionContext.containerView.frame
                }

                transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        print("Transition did end with result: \(transitionCompleted)")
    }
}
