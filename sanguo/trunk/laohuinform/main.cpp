#include <iostream>
#include <stdlib.h>

using namespace std;



int main()
{
	char *value = getenv("QUERY_STRING");
	



	cout<<"Content-type:text/html\r\n\r\n";
	cout<<"<html>\n";
	cout<<"<head>\n";
	cout<<"<title>tetstst</title>\n";
	cout<<"</head>\n";
	cout<<"<body>\n";
	
	cout<<"<table border =\"0\" cellspacing=\"2\">";
	cout<<"<tr><td>";
	if(value != 0)
		std::cout<<"QUERY_STRING ="<<value;
	else
		std::cout<<"QUERY_STRING not exist";

	cout<<"</td></tr>\n";
	cout<<"</table>\n";
	cout<<"</body>\n";
	cout<<"</html>\n";



}
