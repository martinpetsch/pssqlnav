#throw "please uncomment this line before use"

$Server="localhost"
$SourceDB="Demo Database BC (19-0)" 
$SourceMandant="CRONUS AG"
$AppID="`$437dbf0e-84ff-417a-965d-ed2bb9650972"

#$TargetDB="Demo Database BC (19-0)" 
#$TargetMandant="CRONUS AG" 
$TargetDB="Demo Database BC (21-0)" 
$TargetMandant="KAIROS" 

$Tables = New-Object System.Collections.ArrayList
$Tables.Add("Item"+$AppID)

foreach ($TABLENAME in $Tables){
  $TABLENAME_CH=$TABLENAME;
  #if ($TABLENAME.Equals("Klient")) {$TABLENAME_CH="CH Klient"}
  
  $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
  $SqlConnection.ConnectionString = "Server=$Server;Database=$SourceDB;Integrated Security=True"
  $SqlCmd = New-Object System.Data.SqlClient.SqlCommand

  #Get all relevant columns
  $SqlQuery = 'SELECT [COLUMN_NAME] from INFORMATION_SCHEMA.COLUMNS where TABLE_CATALOG=''' +$SourceDB +
       ''' and TABLE_NAME = ''' + $SourceMandant+'$'+$TABLENAME+''' and COLUMN_NAME != ''timestamp'''    
  echo $SqlQuery   
  $SqlCmd.CommandText = $SqlQuery
  $SqlCmd.Connection = $SqlConnection
  $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
  $SqlAdapter.SelectCommand = $SqlCmd
  $DataSet = New-Object System.Data.DataSet
  $SqlAdapter.Fill($DataSet)

  $DataSet.Tables[0] |ogv
  echo $SqlQuery
  
  $Columns =""
  ForEach ($Column in $DataSet.Tables[0]) { $Columns += '['+$Column.COLUMN_NAME+']' }
  echo $Columns
  $Columns = $Columns.Replace('][','],[')
  echo $Columns

  $Columns_CH = $Columns
  #$Columns_CH = $Columns_CH.Replace('ID Nummer','CH-ID-Nummer')

  #Do the data moving
  $SqlConnection.Open()
  $SqlQuery = 'INSERT INTO [' + $TargetDB + '].[dbo].[' + $TargetMandant + '$' + $TABLENAME_CH + ']' +' ('+$Columns_CH+') '+' SELECT '+$Columns+' FROM [' +  $SourceDB + '].[dbo].[' + $SourceMandant + '$' + $TABLENAME + ']' 

  $SqlCmd.CommandText = $SqlQuery
  $SqlCmd.CommandTimeout=0 
  $SqlCmd.ExecuteNonQuery()

  $SqlConnection.Close()
}