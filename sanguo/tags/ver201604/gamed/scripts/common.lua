
G_ERRCODE = {}
G_ERRCODE["SUCCESS"] = 0
G_ERRCODE["NO_ROLE"] = 1
G_ERRCODE["CREATING_ROLE"] = 2
G_ERRCODE["INVALID_NAME"] = 3
G_ERRCODE["USED_NAME"] = 4
G_ERRCODE["SYSTEM_INVALID"] = 5
G_ERRCODE["YUANBAO_LESS"] = 6   --Ԫ������
G_ERRCODE["NO_MAFIA"] = 101
G_ERRCODE["CREATING_MAFIA"] = 102

G_ERRCODE["TASK_ID_CURRENT"]  = 201 --��ǰ�������в��������ID
G_ERRCODE["TASK_NOT_FINISH"]  = 202 --�������û�����
G_ERRCODE["TASK_NOT_EXIST"]   = 203 --��ǰ��ģ���в������������
G_ERRCODE["TASK_NOT_LEVEL"]   = 204 --��ǰ�ȼ�����Ӧ�����������
G_ERRCODE["TASK_NOT_TIME"]    = 205 --��ǰ�����ڹ涨��ʱ�䷶Χ֮��

G_ERRCODE["NO_TONGGUAN"] = 301 --����3�ǣ��޷�ɨ��
G_ERRCODE["NO_ENOUGHVP"] = 302 --�������㣬�޷�ɨ��
G_ERRCODE["NO_COUNT"]	 = 303 --������������
G_ERRCODE["NO_SWEEPITEM"]= 304 --ɨ����㣬�޷�ɨ��
G_ERRCODE["NO_TONGGUAN"] = 305 --��û��ͨ�ظ������޷�ɨ��
G_ERRCODE["NO_STAGE"] 	 = 306 --û������ؿ�
G_ERRCODE["NO_REQSTAGE"] = 307 --û�д��ǰ�ùؿ�
G_ERRCODE["NO_REQSTAR"]  = 308 --ǰ�ùؿ����Ǽ�û�дﵽҪ��
G_ERRCODE["NO_LEVEL"]	 = 309 --��ҵĵȼ�û�дﵽҪ��
G_ERRCODE["NO_FAIL"]	 = 310 --���û�д���������
G_ERRCODE["NO_STAR"]	 = 311 --ͨ���ˣ�����û������
G_ERRCODE["NO_HERO"]	 = 312 --�������������������佫��Ϣ�д������û������佫
G_ERRCODE["NO_REQ_HERO"] = 313 --������������������ǿ�Ƴ�ս���佫��Ϣ�д���
G_ERRCODE["HERO_COUNT_ERR"] = 314 --�佫���������󣬴�����3����
G_ERRCODE["REQ_HERO_ERR"] = 315 --ǿ�Ƴ�ս���佫ID��Ϣ����
G_ERRCODE["INSTANCE_NO_COUNT"] = 316 --������������ﵽ����

G_ERRCODE["NO_COMLIMIT"] = 351 --û�������������޴�ģ��
G_ERRCODE["VP_NO_COUNT"] = 352 --��������Ѿ��ﵽ����
G_ERRCODE["VP_SYSTEM_ERROR"] = 353 --ϵͳ�������˴���
G_ERRCODE["VP_LESS_YUANBAO"] = 354 --��ҵ�Ԫ������

G_ERRCODE["BUY_INSTANCE_COUNT_HAVE"] = 361 --���д�������������
G_ERRCODE["CAN_NOT_BUY_INSTANCE_COUNT"] = 362 --�����Թ������
G_ERRCODE["INSTANCE_SYSTEM_COUNT"] = 363 --��������������ô���


G_ERRCODE["HERO_ID_ERROR"] = 371 --�佫��ID����
G_ERRCODE["HAVED_HERO"] = 372 --�Ѿ�������佫�ˣ��޷�����
G_ERRCODE["HERO_CAN_NOT_BUY"] = 373 --����佫�޷�ͨ��������
G_ERRCODE["HERO_BUY_MONEY_LESS"] = 374 --ͭ�Ҳ���
G_ERRCODE["HERO_BUY_TYPE_ERROR"] = 375 --Ӣ�۹�������ʹ���
G_ERRCODE["HERO_BUY_SOUL_LESS"] = 376 --��겻��

