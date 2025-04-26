// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DecentralizedExamSystem {
    address public owner;

    struct Exam {
        string title;
        bool published;
        uint256 totalMarks;
    }

    struct Question {
        string questionText;
        string[] options;
        uint256 correctOptionIndex;
        uint256 marks;
    }

    struct StudentSubmission {
        mapping(uint256 => uint256) answers; // questionId => selectedOptionIndex
        bool submitted;
        uint256 score;
    }

    mapping(uint256 => Exam) public exams;
    mapping(uint256 => mapping(uint256 => Question)) public examQuestions; // examId => questionId => Question
    mapping(uint256 => uint256) public questionCount; // examId => number of questions
    mapping(uint256 => mapping(address => StudentSubmission))
        public studentAnswers; // examId => (student => answers)

    uint256 public examCount;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier examExists(uint256 examId) {
        require(examId < examCount, "Exam does not exist");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createExam(string memory title) external onlyOwner {
        exams[examCount] = Exam({
            title: title,
            published: false,
            totalMarks: 0
        });

        examCount++;
    }

    function addQuestion(
        uint256 examId,
        string memory questionText,
        string[] memory options,
        uint256 correctOptionIndex,
        uint256 marks
    ) external onlyOwner examExists(examId) {
        require(!exams[examId].published, "Cannot modify after publishing");
        require(options.length >= 2, "Must have at least 2 options");
        require(
            correctOptionIndex < options.length,
            "Invalid correct answer index"
        );

        uint256 questionId = questionCount[examId];

        examQuestions[examId][questionId] = Question({
            questionText: questionText,
            options: options,
            correctOptionIndex: correctOptionIndex,
            marks: marks
        });

        questionCount[examId]++;
        exams[examId].totalMarks += marks;
    }

    function publishExam(uint256 examId) external onlyOwner examExists(examId) {
        require(!exams[examId].published, "Exam already published");
        require(questionCount[examId] > 0, "Exam must have questions");

        exams[examId].published = true;
    }

    function submitAnswers(uint256 examId, uint256[] memory selectedOptions)
        external
        examExists(examId)
    {
        require(
            !studentAnswers[examId][msg.sender].submitted,
            "You have already submitted the exam"
        );
        require(
            selectedOptions.length == questionCount[examId],
            "Must answer all questions"
        );

        uint256 score = 0;
        for (uint256 i = 0; i < selectedOptions.length; i++) {
            if (
                selectedOptions[i] ==
                examQuestions[examId][i].correctOptionIndex
            ) {
                score += examQuestions[examId][i].marks;
            }
            studentAnswers[examId][msg.sender].answers[i] = selectedOptions[i];
        }

        studentAnswers[examId][msg.sender].submitted = true;
        studentAnswers[examId][msg.sender].score = score;
    }

    function getStudentScore(uint256 examId, address student)
        external
        view
        examExists(examId)
        returns (uint256)
    {
        require(
            studentAnswers[examId][student].submitted,
            "Student has not submitted the exam"
        );
        return studentAnswers[examId][student].score;
    }
}
