//
//  ATCreateController+BindTableViewDelegate.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 29/04/21.
//

import MapKit
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

// MARK: BindTableViewDelegate
extension ATCreateController {
    
    func bindTableViewDelegate(tableView: UITableView) {
        tableView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: UITableViewDelegate
extension ATCreateController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionModel = self.createView.fields.value[indexPath.section]
        let rowModel = sectionModel.items[indexPath.row]
        switch rowModel {
        case .datePicker:
            return self.isSelectDate ? CGFloat(160) : CGFloat(0)
        case .explanation:
            return CGFloat(200)
        case .timePicker:
            return self.isSelectTime ? CGFloat(160) : CGFloat(0)
        default:
            return CGFloat(44)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionModel = self.createView.fields.value[indexPath.section]
        let rowModel = sectionModel.items[indexPath.row]
        switch rowModel {
        case .date:
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.beginUpdates()
            var newFields = self.createView.fields.value
            var firstSection = self.createView.fields.value[1]
            if self.isSelectDate {
                let index = firstSection.items.index(of: .datePicker)!
                firstSection.items.remove(firstIndexOf: .datePicker)
                tableView.deleteRows(at: [IndexPath(row: index, section: 1)], with: .fade)
            } else {
                firstSection.items.insert(.datePicker, afterFirstIndexOf: .date)
                let index = firstSection.items.index(of: .datePicker)!
                tableView.insertRows(at: [IndexPath(row: index, section: 1)], with: .fade)
            }
            newFields[1] = firstSection
            self.isSelectDate.toggle()
            self.createView.fields.accept(newFields)
            tableView.endUpdates()
        case .time:
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.beginUpdates()
            var newFields = self.createView.fields.value
            var firstSection = self.createView.fields.value[1]
            if self.isSelectTime {
                let index = firstSection.items.index(of: .timePicker)!
                firstSection.items.remove(firstIndexOf: .timePicker)
                tableView.deleteRows(at: [IndexPath(row: index, section: 1)], with: .fade)
            } else {
                firstSection.items.insert(.timePicker, afterFirstIndexOf: .time)
                let index = firstSection.items.index(of: .timePicker)!
                tableView.insertRows(at: [IndexPath(row: index, section: 1)], with: .fade)
            }
            newFields[1] = firstSection
            self.isSelectTime.toggle()
            self.createView.fields.accept(newFields)
            tableView.endUpdates()
        case .label:
            self.viewModel.presentLBListUI()
        case .location:
            tableView.deselectRow(at: indexPath, animated: true)
            self.onIndexLocationDidSelect(by: tableView, at: indexPath)
        default:
            break
        }
    }
    
    private func onIndexLocationDidSelect(by tableView: UITableView, at index: IndexPath) {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.desiredAccuracy = .greatestFiniteMagnitude
            self.locationAuthorizationStatusDidHandle(self.locationManager,
                                                      status: CLLocationManager.authorizationStatus())
        } else {
            self.showAlertWhenLocationServiceNotAvailable()
        }
        
        self.locationManager.rx
            .didChangeAuthorization
            .asDriver()
            .drive(onNext: { [unowned self] (event) in
                self.locationAuthorizationStatusDidHandle(event.manager, status: event.status)
            })
            .disposed(by: self.disposeBag)
    }
    
}
