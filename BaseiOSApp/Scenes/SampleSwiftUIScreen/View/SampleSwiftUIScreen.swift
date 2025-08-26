//
//  SampleSwiftUIScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 07/08/2025.
//

import SwiftUI
import Combine

struct SampleSwiftUIScreen: View {
    
    @StateObject var viewModel: SampleDashboardViewModel = SampleDashboardViewModel()
    
    @State var dashboardObj: DashboardResult?
    @State private var appearOnce: Bool = false
    
    //For loader
    @State private var loading = true
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                
                HStack(spacing: 10) {
                    CardView()
                    CardView()
                }
                .padding(.horizontal, 10)
                HStack(spacing: 10) {
                    CardView()
                    CardView()
                        .onTapGesture {
                            print("Clicked")
                        }
                }
                .padding(.horizontal, 10)
                AttendanceListContainerView(dashboardResult: $dashboardObj)
                    .padding(.horizontal, 10)
                ApprovalsListContainerView(dashboardResult: $dashboardObj)
                    .padding(.horizontal, 10)
                Spacer()
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                
            }
            .onAppear {
                
                if !appearOnce {
                    appearOnce = true
                    attendanceListApi()
                }
                
                viewModel.dashboardResponseV2Publisher.sink { model in
                    print("Sink value: \(String(describing: model))")
                    if let model {
                        loading = false
                    }
                    dashboardObj = model?.result
                }
                .store(in: &viewModel.cancellables)
                
            }
            
        }
        //This is an activity indicator
        .activityIndicatorOverlay(isPresented: loading)
    }
    
    //MARK: APICalls
    private func callApis() {
        DispatchQueue.main.async {
//            ActivityIndicator.shared.showActivityIndicator(view: self.view, showBackground: true)
        }
        viewModel.businessListApi(onlyFetch: true)
        
    }
    
    private func attendanceListApi() {
        DispatchQueue.main.async {
//            self.noRecordFoundLbl.isHidden = false
//            self.noRecordFoundLbl.text = "Loading..."
        }
        viewModel.dashboardApi(businessId: 456, refresh: true)
    }
    
    private func staffDetailApi() {
        DispatchQueue.main.async {
//            ActivityIndicator.shared.showActivityIndicator(view: self.view)
        }
        viewModel.staffDetailApi(businessId: 456)
    }
    
}

struct ApprovalsListContainerView: View {
    
    @Binding var dashboardResult: DashboardResult?
    
    var body: some View {
        
        LazyVStack(alignment: .leading) {
            
            CustomHeader(leadTitle: "Leave Approval", trailingBtnTitle: "Today", menubuttonOptions: [.init(title: "Today"), .init(title: "Yesterday")])
                .padding(.horizontal, 10)
            SeparatorLineViewCustom()
            LazyVStack(alignment: .leading) {
                ScrollView(showsIndicators: false) {
                    ForEach(dashboardResult?.attendanceDetails ?? [], id: \.self) { customId in
                        StaffApprovalRequestNodeView()
                    }
                }
                //                .frame(height: 411)
            }
            .padding(.horizontal, 10)
            HStack {
                Text("View All")
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.vertical, 10)
                    .onTapGesture {
                        print("Clicked")
                    }
                Spacer()
                Text("1 of 10")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color(uiColor: .clr_violet))
            }
            .padding(.horizontal, 10)
            
        }
        .padding(.top, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
            //                .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
        )
        .overlay( // 💡 Border instead of shadow
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.clrGray1, lineWidth: 1)
        )
        
    }
    
}

//#Preview {
//    SampleSwiftUIScreen()
//}

struct MenuButtonOptionModel: Identifiable {
    var id: UUID = UUID()
    var title: String
}

struct CustomHeader: View {
    
    @State private(set) var leadTitle: String
    @State private(set) var trailingBtnTitle: String
    private(set) var menubuttonOptions: [MenuButtonOptionModel]
    
    var body: some View {
        HStack {
            Text(leadTitle)
                .font(.system(size: 14, weight: .bold))
            Spacer()
            Menu {
                ForEach(menubuttonOptions) { btnInfo in
                    
                    Button(btnInfo.title) {
                        print("Option selected")
                        trailingBtnTitle = btnInfo.title
                    }
                    
                }
                
//                    Divider() // Add a separator
//                    Button("Delete", role: .destructive) {
//                        print("Delete action")
//                    }
            } label: {
                // The view that triggers the menu (e.g., a Text, Image, or Button)
                HStack {
                    Text(trailingBtnTitle)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.black)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 12)
                    Image(uiImage: .downIconSystem)
                        .tint(.gray)
                        .frame(width: 10, height: 10)
                        .padding(.trailing, 12)
                }
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.clrGray1)
                )
            }
            
            //Deprecated
//                HStack {
//                    Text("All")
//                        .font(.system(size: 14, weight: .regular))
//                        .padding(.vertical, 7)
//                        .padding(.horizontal, 12)
//                    Image(uiImage: .downIconSystem)
//                        .tint(.gray)
//                        .frame(width: 10, height: 10)
//                        .padding(.trailing, 12)
//                }
//                .background(
//                    RoundedRectangle(cornerRadius: 5)
//                        .fill(Color.clrGray1)
//        //                .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
//                )
//                .onTapGesture {
//                    print("Clicked")
//
//                }
        }
        .padding(.horizontal, 10)
    }
    
}

