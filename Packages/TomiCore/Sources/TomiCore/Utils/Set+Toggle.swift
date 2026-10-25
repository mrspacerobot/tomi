extension Set {
    /// Takes the element out when it is in, puts it in when it is not.
    mutating func toggle(_ element: Element) {
        if contains(element) {
            remove(element)
        } else {
            insert(element)
        }
    }
}
