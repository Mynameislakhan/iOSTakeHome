//
//  PeopleViewModel.swift
//  05-iOSTakeHome
//
//  Created by kopresh desai on 20/09/25.
//

import Foundation

final class PeopleViewModel: ObservableObject {
    
    @Published private(set) var users: [User] = []
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published private(set) var viewState: ViewState?
    @Published var hasError = false
    
    private var page = 1
    private var totalPages: Int?
    
    var isLoading: Bool {
        viewState == .loading
    }
    
    var isFetching: Bool {
        viewState == .fetching
    }
/*
    func fetchUsers() {
        isLoading = true
        NetworkingManager.shared.request(.people, type: UsersResponse.self) { [weak self] res in
            DispatchQueue.main.async {
                defer {self?.isLoading = false}
                switch res {
                case .success(let response):
                    self?.users = response.data
                case .failure(let error):
                    self?.hasError = true
                    self?.error = error as? NetworkingManager.NetworkingError
                }
            }
        }
    }
*/
    func fetchUsers() {
        reset()
        viewState = .loading
        defer { viewState = .finished }
        NetworkingManager.shared.request(.people(page: page), type: UsersResponse.self) { [weak self] res in
            DispatchQueue.main.async {
                switch res {
                case .success(let response):
                    self?.totalPages = response.totalPages
                    self?.users = response.data
                case .failure(let error):
                    self?.hasError = true
                    if let networkingError = error as? NetworkingManager.NetworkingError {
                        self?.error = networkingError
                    } else {
                        self?.error = .custom(error: error)
                    }
                }
            }
        }
    }
    
    func fetchNextSetOfUsers() {
        guard page != totalPages else { return }
        viewState = .fetching
        defer { viewState = .finished }
        page += 1
        NetworkingManager.shared.request(.people(page: page), type: UsersResponse.self) { [weak self] res in
            DispatchQueue.main.async {
                switch res {
                case .success(let response):
                    self?.totalPages = response.totalPages
                    self?.users += response.data
                case .failure(let error):
                    self?.hasError = true
                    if let networkingError = error as? NetworkingManager.NetworkingError {
                        self?.error = networkingError
                    } else {
                        self?.error = .custom(error: error)
                    }
                }
            }
        }
    }
/*
    @MainActor
    func fetchUsers() async {
        reset()
        viewState = .loading
        defer { viewState = .finished }
        
        do {
            let response = try await NetworkingManager.shared.request(.people(page: page), type: UsersResponse.self)
            self.totalPages = response.totalPages
            self.users = response.data
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    @MainActor
    func fetchNextSetOfUsers() async {
        
        guard page != totalPages else { return }
        
        viewState = .fetching
        defer { viewState = .finished }
        
        page += 1
        
        do {
            let response = try await NetworkingManager.shared.request(.people(page: page), type: UsersResponse.self)
            self.totalPages = response.totalPages
            self.users += response.data
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
*/
    func hasReachedEnd(of user: User) -> Bool {
        users.last?.id == user.id
    }
}

extension PeopleViewModel {
    enum ViewState {
        case fetching
        case loading
        case finished
    }
    
    func reset() {
        if viewState == .finished {
            users.removeAll()
            page = 1
            totalPages = nil
            viewState = nil
        }
    }
}
