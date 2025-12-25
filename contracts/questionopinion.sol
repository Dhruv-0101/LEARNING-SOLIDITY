// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OpinionPoll {
    /*//////////////////////////////////////////////////////////////
                                ENUMS
    //////////////////////////////////////////////////////////////*/
    enum QuestionStatus {
        Pending,
        Active,
        Ended
    }

    /*//////////////////////////////////////////////////////////////
                                STRUCTS
    //////////////////////////////////////////////////////////////*/
    struct Question {
        uint256 id;
        address creator;
        string ipfsHash; // question + options stored on IPFS
        string category;
        uint256 createdAt;
        uint256 endTime;
        uint8 maxSelectableOptions;
        uint256 questionUpvotes;
        QuestionStatus status;
    }

    struct Option {
        uint256 voteCount;
    }

    /*//////////////////////////////////////////////////////////////
                                STATE
    //////////////////////////////////////////////////////////////*/
    uint256 public questionCount;

    // questionId => Question
    mapping(uint256 => Question) public questions;

    // questionId => options
    mapping(uint256 => Option[]) private questionOptions;

    // questionId => user => voted?
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    // questionId => user => upvoted?
    mapping(uint256 => mapping(address => bool)) public hasUpvoted;

    // user activity tracking
    mapping(address => uint256[]) public questionsCreatedByUser;
    mapping(address => uint256[]) public questionsVotedByUser;

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/
    event QuestionCreated(
        uint256 indexed questionId,
        address indexed creator,
        string category,
        uint256 endTime
    );

    event QuestionUpvoted(uint256 indexed questionId, address indexed user);

    event Voted(
        uint256 indexed questionId,
        address indexed user,
        uint256[] optionIndexes
    );

    /*//////////////////////////////////////////////////////////////
                        QUESTION CREATION
    //////////////////////////////////////////////////////////////*/
    function createQuestion(
        string calldata ipfsHash,
        string calldata category,
        uint256 durationInSeconds,
        uint8 optionCount,
        uint8 maxSelectableOptions
    ) external {
        require(optionCount >= 2, "Min 2 options required");
        require(
            maxSelectableOptions >= 1 && maxSelectableOptions <= optionCount,
            "Invalid selectable options"
        );
        require(durationInSeconds > 0, "Invalid duration");

        questionCount++;

        uint256 endTime = block.timestamp + durationInSeconds;

        questions[questionCount] = Question({
            id: questionCount,
            creator: msg.sender,
            ipfsHash: ipfsHash,
            category: category,
            createdAt: block.timestamp,
            endTime: endTime,
            maxSelectableOptions: maxSelectableOptions,
            questionUpvotes: 0,
            status: QuestionStatus.Active
        });

        // create options
        for (uint256 i = 0; i < optionCount; i++) {
            questionOptions[questionCount].push(Option({voteCount: 0}));
        }

        questionsCreatedByUser[msg.sender].push(questionCount);

        emit QuestionCreated(questionCount, msg.sender, category, endTime);
    }

    /*//////////////////////////////////////////////////////////////
                        QUESTION UPVOTE
    //////////////////////////////////////////////////////////////*/
    function upvoteQuestion(uint256 questionId) external {
        Question storage q = questions[questionId];

        require(q.id != 0, "Question not found");
        require(!hasUpvoted[questionId][msg.sender], "Already upvoted");

        hasUpvoted[questionId][msg.sender] = true;
        q.questionUpvotes++;

        emit QuestionUpvoted(questionId, msg.sender);
    }

    /*//////////////////////////////////////////////////////////////
                            VOTING
    //////////////////////////////////////////////////////////////*/
    function vote(
        uint256 questionId,
        uint256[] calldata optionIndexes
    ) external {
        Question storage q = questions[questionId];

        require(q.id != 0, "Question not found");
        require(block.timestamp < q.endTime, "Voting ended");
        require(!hasVoted[questionId][msg.sender], "Already voted");
        require(
            optionIndexes.length > 0 &&
                optionIndexes.length <= q.maxSelectableOptions,
            "Invalid selection count"
        );

        uint256 optionsLength = questionOptions[questionId].length;

        // validate option indexes
        for (uint256 i = 0; i < optionIndexes.length; i++) {
            require(optionIndexes[i] < optionsLength, "Invalid option index");
            questionOptions[questionId][optionIndexes[i]].voteCount++;
        }

        hasVoted[questionId][msg.sender] = true;
        questionsVotedByUser[msg.sender].push(questionId);

        emit Voted(questionId, msg.sender, optionIndexes);
    }

    /*//////////////////////////////////////////////////////////////
                        STATUS UPDATE (VIEW)
    //////////////////////////////////////////////////////////////*/
    function getQuestionStatus(
        uint256 questionId
    ) public view returns (QuestionStatus) {
        Question memory q = questions[questionId];
        if (block.timestamp >= q.endTime) {
            return QuestionStatus.Ended;
        }
        return q.status;
    }

    /*//////////////////////////////////////////////////////////////
                        READ FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function getOptions(
        uint256 questionId
    ) external view returns (Option[] memory) {
        return questionOptions[questionId];
    }

    function getUserCreatedQuestions(
        address user
    ) external view returns (uint256[] memory) {
        return questionsCreatedByUser[user];
    }

    function getUserVotedQuestions(
        address user
    ) external view returns (uint256[] memory) {
        return questionsVotedByUser[user];
    }

    function getActiveQuestions()
        external
        view
        returns (Question[] memory activeQuestions)
    {
        uint256 count;
        for (uint256 i = 1; i <= questionCount; i++) {
            if (block.timestamp < questions[i].endTime) {
                count++;
            }
        }

        activeQuestions = new Question[](count);
        uint256 index;

        for (uint256 i = 1; i <= questionCount; i++) {
            if (block.timestamp < questions[i].endTime) {
                activeQuestions[index++] = questions[i];
            }
        }
    }
}
