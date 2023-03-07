#include <stdio.h>
#include <mysql.h>

//g++ mysql_connector.cpp `mysql_config --cflags --libs` -o test

int main(int argc, char *argv[])
{
	MYSQL conn;
	int res;
	mysql_init(&conn);
	if(mysql_real_connect(&conn,"localhost","root","","douban",0,NULL,CLIENT_FOUND_ROWS))
	{
		printf("connect success!\n");
		res = mysql_query(&conn,"insert into t1 values('wjd','2','www','46','56')");
		if(res)
		{
			printf("error\n");
		}
		else
		{
			printf("OK\n");
		}

		mysql_close(&conn);
	}
	else
	{
		printf("connect wrong!\n");
	}
	return 0;
}
