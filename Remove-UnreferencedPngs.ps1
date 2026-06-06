# Remove-UnreferencedPngs.ps1
# Run from the root of your Obsidian vault.
# Deletes all .png files not referenced in any .md file.
# Use -WhatIf to do a dry run first (no files deleted).

[CmdletBinding(SupportsShouldProcess)]
param ()

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
if (-not $root) { $root = Get-Location }

Write-Host "`n=== Scanning vault at: $root ===`n" -ForegroundColor Cyan

# ── 1. Collect every .md file ───────────────────────────────────────────────
$mdFiles = Get-ChildItem -Path $root -Recurse -Filter '*.md' -File
Write-Host "Found $($mdFiles.Count) Markdown files."

# ── 2. Build a set of every PNG name referenced in any .md ──────────────────
# Patterns handled:
#   ![[image.png]]                 Obsidian wiki embed
#   ![[subfolder/image.png]]       Obsidian wiki embed with path
#   ![alt](path/to/image.png)      Standard Markdown image
#   [text](path/to/image.png)      Standard Markdown link to image
#   URL-encoded spaces (%20)

$referencedNames = [System.Collections.Generic.HashSet[string]]::new(
    [System.StringComparer]::OrdinalIgnoreCase
)

$wikiPattern    = [regex]'!\[\[([^\]]+\.png)\]\]'
$mdImagePattern = [regex]'\(([^)]+\.png)\)'

foreach ($md in $mdFiles) {
    $content = Get-Content $md.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }

    foreach ($m in $wikiPattern.Matches($content)) {
        $name = [System.IO.Path]::GetFileName($m.Groups[1].Value)
        $null = $referencedNames.Add($name)
    }

    foreach ($m in $mdImagePattern.Matches($content)) {
        $raw  = [Uri]::UnescapeDataString($m.Groups[1].Value)
        $name = [System.IO.Path]::GetFileName($raw)
        $null = $referencedNames.Add($name)
    }
}

Write-Host "Found $($referencedNames.Count) unique PNG references in Markdown files.`n"

# ── 3. Walk every .png and delete if unreferenced ───────────────────────────
$pngFiles = Get-ChildItem -Path $root -Recurse -Filter '*.png' -File
$deleted  = 0
$kept     = 0
$errors   = 0

foreach ($png in $pngFiles) {
    $rel = $png.FullName.Substring($root.ToString().Length).TrimStart('\','/')

    if ($referencedNames.Contains($png.Name)) {
        $kept++
        continue
    }

    if ($PSCmdlet.ShouldProcess($rel, 'Delete unreferenced PNG')) {
        try {
            Remove-Item $png.FullName -Force
            Write-Host "  Deleted: $rel" -ForegroundColor Red
            $deleted++
        } catch {
            Write-Host "  ERROR deleting $rel : $_" -ForegroundColor Magenta
            $errors++
        }
    } else {
        # -WhatIf path
        $deleted++
    }
}

# ── 4. Summary ───────────────────────────────────────────────────────────────
$dryRun = -not $PSCmdlet.ShouldProcess('summary', 'dummy')
Write-Host "`n=== Summary ===" -ForegroundColor Cyan
Write-Host "  Total PNGs found : $($pngFiles.Count)"
Write-Host "  Referenced (kept): $kept"
if ($WhatIfPreference) {
    Write-Host "  Would delete     : $deleted" -ForegroundColor Yellow
    Write-Host "`n  Dry run complete. Run without -WhatIf to actually delete." -ForegroundColor Yellow
} else {
    Write-Host "  Deleted          : $deleted" -ForegroundColor Red
}
if ($errors -gt 0) {
    Write-Host "  Errors           : $errors" -ForegroundColor Magenta
}
Write-Host ""
