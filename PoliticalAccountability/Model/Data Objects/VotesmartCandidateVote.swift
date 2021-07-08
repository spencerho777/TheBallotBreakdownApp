//
//  VotesmartCandidateVote.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 6/18/21.
//  Copyright © 2021 Spencer Ho's Hose. All rights reserved.
//

import Foundation

struct VotesmartCandidateVoteJSON: Decodable {
    var votes: VotesmartCandidateVoteResult
}

struct VotesmartCandidateVoteResult: Decodable {
    var vote: [SmartVote]
}

struct SmartVote: Decodable {
    var candidateId: String
    var candidateName: String
    var officeParties: String
    var action: String
}

