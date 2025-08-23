// SPDX-License-Identifier: MIT
// Specifies the open-source license.
pragma solidity 0.8.26;
// Defines the Solidity compiler version.

// Import necessary contracts from the Chainlink library.
import {FunctionsClient} from "@chainlink/contracts@1.4.0/src/v0.8/functions/v1_0_0/FunctionsClient.sol";//fulfill request
import {ConfirmedOwner} from "@chainlink/contracts@1.4.0/src/v0.8/shared/access/ConfirmedOwner.sol";//mere behalf pe woh call karega aur me usse token dunga. 
import {FunctionsRequest} from "@chainlink/contracts@1.4.0/src/v0.8/functions/v1_0_0/libraries/FunctionsRequest.sol";

/**
 * @title GettingStartedFunctionsConsumer
 * @notice An example contract for making API requests using Chainlink Functions.
 */
// The contract inherits from:
// - FunctionsClient: Provides the core logic for interacting with Chainlink Functions.
// - ConfirmedOwner: A security feature that restricts certain functions to the contract deployer.
contract GettingStartedFunctionsConsumer is FunctionsClient, ConfirmedOwner {
    // This line allows us to use the FunctionsRequest library's functions on the Request struct.
    using FunctionsRequest for FunctionsRequest.Request;//send request

    // --- STATE VARIABLES ---
    // These variables store the results of our last API call.

    bytes32 public s_lastRequestId; // The unique ID of the last request we sent.
    bytes public s_lastResponse;    // The raw data returned from the API call.
    bytes public s_lastError;       // Any error message returned if the call failed.

    // A custom error to ensure that a response corresponds to the request we sent.
    error UnexpectedRequestID(bytes32 requestId);

    // An event to log the full response details on the blockchain.
    event Response(
        bytes32 indexed requestId,
        string character,
        bytes response,
        bytes err
    );

    // --- CHAINLINK CONFIGURATION (Hardcoded for Sepolia Testnet) ---

    // The address of the main Chainlink Functions contract that manages all requests.
    address router = 0xb83E47C2bC239B3bf370bc41e1459A34b41238D0;//sepolia

    // This is the JavaScript code that will be executed off-chain by a Chainlink node.
    string source =
        // It takes a character ID as an argument (e.g., "1" for Luke Skywalker).
        "const characterId = args[0];"
        // It makes an HTTP GET request to the Star Wars API.
        "const apiResponse = await Functions.makeHttpRequest({"
        "url: `https://swapi.info/api/people/${characterId}/`"
        "});"
        // It checks if the API call resulted in an error.
        "if (apiResponse.error) {"
        "throw Error('Request failed');"
        "}"
        // It extracts the 'data' object from the successful API response.
        "const { data } = apiResponse;"
        // It encodes the character's name into a string and returns it to the smart contract.
        "return Functions.encodeString(data.name);";

    // The maximum amount of gas the callback function (fulfillRequest) can use.
    uint32 gasLimit = 300000;

    // The unique ID for the Decentralized Oracle Network (DON) that will execute our JS code.
    bytes32 donID =
        0x66756e2d657468657265756d2d7365706f6c69612d3100000000000000000000;

    // A public state variable to store the final, decoded character name.
    string public character;

    // The constructor is called only once when the contract is deployed.
    // It initializes the FunctionsClient with the router's address.
    // It also sets the deployer of the contract as the owner.
    constructor() FunctionsClient(router) ConfirmedOwner(msg.sender) {}

    // --- 1. SENDING THE REQUEST ---
    // This function starts the process. It can only be called by the contract owner.
    function sendRequest(
        uint64 subscriptionId, // Your Chainlink Functions subscription ID for billing.
        string[] calldata args  // The arguments for the JS code (e.g., ["1"]).
    ) external onlyOwner returns (bytes32 requestId) {
        // Create a new request object in memory.
        FunctionsRequest.Request memory req;
        // Initialize it with our JavaScript source code.
        req.initializeRequestForInlineJavaScript(source);
        // If arguments were provided, add them to the request.
        if (args.length > 0) req.setArgs(args);

        // Send the actual request to the Chainlink network and store the unique ID it returns.
        s_lastRequestId = _sendRequest(
            req.encodeCBOR(), // The encoded request payload.
            subscriptionId,
            gasLimit,
            donID
        );

        return s_lastRequestId;
    }

    // --- 2. RECEIVING THE RESPONSE ---
    // This is the callback function that the Chainlink oracle calls to deliver the result.
    // It's 'internal' because it should only be called by the FunctionsClient contract.
    function fulfillRequest(
        bytes32 requestId, // The ID of the request being fulfilled.
        bytes memory response, // The raw data returned by our JS code.
        bytes memory err       // Any error data.
    ) internal override {
        // Security check: Make sure the response ID matches our last request ID.
        if (s_lastRequestId != requestId) {
            revert UnexpectedRequestID(requestId);
        }
        // Store the raw response and error data.
        s_lastResponse = response;
        s_lastError = err;

        // Decode the raw bytes response into a human-readable string and store it.
        character = string(response);

        // Emit an event to create a public log of the successful response.
        emit Response(requestId, character, s_lastResponse, s_lastError);
    }
}