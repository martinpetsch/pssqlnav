$Server="localhost"
$DB="Demo Database BC (19-0)" 
$AppID="`$437dbf0e-84ff-417a-965d-ed2bb9650972"
$SqlQuery = 'SELECT Top(10) * FROM [CRONUS AG$Item'+$AppID+'] where Description like ''%rad%'' '  #to escape ' just double it ''

$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server=$Server;Database=$DB;Integrated Security=True"
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)
$SqlConnection.Close()
 
$DataSet.Tables[0] | ogv

$DataSet.Tables[0] | foreach {$_.Description}

$mydata=$DataSet.Tables[0]
$mydata |Get-Member |ogv
