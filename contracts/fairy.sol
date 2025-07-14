// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.20;

// import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

// contract DecentralizedQnA is Initializable {
//     enum QuestionType {
//         YES_NO,
//         SINGLE_CHOICE,
//         MULTIPLE_CHOICE
//     }

//     struct Question {
//         uint256 id;
//         address creator;
//         string ipfsHash;
//         string[] tags;
//         QuestionType qType;
//         string[] options;
//         uint256 createdAt;
//         uint256 deadline;
//         uint256 upvotes;
//         bool showResultsAfterDeadline;
//         bool disabled;
//     }

//     address public admin;
//     uint256 public questionCounter;

//     mapping(uint256 => Question) private questions;
//     mapping(uint256 => address[]) private allowedVoters;
//     mapping(uint256 => address[]) private reporters;

//     mapping(address => string) public userProfiles;
//     mapping(uint256 => mapping(address => bool)) public hasVoted;
//     mapping(uint256 => mapping(address => bool)) public hasUpvoted;
//     mapping(uint256 => mapping(address => bool)) public hasReported;
//     mapping(uint256 => mapping(uint256 => uint256)) public optionVotes;

//     uint256[] public questionIds;

//     modifier onlyAdmin() {
//         require(msg.sender == admin, "Only admin");
//         _;
//     }

//     modifier validQuestion(uint256 _id) {
//         require(_id < questionCounter, "Invalid question ID");
//         _;
//     }

//     function initialize() public initializer {
//         admin = msg.sender;
//     }

//     // -------------------- PROFILE --------------------
//     function setUserProfile(string memory _ipfsHash) external {
//         userProfiles[msg.sender] = _ipfsHash;
//     }

//     // -------------------- CREATE QUESTION --------------------
//     function createQuestion(
//         string memory _ipfsHash,
//         string[] memory _tags,
//         QuestionType _type,
//         string[] memory _options,
//         uint256 _deadline,
//         bool _showResultsAfterDeadline,
//         address[] memory _allowed
//     ) external returns (uint256) {
//         require(
//             _type == QuestionType.YES_NO || _options.length >= 2,
//             "At least 2 options required"
//         );

//         uint256 id = questionCounter++;

//         Question storage q = questions[id];
//         q.id = id;
//         q.creator = msg.sender;
//         q.ipfsHash = _ipfsHash;
//         q.tags = _tags;
//         q.qType = _type;
//         q.createdAt = block.timestamp;
//         q.deadline = _deadline;
//         q.showResultsAfterDeadline = _showResultsAfterDeadline;

//         if (_type == QuestionType.YES_NO) {
//             q.options = ["Yes", "No"];
//         } else {
//             q.options = _options;
//         }

//         if (_allowed.length > 0) {
//             allowedVoters[id] = _allowed;
//         }

//         questionIds.push(id);
//         return id;
//     }

//     // -------------------- VOTE --------------------
//     function vote(uint256 _id, uint256[] memory _optionIndexes)
//         external
//         validQuestion(_id)
//     {
//         Question storage q = questions[_id];
//         require(!q.disabled, "Disabled");
//         require(block.timestamp <= q.deadline, "Ended");
//         require(!hasVoted[_id][msg.sender], "Already voted");

//         if (allowedVoters[_id].length > 0) {
//             bool allowed = false;
//             for (uint256 i = 0; i < allowedVoters[_id].length; i++) {
//                 if (allowedVoters[_id][i] == msg.sender) {
//                     allowed = true;
//                     break;
//                 }
//             }
//             require(allowed, "Not allowed to vote");
//         }

//         if (
//             q.qType == QuestionType.SINGLE_CHOICE ||
//             q.qType == QuestionType.YES_NO
//         ) {
//             require(_optionIndexes.length == 1, "One option allowed");
//         } else {
//             require(_optionIndexes.length > 0, "Select at least one option");
//         }

//         for (uint256 i = 0; i < _optionIndexes.length; i++) {
//             require(_optionIndexes[i] < q.options.length, "Invalid option");
//             optionVotes[_id][_optionIndexes[i]]++;
//         }

//         hasVoted[_id][msg.sender] = true;
//     }

//     // -------------------- UPVOTE --------------------
//     function upvoteQuestion(uint256 _id) external validQuestion(_id) {
//         require(!hasUpvoted[_id][msg.sender], "Already upvoted");
//         questions[_id].upvotes++;
//         hasUpvoted[_id][msg.sender] = true;
//     }

//     // -------------------- REPORT --------------------
//     function reportQuestion(uint256 _id) external validQuestion(_id) {
//         require(!hasReported[_id][msg.sender], "Already reported");
//         hasReported[_id][msg.sender] = true;
//         reporters[_id].push(msg.sender);
//     }

