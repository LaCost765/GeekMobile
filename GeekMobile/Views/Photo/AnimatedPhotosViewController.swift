//
//  AnimatedPhotosViewController.swift
//  GeekMobile
//
//  Created by Egor on 01.04.2021.
//

import UIKit

class AnimatedPhotosViewController: UIViewController {

    var images: [UIImage?] = []
    
    enum SwipeDirection {
        case left, right, none
    }
    
    @IBOutlet weak var foregroundImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var interactiveAnimator: UIViewPropertyAnimator!
    
    var startX: CGFloat = 0
    var animationProgress: CGFloat = 0
    var animationDirection: SwipeDirection = .none
    var currentImageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foregroundImageView.image = images[currentImageIndex]
        
        setDefaultBackgroundTransform(for: .left)
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        self.view.addGestureRecognizer(recognizer)
    }
    
    func setDefaultBackgroundTransform(for swipe: SwipeDirection) {
        
        if swipe == .left {
            let translation = CATransform3DMakeTranslation(self.view.frame.width + 200, 0, 0)
            self.backgroundImageView.transform = CATransform3DGetAffineTransform(translation)
        } else {
            let translation = CATransform3DMakeTranslation(-self.view.frame.width - 200, 0, 0)
            self.backgroundImageView.transform = CATransform3DGetAffineTransform(translation)
        }
    }
    
    func setTransform(_ direction: SwipeDirection) {
        
        if direction == .left && currentImageIndex + 1 < images.count  {
            // move foreground
            let translation = CATransform3DMakeTranslation(-self.view.frame.width - 200, 0, 0)
            let scale = CATransform3DScale(CATransform3DIdentity, 0.6, 0.6, 0)
            let transform = CATransform3DConcat(translation, scale)
            self.foregroundImageView.transform = CATransform3DGetAffineTransform(transform)
            
            // move background
            backgroundImageView.image = images[currentImageIndex + 1]
            self.backgroundImageView.transform = .identity
            
        } else if direction == .right && currentImageIndex - 1 >= 0 {
            // move foreground
            let translation = CATransform3DMakeTranslation(self.view.frame.width + 200, 0, 0)
            let scale = CATransform3DScale(CATransform3DIdentity, 0.6, 0.6, 0)
            let transform = CATransform3DConcat(translation, scale)
            self.foregroundImageView.transform = CATransform3DGetAffineTransform(transform)
            
            // move background
            backgroundImageView.image = images[currentImageIndex - 1]
            self.backgroundImageView.transform = .identity
        }
    }
    
    func handleRecognizerStateWithValidation(_ code: () -> Void) {
        
        if animationDirection == .left && currentImageIndex + 1 < images.count ||
            animationDirection == .right && currentImageIndex != 0 {
            
            code()
        }
    }
    
    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
        
        case .began:
            
            animationDirection = recognizer.velocity(in: self.view).x > 0 ? .right : .left
            
            handleRecognizerStateWithValidation {
                setDefaultBackgroundTransform(for: animationDirection)
                
                interactiveAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
                
                    self.setTransform(self.animationDirection)
                })
                
                interactiveAnimator.pauseAnimation()
                startX = recognizer.translation(in: self.view).x
            }
            
        case .changed:
      
            handleRecognizerStateWithValidation {
                var progress: CGFloat = 0
                if animationDirection == .left {
                    progress = (startX - recognizer.translation(in: self.view).x) / 400
                } else {
                    progress = (recognizer.translation(in: self.view).x - startX) / 400
                }
                
                if progress < 0 {
                    interactiveAnimator.stopAnimation(false)
                    interactiveAnimator.finishAnimation(at: .start)
                    
                    let dir: SwipeDirection = self.animationDirection == .left ? .right : .left
                    
                    self.animationDirection = dir
                    setDefaultBackgroundTransform(for: dir)
                    
                    interactiveAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
                    
                        self.setTransform(dir)
                    })
                    
                    interactiveAnimator.pauseAnimation()
                    startX = recognizer.translation(in: self.view).x
                } else {
                    animationProgress = progress
                    interactiveAnimator.fractionComplete = animationProgress
                }
            }

        case .ended:
            
            handleRecognizerStateWithValidation {
                if animationProgress < 0.5 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.interactiveAnimator.stopAnimation(false)
                        self.interactiveAnimator.finishAnimation(at: .start)
                    })
                } else {
                    self.interactiveAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                    
                    self.backgroundImageView.transform = .identity
                    
                    if animationDirection == .right && currentImageIndex != 0 {
                        currentImageIndex -= 1
                    } else if animationDirection == .left && currentImageIndex < images.count {
                        currentImageIndex += 1
                    }
                    
                    // swipe pointers
                    (backgroundImageView, foregroundImageView) = (foregroundImageView, backgroundImageView)
                }
            }
            
        default: return
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
