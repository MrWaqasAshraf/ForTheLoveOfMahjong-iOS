//
//  SampleDashboardViewModel.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 09/08/2025.
//

import Foundation
import Combine

struct BusinessInfoModel {
    var businessId: Int?
    var businessName: String?
}

class SampleDashboardViewModel: ObservableObject {
    
//    businessid 456
//    user 768
    
    //For Real time change
    var startProductiveTimer: Bool = false
    
    //For actions
    var selectedEmpoloyeeId: Int?
    var selectedEmployee: StaffData?
    
    //For Filter
    var dateFilter: String? = nil
    var selectedDateFilter: Date? = nil
    
    //For queueing
    private var customQueue: DispatchQueue = DispatchQueue(label: "customQueue")
    
    //For pagination
    private(set) var isPaginating: Bool = false
    private(set) var isLastPage: Bool = false
    private(set) var pageNo: Int = 1
    
    //Publishers
    @Published private var staffDetailResponseV2: StaffListResponse?
    @Published private var businessListResponseV2: BusinessListResponse?
    @Published private var dashboardResponseV2: DashboardResponse?
    
    var cancellables = Set<AnyCancellable>()
    
    //For APIs
    var selectedBusiness: Bindable<BusinessInfoModel> = Bindable<BusinessInfoModel>()
    
    private var businessInfoService: any ServicesDelegate
    private var dashboardService: any ServicesDelegate
    private var staffListService: any ServicesDelegate
    
    
    var staffDetailResponseV2Publisher: AnyPublisher<StaffListResponse?, Never> {
        $staffDetailResponseV2.eraseToAnyPublisher()
    }
    var businessListResponseV2Publisher: AnyPublisher<BusinessListResponse?, Never> {
        $businessListResponseV2.eraseToAnyPublisher()
    }
    var dashboardResponseV2Publisher: AnyPublisher<DashboardResponse?, Never> {
        $dashboardResponseV2.eraseToAnyPublisher()
    }
    
    init(selectedEmpoloyeeId: Int? = nil, businessId: Int? = 456, businessName: String? = "", dateFilter: String? = nil, selectedDateFilter: Date? = nil, businessInfoService: any ServicesDelegate = BusinessInfoService(), dashboardService: any ServicesDelegate = DashboardService(), staffListService: any ServicesDelegate = StaffListService()) {
        self.selectedEmpoloyeeId = selectedEmpoloyeeId
        self.selectedBusiness.value = BusinessInfoModel(businessId: businessId, businessName: businessName)
        self.dateFilter = dateFilter
        self.selectedDateFilter = selectedDateFilter
        self.businessInfoService = businessInfoService
        self.dashboardService = dashboardService
        self.staffListService = staffListService
    }
    
    func businessListApi(paginate: Bool = false, onlyFetch: Bool = false){
        
        if onlyFetch {
            businessInfoService.businessListApi(userId: 768, pageNo: 1, pageSize: 100, dynamicListing: .isFalse) { [weak self] result in
                switch result{
                case .success((let data, let json, let resp)):
                    self?.businessListResponseV2 = data
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self?.businessListResponseV2 = BusinessListResponse(error: true, result: nil, message: error.localizedDescription, statusCode: -1)
                    }
                    
                }
            }
        }
        
    }
    
    func dashboardApi(businessId: Int? = nil, paginate: Bool = false, refresh: Bool = false/*, dateFilter: String? = nil*/) {
        if refresh {
            dashboardService.dashboardApi(businessId: businessId, pageNo: 1, pageSize: 5, dateFilter: dateFilter) { [weak self] result in
                switch result{
                case .success((var data, let json, let resp)):
                    
                    self?.addAttendanceData(data: data)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self?.dashboardResponseV2 = DashboardResponse(error: true, result: nil, message: error.localizedDescription, code: -1)
                    }
                    
                }
            }
        }
        else {
            if !isLastPage {
                if !isPaginating {
                    if paginate {
                        pageNo += 1
                    }
                    isPaginating = true
                    dashboardService.dashboardApi(businessId: businessId, pageNo: pageNo, pageSize: 10, dateFilter: dateFilter) { [weak self] result in
                        switch result{
                        case .success((var data, let json, let resp)):
                            
                            //New
                            self?.addToDashboard(data: data)
                            
                        case .failure(let error):
                            print(error.localizedDescription)
                            DispatchQueue.main.async {
                                self?.dashboardResponseV2 = DashboardResponse(error: true, result: nil, message: error.localizedDescription, code: -1)
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
    
    func staffDetailApi(businessId: Int? = nil) {
        staffListService.staffDetailApi(businessId: businessId) { [weak self] result in
            switch result {
            case .success((let data, let json, let resp)):
                self?.staffDetailResponseV2 = data
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self?.staffDetailResponseV2 = StaffListResponse(result: nil, code: -1, message: error.localizedDescription)
                }
               
            }
        }
    }
    
    
    private func addToDashboard(data: DashboardResponse?) {
        
        var mutable = data
//        let canViewHrControls = rolesAndPermissionsManager.checkModulePermission(action: iReachPermissionsAction.canViewHrDashboard.rawValue) || rolesAndPermissionsManager.checkIfOwner()
//        if !canViewHrControls {
//            var attendanceList = data?.result?.attendanceDetails?.filter({ $0.staff?.staffID == self.selectedEmpoloyeeId })
//            mutable?.result?.attendanceDetails = attendanceList
//        }
        if var list = mutable?.result?.attendanceDetails {
            if let listValue = dashboardResponseV2 {
                if let salesOrderList = listValue.result?.attendanceDetails {
                    
                    
                    dashboardResponseV2?.result?.attendanceDetails?.append(contentsOf: list)
                }
                else {
//                    dashboardResponse.value = data
                    addAttendanceData(data: mutable)
                }
            }
            else {
//                dashboardResponse.value = data
                addAttendanceData(data: mutable)
            }
            
        }
        
        let isLast: Bool = (data?.result?.attendanceDetails?.count ?? 0) < 10
        isLastPage = isLast
        isPaginating = false
        
    }
    
    private func addAttendanceData(data: DashboardResponse?){
        
        //New
        DispatchQueue.main.async {
            self.dashboardResponseV2 = data
        }
    }
}
