To adjust your system's time based on the output from the `w32tm /stripchart` command, you can parse the offset value and apply it to your system clock using PowerShell. Here's how you can do it:

---

### 🛠️ Step-by-Step Guide

1. **Run the `w32tm /stripchart` Command:**

   Execute the following command in PowerShell to get the time offset between your system and the NTP server:

   ```powershell
   $output = w32tm /stripchart /computer:time.windows.com /samples:1 /dataonly
   ```



2. **Parse the Offset Value:**

   Extract the offset value from the command output:

   ```powershell
   $offsetLine = $output | Select-String -Pattern "^\d{2}:\d{2}:\d{2},\s+[+-]\d+\.\d+" | Select-Object -Last 1
   $offsetValue = ($offsetLine -split ",\s*")[1] -replace "s", ""
   $offsetSeconds = [double]$offsetValue
   ```



3. **Adjust the System Time:**

   Calculate the new time by adding the offset to the current system time and set it:

   ```powershell
   $newTime = (Get-Date).AddSeconds($offsetSeconds)
   Set-Date -Date $newTime
   ```



*Note: You need to run PowerShell as an administrator to change the system time.*

---

### 🔍 Example

If the `w32tm /stripchart` output is:

```

Tracking time.windows.com [20.101.57.9:123].
Collecting 1 samples.
The current time is 28.05.2025 11:21:53.
11:21:53, +137.0856223s
```



The offset is `+137.0856223` seconds. Adding this to the current time (`11:21:53`) results in approximately `11:24:10`.

---

### ⚠️ Important Considerations

* **Permissions:** Ensure you run PowerShell with administrative privileges to modify the system time.

* **Time Drift:** Manually setting the time is a one-time correction. For ongoing accuracy, configure your system to synchronize with a reliable NTP server.

* **NTP Synchronization:** If automatic synchronization isn't working, verify that UDP port 123 is open and not blocked by a firewall.

---

If you need assistance with configuring NTP synchronization or have further questions, feel free to ask!


Give me git repo name and sort description -- for this tutorial resolvinw gtis issue i have 