//     function getReports(uint256 _id)
//         external
//         view
//         onlyAdmin
//         validQuestion(_id)
//         returns (address[] memory)
//     {
//         return reporters[_id];
//     }

//     function disableQuestion(uint256 _id) external onlyAdmin {
//         questions[_id].disabled = true;
//     }

//     // -------------------- GETTERS --------------------

//     function getQuestionDetails(uint256 _id)
//         external
//         view
//         validQuestion(_id)
//         returns (
//             uint256,
//             address,
//             string memory, 
//             string[] memory,
//             QuestionType,
//             string[] memory
//         )
//     {
//         Question storage q = questions[_id];
//         return (q.id, q.creator, q.ipfsHash, q.tags, q.qType, q.options);
//     }

//     function getQuestionStatus(uint256 _id)
//         external
//         view
//         validQuestion(_id)
//         returns (
//             uint256,
//             uint256,
//             uint256,
//             bool,
//             bool,
//             address[] memory
//         )
//     {
//         Question storage q = questions[_id];
//         return (
//             q.createdAt,
//             q.deadline,
//             q.upvotes,
//             q.disabled,
//             q.showResultsAfterDeadline,
//             allowedVoters[_id]
//         );
//     }

//     function getQuestionVotes(uint256 _id)
//         external
//         view
//         validQuestion(_id)
//         returns (uint256[] memory)
//     {
//         Question storage q = questions[_id];
//         uint256[] memory votes = new uint256[](q.options.length);
//         for (uint256 i = 0; i < q.options.length; i++) {
//             if (q.showResultsAfterDeadline && block.timestamp < q.deadline) {
//                 votes[i] = 0;
//             } else {
//                 votes[i] = optionVotes[_id][i];
//             }
//         }
//         return votes;
//     }

//     function getAllQuestionIds() external view returns (uint256[] memory) {
//         return questionIds;
//     }
// // }
// pragma solidity ^0.8.20;

// import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

// contract DecentralizedQnA is Initializable {
//     enum QuestionType {
//         YES_NO,
//         SINGLE_CHOICE,
//         MULTIPLE_CHOICE
//     }

//     struct Question {
//         uint256 id;
//         address creator;
//         string ipfsHash;
//         string[] tags;
//         QuestionType qType;
//         string[] options;
//         uint256 createdAt;
//         uint256 deadline;
//         uint256 upvotes;
//         bool showResultsAfterDeadline;
//         bool disabled;
//     }

//     address public admin;
//     uint256 public questionCounter;

//     mapping(uint256 => Question) private questions;
//     mapping(uint256 => address[]) private allowedVoters;
//     mapping(uint256 => address[]) private reporters;

//     mapping(address => string) public userProfiles;
//     mapping(uint256 => mapping(address => bool)) public hasVoted;
//     mapping(uint256 => mapping(address => bool)) public hasUpvoted;
//     mapping(uint256 => mapping(address => bool)) public hasReported;
//     mapping(uint256 => mapping(uint256 => uint256)) public optionVotes;

//     uint256[] public questionIds;

//     modifier onlyAdmin() {
//         require(msg.sender == admin, "Only admin");
//         _;
//     }

//     modifier validQuestion(uint256 _id) {
//         require(_id < questionCounter, "Invalid question ID");
//         _;
//     }

//     function initialize() public initializer {
//         admin = msg.sender;
//     }

//     // -------------------- PROFILE --------------------
//     function setUserProfile(string memory _ipfsHash) external {
//         userProfiles[msg.sender] = _ipfsHash;
//     }

//     // -------------------- CREATE QUESTION --------------------
//     function createQuestion(
//         string memory _ipfsHash,
//         string[] memory _tags,
//         QuestionType _type,
//         string[] memory _options,
//         uint256 _deadline,
//         bool _showResultsAfterDeadline,
//         address[] memory _allowed
//     ) external returns (uint256) {
//         require(
//             _type == QuestionType.YES_NO || _options.length >= 2,
//             "At least 2 options required"
//         );

//         uint256 id = questionCounter++;

//         Question storage q = questions[id];
//         q.id = id;
//         q.creator = msg.sender;
//         q.ipfsHash = _ipfsHash;
//         q.tags = _tags;
//         q.qType = _type;
//         q.createdAt = block.timestamp;
//         q.deadline = _deadline;
//         q.showResultsAfterDeadline = _showResultsAfterDeadline;

//         if (_type == QuestionType.YES_NO) {
//             q.options = ["Yes", "No"];
//         } else {
//             q.options = _options;
//         }

//         if (_allowed.length > 0) {
//             allowedVoters[id] = _allowed;
//         }

//         questionIds.push(id);
//         return id;
//     }