G_ERRCODE["NO_ITEM"] = 381 --��Ʒ��ID������
G_ERRCODE["NO_ITEM_TYPE"] = 382 --��Ʒ��TYPE����û�н�����д.�޷�ʹ��
G_ERRCODE["HERO_EXP_FULL"] = 384 --���û������佫
G_ERRCODE["TEM_NO_HERO"] = 385 --���û������佫
G_ERRCODE["ITEM_COUNT_LESS"] = 386 --��Ʒ��������
G_ERRCODE["NOT_EXP_ITEM"] = 387 --��Ʒ��������

G_ERRCODE["MAX_HERO_ORDER"] = 390 --Ӣ�۴ﵽ��ߵĽ��
G_ERRCODE["NOT_MAX_LEVEL_ORDER"] = 391 --Ӣ��δ�ﵽ��ǰ������ߵȼ�

G_ERRCODE["PVP_HERO_COUNT_ERR"] = 401 --�����佫����������

G_ERRCODE["PVP_STATE_ERROR"] = 411 --PVP����״̬�����쳣�������½���ƥ��
G_ERRCODE["PVP_INVITE_STATE_ERROR"] = 412 --PVP����״̬�����쳣�������½�������

G_ERRCODE["HERO_NO_SKILLID"] = 421 --�佫û���������
G_ERRCODE["HERO_SKILLLV_WRONG"] = 422 --�佫��������ܵȼ�����
G_ERRCODE["HERO_SKILLLV_MONEY_LESS"] = 423 --�佫�������ܽ�Ǯ����
G_ERRCODE["HERO_SKILLLV_MAX"] = 424 --�佫�ļ��ܵȼ������Գ����佫�ȼ�
G_ERRCODE["HERO_SKILL_POINT_LESS"] = 425 --�佫�ļ��ܵ�������
G_ERRCODE["HERO_SKILL_POINT_ZERO"] = 426 --ֻ���佫�ļ��ܵ���Ϊ0��ʱ��ſ��Թ���
G_ERRCODE["HERO_SKILL_NOT_LEVELUP"] = 427 --���ܲ���������

G_ERRCODE["HERO_COMMENTS_SELF"] = 431--�����Ը��Լ����佫���۵���
G_ERRCODE["HERO_COMMENTS_DID"] = 432--�Ѿ���������۵������
G_ERRCODE["HERO_COMMENTS_NOT_HAVE"] = 433--û��������ۣ��޷����е��޲���
G_ERRCODE["HERO_COMMENTS_NOT_WRITE"] = 434--û�и�����佫д�����ۣ��������д
G_ERRCODE["HERO_COMMENTS_CAN_NOT_WRITE"] = 435--����佫����������
G_ERRCODE["HERO_COMMENTS_MAX"] = 436--���������佫���۴ﵽ����

G_ERRCODE["PVP_VIDEO_NOT_EXIST"] = 441--���ս���طŲ�����
G_ERRCODE["PVP_VIDEO_NOT_EXIST_SELF"] = 442--���Լ����ϲ��������¼��

G_ERRCODE["CHAT_TOO_LONG"] = 451--���쳤��̫���������±༭�������١�
G_ERRCODE["CHAT_TO_SELF"] = 452--�����Ը��Լ�˽��
G_ERRCODE["CHAT_NOT_ONLINE"] = 453--��Ҳ�����

G_ERRCODE["BLACKLIST_HAVE"] = 461--�������Ѿ��ں���������

G_ERRCODE["MAIL_NOT_EXIST"] = 471--����ʼ�������
G_ERRCODE["MAIL_NO_ATTACHMENT"] = 472--����ʼ�û�и���

G_ERRCODE["SELECT_SKILL_NO_HERO"] = 481--���û������佫
G_ERRCODE["SELECT_SKILL_NUM_ERROR"] = 482--�佫�ļ�����������
G_ERRCODE["SELECT_SKILL_ID_ERROR"] = 483--�佫�ļ��ܲ�����
G_ERRCODE["SELECT_SKILL_LEVEL_LESS"] = 484--�佫�������˫���ܻ�û�дﵽ�����ĵȼ�

