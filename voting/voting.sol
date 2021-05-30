// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Voting {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        assert(owner == msg.sender);
        _;
    }

    struct Candidate {
        string name;
        string party;
        uint256 noOfVotes;
        bool doesExist;
    }

    struct Voter {
        uint256 candidateIDVote;
        bool hasVoted;
        // Assignment: Is authorize to vote
        // Only owner of contract can set it true
        bool isAuthorized;
    }

    uint256 numCandidates;
    uint256 numVoters;
    uint256 numOfVotes;

    // holds all the candidates
    mapping(uint256 => Candidate) candidates;
    // holds the voters
    mapping(address => Voter) voters;

    // add candidates
    function addCandidate(string memory name, string memory party)
        public
        onlyOwner
    {
        numCandidates++;
        candidates[numCandidates] = Candidate(name, party, 0, true);
    }

    // Assignment: only owner can authorize a voter
    function authorize(address _voter) public onlyOwner {
        voters[_voter].isAuthorized = true;
    }

    // vote a Candidate
    function vote(uint256 candidateId) public {
        // Assignment: authorized voter check
        require(voters[msg.sender].isAuthorized);

        require(!voters[msg.sender].hasVoted);
        require(candidates[candidateId].doesExist);

        voters[msg.sender] = Voter(candidateId, true, true);

        candidates[candidateId].noOfVotes++;
        numVoters++;
        numOfVotes++;
    }

    // returns the total votes casted for the specified candidate
    function totalVotes(uint256 candidateId) public view returns (uint256) {
        return candidates[candidateId].noOfVotes;
    }

    // returns total number of candidates
    function getNumOfCandidates() public view returns (uint256) {
        return numCandidates;
    }

    // returns total number of votes
    function getNumOfVoters() public view returns (uint256) {
        return numVoters;
    }

    // returns candidate information, including its ID, name, and party
    function getCandidate(uint256 candidateId)
        public
        view
        returns (
            uint256,
            string memory,
            string memory,
            uint256
        )
    {
        Candidate memory candidate = candidates[candidateId];

        return (
            candidateId,
            candidate.name,
            candidate.party,
            candidate.noOfVotes
        );
    }
}
