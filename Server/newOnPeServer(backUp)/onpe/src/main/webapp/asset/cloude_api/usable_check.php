<?
@extract($_GET);
@extract($_POST);
	if(!isset($license)){
		return;
	}

/*
	$link = mysql_connect("localhost", "fbookclient", "fbookclient")
    or die(mysql_error());
	mysql_select_db("fbookclient") or die("db error");
*/

	//$link = mysql_connect("localhost", "fbookclient", "fbookclient") or die(mysql_error());
	$link = mysqli_connect("localhost", "fbookclient", "fbookclient", "fbookclient");
	mysqli_select_db($link, "fbookclient");

	$query = "select issue_date,last_date from license where license='$license'";
	$result = mysqli_query($link,$query);
	
	if($row = mysqli_fetch_array($result)){
		echo substr($row['issue_date'],0,10).",".substr($row['last_date'],0,10);
	}else{
		echo "not registed";		
	}

	//mysql_free_result($result);
	mysqli_close($link);		
?>