G_ERRCODE["MALLITEM_ID_ERR"] = 501--������̵���Ʒ������
G_ERRCODE["MALLITEM_NUM_ERR"] = 502--�������Ʒ������0
G_ERRCODE["MALLITEM_MAX_ERR"] = 503--�������Ʒ��������������
G_ERRCODE["MALLITEM_MONEY_LESS"] = 504--������Ʒ����Ľ�Ҳ���
G_ERRCODE["MALLITEM_YUANBAO_LESS"] = 505--������Ʒ����Ĺ�����
G_ERRCODE["MALLITEM_TEM_ERR"] = 506--������Ʒ��ģ�����
G_ERRCODE["MALLITEM_TEM_MONEY_ERR"] = 507--��Ʒ�Ĺ���۸���ִ�������Ϊ0����<0
G_ERRCODE["MALLITEM_REP_LESS"] = 508--������Ʒ�������������

G_ERRCODE["INSTANCE_NO_REQUEST"] = 521--����û��ǿ���佫
G_ERRCODE["INSTANCE_NO_HERO"] = 522--���������ó�ս����

G_ERRCODE["HERO_STAR_MAX"] = 531--�佫�Ѿ��ﵽ����ߵ��Ǽ�
G_ERRCODE["HERO_STAR_ERR"] = 532--�佫���Ǽ�����
G_ERRCODE["HERO_STAR_SOUL_LESS"] = 533--�佫��������

G_ERRCODE["PRIVATE_SHOP_ERR"] = 541--����̵겻����
G_ERRCODE["PRIVATE_SHOP_CANOT_REFRESH"] = 542--����̵겻�����ֶ�ˢ��
G_ERRCODE["PRIVATE_SHOP_REFRESH_MAX"] = 543--�����ﵽˢ������
G_ERRCODE["PRIVATE_SHOP_REFRESH_PRICE_ERR"] = 544--�̵�ˢ�¼۸����
G_ERRCODE["PRIVATE_SHOP_MONEY_TYPE_ERR"] = 545--�����̵�������ʹ���
G_ERRCODE["PRIVATE_SHOP_MONEY_LESS"] = 546--�����̵��Ҳ���
G_ERRCODE["PRIVATE_SHOP_YUANBAO_LESS"] = 547--�����̵�Ԫ������
G_ERRCODE["PRIVATE_SHOP_REP_LESS"] = 548--�����̵���������
G_ERRCODE["PRIVATE_SHOP_BUY_MAX"] = 549--�����̵���Ʒ�Ѿ�û�й��������
G_ERRCODE["PRIVATE_SHOP_ITEM_NOT_EXIST"] = 550--�������Ʒ������
G_ERRCODE["PRIVATE_SHOP_ITEM_INFO_ERR"] = 551--�����̵���Ʒ����Ϣ����

G_ERRCODE["BATTLE_LIMIT_NO_COUNT"] = 571--ս��û���޴�ģ����
G_ERRCODE["BATTLE_DATA_ERROR"] = 572--ս����ͼ��Ϣ���ô���
G_ERRCODE["BATTLE_ID_NOT_EXIST"] = 573--�����ڵ�ս��
G_ERRCODE["BATTLE_HAVE_BEGIN"] = 574--ս���Ѿ���ʼ��
G_ERRCODE["BATTLE_HAVE_END"] = 575--ս���Ѿ�������
G_ERRCODE["BATTLE_HERO_NOT_EXIST"] = 576--ս�۲���������佫
G_ERRCODE["BATTLE_NOT_FINISH_REQ"] = 577--ս�ۻ�û�����ǰ��ս��
G_ERRCODE["BATTLE_SELECT_ZERO"] = 578--ս��û��ѡ���佫
G_ERRCODE["BATTLE_SELECT_MORE_HERO"] = 579--ս��ѡ����佫��������
G_ERRCODE["BATTLE_LEVEL_LESS"] = 580--�ȼ����㣬�����Բμ����ս��
G_ERRCODE["BATTLE_MOVE_SRC_ERR"] = 581--�ƶ���������
G_ERRCODE["BATTLE_MOVE_DST_ERR"] = 582--�ƶ����յ㲻�ɴ�
G_ERRCODE["BATTLE_NOT_BEGIN"] = 583--ս�ۻ�û�п�ʼ
G_ERRCODE["BATTLE_POSITION_NO_ARMY"] = 584--��ǰλ��û�ео�
G_ERRCODE["BATTLE_ARMY_NOT_SAME"] = 585--ս��λ�õĵо���Ϣ��һ��
G_ERRCODE["BATTLE_SET_HERO_INFO"] = 586--ս�۳�ս�佫���ݴ�������������
G_ERRCODE["BATTLE_VP_LESS"] = 587--ս���������㣬���ص���һ������

