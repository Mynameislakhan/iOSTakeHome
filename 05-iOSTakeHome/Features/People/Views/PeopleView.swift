//
//  PeopleView.swift
//  05-iOSTakeHome
//
//  Created by kopresh desai on 18/09/25.
//

import SwiftUI

struct PeopleView: View {
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    @StateObject private var vm = PeopleViewModel()
    @State private var shouldShowCreate: Bool = false
    @State private var shouldShowSuccess = false
    @State private var hasAppeared = false
    
    var body: some View {
        NavigationView {
            ZStack {
                
                background
                if vm.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(vm.users, id: \.id) { user in
//                                NavigationLink {
//                                    DetailView()
//                                } Label: {
//                                    PersonItemView(user: user)
//                                }
                                NavigationLink {
                                    DetailView(userId: user.id)
                                } label: {
                                    PersonItemView(user: user)
                                        .onAppear {
                                            if vm.hasReachedEnd(of: user) && !vm.isFetching {
                                                vm.fetchNextSetOfUsers()
                                            }
                                        }
                                }
                            }
                        }
                        .padding()
                    }
                    .overlay(alignment: .bottom) {
                        if vm.isFetching {
                            ProgressView()
                        }
                    }
                }
                
            }
            .navigationTitle("People")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    create
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    refresh
                }
            }
            .onAppear {
//                do {
//                    let res = try StaticJSONMapper.decode(file: "UserStaticData.json", type: UsersResponse.self)
//                    users = res.data
//                } catch {
//                    print(error)
//                }
                if !hasAppeared {
                    vm.fetchUsers()
                    hasAppeared = true
                }
                
            }
            .sheet(isPresented: $shouldShowCreate) {
                CreateView {
                    haptic(.success)
                    withAnimation(.spring().delay(0.25)) {
                        self.shouldShowSuccess.toggle()
                    }
                }
            }
            .alert(isPresented: $vm.hasError, error: vm.error) {
                Button("Retry") {
                    vm.fetchUsers()
                }
            }
            .overlay {
                if shouldShowSuccess {
                    CheckmarkPopoverView()
                        .transition(.scale.combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                self.shouldShowSuccess.toggle()
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    PeopleView()
}

private extension PeopleView {
    
    var background: some View {
        Theme.background
            .ignoresSafeArea(edges: .top)
    }
    
    var create: some View {
        Button {
            shouldShowCreate.toggle()
        } label: {
            Symbols.plus
                .font(
                    .system(.headline, design: .rounded)
                    .bold()
                )
        }
        .disabled(vm.isLoading)
    }
    
    var refresh: some View {
        Button {
            vm.fetchUsers()
        } label: {
            Symbols.refresh
                .font(
                    .system(.headline, design: .rounded)
                    .bold()
                )
        }
        .disabled(vm.isLoading)
    }
}