struct SeparatorLineViewCustom: View {

    var body: some View {
        
        HStack {
            
        }
        .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1, alignment: .center)
        .background(Color.clrGray1)
        
    }
    
}

struct AttendanceListContainerView: View {
    
    @Binding var dashboardResult: DashboardResult?
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            
            CustomHeader(leadTitle: "Check In / Check out", trailingBtnTitle: "All", menubuttonOptions: [.init(title: "All"), .init(title: "Monthly")])
                .padding(.horizontal, 10)
            
            SeparatorLineViewCustom()
            
            LazyVStack(alignment: .leading) {
                ScrollView(showsIndicators: false) {
                    ForEach(dashboardResult?.attendanceDetails ?? [], id: \.self) { model in
                        StaffInfoNodeView(attendanceInfo: model)
                    }
                }
//                .frame(height: 411)
            }
            .padding(.horizontal, 10)
            
            HStack {
                Text("View All")
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.vertical, 10)
                    .onTapGesture {
                        print("Clicked")
                        
                        //MARK: TestNavigation
//                        let vc = AppUIViewControllers.firstScreen()
//                        appNavigationCoordinator.pushUIKit(vc)
                        
//                        let sui = SampleSwiftUIScreen()
//                        appNavigationCoordinator.pushSwiftUI(sui)
                    }
                Spacer()
                Text("1 of 10")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color(uiColor: .clr_violet))
            }
            .padding(.horizontal, 10)
            
            
        }
        .padding(.top, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
//                .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
        )
        .overlay( // 💡 Border instead of shadow
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.clrGray1, lineWidth: 1)
        )
    }
    
}

struct StaffApprovalRequestNodeView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(spacing: 10) {
                
                Image(.AD)
                    .frame(width: 40, height: 40, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
            //                .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
                    )
                    .overlay( // 💡 Border instead of shadow
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.clrGray1, lineWidth: 1)
                    )
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Junaid Ahmed just applied for 2 Days - Annual Leave")
                        .font(.system(size: 14, weight: .bold))
                    HStack {
                        Text("No Over lapping")
                            .font(.system(size: 12, weight: .regular))
                        Spacer()
//                        VStack {
//                            Spacer()
                            HStack(spacing: 10) {
                                Button {
                                    print("Clicked")
                                } label: {
                                    Text("Reject")
                                        .frame(minWidth: 65, maxWidth: 70/*, minHeight: 25, maxHeight: 25*/, alignment: .center)
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(.white)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 5)
                                                .fill(Color.clrRed)
                                //                .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
                                        )
                                }

                                
                                Text("Approve")
                                    .frame(minWidth: 65, maxWidth: 70/*, minHeight: 25, maxHeight: 25*/, alignment: .center)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.clrGreen)
                            //                .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
                                    )
                            }
//                        }
                    }
                    
                }
                
                
                
            }
            
            HStack {
                
            }
            .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1, alignment: .center)
            .background(Color.clrGray1)
            
        }
    }
    
}

struct StaffInfoNodeView: View {
    
    var attendanceInfo: AttendanceStatusResult?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(spacing: 10) {
                
                Image(.AD)
                    .frame(width: 40, height: 40, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
            //                .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
                    )
                    .overlay( // 💡 Border instead of shadow
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.clrGray1, lineWidth: 1)
                    )
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(attendanceInfo?.staff?.fullName ?? "")
                        .font(.system(size: 14, weight: .bold))
                    Text(attendanceInfo?.markedByType ?? "")
                        .font(.system(size: 12, weight: .regular))
                }
                
            }
            
            HStack(spacing: 10) {
                
                HStack(spacing: 10) {
                    Image(.AD)
                        .frame(width: 14, height: 14, alignment: .center)
                    Text("Double")
                        .font(.system(size: 12, weight: .regular))
                }
                
                HStack(spacing: 5) {
                    Image(.AD)
                        .frame(width: 14, height: 14, alignment: .center)
                    Text("Johar Town")
                        .font(.system(size: 12, weight: .regular))
                }
                
                HStack(spacing: 5) {
                    Image(.AD)
                        .frame(width: 14, height: 14, alignment: .center)
                    Text(attendanceInfo?.checkinTime ?? "")
                        .font(.system(size: 12, weight: .regular))
                }
                
                HStack(spacing: 5) {
                    Image(.AD)
                        .frame(width: 14, height: 14, alignment: .center)
                    Text("Working")
                        .font(.system(size: 12, weight: .regular))
                }
                
            }
            
            HStack {
                
            }
            .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1, alignment: .center)
            .background(Color.clrGray1)
            
        }
    }
    
}

struct CardView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Image(.AD)
                Spacer()
                Text("200")
                    .font(.system(size: 30))
                    .multilineTextAlignment(.trailing)
            }
            .padding(.bottom, 25)
            Text("Late Arrival")
                .font(.system(size: 16))
                .multilineTextAlignment(.leading)
                .padding(.bottom, 5)
            Text("Tracking manager requests")
                .font(.system(size: 12))
                .multilineTextAlignment(.leading)
                .padding(.bottom, 13)
            
            
        }
        .padding(.leading, 10)
        .padding(.top, 10)
        .padding(.trailing, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
//                .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
        )
        .overlay( // 💡 Border instead of shadow
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.clrGray1, lineWidth: 1)
        )
    }
    
}
