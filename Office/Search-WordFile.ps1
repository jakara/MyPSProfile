
Function Search-WordFile
{  
    Param( 
            [Parameter(Mandatory=$true, Position=0)] [string[]] $Files, 
            [Parameter(Mandatory=$true, Position=1)] [string] $FindText, 
            [switch] $MatchCase,
            [switch] $MatchWholeWord,
            [switch] $MatchWildCards,
            [switch] $MatchSoundsLike,
            [switch] $MatchAllWordForms,
            [switch] $Forward,
            [switch] $Wrap
            
    ) 

    $application = New-Object -comobject word.application
    $application.visible = $False
    #$docs = Get-childitem -path $Path -Recurse -Include HSG*.docx,WES*.docx |
    # where {$_.LastWriteTime -gt [datetime]"7/1/11" -AND $_.lastwritetime -le [datetime]"6/30/12"}
    #$docs = ls -Path $Path
    #$FindText = "微信"
    $i = 1
    #$totalwords = 0
    #$totaldocs = 0

    $res = @()
    Foreach ($file in $Files)
    {
        Write-Progress -Activity "Processing files" -status "Processing $($file)" -PercentComplete ($i /$Files.Count * 100) 
        #echo "processing $($doc.FullName)"
        if($file.endswith(".docx") -and (Test-Path -Path $file)){            
            $document = $application.documents.open($file)
            $range = $document.content
            $null = $range.movestart()
            $wordFound = $range.find.execute($FindText,$MatchCase,
                                                $MatchWholeWord,$MatchWildCards,$MatchSoundsLike,
                                                $MatchAllWordForms,$Forward,$Wrap)
            if($wordFound) 
            {
                $res += $file
                #echo "found in  $($doc.FullName)"
                #$doc.fullname
                #$document.Words.count
                #$totaldocs ++
                #$totalwords += $document.Words.count
            } #end if $wordFound
            $document.close()
            [System.Runtime.InteropServices.Marshal]::ReleaseComObject($range) | Out-Null
            [System.Runtime.InteropServices.Marshal]::ReleaseComObject($document) | Out-Null
            $i++
        }
    } #end foreach $doc
    $application.quit()
    

    #clean up stuff
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($application) | Out-Null
    Remove-Variable -Name application
    [gc]::collect()
    [gc]::WaitForPendingFinalizers()

    return $res
};

Set-Alias searchword Search-WordFile
echo "searchword -> Search-WordFile"

#test case
# searchword -Files (ls | %{$_.FullName}) -FindText "微信"