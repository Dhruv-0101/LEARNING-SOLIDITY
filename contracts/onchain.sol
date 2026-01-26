// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title PollingApp
 * @dev Decentralized Polling Smart Contract
 */
contract PollingApp {
    enum QuestionType { YesNo, SingleChoice, MultipleChoice }

    struct Question {
        address creator;
        string ipfsHash;
        QuestionType qType;
        uint256 deadline;
        uint8 category;
        uint256 voteCount;
        uint256 upvoteCount;
        bool exists;
    }

    // Mapping from question ID to Question details
    mapping(uint256 => Question) public questions;
    // Mapping from question ID to user to boolean (has voted)
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    // Mapping from question ID to user to boolean (has upvoted)
    mapping(uint256 => mapping(address => bool)) public hasUpvoted;
    
    uint256 public nextQuestionId;

    event QuestionCreated(
        uint256 indexed questionId,
        address indexed creator,
        string ipfsHash,
        QuestionType qType,
        uint256 deadline,
        uint8 category
    );

    event Voted(
        uint256 indexed questionId,
        address indexed voter,
        uint256[] selectedOptions
    );

    event Upvoted(
        uint256 indexed questionId,
        address indexed upvoter
    );

    /**
     * @dev Create a new poll/question
     * @param _ipfsHash CID from IPFS containing question text and options
     * @param _qType Type of the question (YesNo, Single, Multiple)
     * @param _deadline Timestamp when voting ends
     * @param _category Predefined category ID
     */
    function createQuestion(
        string memory _ipfsHash,
        QuestionType _qType,
        uint256 _deadline,
        uint8 _category
    ) external {
        require(_deadline > block.timestamp, "Deadline must be in the future");
        require(_category < 10, "Invalid category");

        questions[nextQuestionId] = Question({
            creator: msg.sender,
            ipfsHash: _ipfsHash,
            qType: _qType,
            deadline: _deadline,
            category: _category,
            voteCount: 0,
            upvoteCount: 0,
            exists: true
        });

        emit QuestionCreated(nextQuestionId, msg.sender, _ipfsHash, _qType, _deadline, _category);
        nextQuestionId++;
    }

    /**
     * @dev Vote on a specific question
     * @param _questionId ID of the question
     * @param _selectedOptions Array of selected option indices
     */
    function vote(uint256 _questionId, uint256[] calldata _selectedOptions) external {
        Question storage q = questions[_questionId];
        require(q.exists, "Question does not exist");
        require(block.timestamp < q.deadline, "Poll has ended");
        require(!hasVoted[_questionId][msg.sender], "Already voted");
        require(_selectedOptions.length > 0, "Must select at least one option");

        if (q.qType == QuestionType.YesNo || q.qType == QuestionType.SingleChoice) {
            require(_selectedOptions.length == 1, "Only one option allowed");
        }

        hasVoted[_questionId][msg.sender] = true;
        q.voteCount++;

        emit Voted(_questionId, msg.sender, _selectedOptions);
    }

    /**
     * @dev Upvote a specific question
     * @param _questionId ID of the question
     */
    function upvote(uint256 _questionId) external {
        Question storage q = questions[_questionId];
        require(q.exists, "Question does not exist");
        require(!hasUpvoted[_questionId][msg.sender], "Already upvoted");

        hasUpvoted[_questionId][msg.sender] = true;
        q.upvoteCount++;

        emit Upvoted(_questionId, msg.sender);
    }
}
