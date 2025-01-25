//
//  DefaultPersistenceManagerSpec.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation
import SwiftData
import XCTest

import Quick
import Nimble
import Mimus
@testable import CloudflareDNSUpdater

// swiftlint:disable function_body_length
final class DefaultPersistenceManagerSpec: QuickSpec {
    override static func spec() {
        var sut: DefaultPersistenceManager!
        
        beforeEach {
            sut = DefaultPersistenceManager.shared
            try? sut.deleteAll(AutoUpdateRecord.self)
        }
        
        afterEach {
            try? sut.deleteAll(AutoUpdateRecord.self)
        }
        
        describe("DefaultPersistenceManager") {
            context("CRUD Operations") {
                it("should save an item successfully") {
                    let record = AutoUpdateRecord(
                        recordId: "test",
                        recordName: "test.com"
                    )
                    
                    expect { try sut.save(record) }.toNot(throwError())
                    
                    let savedRecords = try? sut.fetch(AutoUpdateRecord.self)
                    expect(savedRecords).toNot(beEmpty())
                    expect(savedRecords?.first?.recordId).to(equal("test"))
                }
                
                it("should fetch items with predicate") {
                    let record1 = AutoUpdateRecord(
                        recordId: "test1",
                        recordName: "test1.com"
                    )
                    let record2 = AutoUpdateRecord(
                        recordId: "test2",
                        recordName: "test2.com"
                    )
                    
                    try? sut.save(record1)
                    try? sut.save(record2)
                    
                    let predicate = #Predicate<AutoUpdateRecord> { record in
                        record.recordName == "test1.com"
                    }
                    
                    let fetchedRecords = try? sut.fetch(AutoUpdateRecord.self, predicate: predicate)
                    expect(fetchedRecords?.count).to(equal(1))
                    expect(fetchedRecords?.first?.recordName)
                        .to(equal("test1.com"))
                }
                
                it("should fetch items with sort descriptor") {
                    let record1 = AutoUpdateRecord(
                        recordId: "test1",
                        recordName: "b.com"
                    )
                    let record2 = AutoUpdateRecord(
                        recordId: "test2",
                        recordName: "a.com"
                    )
                    
                    try? sut.save(record1)
                    try? sut.save(record2)
                    
                    let sortDescriptor = SortDescriptor<AutoUpdateRecord>(
                        \.recordName
                    )
                    let fetchedRecords = try? sut.fetch(AutoUpdateRecord.self, sortBy: [sortDescriptor])
                    
                    expect(fetchedRecords?.first?.recordName).to(equal("a.com"))
                }
                
                it("should update an item") {
                    let record = AutoUpdateRecord(
                        recordId: "test",
                        recordName: "test.com"
                    )
                    try? sut.save(record)
                    
                    record.recordName = "updated.com"
                    expect { try sut.update() }.toNot(throwError())
                    
                    let updatedRecord = try? sut.fetch(AutoUpdateRecord.self).first
                    expect(updatedRecord?.recordName).to(equal("updated.com"))
                }
                
                it("should delete an item") {
                    let record = AutoUpdateRecord(
                        recordId: "test",
                        recordName: "test.com"
                    )
                    try? sut.save(record)
                    
                    expect { try sut.delete(record) }.toNot(throwError())
                    
                    let remainingRecords = try? sut.fetch(AutoUpdateRecord.self)
                    expect(remainingRecords).to(beEmpty())
                }
                
                it("should delete all items of a type") {
                    let record1 = AutoUpdateRecord(
                        recordId: "test1",
                        recordName: "test1.com"
                    )
                    let record2 = AutoUpdateRecord(
                        recordId: "test2",
                        recordName: "test2.com"
                    )
                    
                    try? sut.save(record1)
                    try? sut.save(record2)
                    
                    expect { try sut.deleteAll(AutoUpdateRecord.self) }.toNot(throwError())
                    
                    let remainingRecords = try? sut.fetch(AutoUpdateRecord.self)
                    expect(remainingRecords).to(beEmpty())
                }
            }
            
            context("Concurrent Access") {
                it("should handle concurrent saves safely") { @MainActor in
                    let expectation1 = XCTestExpectation(description: "Save 1")
                    let expectation2 = XCTestExpectation(description: "Save 2")
                    
                    Task {
                        let record1 = AutoUpdateRecord(
                            recordId: "concurrent1",
                            recordName: "test1.com"
                        )
                        try? sut.save(record1)
                        expectation1.fulfill()
                    }
                    
                    Task {
                        let record2 = AutoUpdateRecord(
                            recordId: "concurrent2",
                            recordName: "test2.com"
                        )
                        try? sut.save(record2)
                        expectation2.fulfill()
                    }
                    
                    XCTWaiter().wait(for: [expectation1, expectation2], timeout: 5.0)
                    
                    let savedRecords = try? sut.fetch(AutoUpdateRecord.self)
                    expect(savedRecords?.count).to(equal(2))
                }
                
                it("should handle concurrent updates safely") {
                    let record1 = AutoUpdateRecord(
                        recordId: "test1",
                        recordName: "test1.com"
                    )
                    let record2 = AutoUpdateRecord(
                        recordId: "test2",
                        recordName: "test2.com"
                    )
                    try? sut.save(record1)
                    try? sut.save(record2)
                    
                    let expectation1 = XCTestExpectation(description: "Update 1")
                    let expectation2 = XCTestExpectation(description: "Update 2")
                    
                    Task {
                        record1.recordName = "updated1.com"
                        try? sut.update()
                        expectation1.fulfill()
                    }
                    
                    Task {
                        record2.recordName = "updated2.com"
                        try? sut.update()
                        expectation2.fulfill()
                    }
                    
                    XCTWaiter().wait(for: [expectation1, expectation2], timeout: 5.0)
                    
                    let updatedRecords = try? sut.fetch(AutoUpdateRecord.self)
                    expect(updatedRecords?.count).to(equal(2))
                    expect(updatedRecords?.map { $0.recordName })
                        .to(contain(["updated1.com", "updated2.com"]))
                }
            }
            
            context("Error Handling") {
                it("should throw contextNotFound error when context is nil on save") {
                    sut._context = nil
                    let record = AutoUpdateRecord(
                        recordId: "test",
                        recordName: "test.com"
                    )
                    
                    expect { try sut.save(record) }
                        .to(throwError(PersistenceError.contextNotFound))
                }
                
                it("should throw contextNotFound error when context is nil on update") {
                    sut._context = nil
                    let record = AutoUpdateRecord(
                        recordId: "test",
                        recordName: "test.com"
                    )
                    
                    expect { try sut.update() }
                        .to(throwError(PersistenceError.contextNotFound))
                }
                
                it("should throw contextNotFound error when context is nil on delete") {
                    sut._context = nil
                    let record = AutoUpdateRecord(
                        recordId: "test",
                        recordName: "test.com"
                    )
                    
                    expect { try sut.delete(record) }
                        .to(throwError(PersistenceError.contextNotFound))
                }
                
                it("should throw contextNotFound error when context is nil on fetch") {
                    sut._context = nil
                    let record = AutoUpdateRecord(
                        recordId: "test",
                        recordName: "test.com"
                    )
                    
                    expect { try sut.fetch(AutoUpdateRecord.self) }
                        .to(throwError(PersistenceError.contextNotFound))
                }
                
                it("should throw contextNotFound error when context is nil on delete all") {
                    sut._context = nil
                    let record = AutoUpdateRecord(
                        recordId: "test",
                        recordName: "test.com"
                    )
                    
                    expect { try sut.deleteAll(AutoUpdateRecord.self) }
                        .to(throwError(PersistenceError.contextNotFound))
                }
            }
        }
            
    }
}
