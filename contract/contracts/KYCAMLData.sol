// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity ^0.8.20;

import "fhevm/abstracts/EIP712WithModifier.sol";
import "@anon-aadhaar/contracts/interfaces/IAnonAadhaar.sol";
import "fhevm/lib/TFHE.sol";

contract KYCAMLData is EIP712WithModifier {
    bytes32 private DOMAIN_SEPARATOR;
    address public trustedKYCProvider;
    address public anonAadhaarVerifierAddr;

    mapping(address => euint32) internal kycData;
    mapping(address => string) public encryptedAadhaarCIDs; // Store encrypted IPFS CIDs
    mapping(address => mapping(address => bool)) public cidAccess; // Track access to CIDs

    constructor(address _verifierAddr) EIP712WithModifier("KYCAML Authorization", "1") {
        trustedKYCProvider = msg.sender;
        anonAadhaarVerifierAddr = _verifierAddr;
    }

    IAnonAadhaar anonAadhaarVerifier = IAnonAadhaar(anonAadhaarVerifierAddr);

    modifier onlyProvider {
        require(msg.sender == trustedKYCProvider, "Caller is not the trusted provider");
        _;
    }

    function storeKYCData(address user, euint32 encryptedData) external onlyProvider {
        kycData[user] = encryptedData;
    }

    function viewKYCData(address user, bytes32 publicKey, bytes calldata signature) 
        public 
        view 
        onlySignedPublicKey(publicKey, signature) 
        returns (bytes memory) 
    {
        return TFHE.reencrypt(kycData[user], publicKey);
    }

    function storeEncryptedAadhaarCID(address user, string memory cid) external onlyProvider {
        encryptedAadhaarCIDs[user] = cid;
    }

    function grantAccessToAadhaarCID(address user, address governmentEntity) external onlyProvider {
        cidAccess[user][governmentEntity] = true;
    }

    function getEncryptedAadhaarCID(address user, address governmentEntity) external view returns (string memory) {
        require(cidAccess[user][governmentEntity], "Access not granted");
        return encryptedAadhaarCIDs[user];
    }

    function verifyAnonAadhaarProof(
        uint256 nullifierSeed,
        uint256 nullifier,
        uint256 timestamp,
        uint256 signal,
        uint256[4] calldata revealArray,
        uint256[8] calldata groth16Proof
    ) external view returns (bool) {
        return IAnonAadhaar(anonAadhaarVerifierAddr).verifyAnonAadhaarProof(
            nullifierSeed,
            nullifier,
            timestamp,
            signal,
            revealArray,
            groth16Proof
        );
    }
}
