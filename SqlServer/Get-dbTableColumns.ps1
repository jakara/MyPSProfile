
Function Get-dbTableColumns{ 
    <#  
    .SYNOPSIS 
        Gives you a list of all the tables column basic information of the specified Database.  
    .Description  
        Use an embed T-SQL Script use with SQL PowerShell module to query the database and list all tables column  
        information. This function can be use in PowerShell V1 and V2 but needs the SQL Server 2008 and SQLPS module  
        installed in order to run. It has the alias - 'gtc'. 
        This function will load the SQLPS module, and remove it when done. 
    .Parameter $dbname  
        SQLInstanceName - [String].  Enter the SQL Server or SQLServer\Instance name (optional) 
    .Parameter $Svrname 
        DatabaseName - [String].   Enter the Database Name. (required) 
    .Example  
        PS> Get-dbTableColumns -Database 'YourDatabaseName' 
         
        or using the alias: 
         
        PS> gtc -InstanceName 'InstanceName\ServerName' - Database 'YourDatabaseName' 
         
        Using the full function name with all paramaters. 
    .Notes  
        NAME: Get-dbTableColumns 
        Alias: gtc 
        AUTHOR: Max Trinidad      
        Created:  04/05/2011 17:10:01 - Version 0.1 - This is a basic function. 
        Compatibility - Version 2 
    .Link  
        about_functions  
        about_functions_advanced  
        about_functions_advanced_methods  
        about_functions_advanced_parameters  
    .Inputs 
        SQLInstanceName - [String] - Optional 
        DatabaseName - [String] - Required         
    .Outputs 
        Return [] - System Array Type Object 
#>  
Param( 
        [Parameter(Mandatory=$false, Position=0)] [string] $ServerInstance, 
        [Parameter(Mandatory=$true, Position=1)] [string] $Database, 
        [Parameter(Mandatory=$false, Position=2)] [string] $Username,
        [Parameter(Mandatory=$false, Position=3)] [string] $Password
) 
 
## - Stored T-SQL modified script into a string variable 
# Modified version T-SQL script from SQL MVP - Pinal Dave. 
$sqlQuery = @" 
select 
s.name+'.'+OBJECT_NAME(c.OBJECT_ID) as SchemaTableName 
,c.name AS ColumnName 
,SCHEMA_NAME(t.schema_id) AS SchemaName 
,t.name AS TypeName 
,c.max_length 
,c.is_computed 
,c.is_nullable 
FROM sys.columns AS c 
JOIN sys.types AS t ON c.user_type_id=t.user_type_id 
JOIN sys.tables as t2 on t2.object_id = c.object_id 
JOIN sys.schemas as s on s.schema_id = t2.schema_id 
ORDER BY c.OBJECT_ID, c.Column_Id; 
"@ 
 
    if ($SQLInstanceName.Length -eq 0){ $SQLInstanceName = '.' }; 
 
    Try{ 
        push-location
        #Import-Module SQLPS -DisableNameChecking 
        $Results1 = Invoke-SQLCmd -ServerInstance $ServerInstance -Database $Database -Query $sqlQuery -username $username -password $password
        return $Results1 | ft -auto #-GroupBy SchemaTableName 
        #Remove-Module SQLPS
        pop-location 
         
    } Catch { 
     
      Write-Host "Get-dbTableColumns $SQLInstanceName - $DatabaseName Failed: $_.exception.message" -Fore red -back black 
     
    } 
 
};

Set-Alias gtc Get-dbTableColumns;
echo "gtc -> Get-dbTableColumns"