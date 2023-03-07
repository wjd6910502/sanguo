
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

G_ERRCODE["HERO_COMMENTS_SELF"] = 431--�����Ը��Լ����佫���۵���
G_ERRCODE["HERO_COMMENTS_DID"] = 432--�Ѿ���������۵������
G_ERRCODE["HERO_COMMENTS_NOT_HAVE"] = 433--û��������ۣ��޷����е��޲���
G_ERRCODE["HERO_COMMENTS_NOT_WRITE"] = 434--û�и�����佫д�����ۣ��������д
G_ERRCODE["HERO_COMMENTS_CAN_NOT_WRITE"] = 435--����佫����������
G_ERRCODE["HERO_COMMENTS_MAX"] = 436--���������佫���۴ﵽ����

G_ACH_TYPE = {}
G_ACH_TYPE["STAGE_STAR"]  = 1
G_ACH_TYPE["STAGE_VIP"]  = 2
G_ACH_TYPE["STAGE_PVP"]  = 3

G_CHAT_TYPE = {}
G_CHAT_TYPE["CHAT_WORLD"] = 1
G_CHAT_TYPE["CHAT_MAFIA"] = 2
G_CHAT_TYPE["CHAT_PRIVATE"] = 3


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
