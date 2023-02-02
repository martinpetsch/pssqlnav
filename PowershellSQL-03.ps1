#get data from sql-server as sa (=SQL user/pw)
$Server="localhost"
$DB="Demo Database NAV (9-0)" 
$cred=get-credential
$cred.Password.MakeReadOnly()
$sqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server=$Server;Database=$DB;"
$sqlConnection.Credential = [System.Data.SqlClient.SqlCredential]::new($cred.UserName, $cred.Password)
$sqlConnection.Open()
 
$SqlQuery = 'Select databaseversionno From [$ndo$dbproperty]'
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.Connection = $SqlConnection
$SqlCmd.CommandText = $SqlQuery
 
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
 
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)
$DataSet.Tables[0].Rows[0][0].ToString()  #first row, first column, value
$sqlConnection.Close()