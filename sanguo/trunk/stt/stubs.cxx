#ifdef WIN32
#include <winsock2.h>
#include "gncompress.h"
#else
//#include "binder.h"
#endif
#include "gettextinspeech.hrp"
#include "sttzoneregister.hpp"
#include "getiatextinspeechre.hpp"

namespace GNET
{

static GetTextInSpeech __stub_GetTextInSpeech (RPC_GETTEXTINSPEECH, new GetTextInSpeechArg, new GetTextInSpeechRes);
static STTZoneRegister __stub_STTZoneRegister((void*)0);
static GetIATextInSpeechRe __stub_GetIATextInSpeechRe((void*)0);
void make_compile_unit_stubs_o_md5sum_no_change_no_use_but_do_not_delete_it___for_stt() {} //非常山寨的解决重新编译md5sum保持不变的问题
};

