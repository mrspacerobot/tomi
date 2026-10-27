extension ProgressSnapshot {
    /// The bar under the progress columns.
    public var rankBar: RankBar {
        RankBar(xp: xp, rank: rank)
    }
}
