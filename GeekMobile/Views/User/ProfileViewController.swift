//
//  ProfileViewController.swift
//  GeekMobile
//
//  Created by Egor on 13.03.2021.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: CustomImageView!
    @IBOutlet weak var changeProfileImageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    var viewModel: ProfileViewModel
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        viewModel = ProfileViewModel()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        viewModel = ProfileViewModel()
        super.init(coder: coder)
    }
    
    func bindViewModel() {
        viewModel.name.bind(to: nameLabel.rx.text).disposed(by: viewModel.bag)
        viewModel.profilePhoto.subscribe(onNext: { [weak self] image in
            
            guard let data = image else { return }
            self?.profileImageView.image = UIImage(data: data)
            self?.profileImageView.setNeedsDisplay()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        // Do any additional setup after loading the view.
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
