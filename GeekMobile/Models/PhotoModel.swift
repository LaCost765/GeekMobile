//
//  PhotoModel.swift
//  GeekMobile
//
//  Created by Egor on 13.03.2021.
//

import Foundation
import RxSwift

protocol PhotoModel {
    var likes: Int { get set }
    var data: BehaviorSubject<Data?> { get set }
}

class PhotoModelImpl: PhotoModel {
    
    var likes: Int
    var data: BehaviorSubject<Data?>
    var bag: DisposeBag = DisposeBag()
    
    init(url: String, likes: Int) {
        
        self.data = BehaviorSubject<Data?>(value: nil)
        self.likes = likes
        
        self.loadPhotoData(url: url)
            .subscribe(onNext: { [weak self] data in
                self?.data.onNext(data)
            })
            .disposed(by: bag)
    }
    
    private func loadPhotoData(url: String) -> Observable<Data> {
        
        return NetworkManager.shared.makeRequest(url: url)
    }
}
