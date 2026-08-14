import Foundation

public extension JSONDecoder {
    static var bloomDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

public final class MessageBox: Codable {
    public let value: Message
    
    public init(_ value: Message) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode(Message.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

public struct User: Codable {
    public let id: String
    public let username: String
    public let displayName: String?
    public let description: String?
    public let mlKemPublicKey: String
    public let ecdhPublicKey: String
    public let edPublicKey: String
    public let date: Date
}

public struct EditUserRequest: Codable {
    public let username: String?
    public let displayName: String?
    public let description: String?
}

public struct EditUserResponse: Codable {
    public let success: Bool
    public let user: User
}

public struct Session: Codable {
    public let id: Int
    public let token: String
    public let userId: String
    public let revokedAt: Date?
    public let createdAt: Date
}

public struct EncryptedKey: Codable {
    public let ciphertext: String
    public let nonce: String
    public let salt: String
    public let signature: String
}

public struct IdentityPublicKeys: Codable {
    public let mlKemPublicKey: String
    public let ecdhPublicKey: String
    public let edPublicKey: String
}

public struct EncryptedKeys: Codable {
    public let ciphertext: String
    public let nonce: String
    public let salt: String
    public let signature: String
    public let id: Int
    public let type: String
    public let userId: String
}

public struct IdentityKeysRequest: Codable {
    public let encryptedSecretKeys: EncryptedKey
    public let publicKeys: IdentityPublicKeys
}

public struct GetKeysResponse: Codable {
    public let userId: Int
    public let ciphertext: String
    public let nonce: String
    public let salt: String
    public let signature: String
}

public struct KeysRequest: Codable {
    public let authLookupId: String
    public let identityKeys: IdentityKeysRequest
    public let encryptedMasterKey: EncryptedKey
}

public struct RegisterResponse: Codable {
    public let token: String
    public let user: User
    public let session: Session
}

struct RegisterBackgroundResult: Sendable {
    let rawRecoveryKey: String?
    let userJSON: Data?
}

public struct BeginLoginResponse: Codable {
    public let userId: String
    public let keys: KeysRequest
    public let challenge: String
}

public struct LoginChallenge: Codable {
    public let challenge: String
    public let userId: String
}

public struct FinishLoginRequest: Codable {
    public let userId: String
    public let signature: String
}

public struct RawMessage: Codable {
    public let id: Int
    public let ciphertext: String
    public let nonce: String
    public let salt: String
    public let chatId: Int
    public let seen: Date?
    public let replyTo: Int?
}

public struct RawMessageWithReply: Codable {
    public let id: Int
    public let ciphertext: String
    public let nonce: String
    public let salt: String
    public let chatId: Int
    public let seen: Date?
    public let replyTo: Int?
    public let replyToMessage: RawMessage?
}

public struct Message: Codable {
    public let id: Int
    public let ciphertext: String
    public let nonce: String
    public let salt: String
    public let chatId: Int
    public let seen: Date?
    public let replyTo: Int?
    public let content: String?
    public let authorId: String?
    public let syncTag: String?
    public let timestamp: Int64?
    
    public let replyToMessage: MessageBox?
}

public struct SendMessageRequest: Codable {
    public let ciphertext: String
    public let nonce: String
    public let salt: String
    public let chatId: Int
    public let replyTo: Int?
}

public struct DecryptedMessage: Codable, Identifiable {
    public let id: Int
    public let content: String
    public let authorId: String
    public let timestamp: Int64
    public let seen: Date?
}

public struct DecryptedMessageWithReply: Codable, Identifiable {
    public let id: Int
    public let content: String
    public let authorId: String
    public let timestamp: Int64
    public let seen: Date?
    public let replyTo: DecryptedMessage?
}

public struct EncryptedSyncKey: Codable {
    public let ciphertext: String
    public let nonce: String
}

public struct Handshake: Codable {
    public let receiverCipherText: String
    public let senderEphemeralX448: String
    public let encryptedSyncKey: EncryptedSyncKey
}

public struct EncryptedGroupKey: Codable {
    public let ciphertext: String
    public let nonce: String
    public let salt: String
}

public struct GroupMember: Codable {
    public let recipientId: String
    public let invitedById: String
    public let receiverCipherText: String
    public let senderEphemeralX448: String
    public let encryptedSyncKey: EncryptedSyncKey
    public let encryptedGroupKey: EncryptedGroupKey
}

public struct GroupMemberRequest: Codable {
    public let memberId: String
    public let handshake: Handshake
    public let encryptedGroupKey: EncryptedGroupKey
}

public struct CreateChatRequest: Codable {
    public let type: String
    public let recipient: String?
    public let handshake: Handshake?
    public let title: String?
    public let members: [GroupMemberRequest]?
}

public struct RawChat: Codable {
    public let id: Int
    public let members: [User]?
    public let handshake: Handshake?
    public let title: String?
    public let type: String
}

public struct Chat: Codable {
    public let id: Int
    public let members: [User]?
    public let handshake: Handshake?
    public let title: String?
    public let type: String
    public let lastMessage: DecryptedMessageWithReply?
    public let lastReadMessage: DecryptedMessageWithReply?
}

public struct ChatResponse: Codable {
    public let id: Int
    public let members: [User]?
    public let handshake: Handshake?
    public let title: String?
    public let type: String
    public let me: User?
    public let recipient: User?
    public let lastMessage: DecryptedMessageWithReply?
}

public struct StartExchangeSessionResponse: Codable {
    public let roomId: String
}

public struct PublicKeys: Codable {
    public let mlKem768PublicKey: String
    public let x448PublicKey: String
    public let ed448PublicKey: String
}

public struct SavedCredentials: Codable {
    public let userId: String
    public let recoveryKey: Data
    public let masterKey: Data
    public let mlKem768PublicKey: String
    public let x448PublicKey: String
    public let ed448PublicKey: String
    public let secretKeys: Data
    public let userJson: Data
    public let token: String
}
