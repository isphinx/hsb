public class HueAdjustment: BasicOperation {
    public var hue:Float = 88.0 { didSet { uniformSettings["hue"] = hue } }
    
    public init() {
        super.init(fragmentFunctionName:"hueFragment", numberOfInputs:1)
        
        ({hue = 88.0})()
    }
}
