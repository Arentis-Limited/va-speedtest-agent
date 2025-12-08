# VA Speedtest Agent

The **VA Speedtest Agent** is a lightweight, self-contained module designed for remote gateways within the VA-Connect system.  
It provides:

- A local FastAPI web dashboard
- Cloudflare-based speed testing (download + upload)
- Background automated testing at configurable intervals
- JSON result logging
- Systemd-managed service for auto-start and reliability
- A universal Linux installer for Ubuntu-based gateways

This tool supports monitoring remote site bandwidth and diagnosing poor connectivity issues from the gateway side.

---

## 🚀 Quick Install (One-Line)

Run this on any VA-Connect Ubuntu gateway:

```bash
sudo bash -c "$(wget -qO- https://raw.githubusercontent.com/Arentis-Limited/va-speedtest-agent/main/bootstrap.sh)"
