param ([int]$RunID)

if ($RunID -le 0) {
    Write-Host "⚠️ Invalid Run ID: $RunID. Must be a positive integer." -ForegroundColor Yellow
    pause
    return
}

$dashboardDir = "C:\Users\Varun Paruchuri\varun939-p\dashboard"
$summaryPath = "$dashboardDir\summaries\summary_${RunID}.json"
$thumbPath = "$dashboardDir\thumbnails\run_${RunID}_thumb.png"
$viewerPath = "$dashboardDir\viewer.md"

if (-not (Test-Path $summaryPath)) {
    Write-Host "❌ Summary not found for Run #$RunID" -ForegroundColor Red
    pause
    return
}

try {
    $json = Get-Content $summaryPath -Raw | ConvertFrom-Json
}
catch {
    Write-Host "💥 Invalid JSON format in summary for Run #$RunID" -ForegroundColor Red
    pause
    return
}

$thumbStatus = if (Test-Path $thumbPath) { "✅" } else { "⚠️ Missing" }
$status = $json.status
$duration = $json.duration
$impact = $json.impact

Set-Content -Path $viewerPath -Value ""

$block = @"
---

## 🧪 Chaos Replay: Run #$RunID  
📄 [View Summary](./summaries/summary_${RunID}.json)  
📸 Thumbnail: $thumbStatus  
🎯 Status: $status  
⏱️ Duration: $duration  
🔥 Impact: $impact

---
"@
Add-Content -Path $viewerPath -Value $block

Write-Host "✅ Summary validated. Launching viewer for Run #$RunID..." -ForegroundColor Green
Start-Process "notepad.exe" $viewerPath