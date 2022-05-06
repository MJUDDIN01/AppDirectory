//
//  PeopleViewModel.swift
//  AppDirectory
//
//  Created by Jasim Uddin on 05/05/2022.
//

import Foundation

enum Actions {
    case loadPeoples(DirectoryRequest)
}

enum States: Equatable {
    case showActivityIndicator
    case showPeoples
    case showError(String)
    case none
}

struct People {
    let name: String
    let email: String
    let jobTitle: String
    let poster: String
}

class PeopleViewModel {
    
    private var peoplesData:[PeopleData] = []

    private var directoryApi: DirectoryApiType
    
    @Published  var state: States = .none
    
    var numberOfPeople:Int {
        return peoplesData.count
    }

    init(directoryApi: DirectoryApiType) {
        self.directoryApi = directoryApi
    }
    
    func submitAction(action: Actions) {
        switch action {
        case .loadPeoples(let directoryRequest):
            self.state = .showActivityIndicator
            getPeoples(request: directoryRequest)
        }
    }
    
    func getPeople(for index: Int)-> People {
        let peopleData = peoplesData[index]
        let fullName = "\(peopleData.firstName ) \(peopleData.lastName ?? "") "
        return People(name:fullName , email: peopleData.email ?? "", jobTitle: peopleData.jobTitle ?? "", poster: peopleData.avatar ?? "")
    }
    
    private func getPeoples(request: DirectoryRequest) {
        directoryApi.get(with: request, type:PeopleData.self) { [weak self] result in
            switch result {
            case .success(let peoplesData) :
                self?.peoplesData = peoplesData
                self?.state = .showPeoples
            case .failure(let error) :
                self?.peoplesData = []
                self?.handleError(error: error)
            }
        }
    }
    
    private func handleError(error: ApiError) {
        var errorMessage = ""
        switch error {
        case .UrlNotCorrect(let message):
            errorMessage = message
        case .recieveNilResponse(let message):
            errorMessage = message
        case .recieveErrorHttpStatus(let message):
            errorMessage = message
        case .recieveNilBody(let message):
            errorMessage = message
        case .failedParse(let message):
            errorMessage = message
        case .customError(let message):
            errorMessage =  "\(Constants.failedMessage) \(message)"
        }
        self.state = States.showError(errorMessage)
    }
}
