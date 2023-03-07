
#include <cstdio>
#include <cstring>
#include <vector>

#include "lcs.h"

using namespace std;

template <typename T>
vector<T> run_lcs(vector<T>& o, vector<T>& n) 
{
	vector<T> LCS(n.size());
	typename vector<T>::iterator end = lcs(o.begin(), o.end(), n.begin(), n.end(), LCS.begin());
	LCS.resize(end-LCS.begin());
	return LCS;
}

inline void MyDiff(vector<string>& src, vector<string>& dest, vector<pair<int,int> >& deletions, vector<pair<int,vector<string> > >& insertions)
{
	vector<string> common = run_lcs(src, dest);

	int len = 0;
	vector<string>::iterator it_src = src.begin();
	vector<string>::iterator it_common = common.begin();
	while(it_src!=src.end() && it_common!=common.end())
	{
		if(*it_src == *it_common) //TODO: ==有优化空间
		{
			if(len > 0)
			{
				deletions.push_back(make_pair(it_src-src.begin()-len,len));
				len = 0;
			}
			++it_src;
			++it_common;
		}
		else
		{
			len++;
			++it_src;
		}
	}
	if(it_src != src.end()) deletions.push_back(make_pair(it_src-src.begin(),src.size()-(it_src-src.begin())));

	len = 0;
	it_common = common.begin();
	vector<string>::iterator it_dest = dest.begin();
	while(it_common!=common.end() && it_dest!=dest.end())
	{
		if(*it_common == *it_dest)
		{
			if(len > 0)
			{
				vector<string> add;
				add.insert(add.end(), it_dest-len, it_dest);
				insertions.push_back(make_pair(it_common-common.begin(),add)); //for INSERT: ^it
				len = 0;
			}
			++it_common;
			++it_dest;
		}
		else
		{
			len++;
			++it_dest;
		}
	}
	if(it_dest != dest.end())
	{
		vector<string> add;
		add.insert(add.end(), it_dest, dest.end());
		insertions.push_back(make_pair(common.size(),add));
	}
}

inline bool MyPatch(vector<string>& src, const vector<pair<int,int> >& deletions, const vector<pair<int,vector<string> > >& insertions)
{
	//src=>common
	for(vector<pair<int,int> >::const_reverse_iterator it=deletions.rbegin(); it!=deletions.rend(); ++it)
	{
		int index = it->first;
		int len = it->second;
		if(index<0 || index>=(int)src.size() || index+len>(int)src.size()) return false;
		src.erase(src.begin()+index, src.begin()+index+len);
	}
	//common=>dest
	for(vector<pair<int,vector<string> > >::const_reverse_iterator it=insertions.rbegin(); it!=insertions.rend(); ++it)
	{
		int index = it->first;
		if(index<0 || index>(int)src.size()+1) return false;
		vector<string> add = it->second;
		if(index == (int)src.size()+1)
		{
			src.insert(src.end(), add.begin(), add.end());
		}
		else
		{
			src.insert(src.begin()+index, add.begin(), add.end());
		}
	}
	return true;
}