//     // -------------------- VOTE --------------------
//     function vote(uint256 _id, uint256[] memory _optionIndexes)
//         external
//         validQuestion(_id)
//     {
//         Question storage q = questions[_id];
//         require(!q.disabled, "Disabled");
//         require(block.timestamp <= q.deadline, "Ended");
//         require(!hasVoted[_id][msg.sender], "Already voted");

//         if (allowedVoters[_id].length > 0) {
//             bool allowed = false;
//             for (uint256 i = 0; i < allowedVoters[_id].length; i++) {
//                 if (allowedVoters[_id][i] == msg.sender) {
//                     allowed = true;
//                     break;
//                 }
//             }
//             require(allowed, "Not allowed to vote");
//         }

//         if (
//             q.qType == QuestionType.SINGLE_CHOICE ||
//             q.qType == QuestionType.YES_NO
//         ) {
//             require(_optionIndexes.length == 1, "One option allowed");
//         } else {
//             require(_optionIndexes.length > 0, "Select at least one option");
//         }

//         for (uint256 i = 0; i < _optionIndexes.length; i++) {
//             require(_optionIndexes[i] < q.options.length, "Invalid option");
//             optionVotes[_id][_optionIndexes[i]]++;
//         }

//         hasVoted[_id][msg.sender] = true;
//     }

//     // -------------------- UPVOTE --------------------
//     function upvoteQuestion(uint256 _id) external validQuestion(_id) {
//         require(!hasUpvoted[_id][msg.sender], "Already upvoted");
//         questions[_id].upvotes++;
//         hasUpvoted[_id][msg.sender] = true;
//     }

//     // -------------------- REPORT --------------------
//     function reportQuestion(uint256 _id) external validQuestion(_id) {
//         require(!hasReported[_id][msg.sender], "Already reported");
//         hasReported[_id][msg.sender] = true;
//         reporters[_id].push(msg.sender);
//     }

//     function getReports(uint256 _id)
//         external
//         view
//         onlyAdmin
//         validQuestion(_id)
//         returns (address[] memory)
//     {
//         return reporters[_id];
//     }

//     function disableQuestion(uint256 _id) external onlyAdmin {
//         questions[_id].disabled = true;
//     }

//     // -------------------- GETTERS --------------------

//     function getQuestionDetails(uint256 _id)
//         external
//         view
//         validQuestion(_id)
//         returns (
//             uint256,
//             address,
//             string memory,
//             string[] memory,
//             QuestionType,
//             string[] memory
//         )
//     {
//         Question storage q = questions[_id];
//         return (q.id, q.creator, q.ipfsHash, q.tags, q.qType, q.options);
//     }

//     function getQuestionStatus(uint256 _id)
//         external
//         view
//         validQuestion(_id)
//         returns (
//             uint256,
//             uint256,
//             uint256,
//             bool,
//             bool,
//             address[] memory
//         )
//     {
//         Question storage q = questions[_id];
//         return (
//             q.createdAt,
//             q.deadline,
//             q.upvotes,
//             q.disabled,
//             q.showResultsAfterDeadline,
//             allowedVoters[_id]
//         );
//     }

//     function getQuestionVotes(uint256 _id)
//         external
//         view
//         validQuestion(_id)
//         returns (uint256[] memory)
//     {
//         Question storage q = questions[_id];
//         uint256[] memory votes = new uint256[](q.options.length);
//         for (uint256 i = 0; i < q.options.length; i++) {
//             if (q.showResultsAfterDeadline && block.timestamp < q.deadline) {
//                 votes[i] = 0;
//             } else {
//                 votes[i] = optionVotes[_id][i];
//             }
//         }
//         return votes;
//     }

//     function getAllQuestionIds() external view returns (uint256[] memory) {
//         return questionIds;
//     }
// }

pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract DecentralizedQnA is Initializable {
    enum QuestionType {
        YES_NO,
        SINGLE_CHOICE,
        MULTIPLE_CHOICE
    }

    struct Question {
        uint256 id;
        address creator;
        string ipfsHash;
        string[] tags;
        QuestionType qType;
        string[] options;
        uint256 createdAt;
        uint256 deadline;
        uint256 upvotes;
        bool showResultsAfterDeadline;
        bool disabled;
    }

    address public admin;
    uint256 public questionCounter;

    mapping(uint256 => Question) private questions;
    mapping(uint256 => address[]) private allowedVoters;
    mapping(uint256 => address[]) private reporters;

    mapping(address => string) public userProfiles;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    mapping(uint256 => mapping(address => bool)) public hasUpvoted;
    mapping(uint256 => mapping(address => bool)) public hasReported;
    mapping(uint256 => mapping(uint256 => uint256)) public optionVotes;

    uint256[] public questionIds;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    modifier validQuestion(uint256 _id) {
        require(_id < questionCounter, "Invalid question ID");
        _;
    }

    function initialize() public initializer {
        admin = msg.sender;
    }

    // -------------------- PROFILE --------------------
    function setUserProfile(string memory _ipfsHash) external {
        userProfiles[msg.sender] = _ipfsHash;
    }

    // -------------------- CREATE QUESTION --------------------
    function createQuestion(
        string memory _ipfsHash,
        string[] memory _tags,
        QuestionType _type,
        string[] memory _options,
        uint256 _deadline,
        bool _showResultsAfterDeadline,
        address[] memory _allowed
    ) external returns (uint256) {
        require(
            _type == QuestionType.YES_NO || _options.length >= 2,
            "At least 2 options required"
        );

        uint256 id = questionCounter++;

        Question storage q = questions[id];
        q.id = id;
        q.creator = msg.sender;
        q.ipfsHash = _ipfsHash;
        q.tags = _tags;
        q.qType = _type;
        q.createdAt = block.timestamp;
        q.deadline = _deadline;
        q.showResultsAfterDeadline = _showResultsAfterDeadline;

        if (_type == QuestionType.YES_NO) {
            q.options = ["Yes", "No"];
        } else {
            q.options = _options;
        }

        if (_allowed.length > 0) {
            allowedVoters[id] = _allowed;
        }

        questionIds.push(id);
        return id;
    }

    // -------------------- VOTE --------------------
    function vote(uint256 _id, uint256[] memory _optionIndexes)
        external
        validQuestion(_id)
    {
        Question storage q = questions[_id];
        require(!q.disabled, "Disabled");
        require(block.timestamp <= q.deadline, "Ended");
        require(!hasVoted[_id][msg.sender], "Already voted");

        if (allowedVoters[_id].length > 0) {
            bool allowed = false;
            for (uint256 i = 0; i < allowedVoters[_id].length; i++) {
                if (allowedVoters[_id][i] == msg.sender) {
                    allowed = true;
                    break;
                }
            }
            require(allowed, "Not allowed to vote");
        }

        if (
            q.qType == QuestionType.SINGLE_CHOICE ||
            q.qType == QuestionType.YES_NO
        ) {
            require(_optionIndexes.length == 1, "One option allowed");
        } else {
            require(_optionIndexes.length > 0, "Select at least one option");
        }

        for (uint256 i = 0; i < _optionIndexes.length; i++) {
            require(_optionIndexes[i] < q.options.length, "Invalid option");
            optionVotes[_id][_optionIndexes[i]]++;
        }

        hasVoted[_id][msg.sender] = true;
    }

    // -------------------- UPVOTE --------------------
    function upvoteQuestion(uint256 _id) external validQuestion(_id) {
        require(!hasUpvoted[_id][msg.sender], "Already upvoted");
        questions[_id].upvotes++;
        hasUpvoted[_id][msg.sender] = true;
    }

    // -------------------- REPORT --------------------
    function reportQuestion(uint256 _id) external validQuestion(_id) {
        require(!hasReported[_id][msg.sender], "Already reported");
        hasReported[_id][msg.sender] = true;
        reporters[_id].push(msg.sender);
    }

    function getReports(uint256 _id)
        external
        view
        onlyAdmin
        validQuestion(_id)
        returns (address[] memory)
    {
        return reporters[_id];
    }

    function disableQuestion(uint256 _id) external onlyAdmin {
        questions[_id].disabled = true;
    }

    // -------------------- GETTERS --------------------

    function getQuestionDetails(uint256 _id)
        external
        view
        validQuestion(_id)
        returns (
            uint256,
            address,
            string memory,
            string[] memory,
            QuestionType,
            string[] memory
        )
    {
        Question storage q = questions[_id];
        return (q.id, q.creator, q.ipfsHash, q.tags, q.qType, q.options);
    }

    function getQuestionStatus(uint256 _id)
        external
        view
        validQuestion(_id)
        returns (
            uint256,
            uint256,
            uint256,
            bool,
            bool,
            address[] memory
        )
    {
        Question storage q = questions[_id];
        return (
            q.createdAt,
            q.deadline,
            q.upvotes,
            q.disabled,
            q.showResultsAfterDeadline,
            allowedVoters[_id]
        );
    }

    function getQuestionVotes(uint256 _id)
        external
        view
        validQuestion(_id)
        returns (uint256[] memory)
    {
        Question storage q = questions[_id];
        uint256[] memory votes = new uint256[](q.options.length);
        for (uint256 i = 0; i < q.options.length; i++) {
            if (q.showResultsAfterDeadline && block.timestamp < q.deadline) {
                votes[i] = 0;
            } else {
                votes[i] = optionVotes[_id][i];
            }
        }
        return votes;
    }

    function getAllQuestionIds() external view returns (uint256[] memory) {
        return questionIds;
    }
}
