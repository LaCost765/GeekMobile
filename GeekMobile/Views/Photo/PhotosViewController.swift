//
//  PhotosViewController.swift
//  ClientVK
//
//  Created by Egor on 06.03.2021.
//

import UIKit
import RxSwift

private let reuseIdentifier = "PhotoCell"

class PhotosViewController: UICollectionViewController {
    
    var photos: [PhotoModel] = []
    
    var viewModel: FriendViewModel?
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        guard let vm = viewModel else { return }
        if vm.photos.value.isEmpty {
            vm.loadPhotos()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    func bindViewModel() {
        
        guard let vm = viewModel else { return }
        vm.photos
            .subscribe(onNext: { [weak self] dataArray in
                
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    self.photos = dataArray
                    self.collectionView.reloadData()
                }
            })
            .disposed(by: bag)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "BrowsePhoto" {
            
            guard let cell = sender as? PhotoCollectionViewCell else { return }
            guard let customSegue = segue as? CustomSegue else { return }
            guard let animatedVC = segue.destination as? AnimatedPhotosViewController else { return }
            
            let navBarHeight = (self.navigationController?.navigationBar.frame.height ?? 0) + (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)
            
            let frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y + navBarHeight, width: cell.frame.width, height: cell.frame.height)
            
            customSegue.startFrame = frame
            animatedVC.images = photos.map { UIImage(data: $0.data!) }
            animatedVC.currentImageIndex = collectionView.indexPath(for: cell)?.item ?? 0
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
    
        guard let photoData = photos[indexPath.row].data else { return cell }
        cell.setLikes(likes: photos[indexPath.row].likes)
        cell.photo.image = UIImage(data: photoData)
        cell.photo.setNeedsDisplay()
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width / 3 - 5, height: collectionView.frame.height / 3 - 5)
    }
}
