import Foundation
import StunClient

public final class CliSample {
    private let arguments: [String]
    private var client: StunClient!
    private let semaphore = DispatchSemaphore(value: 0)
    
    public init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }

    public func run() {
        client = StunClient(stunIpAddress: "64.233.163.127", stunPort: 19302, localPort: UInt16(14135))
        let successCallback: (String, Int) -> () = { [weak self] (myAddress: String, myPort: Int) in
                guard let self = self else { return }
                
                print("COMPLETED, my address: \(myAddress) my port: \(myPort)")
                self.semaphore.signal()
        }
        let errorCallback: (StunError) -> () = { [weak self] error in
                    guard let self = self else { return }
                    
                    print("ERROR: \(error.localizedDescription)")
                    self.semaphore.signal()
            }
        let verboseCallback: (String) -> () = { [weak self] logText in
                    guard let _ = self else { return }
                    
                    print("LOG: \(logText)")
            }
        
        client
            .whoAmI()
            .ifWhoAmISuccessful(successCallback)
            .ifError(errorCallback)
            .verbose(verboseCallback)
            .start()
        
        _ = semaphore.wait(timeout: .distantFuture)
    }
}