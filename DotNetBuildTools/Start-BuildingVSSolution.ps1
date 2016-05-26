
function global:Start-BuildingVSSolution            
{            
    param            
    (
        [parameter(Mandatory=$true)]            
        [ValidateNotNullOrEmpty()]             
        [String] $SolutionFile,            
                    
        [parameter(Mandatory=$false)]            
        [ValidateNotNullOrEmpty()]             
        [String] $Configuration = "Debug",            
                    
        [parameter(Mandatory=$false)]            
        [ValidateNotNullOrEmpty()]             
        [Boolean] $AutoLaunchBuildLog = $true,            
            
        [parameter(Mandatory=$false)]            
        [ValidateNotNullOrEmpty()]             
        [Switch] $MsBuildHelp,            
                    
        [parameter(Mandatory=$false)]            
        [ValidateNotNullOrEmpty()]             
        [Switch] $CleanFirst,      
        
        [parameter(Mandatory=$false)]            
        [ValidateNotNullOrEmpty()]             
        [string] $MSBuildVersion="4.0",            
                    
        [parameter(Mandatory=$false)]      
        [ValidateNotNullOrEmpty()]             
        [string] $BuildLogFile="build.log",            
               
        [parameter(Mandatory=$false)]    
	    [ValidateNotNullOrEmpty()]                  
        [string] $BuildLogOutputPath = $env:userprofile        
    )            
                
    process            
    {          
        
        # Local Variables            
        #$MsBuild = $env:systemroot + "\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"; #causes bugs
        $MsBuild = "${Env:ProgramFiles(x86)}" + "\MSBuild\14.0\Bin\MSBuild.exe"    
        if($MSBuildVersion.Equals("2.0")){         
            $MsBuild = $env:systemroot + "\Microsoft.NET\Framework\v2.0.50727\MSBuild.exe";            
        }    
        if($MSBuildVersion.Equals("3.5")){
            $MsBuild = $env:systemroot + "\Microsoft.NET\Framework\v3.5\MSBuild.exe";            
        }    
     
                
        # Caller requested MsBuild Help?            
        if($MsBuildHelp)            
        {            
                $BuildArgs = @{            
                    FilePath = $MsBuild            
                    ArgumentList = "/help"            
                    Wait = $true            
                    RedirectStandardOutput = $env:userprofile + "\Documents\MsBuildHelp.txt"            
                }            
            
                # Get the help info and show            
                Start-Process @BuildArgs            
                Start-Process -verb Open $env:userprofile + "\Documents\MsBuildHelp.txt";            
        }            
        else            
        {            
            # Local Variables            
            $SlnFilePath = $SolutionFile;            
            $SlnFileParts = $SolutionFile.Split("\");            
            $SlnFileName = $SlnFileParts[$SlnFileParts.Length - 1];            
            $BuildLog = $BuildLogOutputPath + $BuildLogFile            
            $bOk = $true;            
                        
            try            
            {            
                # Clear first?            
                if($CleanFirst)            
                {            
                    # Display Progress            
                    Write-Progress -Id 20275 -Activity $SlnFileName  -Status "Cleaning..." -PercentComplete 10;            
                            
                    $BuildArgs = @{            
                        FilePath = $MsBuild            
                        ArgumentList = $SlnFilePath, "/t:clean", ("/p:Configuration=" + $Configuration), "/v:minimal"            
                        RedirectStandardOutput = $BuildLog            
                        Wait = $true            
                        WindowStyle = "Hidden"            
                    }            
            
                    # Start the build            
                    Start-Process @BuildArgs #| Out-String -stream -width 1024 > $DebugBuildLogFile             
                                
                    # Display Progress            
                    Write-Progress -Id 20275 -Activity $SlnFileName  -Status "Done cleaning." -PercentComplete 50;            
                }            
                
                # Display Progress            
                Write-Progress -Id 20275 -Activity $SlnFileName  -Status "Building..." -PercentComplete 60;  
                
                echo "building solution: $SlnFileName with $MsBuild"          
                            
                # Prepare the Args for the actual build            
                $BuildArgs = @{            
                    FilePath = $MsBuild            
                    ArgumentList = $SlnFilePath, "/t:rebuild", "/v:minimal", "/clp:ErrorsOnly"#, ("/p:Configuration=" + $Configuration), '/p:Platform="Mixed Platforms"'
                    RedirectStandardOutput = $BuildLog            
                    Wait = $true            
                    WindowStyle = "Hidden"            
                }            
            
                # Start the build            
                Start-Process @BuildArgs #| Out-String -stream -width 1024 > $DebugBuildLogFile             
                            
                # Display Progress            
                Write-Progress -Id 20275 -Activity $SlnFileName  -Status "Done building." -PercentComplete 100;            
            }            
            catch            
            {            
                $bOk = $false;            
                Write-Error ("Unexpect error occured while building " + $SlnFileParts[$SlnFileParts.Length - 1] + ": " + $_.Exception.Message);            
            }            
                        
            # All good so far?            
            if($bOk)            
            {            
                #Show projects which where built in the solution            
                #Select-String -Path $BuildLog -Pattern "Done building project" -SimpleMatch            
                            
                # Show if build succeeded or failed...          
                
                $successes = Select-String -Path $BuildLog -Pattern "Build succeeded." -SimpleMatch            
                $failures = Select-String -Path $BuildLog -Pattern ": error " -SimpleMatch            
                            
                if($failures -ne $null)            
                {            
                    Write-Warning ($SlnFileName + ": A build failure occured. Please check the build log $BuildLog for details.");
                    $bOk = $false            
                } 
                else 
                {                    
                    echo "Build succeeded!";   
                }           
                            
                # Show the build log...            
                if($AutoLaunchBuildLog)            
                {            
                    Start-Process -verb "Open" $BuildLog;            
                }            
            }
            
            return $bOk            
        }            
    }            
             
}

Set-Alias compile Start-BuildingVSSolution -Scope Global
echo "compile -> Start-BuildingVSSolution"