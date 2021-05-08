//
//  HDTimelineController+UICollectionViewDelegateFlowLayout.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 20/04/21.
//

import UIKit

// MARK: UICollectionViewDelegateFlowLayout
extension HDTimelineController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
}
