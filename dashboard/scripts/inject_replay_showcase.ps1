param ([int]$RunID)

# ✅ Guard against invalid RunID
if ($RunID -le 0) {
    Write-Host "⚠️ Invalid Run ID: $RunID. Must be a positive integer." -ForegroundColor Yellow
    pause
    return
}

# 📁 Paths
$dashboardDir = "C:\Users\Varun Paruchuri\varun939-p\dashboard"
$viewerPath = "$dashboardDir\viewer.md"
$summaryPath = "$dashboardDir\summaries\summary_${RunID}.json"
$thumbPath = "$dashboardDir\thumbnails\run_${RunID}_thumb.png"
$heatmapPath = "$dashboardDir\heatmaps\run_${RunID}_heatmap.png"

# 🧼 Clear viewer.md before injecting
Set-Content -Path $viewerPath -Value ""

# 🏷️ Banner Block
$banner = @"
---

## 🧪 Chaos Replay: Run #$RunID  
📅 Timestamp: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")  
🏷️ Status: Live Replay

---
"@
Add-Content -Path $viewerPath -Value $banner

# 📊 Heatmap Embed
if (Test-Path $heatmapPath) {
    Add-Content -Path $viewerPath -Value "`n![Chaos Heatmap](./heatmaps/run_${RunID}_heatmap.png)`n"
} else {
    Add-Content -Path $viewerPath -Value "`n_Heatmap missing for Run #$RunID_`n"
}

# 🧠 Insight Panel
if (Test-Path $summaryPath) {
    try {
        $json = Get-Content $summaryPath -Raw | ConvertFrom-Json
        $impact = $json.impact
        $duration = $json.duration
        $status = $json.status

        $panel = @"
---

### 🧠 Replay Insights  
- Status: $status  
- Duration: $duration  
- Impact: $impact

---
"@
        Add-Content -Path $viewerPath -Value $panel
    }
    catch {
        Add-Content -Path $viewerPath -Value "`n_Insight panel failed to load for Run #$RunID_`n"
    }
} else {
    Add-Content -Path $viewerPath -Value "`n❌ Summary not found for Run #$RunID`n"
}

# 🖼️ Thumbnail Gallery
if (Test-Path $thumbPath) {
    Add-Content -Path $viewerPath -Value "`n### 📸 Run Thumbnail`n![Run Thumbnail](./thumbnails/run_${RunID}_thumb.png)`n"
} else {
    Add-Content -Path $viewerPath -Value "`n_Thumbnail missing for Run #$RunID_`n"
}

# ✅ Done
Write-Host "`n✅ Chaos Replay Showcase injected into viewer.md for Run #$RunID" -ForegroundColor Green
pause