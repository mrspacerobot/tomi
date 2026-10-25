extension ScanModel {
    static func preview() -> ScanModel {
        let flow = AppFlowModel.preview()
        return ScanModel(api: flow.services.api, profile: flow.profile)
    }
}
