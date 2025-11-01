const std = @import("std");
const zap = @import("zap");

fn on_request(r: zap.Request) void {
    r.setStatus(.not_found);
    r.sendBody("<html><body><h1>404 - File not found</h1></body></html>") catch return;
}

pub fn main() !void {
    zap.mimetypeRegister("wasm", "application/wasm");
    var listener = zap.HttpListener.init(.{
        .port = 4000,
        .on_request = on_request,
        .public_folder = "docs",
        .log = false,
    });
    try listener.listen();

    std.debug.print("Listening on 0.0.0.0:4000\n", .{});

    // start worker threads
    zap.start(.{
        .threads = 4,
        .workers = 4,
    });
}
