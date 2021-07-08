//
//  PCT.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 1/18/21.
//  Copyright © 2021 Spencer Ho's Hose. All rights reserved.
//

import Foundation

struct PCTJSON: Decodable {
    var npat: PCTResult
}

struct PCTResult: Decodable {
    var npatName: String
    var surveyMessage: String
    var candidate: String
    var section: [PCTIssue]
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        npatName = try container.decode(String.self, forKey: .npatName)
        surveyMessage = try container.decode(String.self, forKey: .surveyMessage)
        candidate = try container.decode(String.self, forKey: .candidate)
        do {
            section = try container.decode([PCTIssue].self, forKey: .section)
        } catch {
            section = []
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case npatName, surveyMessage, candidate, section
    }
}

struct PCTIssue: Decodable {
    var name: String
    var row: [PCTResponse]
    init (from decoder :Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        do {
            row = try container.decode([PCTResponse].self, forKey: .row)
        } catch {
            let newValue = try container.decode(PCTResponse.self, forKey: .row)
            row = [newValue]
        }
    }
    enum CodingKeys: String, CodingKey {
        case name, row
    }
}

struct PCTResponse: Decodable {
    var rowText: String
    var optionText: String
    var answerText: String
    var row: [PCTResponse]?
    
    init (from decoder :Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rowText = try container.decode(String.self, forKey: .rowText)
        optionText = try container.decode(String.self, forKey: .optionText)
        answerText = try container.decode(String.self, forKey: .answerText)
        do {
            row = try container.decode([PCTResponse].self, forKey: .row)
        } catch {
            row = nil
        }
    }
    enum CodingKeys: String, CodingKey {
        case path, rowText, optionText, answerText, row
    }
}

