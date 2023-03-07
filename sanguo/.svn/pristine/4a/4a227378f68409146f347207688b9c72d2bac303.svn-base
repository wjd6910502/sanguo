<?php
  //echo "this is test\n";	
  #echo "<p>1</p>";

  $account = $_GET['account'];
  //echo $account;
  //$account="3we"; 
 
  $mysql_server_name="127.0.0.1";
  $mysql_username="root";
  $mysql_password="Sanguo6910502";
  $mysql_database="douban";   	
  $conn = mysql_connect($mysql_server_name,$mysql_username,$mysql_password);
  #echo $conn;
  
  mysql_query("set names 'utf-8'");
  mysql_select_db($mysql_database);
  
  $sql = "select * from t2 where account='$account'";
  $result = mysql_query($sql,$conn);
 	
  # 获取数据 
  #echo $reslut;
  
  
  $arr = array();
  while($row = mysql_fetch_array($result))
  {
    #echo "<div style=\"height:24px;line-height:24px;font-weight:bold;\">";
    #echo $row["id"] . " " . $row["roleid"] . " " . $row["loginid"] . "<br/>";
    
	
    $count=count($row);
    for($i=0;$i<$count;$i++)
    {
 	unset($row[$i]); #奇怪的数据结构  删除冗余数据
    }
    unset($row["account"]);  	
  
    #$js1 = json_encode($row);
	
    #foreach($row as $a)
    #{
    #  print $a;
    #}
    #print "\n";
    array_push($arr,$row);
  
    #print $js1;
    #print ",";
  }

	
  #打印数据
  print "{";
  print "\"account\"";
  print " : ";
  print "\""; print $account; print "\"";
  print ", ";
  print "\"roles\" :";
  print "[";
  $i=1;
  foreach($arr as $arr1)
  {
    if($i>=2)
    {
	printf(", ");
    }
    printf(" { ");
    printf(" \"zoneid\" : %d ,", $arr1["zoneid"]);
    #printf(" \"name\" : \"%s\" ,",$arr1["name"]);
    #printf("name = %s ", $arr1["name"]);
    #$zhongwen= iconv('gbk','UTF-8',$arr1["name"]);
    printf(" \"name\" : \"%s\" ,",$arr1["name"]);
    printf(" \"level\" : %d ,", $arr1["level"]);
    printf(" \"photo\" : %d ", $arr1["photo"]);
    printf(" } ");	
    $i = $i +1;
  }  
  print "]";
  print "}";
	
  # 插入数据
  
 
	
  #$js1 = json_encode($conn);
  #print "[";
  #print $js1;
  #print "]";	
  #echo "<p>2</p>";
?>

