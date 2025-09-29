//
//  FAQsViewModel.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 29/09/2025.
//

import Foundation

class FAQsViewModel {
    
    var pageNo: Int = 1
    var pageSize: Int = 100
    private(set) var isLast: Bool = false
    private(set) var isPaginating: Bool = false
    
    private(set) var faqsListResponse: Bindable<FaqsListResponse> = Bindable<FaqsListResponse>()
    private var faqsService: any ServicesDelegate
    
    init(faqsService: any ServicesDelegate = FAQsService()) {
        self.faqsService = faqsService
    }
    
    func faqsListApi(paginate: Bool = false) {
        
        if paginate {
            pageNo += 1
        }
        isPaginating = true
        faqsService.faqsListApi(pageNo: pageNo, pageSize: pageSize) { [weak self] result in
            switch result {
            case .success((let data, let json, let resp)):
                self?.addDataToList(data: data)
            case .failure(let error):
                print(error.localizedDescription)
                if let data = self?.faqsListResponse.value {
                    self?.faqsListResponse.value = data
                }
                else {
                    self?.faqsListResponse.value = FaqsListResponse(success: false, data: nil)
                }
            }
            self?.isPaginating = false
        }
        
    }
    
    func addDataToList(data: FaqsListResponse?) {
        
        var faqsList: [FaqsData] = []
        if let data, var faqs = data.data {
            let isEmpty = faqsListResponse.value?.data?.isEmpty ?? true
            if isEmpty {
                if let hasData = faqsListResponse.value {
                    faqsListResponse.value?.data = faqs
                }
                else {
                    faqsListResponse.value = data
                }
            }
            else {
                faqsListResponse.value?.data?.append(contentsOf: faqs)
            }
            faqsList.append(contentsOf: faqs)
        }
        else {
            faqsListResponse.value = data
        }

        let isEmpty = data?.data?.isEmpty ?? true
        isLast = (data?.data?.count ?? 0) < 25
        if isEmpty, pageNo > 1 {
            pageNo -= 1
        }
        
    }
    
    func shouldExpandFaq(indexPath: IndexPath) {
        var isExpanded = faqsListResponse.value?.data?[indexPath.row].isExpanded == true
        isExpanded.toggle()
        faqsListResponse.value?.data?[indexPath.row].isExpanded = isExpanded
    }
    
}
