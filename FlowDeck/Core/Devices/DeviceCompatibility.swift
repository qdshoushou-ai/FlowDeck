import Foundation

/// 已实测设备组合的写入范围。后端复用不代表新型号或固件自动获得写权限。
/// 服务摘要是安装布局契约的一部分；未知脚本不得自动覆盖或放行。
enum DeviceCompatibility {
    static let u60Model = "MU5250"
    /// 已验证可复用同一套 WebSSH／原厂接口适配的 U60 Pro 固件（原厂 wa_inner_version 后缀）。
    /// B28 = BD_FLYMODEMMU5250V1.0.0B28；B31 = BD_CNMU5250V1.0.0B31（真机 uci zwrt_common_info 读取）。
    /// B31 与 B28 共用管理协议；写入仍逐个按设备回读确认，服务布局不符时按未确认失败处理。
    static let u60FirmwareSuffixes = ["B28", "B31"]
    static let f50Model = "MU300"
    static let f50Firmware = "F50_FLYMODEM_ZYV1.0.0B09"
    static let f50ServiceDigest = "e559d31d1578bcea782efd561959e8dd2aadffea05e5fcbf0d401bf36c2031d6"

    static func supportsU60Firmware(_ firmware: String?) -> Bool {
        guard let firmware, !firmware.isEmpty else { return false }
        return u60FirmwareSuffixes.contains { firmware.hasSuffix($0) }
    }

    static func supportsWebSSHWrite(_ snapshot: DeviceSnapshot) -> Bool {
        snapshot.model == u60Model && supportsU60Firmware(snapshot.firmware)
    }

    static func supportsUFIWrite(_ snapshot: DeviceSnapshot) -> Bool {
        snapshot.model == f50Model && snapshot.firmware == f50Firmware
    }
}
