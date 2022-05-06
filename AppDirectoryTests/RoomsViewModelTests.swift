//
//  RoomsViewModelTests.swift
//  AppDirectoryTests
//
//  Created by Jasim Uddin on 05/05/2022.
//

import XCTest

@testable import AppDirectory


class RoomsViewModelTests: XCTestCase {

    var roomsViewModel: RoomsViewModel!
    var fakeApiTask: FakeApiTask!
    
    override func setUpWithError() throws {
        
        fakeApiTask = FakeApiTask()
    
        roomsViewModel = RoomsViewModel(directoryApi: DirectoryApi(apiTask: fakeApiTask))
    }

 
    func testFetchRooms_success() {
        
        fakeApiTask.responceType = "roomSuccess"
      
        roomsViewModel.submitAction(action: .loadRooms(DirectoryRequest(path: "rooms")))
        

        XCTAssertEqual(roomsViewModel.numberOfRooms, 65)
        
        let room =  roomsViewModel.getRoom(for: 0)
        
        XCTAssertNotNil(room)
        XCTAssertEqual(room.occupiedMessage, "Not Occupied")
        XCTAssertEqual(room.maxOccupancy, 53539)
        
        XCTAssertEqual(roomsViewModel.state,RoomsStates.showRooms )
    }

    func testFetchSearch_failure() {

        fakeApiTask.responceType = "roomFailure"

        roomsViewModel.submitAction(action: .loadRooms(DirectoryRequest(path: "rooms")))
        

        XCTAssertEqual(roomsViewModel.numberOfRooms, 0)
    

        XCTAssertEqual(roomsViewModel.state, RoomsStates.showError("Responce not found"))

    }

    func testGetRepo_failure_parsing_error() {

        fakeApiTask.responceType = "peopleWrongKeyResponce"

        roomsViewModel.submitAction(action: .loadRooms(DirectoryRequest(path: "rooms")))

        XCTAssertEqual(roomsViewModel.numberOfRooms, 0)

        XCTAssertEqual(roomsViewModel.state, RoomsStates.showError("data parsing failed"))

    }

    func testGetRepo_failure_status_code_404() {

        fakeApiTask.responceType = "file_not_found_status_code_404"

        roomsViewModel.submitAction(action: .loadRooms(DirectoryRequest(path: "rooms")))


        XCTAssertEqual(roomsViewModel.numberOfRooms, 0)

        XCTAssertEqual(roomsViewModel.state, RoomsStates.showError("failed with code 404"))

    }

    func testGetRepo_internal_server__failure_status_code_500() {

        fakeApiTask.responceType = "internal_server_error_status_code_500"

        roomsViewModel.submitAction(action: .loadRooms(DirectoryRequest(path: "rooms")))


        XCTAssertEqual(roomsViewModel.numberOfRooms, 0)

        XCTAssertEqual(roomsViewModel.state, RoomsStates.showError("failed with code 500"))

    }

}
