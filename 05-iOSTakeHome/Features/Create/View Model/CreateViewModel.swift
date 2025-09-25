//
//  CreateViewModel.swift
//  05-iOSTakeHome
//
//  Created by kopresh desai on 21/09/25.
//

import Foundation

final class CreateViewModel: ObservableObject {
    
    @Published var person = NewPerson()
    @Published private(set) var state: SubmissionState?
    @Published private(set) var error: FormError?
    @Published var hasError = false
    
    private let validator = CreateValidator()
    
//    func create() {
//        do {
//            try validator.validate(person)
//            
//            state = .submitting
//            
//            let encoder = JSONEncoder()
//            encoder.keyEncodingStrategy = .convertToSnakeCase
//            let data = try? encoder.encode(person)
//            
//            NetworkingManager.shared.request(.create(submissionData: data)) { [weak self] res in
//                DispatchQueue.main.async {
//                    switch res {
//                    case .success:
//                        self?.state = .successful
//                    case .failure(let error):
//                        self?.state = .unsuccessful
//                        self?.hasError = true
//                        if let networkingError = error as? NetworkingManager.NetworkingError {
//                            self?.error = .networking(error: networkingError)
//                        }
//                    }
//                }
//            }
//        } catch {
//            self.hasError = true
//            if let validationError = error as? CreateValidator.CreateValidatorError {
//                self.error = .validation(error: validationError)
//            }
//        }
//        
//    }
    func create() {
        do {
            try validator.validate(person)
            
            state = .submitting
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try? encoder.encode(person)
            
            NetworkingManager.shared.request(.create(submissionData: data)) { [weak self] res in
                DispatchQueue.main.async {
                    switch res {
                    case .success:
                        self?.state = .successful
                    case .failure(let error):
                        self?.state = .unsuccessful
                        self?.hasError = true
                        switch error {
                        case is NetworkingManager.NetworkingError:
                            self?.error = .networking(error: error as! NetworkingManager.NetworkingError)
                        case is CreateValidator.CreateValidatorError:
                            self?.error = .validation(error: error as! CreateValidator.CreateValidatorError)
                        default:
                            self?.error = .system(error: error)
                        }
                    }
                }
            }
        } catch {
            self.hasError = true
            switch error {
            case is CreateValidator.CreateValidatorError:
                self.error = .validation(error: error as! CreateValidator.CreateValidatorError)
            default:
                self.error = .system(error: error)
            }
        }
        
    }
 /*
    @MainActor
    func create() async {
        
        do {
            try validator.validate(person)
            state = .submitting
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try? encoder.encode(person)
            
            try await NetworkingManager.shared.request(.create(submissionData: data))
            state = .successful
            
        } catch {
            self.hasError = true
            self.state = .unsuccessful
            
            switch error {
            case is NetworkingManager.NetworkingError:
                self.error = .networking(error: error as! NetworkingManager.NetworkingError)
            case is CreateValidator.CreateValidatorError:
                self.error = .validation(error: error as! CreateValidator.CreateValidatorError)
            default:
                self.error = .system(error: error)
            }
        }
    }
  */
}

extension CreateViewModel {
    
    enum SubmissionState {
        case unsuccessful
        case successful
        case submitting
    }
    
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension CreateViewModel.FormError {
    
    var errorDescription: String? {
        switch self {
        case .networking(let err),
                .validation(let err):
            return err.errorDescription
        case .system(let err):
            return err.localizedDescription
        }
    }
}
