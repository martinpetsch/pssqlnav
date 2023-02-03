$Server="localhost"
$DB="Demo Database BC (19-0)"
$AppID="`$437dbf0e-84ff-417a-965d-ed2bb9650972"
$TableName="Change Log Entry$AppID";

$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server=$Server;Database=$DB;Integrated Security=True"
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand

#Get Nav Companies, then all changelogs!
$AllCompany="Company"
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server=$Server;Database=$DB;Integrated Security=True"
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand

$SqlQuery = 'SELECT * FROM ['+$DB+'].[dbo].['+$AllCompany+'] where Name <> '' '' ' 
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)

$DataSet.Tables[0].ForEach({
    $CompanyHelper = $_.Name.Replace('.','_')
	$SqlQuery = 'SELECT count(*) as ''RecordCount'' FROM ['+$DB+'].[dbo].['+ $CompanyHelper + '$' + $TableName + ']' 
    $SqlCmd.CommandText = $SqlQuery
    $SqlCmd.Connection = $SqlConnection    
    $SqlCmd.CommandTimeout=180 #seconds standard=30s, 0=forever
    $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
    $SqlAdapter.SelectCommand = $SqlCmd
    $DataSet1 = New-Object System.Data.DataSet    
    $SqlAdapter.Fill($DataSet1) |Out-Null       
    echo ($_.Name + ': ' + $DataSet1.Tables[0][0].RecordCount.ToString('N0'))
})



#Change Log per year:
$Mandant="Cronus AG"
$SqlQuery = 'SELECT Year([Date and Time]) as Jahr, count(*) as ''ChangeLogEntries''  FROM [' + $DB + '].[dbo].[' + $Mandant + '$' + $TABLENAME + '] group by Year([Date and Time]) ' 
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection
$SqlCmd.CommandTimeout=180 #seconds standard=30s, 0=forever
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)
$DataSet.Tables[0] | ogv


#Change Log per table:
$SqlQuery = 'SELECT [Table No_], count(*) as ''Tables''  FROM [' + $DB + '].[dbo].[' + $Mandant + '$' + $TABLENAME + '] where CAST([Date and Time] as Date) <= ''2050-12-31''AND CAST([Date and Time] as Date) >= ''2000-01-01'' group by [Table No_] ' 
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection
$SqlCmd.CommandTimeout=60 #seconds standard=30s, 0=forever
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)
$DataSet.Tables[0] | ogv

