# smc-interpose

This is an experimental repo for running SMC commands on macOS >= 15.0. Starting in macOS Seqouia, reading/writing to certain SMC values is guarded by the `com.apple.private.applesmc.user-access` entitlement. Since this is a private entitlement, only Apple can sign binaries with it - not even registered developers with an Apple Developer license.

When running SMC code without the entitlement, the error is `notPrivileged` with the following kernel log in Console.app:
```
SMCC::smcYPCEventCheck ERROR: not entitled for key CHLS
```

One method of getting around this for testing is through dyld interposing, working similarly to LD_PRELOAD in Linux. With this technique, we can hijack code in an Apple binary that is signed with the required entitlement and run our SMC code. One limitation of this is that SIP must be **turned off**.

For this demo, we will interpose on the `puts` function of `systemstats` for simplicity. When we run `systemstats -h`, it invokes `puts` which will call our version of `puts` instead where we can put SMC code.

To run different SMC code, edit `src/run.swift`.

## Build and run

Verify System Integrity Protection (SIP) is disabled
```
csrutil status
```

If SIP is enabled, boot into recovery mode and disable it:
```
csrutil disable
```

Install pre-requisites to build
```
xcode-select --install
brew install cmake ninja
```

Build the dylib
```
./build.sh
```

Interpose on systemstats
```
DYLD_INSERT_LIBRARIES=./build/libsmc.dylib systemstats -h
```
