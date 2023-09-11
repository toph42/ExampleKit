import Swift

//public type will be visible from AppModule, but cannot
//be initialized because the implicit init is internal
public struct BareExample {}

//public init makes this one usable
public struct InitableExample {
    public init() {}
}

//internal (the default protection level) type will not be visible from AppModule
struct InternalExample {}

//private types are obviously not visible to AppModule
private struct PrivateExample {}
