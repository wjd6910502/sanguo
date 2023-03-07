#include "test.h"

namespace NS_TEST
{

int TestClass::static_var1 = 0;

TestClass* g_func1(int arg1)
{
	printf("g_func1, arg1=%d\n", arg1);

	return new TestClass();
}

TestClass g_func2(int arg1)
{
	printf("g_func2, arg1=%d\n", arg1);

	return TestClass();
}

}

