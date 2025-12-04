# PowerShell script to update navigation in all HTML files

$htmlFiles = Get-ChildItem -Path "C:\Users\maitr\Downloads\doms" -Filter "*.html"

# CSS for dropdown menu
$dropdownCSS = @"
        /* Dropdown styles */
        .dropdown {
            position: relative;
        }
        
        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #0d0d50;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
            border-radius: 4px;
            top: 100%;
            left: 0;
        }
        
        .dropdown-content a {
            color: white;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            text-align: left;
        }
        
        .dropdown-content a:hover {
            background-color: #1b2f6e;
        }
        
        .dropdown:hover .dropdown-content {
            display: block;
        }
"@

# Fix for hover style
$hoverFix = @"
        .nav-links a:hover, .nav-links a.active {
            color: var(--secondary);
        }
"@

# HTML for dropdown menu
$dropdownHTML = @"
                <li class="dropdown">
                    <a href="index" class="active">Home</a>
                    <div class="dropdown-content">
                        <a href="about">About</a>
                    </div>
                </li>
"@

foreach ($file in $htmlFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    
    # Fix hover style
    $content = $content -replace '\.nav-links a:hover, \.nav-links\s+\{\s+color: var\(--secondary\);\s+\}', $hoverFix
    
    # Add dropdown CSS if not already present
    if ($content -notmatch '\.dropdown \{') {
        $content = $content -replace '(\.nav-links a:hover.*?\})\s+(\.mobile-toggle)', "$1`n`n$dropdownCSS`n`n$2"
    }
    
    # Update navigation links
    $content = $content -replace '<li><a href="index".*?</a></li>\s+<li><a href="about">About</a></li>', $dropdownHTML
    
    # Save the updated content
    Set-Content -Path $file.FullName -Value $content
}

Write-Host "Navigation updated in all HTML files."