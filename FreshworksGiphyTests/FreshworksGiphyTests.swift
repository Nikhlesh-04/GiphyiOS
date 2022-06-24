//
//  FreshworksGiphyTests.swift
//  FreshworksGiphyTests
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import XCTest
@testable import FreshworksGiphy

class FreshworksGiphyTests: XCTestCase {

    // NOTE: I create UI and Unit test cases for as API response, but we can also create UI and Unit test cases from create stub and Mock data.
    
    var apiService:APIService? = nil
    let gifFile                 = "demo"
    let gifFileForTempSave      = "test"
    let downloadGIFURL          = "https://media2.giphy.com/media/3GtrYOmcGn2mMGDRFg/giphy.gif?cid=120f7cbbcg813nf920egrh9lzj5ncrijbualk19zzil8w7dw&rid=giphy.gif&ct=g"
    
    override func setUp() {
        super.setUp()
        
        apiService = APIService.shared
    }
    
    override func tearDown() {
        apiService = nil
        removeTempTestFilesFromFileStorge()
        super.tearDown()
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetTrendingAPIWorking() {
        let expectation = XCTestExpectation.init(description: "Trending")
        
        apiService?.getTrending(completion: { accountObject, error in
            if let trending = accountObject {
                if let trend = trending.data.first {
                    XCTAssertEqual(trend.type, "gif")
                    XCTAssertGreaterThan(trend.images.downsized.url.count, 0)
                }
                XCTAssertGreaterThan(trending.data.count, 0)
                expectation.fulfill()
           } else if error != nil {
               XCTFail("Fail")
           }
        })

        wait(for: [expectation], timeout: 60)
    }
    
    func testSearchGIFAPIWorking() {
        let expectation = XCTestExpectation.init(description: "Search")
        apiService?.searchGIF(searchText: "Happy", with: 30, completion: { searchObject, error in
            if let search = searchObject {
                if let trend = search.data.first {
                    XCTAssertEqual(trend.type, "gif")
                    XCTAssertGreaterThan(trend.images.downsized.url.count, 0)
                }
                XCTAssertGreaterThan(search.data.count, 0)
                expectation.fulfill()
            } else if error != nil {
                XCTFail("Fail")
            }
        })

        wait(for: [expectation], timeout: 60)
    }
    
    func testDownloadGIF() {
        let expectation = XCTestExpectation.init(description: "DownlaodGIF")
        
        apiService?.download(gifURL: downloadGIFURL) { data, error in
            if let imageData = data {
                XCTAssertGreaterThan(imageData.count, 0)
                expectation.fulfill()
            } else if error != nil {
                XCTFail("Fail")
            }
        }
        
        wait(for: [expectation], timeout: 60)
    }
    
    
    func testSaveGIFToFileStorageWhileFavorite() {
        if let url = getGIFFile(name: gifFile), let imageData = try? Data(contentsOf: url) {
            XCTAssertTrue(FileManagerHelper.shared.store(data: imageData, forKey: gifFile, fileExtension: Giphy.fileExtension))
        } else {
            XCTFail("Fail")
        }
    }
    
    // Test case for show all favorite gif's
    func testRetriveGIFSFromFileStorage() {
        self.saveImageGIFToFileStorage(name: gifFileForTempSave)
        if let data = FileManagerHelper.shared.fetchAllData() {
            XCTAssertGreaterThan(data.count, 0)
        } else {
            XCTFail("Fail")
        }
    }
    
    // Test case for unfavorite gif
    func testRemoveGIFSFromFileStorage() {
        self.saveImageGIFToFileStorage(name: gifFileForTempSave)
        XCTAssertTrue(FileManagerHelper.shared.removeFile(forKey: gifFileForTempSave, fileExtension: Giphy.fileExtension))
    }
    
    // Test case for check gif is already favorite means available in file storage.
    func testCheckGIFIsAlreayInFileStorage() {
        self.saveImageGIFToFileStorage(name: gifFileForTempSave)
        XCTAssertTrue(FileManagerHelper.shared.isFileExits(forKey: gifFileForTempSave, fileExtension: Giphy.fileExtension))
    }
    
    //MARK: Helper functions
    
    func removeTempTestFilesFromFileStorge() {
        FileManagerHelper.shared.removeFile(forKey: gifFile, fileExtension: Giphy.fileExtension)
        FileManagerHelper.shared.removeFile(forKey: gifFileForTempSave, fileExtension: Giphy.fileExtension)
    }
    
    func getGIFFile(name:String) -> URL? {
        let bundle = Bundle.main
        guard let path = bundle.path(forResource: name, ofType: Giphy.fileExtension) else {
            // File not found ... oops
            return nil
        }
        return URL(fileURLWithPath: path)
    }
    
    func saveImageGIFToFileStorage(name:String) {
        if let url = getGIFFile(name: name), let imageData = try? Data(contentsOf: url) {
            FileManagerHelper.shared.store(data: imageData, forKey: name, fileExtension: Giphy.fileExtension)
        }
    }
    
}
