import Foundation
import Observation
import BloomKit
import Bip39

final class ChatsObserver: NSObject, ClientChatsListenerProtocol {
    var onUpdate: (@MainActor (Data) -> Void)?
    
    func onChatsUpdated(_ chatsJSON: Data?) {
        guard let data = chatsJSON else {
            return
        }
        Task { @MainActor in
            self.onUpdate?(data)
        }
    }
}

final class UserObserver: NSObject, ClientUserListenerProtocol {
    var onUpdate: (@MainActor (User) -> Void)?
    
    func onUserUpdated(_ userJSON: Data?) {
        guard let data = userJSON else { return }
        do {
            let decoder = JSONDecoder.bloomDecoder
            let updatedUser = try decoder.decode(User.self, from: data)
            Task { @MainActor in
                self.onUpdate?(updatedUser)
            }
        } catch {}
    }
}

@Observable
@MainActor
final class BloomManager {
    let client: ClientBloomClient
    
    var currentUser: User?
    var conversations: [ChatResponse] = []
    
    private let userObserver = UserObserver()
    private let chatsObserver = ChatsObserver()
    private var isObservingUser = false
    private var isObservingChats = false
    
    init() {
        do {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let storagePath = paths[0].path
            
            let encryptionKey = Self.getOrCreateDatabaseKey()
            
            guard let clientInstance = ClientNewClient(
                "https://api.bloomapp.pw",
                "wss://api.bloomapp.pw/ws",
                storagePath,
                encryptionKey
            ) else {
                fatalError("Failed to initialize ClientNewClient")
            }
            
            self.client = clientInstance
            try self.client.initialize()
            
            if let result = try? client.restoreSession() {
                if let decodedUser = try? JSONDecoder.bloomDecoder.decode(User.self, from: result.userJSON ?? Data()) {
                    setupSession(user: decodedUser)
                }
            }
        } catch {
            print("Critical database error: \(error)")
            fatalError("Critical database error: \(error)")
        }
    }
    
    private static func getOrCreateDatabaseKey() -> Data {
        let service = "pw.bloomapp.auth"
        let account = "db_encryption_key"
        
        if let base64String = KeychainHelper.shared.read(service: service, account: account) {
            if let existingKey = Data(base64Encoded: base64String) {
                return existingKey
            }
        }
        
        var bytes = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        let newKey = Data(bytes)
        
        let base64String = newKey.base64EncodedString()
        KeychainHelper.shared.save(base64String, service: service, account: account)
        
        return newKey
    }

    private func setupSession(user: User) {
        self.currentUser = user
        self.startObservingUser { _ in }
        self.startSyncingChats()
    }

    func registerUser() async -> User? {
        let backgroundResult = await Task.detached(priority: .userInitiated) { [client] () -> RegisterBackgroundResult? in
            do {
                let result = try client.register()
                return RegisterBackgroundResult(
                    rawRecoveryKey: result.rawRecoveryKey,
                    userJSON: result.userJSON
                )
            } catch {
                return nil
            }
        }.value
        
        guard let result = backgroundResult else { return nil }
        
        do {
            if let rawRecoveryKey = result.rawRecoveryKey {
                KeychainHelper.shared.save(rawRecoveryKey, service: "pw.bloomapp.auth", account: "recoveryKey")
            }
            
            let decoder = JSONDecoder.bloomDecoder
            let user = try decoder.decode(User.self, from: result.userJSON ?? Data())
            
            self.setupSession(user: user)
            return user
        } catch {
            return nil
        }
    }

