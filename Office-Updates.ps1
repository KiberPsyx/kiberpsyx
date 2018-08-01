$ComputerName = "Localhost"
$Session = New-Object -ComObject Microsoft.Update.Session            
$Searcher = $Session.CreateUpdateSearcher()         
$HistoryCount = $Searcher.GetTotalHistoryCount()                     

$Upd = $Searcher.QueryHistory(0,$HistoryCount) | ForEach-Object -Process {            
 
    $Title = $null            
    if($_.Title -match "\(KB\d{6,7}\)"){            
         
    $Title = ($_.Title -split '.*\((KB\d{6,7})\)')[1]            
    }else{            
        $Title = $_.Title            
    }  
          
    $Result = $null            
    Switch ($_.ResultCode)            
    {            
        0 { $Result = 'NotStarted'}            
        1 { $Result = 'InProgress' }            
        2 { $Result = 'Succeeded' }            
        3 { $Result = 'SucceededWithErrors' }            
        4 { $Result = 'Failed' }            
        5 { $Result = 'Aborted' }            
        default { $Result = $_ }            
    }  
 
            
        New-Object -TypeName PSObject -Property @{         
        InstalledOn = Get-Date -Date $_.Date;            
        #KBArticle = $Title;            
        Name = $_.Title;            
        Status = $Result            
    }            
          
} |  Where-Object {$_.name -Match "Microsoft"} | Sort-Object -Descending:$true -Property InstalledOn

$Upd
$Upd.Count

Read-Host "Press Enter to start"
Read-Host "Finish"