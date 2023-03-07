#include<iostream>
#include<fstream>
#include<string>
#include<vector>
#include<sstream>
using namespace std;
typedef struct basedata
{
	int order;
	int tick;
	vector<int> op;
	int crc;
};

void trans(vector<string> src,vector<basedata>& dst)
{
	vector<int> nums;
	auto a=src.begin();
	for(;a!=src.end();++a)
	{
		int tmp=atoi(a->c_str());
		nums.push_back(tmp);
	}
	auto b=nums.begin();
	while(b!=nums.end())
	{
		basedata tmp2;
		tmp2.order=*b;

		++b;
		if(b==nums.end())
			break;
		tmp2.tick=*b;
		++b;
		if(b==nums.end())
			break;

		while(*b<=1000&&b!=nums.end())
		{
			tmp2.op.push_back(*b);
			++b;
		}
		if(b==nums.end())
			break;
		else
		{
			tmp2.crc=*b;
			dst.push_back(tmp2);
			++b;
		}
	}
}

void readfromfile(const char *name,vector<string>& dst)
{
	fstream f(name,ios::in);
	f>>noskipws;
	if(f==NULL)
	{
		cout<<"file cannot open"<<endl;
	}
	unsigned char ch;
	string num;
	vector<string> totrans;
	while(f>>ch)
	{
		if(ch=='{')
			break;
	}
	while(!f.eof())
	{
		f>>ch;
		while(ch!='=')
		{
			num.push_back(ch);
			f>>ch;
		}
		totrans.push_back(num);
		num.clear();
		while(ch!='{')
		{
			f>>ch;
		}
		while(!f.eof())
		{
			f>>ch;
			if(ch=='=')
			{
				f>>ch;
				while((ch!=';')&&(ch!=' ')&&(ch!=0)&&(ch!=32))
				{
					num.push_back(ch);
					f>>ch;
				}
				totrans.push_back(num);
				num.clear();
			}
			while(ch==' '||ch==0)
			{
				f>>ch;
				while((ch!=' ')&&(ch!=';')&&(ch!=0)&&(ch!=32))
				{
					num.push_back(ch);
					f>>ch;
				}
				totrans.push_back(num);
				num.clear();
			}
			if(ch=='}')
				break;
		}
		f>>ch;
		if(ch==';')
		{
			streampos pos =	f.tellg();
			f>>ch;
			if(ch=='}')
				break;
			else
				f.seekg(pos);
		}
	}
	dst=totrans;
	f.close();  
}

