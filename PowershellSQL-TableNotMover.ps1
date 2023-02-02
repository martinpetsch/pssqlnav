#throw "please uncomment this line before use"
$Server="localhost"
$SourceDB="Demo Database BC (19-0)" 
$SourceMandant="CRONUS AG"
$AppID="`$437dbf0e-84ff-417a-965d-ed2bb9650972"

$TargetDB="Demo Database BC (19-0)" 
$TargetMandant="KAIROS" 

$Tables = New-Object System.Collections.ArrayList
$Tables.Add("Item"+$AppID)

foreach ($TABLENAME in $Tables){
  $TABLENAME_CH=$TABLENAME;
  
  $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
  $SqlConnection.ConnectionString = "Server=$Server;Database=$SourceDB;Integrated Security=True"
  $SqlCmd = New-Object System.Data.SqlClient.SqlCommand

  #No data moving due to Nav-"timestamp" Column
  $SqlConnection.Open()
  $SqlQuery = 'INSERT INTO [' + $TargetDB + '].[dbo].[' + $TargetMandant + '$' + $TABLENAME_CH + ']  SELECT * FROM [' +  $SourceDB + '].[dbo].[' + $SourceMandant + '$' + $TABLENAME + ']' 
  $SqlCmd.Connection = $SqlConnection
  $SqlCmd.CommandText = $SqlQuery
  $SqlCmd.CommandTimeout=0 
  $SqlCmd.ExecuteNonQuery()
  $SqlConnection.Close()
}