G_ERRCODE["NO_HORSE"] = 601--û�������
G_ERRCODE["HERO_COUNT_ZERO"] = 602--�佫����������Ϊ0
G_ERRCODE["HORSE_COUNT_ZERO"] = 603--��ս�����ó�ս����
G_ERRCODE["BATTLE_STATE_NOT_SET_HERO"] = 604--ս�۵ĵ�ǰ״̬���������ó�ս�佫
G_ERRCODE["BATTLE_HERO_HP_ZERO"] = 605--ս��ѡ����佫Ѫ��Ϊ0

G_ERRCODE["NO_LOTTERY"] = 620 --û������齱ģ��
G_ERRCODE["LOTTERY_MONEY_NOTENOUGH"] = 621 --�齱money���� 
G_ERRCODE["LOTTERY_YUANBAO_NOTENOUGH"] = 622 --�齱yuanbao����
G_ERRCODE["LOTTERY_COSTTYPE_NOTKNOWN"] = 623 --��֪���ĳ齱����
G_ERRCODE["LOTTERY_REP_NOTENOUGH"] = 624  --����齱����    

G_ERRCODE["DAILY_SIGN_HAVE"] = 630 	--�����Ѿ�������ǩ��
G_ERRCODE["DAILY_RESIGN_ERR"] = 631 	--û�в�ǩ�Ļ�����



G_ACH_TYPE = {}
G_ACH_TYPE["STAGE_STAR"]  = 1
G_ACH_TYPE["STAGE_VIP"]  = 2
G_ACH_TYPE["STAGE_PVP"]  = 3
G_ACH_TYPE["AUTO_FINISH"]  = 4  --ÿ�춨����ɵĳɾ�
G_ACH_TYPE["PVP_SERVER_FINISH"]  = 5  --������������ÿ��PVP���������Ķ���

G_CHAT_TYPE = {}
G_CHAT_TYPE["CHAT_WORLD"] = 1
G_CHAT_TYPE["CHAT_MAFIA"] = 2
G_CHAT_TYPE["CHAT_PRIVATE"] = 3

G_EVENT_TYPE = {}
G_EVENT_TYPE["MAIL_PVP_DAILY"] = 1
G_EVENT_TYPE["PVP_SEASON_FINISH"] = 2

G_KICKOUT_REASON = {}
G_KICKOUT_REASON["UNKNOWN"] = 1--δ֪ԭ��
G_KICKOUT_REASON["EXE_OUT_OF_DATE"] = 2--�ͻ���exe�汾̫�ϣ���Ҫ����
G_KICKOUT_REASON["DATA_OUT_OF_DATE"] = 3--�ͻ���data�汾̫�ϣ���Ҫ����

function NewCommand(typ)
	local cmd = {}
	cmd.__type__ = typ
	return cmd
end

function NewMessage(typ)
	local msg = {}
	msg.__type__ = typ
	return msg
end

function _DumpTable(ot, t)
	for k,v in pairs(t) do
		if type(v)=="table" then
			ot[#ot+1] = k.."={"
			_DumpTable(ot, v)
			ot[#ot+1] = "};"
		elseif type(v)=="userdata" then
			ot[#ot+1] = k.."=USERDATA;"
		elseif type(v)=="boolean" then
			ot[#ot+1] = k.."="..tostring(v)..";"
		else
			ot[#ot+1] = k.."="..v..";"
		end
	end
end

function DumpTable(t)
	local ot = {}
	_DumpTable(ot, t)
	return table.concat(ot)
end

function AddTraceInfo(info)
	return info..debug.traceback("",2)
end
