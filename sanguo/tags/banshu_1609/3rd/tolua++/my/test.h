#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>

namespace NS_TEST
{

struct TestObject
{
	int arg;
	std::string str;

	TestObject(): arg(0)
	{
		printf("TestObject::TestObject()\n");
	}
	~TestObject()
	{
		printf("TestObject::~TestObject()\n");
	}
};

class TestClass
{
public:
	int var1;

	static int static_var1;

public:
	TestClass(): var1(0) {}

	TestObject* func1(int arg1, TestObject *arg2)
	{
		printf("TestClass::func1, arg1=%d, arg2=%p, arg2->arg=%d\n", arg1, arg2, arg2->arg);

		var1 = arg1;
		return arg2;
	}

	static int static_func1(int arg1)
	{
		printf("TestClass::static_func1, arg1=%d\n", arg1);

		static_var1 = arg1;
		return arg1;
	}
};

TestClass* g_func1(int arg1);
TestClass g_func2(int arg1);

}

