//
//  DetailView.swift
//  05-iOSTakeHome
//
//  Created by kopresh desai on 19/09/25.
//

import SwiftUI

struct DetailView: View {
    
    let userId: Int
    @StateObject private var vm = DetailViewModel()
    
    var body: some View {
        ZStack {
            background
            if vm.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        avatar
                        Group {
                            general
                            link
                        }
                        .foregroundColor(Theme.text)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 18)
                        .background(Theme.detailBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Details")
        .onAppear {
//            do {
//                userInfo = try StaticJSONMapper.decode(file: "SingleUserData.json", type: UserDetailResponse.self)
//            } catch {
//                print(error)
//            }
            vm.fetchDetails(for: userId)
        }
        .alert(isPresented: $vm.hasError, error: vm.error) {
        }
    }
}

private extension DetailView {
    
    var background: some View {
        Theme.background
            .ignoresSafeArea(edges: .top)
    }
    
    @ViewBuilder
    var avatar: some View {
        if let avatarAbsoluteString = vm.usersInfo?.data.avatar,
           let avatarURL = URL(string: avatarAbsoluteString) {
            AsyncImage(url: avatarURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
            } placeholder: {
                ProgressView()
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
    
    var general: some View {
        VStack(alignment: .leading, spacing: 8) {
            PillView(id: vm.usersInfo?.data.id ?? 0)
            
            Group {
                firstname
                lastname
                email
            }
        }
    }
    
    @ViewBuilder
    var link: some View {
        if let supportAbsoluteString = vm.usersInfo?.support.url,
           let supportURL = URL(string: supportAbsoluteString),
           let supportText = vm.usersInfo?.support.text {
            
            Link(destination: supportURL) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(supportText)
                            .foregroundColor(Theme.text)
                            .font(
                                .system(.body, design: .rounded)
                                .weight(.semibold)
                            )
                            .multilineTextAlignment(.leading)
                        Text(supportAbsoluteString)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    Symbols
                        .link
                        .font(.system(.title3, design: .rounded))
                }
            }
            
        }
        
        
    }
    
    @ViewBuilder
    var firstname: some View {
        Text("First Name")
            .font(
                .system(.body, design: .rounded)
                .weight(.semibold)
            )
        Text(vm.usersInfo?.data.firstName ?? "_")
            .font(
                .system(.subheadline, design: .rounded)
            )
        Divider()
    }
    
    @ViewBuilder
    var lastname: some View {
        Text("Last Name")
            .font(
                .system(.body, design: .rounded)
                .weight(.semibold)
            )
        Text(vm.usersInfo?.data.lastName ?? "_")
            .font(
                .system(.subheadline, design: .rounded)
            )
        Divider()
    }
    
    @ViewBuilder
    var email: some View {
        Text("Email")
            .font(
                .system(.body, design: .rounded)
                .weight(.semibold)
            )
        Text(vm.usersInfo?.data.email ?? "_")
            .font(
                .system(.subheadline, design: .rounded)
            )
    }
}

#Preview {
    
    var previewUserId: Int {        
        let users = try! StaticJSONMapper.decode(file: "UserStaticData.json", type: UsersResponse.self)
        return users.data.first!.id
    }
    
    NavigationView {
        DetailView(userId: previewUserId)
    }
}
