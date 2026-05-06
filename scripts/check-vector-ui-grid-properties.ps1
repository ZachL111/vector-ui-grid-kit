$ErrorActionPreference = "Stop"
$root = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $root

$profile = Get-Content -Raw metadata/property-map.json | ConvertFrom-Json
$w = $profile.weights
$thresholds = $profile.thresholds

function Get-Score($row) {
  return ([int]$row.signal * [int]$w.signal) + ([int]$row.slack * [int]$w.slack) + ([int]$row.confidence * [int]$w.confidence) - ([int]$row.drag * [int]$w.drag)
}

function Get-Lane($score) {
  if ($score -ge [int]$thresholds.ship) { return "ship" }
  if ($score -ge [int]$thresholds.watch) { return "watch" }
  return "hold"
}

$golden = Import-Csv fixtures/golden/scoreboard.csv
if ($golden.Count -lt 90) { throw "vector-ui-grid-kit expected at least 90 golden rows" }
$ids = @{}
foreach ($row in $golden) {
  if ($ids.ContainsKey($row.id)) { throw "vector-ui-grid-kit duplicate golden id $($row.id)" }
  $ids[$row.id] = $true
  $score = Get-Score $row
  if ($score -ne [int]$row.score) { throw "vector-ui-grid-kit score mismatch for $($row.id)" }
  $lane = Get-Lane $score
  if ($lane -ne $row.lane) { throw "vector-ui-grid-kit lane mismatch for $($row.id)" }
}

$mutations = Import-Csv fixtures/fuzz/mutations.csv
if ($mutations.Count -ne $golden.Count) { throw "vector-ui-grid-kit mutation count mismatch" }
foreach ($row in $mutations) {
  $score = Get-Score $row
  if ($score -ne [int]$row.score) { throw "vector-ui-grid-kit mutation score mismatch for $($row.id)" }
  $lane = Get-Lane $score
  if ($lane -ne $row.lane) { throw "vector-ui-grid-kit mutation lane mismatch for $($row.id)" }
}

Write-Host "vector-ui-grid-kit property checks passed"
