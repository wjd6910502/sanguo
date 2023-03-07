#include <iostream>
#include <math.h>
#include <string.h>
#include <stdio.h>
#include <sstream>
#include <time.h>
#include "include/leveldb/db.h"
#include "include/leveldb/write_batch.h"
using namespace std;

int main()
{
	leveldb::DB* db;  
	leveldb::Options options;  
	options.create_if_missing = true;  
	std::string dbpath = "testdb";  
	leveldb::Status status = leveldb::DB::Open(options, dbpath, &db);  
	assert(status.ok());  
	cout<<"Open db OK"<<std::endl;  

	std::string value;  
	leveldb::Status s ;  
	
//	leveldb::WriteBatch batch;
//	for(int key = 1; key < 10000000; key++)
//	{
//		stringstream s_key,s_value;
//		s_key << key;
//		s_value << key;
//
//		string tmp_key,tmp_value;
//		s_key >> tmp_key;
//		s_value >> tmp_value;
//
//		tmp_key = "rolename_" + tmp_key;
//		tmp_value = "rolename_rolename_rolename_rolename_rolename_rolename_rolename_rolename_rolename_rolename_" + tmp_value;
//		batch.Put(tmp_key, tmp_value);
//	}      
//	leveldb::WriteOptions write_options;
//	write_options.sync = true;
//	time_t begin = time(NULL);
//	s = db->Write(write_options, &batch);
//
//	time_t end = time(NULL);
//
//	cout << "save time is " << end-begin <<endl;
//	
//	leveldb::WriteBatch batch2;
//	for(int key = 1; key < 10000000; key++)
//	{
//		stringstream s_key,s_value;
//		s_key << key;
//		s_value << key;
//
//		string tmp_key,tmp_value;
//		s_key >> tmp_key;
//		s_value >> tmp_value;
//
//		tmp_key = "rolename__" + tmp_key;
//		tmp_value = "rolename__rolename_rolename_rolename_rolename_rolename_rolename_rolename_rolename_rolename_" + tmp_value;
//		batch2.Put(tmp_key, tmp_value);
//	}      
//	leveldb::WriteOptions write_options2;
//	write_options2.sync = false;
//	begin = time(NULL);
//	s = db->Write(write_options2, &batch2);
//
//	end = time(NULL);
//
//	cout << "time is " << end-begin <<endl;
	

//	int length;
//	cout << "输入步长" << endl;
//	cin >> length;
//	while(length >= 0)
//	{
//		leveldb::Iterator *it = db->NewIterator(leveldb::ReadOptions());
//		it->SeekToFirst();
//		for(int i = 0; i < length; i++)
//		{
//			if(it->Valid())
//				it->Next();
//		}
//		for(; it->Valid();it->Next())
//		{
//			std::string find_key, find_value;
//			find_key = it->key().ToString();
//			find_value = it->value().ToString();
//
//			std::string find_string = "role_";
//			if(strncmp(find_key.c_str(), find_string.c_str(), 5) == 0)
//			{
//				cout << find_key << " : " << find_value << endl;
//			}
//		}       
//		assert(it->status().ok());
//		delete it;
//		std::string key1,key2;
//		key1 = "role_0";
//		key2 = "role_0";
//		db->Put(leveldb::WriteOptions(), key1, key2);
//		cout << "输入步长" << endl;
//		cin >> length;
//	}


//	int num = 0;
//	leveldb::Iterator *it = db->NewIterator(leveldb::ReadOptions());
//	it->SeekToFirst();
//	for(; it->Valid();it->Next())
//	{
//		num ++;
//	}       
//	cout << num << endl;
//	assert(it->status().ok());
//	delete it;
	delete db;/*删除数据库*/  

	return 0;  
}
