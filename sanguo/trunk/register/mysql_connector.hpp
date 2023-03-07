#ifndef MYSQLCONNNECTOR_HPP_
#define MYSQLCONNNECTOR_HPP_

#include <iostream>
#include <string>
#include <mysql/mysql.h>

struct Roleinfo
{
	std::string account; //要求唯一
	std::string account2zoneid;
	std::string name; // name 与 zoneid 一致 不插入 最后数据库会饱满
	int level;
	int photo;
	int zoneid;
	Roleinfo()
	{
		account = "";
		name = "";
		account2zoneid = "";
		level = 0;
		photo = 0;
		zoneid =0;
	}
};




using namespace std;

class MysqlConnector
{
public:
	MysqlConnector();
	~MysqlConnector();
	bool initDB(string host,string user,string pwd, string db_name);
	bool exeSQL(string sql);
private:
	MYSQL *connection;
	MYSQL_RES * result;
	MYSQL_ROW row;
};


#endif

