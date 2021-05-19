//
//  RxDocumentPicker.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 12/05/21.
//

import MobileCoreServices
import RxSwift
import UIKit

public struct RxDocumentPickerDocumentType {
    public static let pdf = RxDocumentPickerDocumentType(value: String(kUTTypePDF))
    public static let png = RxDocumentPickerDocumentType(value: String(kUTTypePNG))
    public static let jpeg = RxDocumentPickerDocumentType(value: String(kUTTypeJPEG))
    
    let value: String
}

enum RxDocumentPickerAction {
    case documents(observer: AnyObserver<[URL]>)
}

@objc open class RxDocumentPicker: NSObject, UIDocumentPickerDelegate {
    weak var delegate: RxDocumentPickerDelegate?
    
    fileprivate var currentAction: RxDocumentPickerAction?
    
    public init(delegate: RxDocumentPickerDelegate) {
        self.delegate = delegate
    }
        
}

extension RxDocumentPicker {
    
    open func selectDocuments(allowsMultipleSelection: Bool = true,
                              documentTypes: [RxDocumentPickerDocumentType],
                              in pickerMode: UIDocumentPickerMode = .open) -> Observable<[URL]> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            self.currentAction = RxDocumentPickerAction.documents(observer: observer)
            
            let _documentTypes = documentTypes.map({ $0.value })
            let picker = UIDocumentPickerViewController(documentTypes: _documentTypes, in: pickerMode)
            picker.allowsMultipleSelection = allowsMultipleSelection
            picker.modalPresentationStyle = .fullScreen
            picker.delegate = self
            
            self.present(picker)
            
            return Disposables.create()
        }
        .observe(on: ConcurrentMainScheduler.instance)
    }
    
}

extension RxDocumentPicker {
    
    open func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let action = self.currentAction else { return }
        switch action {
        case .documents(let observer):
            observer.onNext(urls)
            self.dismiss(controller)
        }
    }
    
    open func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.dismiss(controller)
    }
    
}

fileprivate extension RxDocumentPicker {
    
    func present(_ picker: UIDocumentPickerViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.present(picker: picker)
        }
    }
    
    func dismiss(_ picker: UIDocumentPickerViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.dismiss(picker: picker)
        }
    }
    
}
