//
//  RoomsViewModel.swift
//  AppDirectory
//
//  Created by Jasim Uddin on 05/05/2022.
//

import Foundation


struct Room {
    var createdAt: String
    var occupiedMessage: String
    var maxOccupancy: Int
    var id: String
}

enum RoomsActions {
    case loadRooms(DirectoryRequest)
}

enum RoomsStates: Equatable {
    case showActivityIndicator
    case showRooms
    case showError(String)
    case none
}

class RoomsViewModel {
    
    private var roomsData:[RoomsData] = []
    private var directoryApi: DirectoryApiType

    @Published  var state: RoomsStates = .none
    
    var numberOfRooms:Int {
        return roomsData.count
    }

    init(directoryApi: DirectoryApiType) {
        self.directoryApi = directoryApi
    }
    
    func submitAction(action: RoomsActions) {
        switch action {
        case .loadRooms(let directoryRequest):
            self.state = .showActivityIndicator
            getRooms(request: directoryRequest)
        }
    }
    
    func getRoom(for index: Int)-> Room {
        let roomData = roomsData[index]
        let message = roomData.isOccupied ? Constants.occupied : Constants.notOccupied
        return Room(createdAt: roomData.createdAt, occupiedMessage:message, maxOccupancy: roomData.maxOccupancy, id: roomData.id)
    }
    
    private func getRooms(request: DirectoryRequest) {
        directoryApi.get(with: request, type:RoomsData.self) { [weak self] result in
            switch result {
            case .success(let roomData) :
                self?.roomsData = roomData
                self?.state = .showRooms
            case .failure(let error) :
                self?.roomsData = []
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
        self.state = .showError(errorMessage)
    }
}
