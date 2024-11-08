@_cdecl("run_smc")
public func run_smc() -> Int32 {
    do {
        try SMCKit.open()
    } catch {   
        print(error)
        return 1
    }

    let key = SMCKit.getKey("CHLS", type: DataTypes.UInt16)

    let chls_bytes: SMCBytes = ( 
        // Writing 0x0150 should set the charge limit to 80%. Doesn't seem to
        // be working though.
        UInt8(1), UInt8(80),
        UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0),
        UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0),
        UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0),
        UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0),
        UInt8(0), UInt8(0)
    )

    // Write CHLS
    do {
        try SMCKit.writeData(key, data: chls_bytes)
    } catch {
        print(error)
        return 1
    }

    // Read CHLS
    do {
        let data = try SMCKit.readData(key)
        print("\(data.0) \(data.1)")
    } catch {
        print(error)
        return 1
    }

    return 0;
}
