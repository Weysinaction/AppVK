// GetGroupsResponse.swift
// Copyright © RoadMap. All rights reserved.

import Alamofire
import Foundation

/// GetGroupsResponse-
class GetGroupsResponse: AsyncOperation {
    // MARK: private properties

    private var request: DataRequest = AF
        .request(
            "https://api.vk.com/method/groups.get?v=5.131&user_id=\(UserInfo.userInfo.userID)&extended=1&access_token=\(UserInfo.userInfo.token)&fields=activity"
        )

    // MARK: public properties

    var data: Data?

    // MARK: GetGroupsResponse

    override func main() {
        print("operationRequestStarted")
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            self?.data = response.data
            self?.state = .finished
        }
    }

    override func cancel() {
        super.cancel()
        request.cancel()
    }
}