    func loginUser(recoveryKey: String? = nil) async -> User? {
        let service = "pw.bloomapp.auth"
        guard let keyToUse = recoveryKey ?? KeychainHelper.shared.read(service: service, account: "recoveryKey") else {
            return nil
        }
        
        let userJSONData = await Task.detached(priority: .userInitiated) { [client] () -> Data? in
            do {
                let restoreResult = try client.restoreSession()
                return restoreResult.userJSON
            } catch {
                do {
                    let hexKey: String
                    if keyToUse.contains(" ") {
                        let wordsArray = keyToUse.components(separatedBy: " ")
                            
                        do {
                            let mnemonic = try Mnemonic(mnemonic: wordsArray)
                                
                            let entropyBytes = mnemonic.entropy
                                
                            hexKey = entropyBytes.map { String(format: "%02x", $0) }.joined()
                        } catch {
                            print(error)
                            return nil
                        }
                    } else {
                        hexKey = keyToUse
                    }

                    let loginResult = try client.login(hexKey)
                    return loginResult.userJSON
                } catch {
                    return nil
                }
            }
        }.value
        
        guard let data = userJSONData else { return nil }
        
        do {
            let decoder = JSONDecoder.bloomDecoder
            let user = try decoder.decode(User.self, from: data)
            
            if recoveryKey != nil {
                KeychainHelper.shared.save(keyToUse, service: service, account: "recoveryKey")
            }
            
            self.setupSession(user: user)
            return user
        } catch {
            return nil
        }
    }
    
    func checkSession() -> Bool {
        let service = "pw.bloomapp.auth"
        return KeychainHelper.shared.read(service: service, account: "recoveryKey") != nil
    }
    
    func logout() {
        stopSyncingChats()
        stopObservingUser()
        client.clearCredentials()
        self.currentUser = nil
    }
    
    private func startSyncingChats() {
        self.chatsObserver.onUpdate = { [weak self] data in
            self?.parseAndSetChats(data)
        }
        if !isObservingChats {
            self.client.register(self.chatsObserver)
            self.client.startChatsSync()
            self.isObservingChats = true
        }
    }
        
    private func stopSyncingChats() {
        guard isObservingChats else { return }
        self.client.stopChatsSync()
        self.client.unregisterChatsListener()
        self.isObservingChats = false
    }
        
    private func parseAndSetChats(_ data: Data) {
        do {
            let decodedChats = try JSONDecoder.bloomDecoder.decode([ChatResponse].self, from: data)
            self.conversations = decodedChats.sorted {
                ($0.lastMessage?.id ?? 0) > ($1.lastMessage?.id ?? 0)
            }
        } catch {
            print(error)
        }
    }

    func getMe() -> User? {
        do {
            let result = try client.getMe()
            let decoder = JSONDecoder.bloomDecoder
            return try decoder.decode(User.self, from: result)
        } catch {
            return nil
        }
    }
    
    func getUser(id: String) -> User? {
        do {
            let result = try client.getUser(id)
            let decoder = JSONDecoder.bloomDecoder
            return try decoder.decode(User.self, from: result)
        } catch {
            return nil
        }
    }
    
    func getOrFetchMe() -> User? {
        do {
            let result = try client.getOrFetchMe()
            let decoder = JSONDecoder.bloomDecoder
            return try decoder.decode(User.self, from: result)
        } catch {
            return nil
        }
    }
    
    func editUser(
        username: String? = nil,
        displayName: String? = nil,
        description: String? = nil
    ) -> User? {
        do {
            let request = ClientEditRequest()
            
            if let username {
                request.username = username
                request.hasUsername = true
            }
            if let displayName {
                request.displayName = displayName
                request.hasDisplayName = true
            }
            if let description {
                request.description = description
                request.hasDescription = true
            }
            
            let result = try client.editUser(request)
            let decoder = JSONDecoder.bloomDecoder
            return try decoder.decode(User.self, from: result)
        } catch {
            return nil
        }
    }
    
    func searchUsers(query: String) -> [User] {
        do {
            let result = try client.searchUsers(query)
            let decoder = JSONDecoder.bloomDecoder
            return try decoder.decode([User].self, from: result)
        } catch {
            return []
        }
    }
    
    func startObservingUser(onUpdate: @escaping @MainActor (User) -> Void) {
        self.userObserver.onUpdate = { [weak self] updatedUser in
            self?.currentUser = updatedUser
            onUpdate(updatedUser)
        }
        if !isObservingUser {
            self.client.register(self.userObserver)
            self.isObservingUser = true
        }
    }
    
    func stopObservingUser() {
        guard isObservingUser else { return }
        self.client.unregisterUserListener()
        self.isObservingUser = false
    }
}
