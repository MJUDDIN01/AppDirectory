//
//  PeopleViewModelTests.swift
//  AppDirectoryTests
//
//  Created by Jasim Uddin on 05/05/2022.
//

import XCTest
@testable import AppDirectory

class PeopleViewModelTests: XCTestCase {

    var peoplesViewModel: PeopleViewModel!
    var fakeApiTask: FakeApiTask!
    
    override func setUpWithError() throws {
        
        fakeApiTask = FakeApiTask()
    
        peoplesViewModel = PeopleViewModel(directoryApi: DirectoryApi(apiTask: fakeApiTask))
    }

 
    func testFetchPeople_success() {
        
        fakeApiTask.responceType = "peopleSuccess"
      
        peoplesViewModel.submitAction(action: .loadPeoples(DirectoryRequest(path: "people")))
        

        XCTAssertEqual(peoplesViewModel.numberOfPeople, 67)
        
        let people =  peoplesViewModel.getPeople(for: 0)

        XCTAssertNotNil(people)
        XCTAssertEqual(people.name, "Maggie Brekke ")
        XCTAssertEqual(people.poster, "https://randomuser.me/api/portraits/women/21.jpg")
        XCTAssertEqual(people.email, "Crystel.Nicolas61@hotmail.com")
        
        XCTAssertEqual(peoplesViewModel.state, States.showPeoples)
    }

    func testFetchPeople_failure() {

        fakeApiTask.responceType = "peopleFailure"

        peoplesViewModel.submitAction(action: .loadPeoples(DirectoryRequest(path: "people")))

        XCTAssertEqual(peoplesViewModel.numberOfPeople, 0)
        
        XCTAssertEqual(peoplesViewModel.state, States.showError("Responce not found"))

    }

    func testGetPeople_failure_parsing_error() {

        fakeApiTask.responceType = "peopleWrongKeyResponce"

        peoplesViewModel.submitAction(action: .loadPeoples(DirectoryRequest(path: "people")))

        XCTAssertEqual(peoplesViewModel.numberOfPeople, 0)

        XCTAssertEqual(peoplesViewModel.state, States.showError("data parsing failed"))
    }

    func testGetPeople_failure_status_code_404() {

        fakeApiTask.responceType = "file_not_found_status_code_404"

        peoplesViewModel.submitAction(action: .loadPeoples(DirectoryRequest(path: "people")))


        XCTAssertEqual(peoplesViewModel.numberOfPeople, 0)

        XCTAssertEqual(peoplesViewModel.state, States.showError("failed with code 404"))

    }

    func testGetPeople_internal_server__failure_status_code_500() {

        fakeApiTask.responceType = "internal_server_error_status_code_500"

        peoplesViewModel.submitAction(action: .loadPeoples(DirectoryRequest(path: "people")))


        XCTAssertEqual(peoplesViewModel.numberOfPeople, 0)

        XCTAssertEqual(peoplesViewModel.state, States.showError("failed with code 500"))
    }

    
}
