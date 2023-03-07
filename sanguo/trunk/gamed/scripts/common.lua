
G_ERRCODE = {}
G_ERRCODE["SUCCESS"] = 0
G_ERRCODE["NO_ROLE"] = 1
G_ERRCODE["CREATING_ROLE"] = 2
G_ERRCODE["INVALID_NAME"] = 3
G_ERRCODE["USED_NAME"] = 4
G_ERRCODE["SYSTEM_INVALID"] = 5
G_ERRCODE["YUANBAO_LESS"] = 6   --Ԫ������
G_ERRCODE["LOAD_ROLE_DATA"] = 7   --����ȥ������Load��ɫ�����ˡ��Ե�һ���ٴ�����
G_ERRCODE["LOAD_ROLE_DATA_AGAIN"] = 8   --����ȥ������Load��ɫ�����ˡ��Ե�һ���ٴ�����
G_ERRCODE["SYSTEM_DATA_ERR"] = 9   --ϵͳ���ݴ���
G_ERRCODE["EXE_OUT_OF_DATE"] = 10   --�汾̫�ɣ��������Դ�Ժ������μӶ�ս
G_ERRCODE["VIP_LEVEL_LESS"] = 11   --VIP�ȼ����㣬������VIP�ȼ��Ժ������μ�
G_ERRCODE["NO_MAFIA"] = 101
G_ERRCODE["CREATING_MAFIA"] = 102
G_ERRCODE["MAFIA_HAVE"] = 103		--�Ѿ��а���ˣ��޷��������
G_ERRCODE["MAFIA_NAME_USED"] = 104	--�����ظ��ˣ���������һ������
G_ERRCODE["MAFIA_APPLY_HAVE_MAFIA"] = 105	--���Ѿ��а���ˣ��޷�������
G_ERRCODE["MAFIA_APPLY_LEVEL_LESS"] = 106	--�Լ��ĵȼ�����������ȼ�
G_ERRCODE["MAFIA_APPLY_HAVE_IN_APPLY"] = 107	--���Ѿ���������������б�����
G_ERRCODE["MAFIA_APPLY_MAX_NUM"] = 108	--�����������޴ﵽ�����
G_ERRCODE["MAFIA_QUIT_NO_MAFIA"] = 109	--û�а����ô�˳����ѽ
G_ERRCODE["MAFIA_QUIT_BANGZHU_ERR"] = 110	--�����������˳����
G_ERRCODE["MAFIA_SET_LEVEL_ERR"] = 111	--Ȩ�޲������޷��޸�����ȼ��Լ��Ƿ���Ҫ��׼
G_ERRCODE["MAFIA_ANNOUNCE_INVALID"] = 112	--���ڷǷ��ַ�����������
G_ERRCODE["MAFIA_KICKOUT_NO_ROLE"] = 113	--�߳�����Ҳ����Լ��İ����
G_ERRCODE["MAFIA_KICKOUT_NO_SELF"] = 114	--�������Լ��߳�ȥ�Լ�
G_ERRCODE["MAFIA_KICKOUT_NO_POWER"] = 115	--��û��Ȩ���߳������ң�����˵һ����ʦ��Ҫ�߳�����
G_ERRCODE["MAFIA_ACCEPT_MEMBER_MAX"] = 116	--��������ﵽ�����ޣ��޷���������Ա
G_ERRCODE["MAFIA_ACCEPT_NO_MEMBER"] = 117	--��������б���û�������Ա
G_ERRCODE["MAFIA_ACCEPT_NO_ROLE"] = 118		--��Ҳ����ڡ�
G_ERRCODE["MAFIA_ACCEPT_HAVE_MAFIA"] = 119	--����Ѿ��а����
G_ERRCODE["MAFIA_POSITION_HIGH_SELF"] = 120	--�������������Լ��ߵ�ְλ
G_ERRCODE["MAFIA_POSITION_NO_CHANGE"] = 121	--ְλû���κεı仯����ʲô�÷������ġ�
G_ERRCODE["MAFIA_SHANRANG_ERR"] = 122		--ֻ�а����ſ��Խ�������
G_ERRCODE["MAFIA_POSITION_MAX_NUM"] = 123	--���ְλ�������ﵽ���
G_ERRCODE["MAFIA_JISI_MAX_NUM"] = 124		--���յļ�������Ѿ��ﵽ������
G_ERRCODE["MAFIA_JISI_TYP_ERR"] = 125		--�������ʹ���
G_ERRCODE["MAFIA_JISI_MONEY_ERR"] = 126		--�����Ǯ����
G_ERRCODE["MAFIA_JISI_YUANBAO_ERR"] = 127	--����Ԫ������
G_ERRCODE["MAFIA_NOT_EXIST"] = 128		--��᲻����
G_ERRCODE["MAFIA_MAIL_LEVEL_ERR"] = 129		--û�з�����ʼ���Ȩ��
G_ERRCODE["MAFIA_BROADCAT_TIME_ERR"] = 130		--�����Է���
G_ERRCODE["INVALID_NAME_SIZE"] = 131

G_ERRCODE["TASK_ID_CURRENT"]  = 201 --��ǰ�������в��������ID
G_ERRCODE["TASK_NOT_FINISH"]  = 202 --�������û�����
G_ERRCODE["TASK_NOT_EXIST"]   = 203 --��ǰ��ģ���в������������
G_ERRCODE["TASK_NOT_LEVEL"]   = 204 --��ǰ�ȼ�����Ӧ�����������
G_ERRCODE["TASK_NOT_TIME"]    = 205 --��ǰ�����ڹ涨��ʱ�䷶Χ֮��
G_ERRCODE["TASK_HAVE_FINISH"]  = 206 --��������Ѿ����

G_ERRCODE["FUDAI_HAVE_GET"]    = 231 --�����Ѿ���ȡ�˸�������
G_ERRCODE["FUDAI_BUY_FIRST"]    = 232 --�����ȹ����˸������ſ�����ȡ��������
G_ERRCODE["FUDAI_TICKET_NOT_EXIST"] = 233         --������Ʊ��Ʒ������

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
G_ERRCODE["MONEYPILES_ERR"] = 317 --Ǯ�ѵ����������
G_ERRCODE["CHESTS_ERR"] = 318 --��������������
G_ERRCODE["NO_MONEYPILES"] = 319 --����û��Ǯ�ѵ���
G_ERRCODE["NO_CHESTS"] = 320 --����û�б������
G_ERRCODE["MONEY_DROPDATA_ERR"] = 321 --�߻�Ǯ�ѵ�����������

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
G_ERRCODE["HERO_SKILLLV_UPGRADE_MONEY_LACK"] = 392 --�佫ͻ�ƽ�Ǯ����

G_ERRCODE["PVP_HERO_COUNT_ERR"] = 401 --�����佫����������

G_ERRCODE["PVP_STATE_ERROR"] = 411 --PVP����״̬�����쳣�������½���ƥ��
G_ERRCODE["PVP_INVITE_STATE_ERROR"] = 412 --PVP����״̬�����쳣�������½�������
G_ERRCODE["PVP_NET_TYPE_ERR"] = 413 --PVP�Լ����������ʹ���
G_ERRCODE["PVP_LATENCY_LARGE"] = 414 --PVP�Լ��������ӳٹ���
G_ERRCODE["PVP_LATENCY_ING"] = 415 --���ڻ�ȡ�Լ����ӳ���Ϣ

G_ERRCODE["HERO_NO_SKILLID"] = 421 --�佫û���������
G_ERRCODE["HERO_SKILLLV_WRONG"] = 422 --�佫��������ܵȼ�����
G_ERRCODE["HERO_SKILLLV_MONEY_LESS"] = 423 --�佫�������ܽ�Ǯ����
G_ERRCODE["HERO_SKILLLV_MAX"] = 424 --�佫�ļ��ܵȼ������Գ����佫�ȼ�
G_ERRCODE["HERO_SKILL_POINT_LESS"] = 425 --�佫�ļ��ܵ�������
G_ERRCODE["HERO_SKILL_POINT_ZERO"] = 426 --ֻ���佫�ļ��ܵ���Ϊ0��ʱ��ſ��Թ���
G_ERRCODE["HERO_SKILL_NOT_LEVELUP"] = 427 --���ܲ���������
G_ERRCODE["HERO_SKILLLV_WRONG_PARAM"] = 428 --�����������
G_ERRCODE["HERO_SKILLLV_RESET_MONEY_LACK"] = 429 --�佫��������Ԫ������
G_ERRCODE["HERO_SKILLLV_RESET_INVALID"] = 430 --�佫����������Ч��������͵ȼ�

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
G_ERRCODE["BLACKLIST_FRIEND"] = 462--�Է�����ĺ����޷����ӵ�����������
G_ERRCODE["BLACKLIST_NOT_HAVE"] = 463--�Է�������ĺ���������

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
G_ERRCODE["PRIVATE_SHOP_CONNOT_BUY_REFRESH_TIME"] = 552 --�̵��޷�����ˢ�´���
G_ERRCODE["PRIVATE_SHOP_REFRESH_TIME_MAX"] = 553 --�̵깺��ˢ�´����ﵽ����

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
G_ERRCODE["BATTLE_STATE_NO_MOVE"] = 588--��ǰ״ֱ̬�ӽ����Ϳ����ˣ�����Ҫ�ƶ�

G_ERRCODE["NO_HORSE"] = 601--û�������
G_ERRCODE["HERO_COUNT_ZERO"] = 602--�佫����������Ϊ0
G_ERRCODE["HORSE_COUNT_ZERO"] = 603--��ս�����ó�ս����
G_ERRCODE["BATTLE_STATE_NOT_SET_HERO"] = 604--ս�۵ĵ�ǰ״̬���������ó�ս�佫
G_ERRCODE["BATTLE_HERO_HP_ZERO"] = 605--ս��ѡ����佫Ѫ��Ϊ0
G_ERRCODE["BATTLE_HERO_SIZE"] = 606		--ֻ������һ���佫

G_ERRCODE["NO_LOTTERY"] = 620 --û������齱ģ��
G_ERRCODE["LOTTERY_MONEY_NOTENOUGH"] = 621 --�齱money���� 
G_ERRCODE["LOTTERY_YUANBAO_NOTENOUGH"] = 622 --�齱yuanbao����
G_ERRCODE["LOTTERY_COSTTYPE_NOTKNOWN"] = 623 --��֪���ĳ齱����
G_ERRCODE["LOTTERY_REP_NOTENOUGH"] = 624  --����齱����    
G_ERRCODE["LOTTERY_COSTYPE_ERROR"] = 625 --�齱���������ʹ���
G_ERRCODE["LOTTERY_DROPITEM_ERROR"] = 626 --������Ʒ������
G_ERRCODE["LOTTERY_DROPITEM_count_ERROR"] = 627 --������Ʒ��������
G_ERRCODE["LOTTERY_ITEM_ERROR"] = 628 --�齱��Ʒ����Ҳ���
G_ERRCODE["LOTTERY_NO_FREE"] = 629 --�����Խ�����ѳ齱


G_ERRCODE["DAILY_SIGN_HAVE"] = 630 	--�����Ѿ�������ǩ��
G_ERRCODE["DAILY_RESIGN_ERR"] = 631 	--û�в�ǩ�Ļ�����
G_ERRCODE["DAILY_DATA_ERR"] = 632     --�߻������ݴ���
G_ERRCODE["LOTTERY_FREE_CD"] = 633 	--����CD�У����ڻ������Գ齱

G_ERRCODE["JJC_RESET_PK_CD_ERR"] = 640 	--��ǰ����Ҫ����ʱ��
G_ERRCODE["JJC_RESET_PK_CD_YUANBAO_LESS"] = 641 	--����CD�����Ԫ������
G_ERRCODE["JJC_BUY_PK_COUNT_ERR"] = 642 	--��ǰ���д����޷�����
G_ERRCODE["JJC_BUY_PK_COUNT_MAX"] = 643 	--�Ѿ��ﵽ��ǰVIP�ȼ���������
G_ERRCODE["JJC_BUY_PK_COUNT_SYSREM_ERR"] = 644 	--����۸�ϵͳ���ô���
G_ERRCODE["JJC_BUY_PK_COUNT_YUANBAO_LESS"] = 645 	--Ԫ�����㣬�޷��������
G_ERRCODE["JJC_ATTACK_COUNT_LESS"] = 646 	--�������㣬�޷�����
G_ERRCODE["JJC_PLAYER_LESS"] = 647 	--�������������㣬��δ����
G_ERRCODE["JJC_ATTACK_CD"] = 648 	--���ڽ���CD�У���ǰ�޷�����
G_ERRCODE["JJC_END_NO_OPPO"] = 649 	--���ڽ���CD�У���ǰ�޷�����
G_ERRCODE["JJC_VIDEO_NOT_EXIST"] = 650 	--JJC¼���Ѿ���������
G_ERRCODE["JJC_RANK_ERR"] = 651 	--JJC�����������
G_ERRCODE["JJC_JOIN_RANK_ERR"] = 652 	--JJC�����������
G_ERRCODE["JJC_CHALLENGE_ROLE_NOT_EXIST"] = 653 	--JJC��Ҳ�����
G_ERRCODE["JJC_ITEM_NOT_EXIST"] = 654 	--��ս���߲�����
G_ERRCODE["JJC_HERO_ZERO"] = 655 	--JJC���ݲ������ǿյ�,������������������ս

G_ERRCODE["WEAPON_EQUIP_HERO_ERR"] = 671 	--�佫������
G_ERRCODE["WEAPON_EQUIP_LEVEL_LESS"] = 672 	--�佫����װ���ȼ�����
G_ERRCODE["WEAPON_EQUIP_NOT_EXIST"] = 673 	--�佫װ��������������
G_ERRCODE["WEAPON_EQUIP_SYS_ERR"] = 674 	--�߻��������
G_ERRCODE["WEAPON_EQUIP_TYPE_ERR"] = 675 	--װ�����Ͳ�ƥ��
G_ERRCODE["WEAPON_LEVELUP_UNEQUIP"] = 676 	--����û��װ��������������
G_ERRCODE["WEAPON_LEVELUP_MAX_LEVEL"] = 677 	--�����ﵽ���ȼ������������佫�ȼ���������
G_ERRCODE["WEAPON_LEVELUP_MONEY_LESS"] = 678 	--������������Ǯ����
G_ERRCODE["WEAPON_STRENGTH_MAX"] = 679 		--����ǿ���ﵽ����ߵȼ�
G_ERRCODE["WEAPON_STRENGTH_ITEM_LESS"] = 680 	--����ǿ��,ȱ����Ӧ��ǿ��ʯ
G_ERRCODE["WEAPON_DECOMPOSE_EQUIP"] = 681 	--�Ѿ�װ������Ʒ�����Էֽ�
G_ERRCODE["WEAPON_PROP_LVUP_TYPE"] = 682	--����ӡ�������ʹ���
G_ERRCODE["WEAPON_HAVED_STRENGTH"] = 683    --�Ѿ�����
G_ERRCODE["WEAPON_LEVELUP_COST_NOT_HAVE"] = 684    --���ĵ�����������
G_ERRCODE["WEAPON_FORGE_ARG_ERROR"] = 685	--���������������
G_ERRCODE["WEAPON_FORGE_ITEM_ERROR"] = 686   --����������ϲ���
G_ERRCODE["WEAPON_FORGE_MONEY_ERROR"] = 687   --��������ˢ������ӡ��Ҳ���
G_ERRCODE["WEAPON_FORGE_YUANBAO_ERROR"] = 688   --��������ˢ������ӡԪ������
G_ERRCODE["WEAPON_FORGE_RESET_ERROR"] = 689	 --����ˢ��

G_ERRCODE["WEAPON_FORGE_LIMIT"] = 690 --�ﵽ����
G_ERRCODE["WEAPON_FORGE_ACTIVE"] = 691 --�Ѿ�����
G_ERRCODE["WEAPON_FORGE_NO_ACTIVE"] = 692 --��δ�������
G_ERRCODE["WEAPON_FORGE_LIMIT_LEVEL"] = 693 --ͼ������
G_ERRCODE["WEAPON_FORGE_TIME"] = 694 --��ȡ����ʱ��û��
	

G_ERRCODE["TRIAL_ACTIVE_LEVEL_NOT_ENOUGH"] = 700 --������ȼ�����
G_ERRCODE["TRIAL_ACTIVE_DIFFICULTY_LOCK"] = 701 --������ؿ��Ѷ���δ����
G_ERRCODE["TRIAL_ACTIVE_PARAM_DIFFICULTY_WRONG"] = 702 --������ѶȲ�������
G_ERRCODE["TRIAL_ACTIVE_PARAM_STAGE_WRONG"] = 703 --������ؿ���������
G_ERRCODE["TRIAL_ACTIVE_PARAM_HERO_NOT_EXIST"] = 704 -- �����ڵ��佫
G_ERRCODE["TRIAL_ACTIVE_PARAM_HERO_DEAD"] = 705 --��������Ӣ�� 
G_ERRCODE["TRIAL_ACTIVE_HAS_REFRESH"] = 706 --�Ѿ�ˢ�¹���   ������޸ĳ�û�д����ˣ��޷�����
G_ERRCODE["TRIAL_ACTIVE_FAILED"] = 707 --��������ʧ��
G_ERRCODE["TRIAL_ACTIVE_DIFFICULTY_NOT_FOUND"] = 708 --�Ѷ��Ҳ���
G_ERRCODE["TRIAL_ACTIVE_STAGE_NOT_FOUND"] = 709 --�ؿ��Ҳ���
G_ERRCODE["TRIAL_ACTIVE_STAGE_STAGE_PASSED"] = 710 --�ؿ��Ѿ�ͨ��
G_ERRCODE["TRIAL_ACTIVE_STAGE_HERO_NOT_SELECTED"] = 711 --û��ѡ��Ӣ��
G_ERRCODE["TRIAL_ACTIVE_BOSSID_NOT_FIND"] = 712 --�Ҳ����ؿ�����id
G_ERRCODE["TRIAL_ACTIVE_REWARD_NOT_TAKEN"] = 713 --��������ûͨ�� ��������ȡ
G_ERRCODE["TRIAL_ACTIVE_REWARD_HAS_TAKEN"] = 714 --���������Ѿ���ȡ
G_ERRCODE["TRIAL_ACTIVE_YUANBAO_NOT_ENOUGH"] = 715 --����ɨ��Ԫ������
G_ERRCODE["TRIAL_ACTIVE_STAGEINFO_NOT_FOUND"] = 716 --�ؿ���Ϣ�Ҳ���
G_ERRCODE["TRIAL_ACTIVE_BOSSINFO_NOT_FOUND"] = 717 --boss��Ϣ�Ҳ���
G_ERRCODE["TRIAL_ACTIVE_STAGE_SWEEP_NOT_ALLOWED"] = 718 --�����ؿ��Ѿ�ͨ�أ�������ɨ��
G_ERRCODE["TRIAL_ACTIVE_STAGE_HAS_FIGHTED"] = 719 --�����ؿ��Ѿ����
G_ERRCODE["TRIAL_ACTIVE_REWARD_FLAG_NOT_RECONGIZE"] = 720 -- �������Ͳ���ʶ��

G_ERRCODE["EQUIPMENT_NOT_EXIST"] = 721 --װ��������
G_ERRCODE["EQUIPMENT_HERO_NOT_EXIST"] = 722 --װ��������������佫
G_ERRCODE["EQUIPMENT_BIND_OTHER_HERO"] = 723 --װ���Ѿ������������佫���޷�װ��������佫
G_ERRCODE["EQUIPMENT_TYP_NOT_EXIST"] = 724 --װ�����Ͳ�����
G_ERRCODE["EQUIPMENT_TYP_NOT_MATCH"] = 725 --װ����������Ӳ�����
G_ERRCODE["EQUIPMENT_MAX_LEVEL"] = 726 --װ���ﵽ����ߵȼ�
G_ERRCODE["EQUIPMENT_LEVEL_SYS_ERR"] = 727 --�߻���װ���ȼ�����������
G_ERRCODE["EQUIPMENT_LEVEL_MONEY_LESS"] = 728 --װ��������Ǯ����
G_ERRCODE["EQUIPMENT_NO_UNEQUIP"] = 729 --��ǰλ��û��װ�����޷�ж��װ��
G_ERRCODE["EQUIPMENT_NOT_GRADE"] = 730 --���װ������������
G_ERRCODE["EQUIPMENT_NOT_REFINABLE"] = 731 --���װ��������ϴ��
G_ERRCODE["EQUIPMENT_NO_REFINABLE_SAVE"] = 732 --���װ��û�����Կ��Խ��б���
G_ERRCODE["EQUIPMENT_GRADE_EQUIP_LESS"] = 733 --��Ʒ����װ������
G_ERRCODE["EQUIPMENT_GRADE_ITEM_LESS"] = 734 --��Ʒ������Ʒ����
G_ERRCODE["EQUIPMENT_GRADE_MAX"] = 735 --װ���ﵽ����߽ױ�
G_ERRCODE["EQUIPMENT_DECOMPOSE_WEARED"] = 736 --�Ѿ�װ����װ���޷��ֽ�
G_ERRCODE["EQUIPMENT_NOT_DECOMPOSE"] = 737 --���װ���޷��ֽ�
G_ERRCODE["EQUIPMENT_LAST_REFINE"] = 738 --�������һ��ϴ������Ĵ����ٽ�����һ��ϴ��
G_ERRCODE["EQUIPMENT_REFINE_MAX"] = 739 --ϴ���ﵽ�����ֵ���������ױ����ﻹ�п������Ѿ��ﵽ����߽ױ�
G_ERRCODE["EQUIPMENT_REFINE_COUNT_ERR"] = 740 --ϴ����������
G_ERRCODE["EQUIPMENT_REFINE_TYP_ERR"] = 741 --ϴ�����ʹ���
G_ERRCODE["EQUIPMENT_REFINE_MONEY_LESS"] = 742 --ϴ����Ҫ�Ľ�Ǯ����
G_ERRCODE["EQUIPMENT_REFINE_GOUYU_LESS"] = 743 --ϴ����Ҫ�Ĺ�����
G_ERRCODE["EQUIPMENT_REFINE_ITEM_LESS"] = 744 --ϴ����Ҫ����Ʒ����
G_ERRCODE["EQUIPMENT_UNEQUIP_MONEY_LESS"] = 745 --����װ������Ľ�Ǯ����
G_ERRCODE["EQUIPMENT_NO_LEVELUP_EQUIP"] = 746 --�佫û�п�������װ��

G_ERRCODE["TONGQUETAI_SET_HERO_COUNT_LESS"] = 751 --ͭȸ̨�������������佫�μ�
G_ERRCODE["TONGQUETAI_SET_HERO_NO_HERO"] = 752 --�佫������
G_ERRCODE["TONGQUETAI_JOIN_HERO_LESS"] = 753 --�������ú�3���佫�ٽ���ͭȸ̨���ƥ��
G_ERRCODE["TONGQUETAI_JOIN_IN_ACTIVITY"] = 754 --����������ƥ���У������Ժ��ٽ�����һ��
G_ERRCODE["TONGQUETAI_CANCLE_JOIN"] = 755 --û����ƥ������С�
G_ERRCODE["TONGQUETAI_JOIN_NO_COUNT"] = 756 --û�д�����
G_ERRCODE["TONGQUETAI_JOIN_SYS_COST_ERR"] = 757 --���ô��󻨷�
G_ERRCODE["TONGQUETAI_JOIN_SYS_COST_TYP_ERR"] = 758 --���û������ʹ���
G_ERRCODE["TONGQUETAI_JOIN_COST_MONEY_LESS"] = 759 --��Ҫ�Ľ�Ǯ����
G_ERRCODE["TONGQUETAI_CANCLE_STATE_ERR"] = 760 --��ǰ״̬������ȡ��ƥ��
G_ERRCODE["TONGQUETAI_PLAYER_DROP"] = 761 --��ҵ��ߣ���һ����ҿ�ʼ��ս
G_ERRCODE["TONGQUETAI_FAIL_PLAYER_DROP"] = 762 --��ҵ��ߣ���λʧ��
G_ERRCODE["TONGQUETAI_ATTACK_SUCCESS"] = 763 --��ҳɹ�����һ������ʼ����һ��
G_ERRCODE["TONGQUETAI_FAIL_ALL_DEAD"] = 764 --�����ҷ����ȫ���������������ͭȸ̨ʧ����
G_ERRCODE["TONGQUETAI_REWARD_NOT_GET"] = 765 --�����ϴεĽ���û����ȡ�������޷��μ�ͭȸ̨��������ȡ����
G_ERRCODE["TONGQUETAI_REWARD_NOT_EXIST"] = 766 --û�н���������ȡ��

G_ERRCODE["BATTLEFIELD_ROUND_STATE_ERR"] = 771 --ս�ۻغ�״̬����
G_ERRCODE["BATTLEFIELD_ROUND_COUNT_LESS"] = 772 --ս��û�лغϴ�����

G_ERRCODE["USE_ITEM_NOT_EXIST"] = 780 --��Ʒ������
G_ERRCODE["USE_ITEM_CAN_NOT_USE"] = 781 --��Ʒ������ʹ��
G_ERRCODE["USE_ITEM_NUM_ERR"] = 782 --�����������0
G_ERRCODE["USE_ITEM_NUM_LESS"] = 783 --��û����ô����Ʒ
G_ERRCODE["USE_ITEM_KEY_NUM_LESS"] = 784 --��û����ô��Ӧ��Կ�ף�(������Ҫע��һ�£���ʹ�����ӣ���ôԿ�׾��Ƕ�Ӧ��Կ�ף���ʹ��Կ�ף���ô���Ӿ���Կ�׵�Կ��)
G_ERRCODE["USE_ITEM_KEY_NUM_MAX"] = 785 --�������ӵĿ��������ﵽ������

G_ERRCODE["TEMPORARY_NO_ID"] = 791 --��ʱ��������û�����������

G_ERRCODE["LEGION_ACH_NOT_FINISH"] = 800 --�������ս��û����ɣ��޷�����ר��
G_ERRCODE["LEGION_HAVE_ACTIVE"] = 801 --�Ѿ������˵�ǰר��
G_ERRCODE["LEGION_LEARN_LEVEL_LESS"] = 802 --ѧϰ��ѧ��Ŀ����ҵȼ����㣬��������ѧϰ
G_ERRCODE["LEGION_DECOMPOSE_ITEM"] = 803 --��ѡ������Ҫ�ֽ�����
G_ERRCODE["LEGION_DECOMPOSE_ITEM_NOT_EXIST"] = 804 --ѡ��ֽ����겻����
G_ERRCODE["LEGION_DECOMPOSE_ITEM_NOT_WUHUN"] = 805 --ѡ��ֽ����Ʒ�������
G_ERRCODE["LEGION_DECOMPOSE_ITEM_COUNT_LESS"] = 806 --ѡ��ֽ�������������
G_ERRCODE["LEGION_XIANGMU_LEARNED"] = 807 --�Ѿ�ѧϰ����
G_ERRCODE["LEGION_XIANGMU_QIANZHI_UNLEARNED"] = 808 --ǰ��û��ѧϰ
G_ERRCODE["LEGION_SPEC_MAX_LEVEL"] = 809 --ר���ȼ��ﵽ����޷�����������

G_ERRCODE["MASHU_NOT_FRIEND"] = 810 --�Է�������ĺ��ѣ��޷���ս
G_ERRCODE["MASHU_FRIEND_COUNT_MAX"] = 811 --������ѵ���ս�����ﵽ����
G_ERRCODE["MASHU_BUY_BUFF_MONEY_LESS"] = 812 --����BUFF��Ǯ����
G_ERRCODE["MASHU_BUY_BUFF_GOUYU_LESS"] = 813 --����BUFF������
G_ERRCODE["MASHU_BUY_BUFF_HAVE_BUFF"] = 814 --�Ѿ��������BUFF
G_ERRCODE["MASHU_SET_HERO_COUNT"] = 815 --ֻ��������һ���佫
G_ERRCODE["MASHU_SET_HORSE_ERR"] = 816 --�������ó�ս����ƥ
G_ERRCODE["MASHU_GET_PRIZE_NOT_RANK"] = 817 --����û�вμ�����������û�п�����ȡ�Ľ���,��Ҫ�õ��������ǵ�ÿ�춼Ҫ�μ�ѽ
G_ERRCODE["MASHU_GET_PRIZE_HAVE_GET"] = 818 --���Ѿ���ȡ�����յĽ���
G_ERRCODE["MASHU_FRIEND_MONEY_LESS"] = 819 --��Ǯ���㣬�޷��������������ս
G_ERRCODE["MASHU_GET_PRIZE_RANK_LOW"] = 820 --��������̫���޷���ȡ����

G_ERRCODE["FRIEND_REQUEST_NOT_ROLE"] = 830 --û���ҵ�������
G_ERRCODE["FRIEND_REQUEST_HAVE"] = 831 --�������Ѿ�����ĺ�����
G_ERRCODE["FRIEND_REQUEST_HAVE_REQ"] = 832 --���Ѿ��������ҽ����˺�������
G_ERRCODE["FRIEND_REQUEST_SELF_MAX"] = 833 --�Լ��ĺ��������ﵽ���
G_ERRCODE["FRIEND_REQUEST_OTHER_MAX"] = 834 --�Է��ĺ��������ﵽ���
G_ERRCODE["FRIEND_REQUEST_SELF_BLACK_LIST"] = 835 --�Է����Լ��ĺ���������
G_ERRCODE["FRIEND_REQUEST_OTHER_BLACK_LIST"] = 836 --�Լ��ڶԷ��ĺ���������
G_ERRCODE["FRIEND_REPLY_ROLE_NOT_EXIST"] = 837 --��Ҳ�����

G_ERRCODE["ACTIVE_CODE_INVALID"]        = 841 --�����콱��
G_ERRCODE["ACTIVE_CODE_USED"]           = 842 --ʹ�ô����ﵽ����
G_ERRCODE["ACTIVE_CODE_TYPE"]           = 843 --�Ҳ�����Ӧ���͵��콱��
G_ERRCODE["ACTIVE_CODE_TIME"]           = 844 --������ȡ��Ч��

G_ERRCODE["LEGION_SPEC_ITEM_LESS"] = 851 --ר���ȼ�ѧϰ����Ʒ����
G_ERRCODE["LEGION_SPEC_EXP_LESS"] = 852 --ר���ȼ�ѧϰ����ѧ���鲻��
G_ERRCODE["LEGION_LEARN_EXP_LESS"] = 853 --ר����Ŀѧϰ�����鲻��
G_ERRCODE["LEGION_LEARN_JUNHUN_LESS"] = 854 --ר����Ŀѧϰ�����겻��
G_ERRCODE["LEGION_LEARN_ITEM_LESS"] = 855 --ר����Ŀѧϰ����Ʒ����


G_ERRCODE["JIEYI_INVITEROLE_NOT_EXIST"] = 870 --����Ľ�ɫ������
G_ERRCODE["JIEYI_INVITEROLE_NOT_ONLINE"] = 871 --����Ľ�ɫ������
G_ERRCODE["JIEYI_INVITEROLE_HAS_JIEYI"] = 872 --����Ľ�ɫ�Ѿ�����
G_ERRCODE["JIEYI_INVITEROLE_LEVEL_NOT_ENOUGH"] = 873 --����Ľ�ɫ�ȼ�����
G_ERRCODE["JIEYI_INVITEROLE_NUMBER_SURPASS"] = 874 --����Ľ�ɫ�Ѿ�����������
G_ERRCODE["JIEYI_INVITEROLE_NOT_CREATED"] = 875 --����û�д���
G_ERRCODE["JIEYI_HAS_CREATED"] = 876 --�����Ѿ�����
G_ERRCODE["JIEYI_INVITEROLE_NOT_ACCEPT"] = 877--����δ��������
G_ERRCODE["JIEYI_BOSS_NOT_FIND"] = 878 -- boss��Ϣ�Ҳ���
G_ERRCODE["JIEYI_BROTHER_NOT_FIND"] = 879 -- brother��Ϣ�Ҳ���
G_ERRCODE["JIEYI_BROTHER_NOT_INVITED"] = 880 -- �����뷽�Ѿ��������� ���������� 
G_ERRCODE["JIEYI_REQUEST_TYPE_WRONG"] = 881 -- �������type����
G_ERRCODE["JIEYI_INFO_NOT_FOUND"] = 882 --����Ľ�����Ϣ�Ҳ���
G_ERRCODE["JIEYI_INVITEREQUEST_CANCEL"] = 883 --���������Ѿ���ȡ��

G_ERRCODE["PHOTO_SET_NO_PHOTO"] = 890  --ͷ������û�����ͷ��
G_ERRCODE["PHOTO_SET_NO_PHOTO_FRAME"] = 891  --ͷ������û�����ͷ���

G_ERRCODE["YUEZHAN_HERO_LESS"] = 900  --��������Լս����
G_ERRCODE["YUEZHAN_ROOM_ERR"] = 901  --����ķ���Ų����ڣ��Ѿ�ȡ����
G_ERRCODE["YUEZHAN_HAVE_ROLE"] = 902  --�Ѿ�����Ӧս�ˣ�����Թۿ����ǵ�ʵʱ��ս
G_ERRCODE["YUEZHAN_FINISH"] = 903  --ʵʱ��ս�Ѿ�����������ȥ�鿴¼��
G_ERRCODE["YUEZHAN_CANCLE_ROLE"] = 904  --�Ѿ�����Ӧս�ˣ��޷�ȡ��
G_ERRCODE["YUEZHAN_CANCLE_NOT_CREATE"] = 905  --�㲻��Լս�ķ����ߣ�������ȡ��
G_ERRCODE["YUEZHAN_CREATER_JOIN"] = 906  --�����߲����Խ����Լ������Լս
G_ERRCODE["YUEZHAN_BATTLE_STATE"] = 907	--���Ѿ�����Լս״̬

G_ERRCODE["HERO_MAX_STAR"] = 920	--�佫�ﵽ����Ǽ����޷���������

G_ERRCODE["SENDFLOWER_TO_SELF"] = 931 --�����Ը��Լ�����
G_ERRCODE["SENDFLOWER_TIMES_UPPER"] = 932 --�ͻ��Ѿ��ﵽ����,�������ͻ�
G_ERRCODE["SENDFLOWER_MONEY_NOT_ENOUGH"] = 933 --�ͻ�����Ǯ�Ҳ���
G_ERRCODE["SENDFLOWER_YUANBAO_NOT_ENOUGH"] = 934 --�ͻ�����Ԫ������
G_ERRCODE["SENDFLOWER_COSTTYPE_NOT_EXIST"] = 935 --�ͻ�����Ԫ������
G_ERRCODE["SENDFLOWER_HAS_SEND"] = 936 --�Ѿ�����������͹����ˣ�ÿ��ֻ�����ͻ�һ��
G_ERRCODE["SENDFLOWER_HAS_SEND"] = 937 --�����Ѿ���������͹���
G_ERRCODE["SENDFLOWER_TYPE_NOT_RIGHT"] = 938 --�ͻ���ʽ����
G_ERRCODE["SENDFLOWER_REWARD_TEMPLAT_ERROR"] = 939 --�ͻ�����ģ���Ҳ���

G_ERRCODE["TOWER_ERROR_ARG"] = 950      --��������������  
G_ERRCODE["TOWER_ERROR_DATA"] = 951     --�������ݴ���
G_ERRCODE["TOWER_ERROR_LEVEL"] = 952    --ѡ�񼶱���ȼ�����
G_ERRCODE["TOWER_ERROR_LAYER"] = 953    --��������
G_ERRCODE["TOWER_ERROR_TYPE"] = 954     --���ʹ���
G_ERRCODE["TOWER_ERROR_GET_BOX"] = 955	--�����Ѿ���ȡ
G_ERRCODE["TOWER_ERROR_BUFF"] = 956		--buff���ݲ�����
G_ERRCODE["TOWER_ERROR_LESS_STAR"] = 957--����������
G_ERRCODE["TOWER_ERROR_GET_BUFF"] = 958 --�Ѿ�������BUFF
G_ERRCODE["TOWER_HERO_NOT_SELECTED"] = 959 --û��ѡ��Ӣ��
G_ERRCODE["TOWER_ERROR_ATTACK_ARMY_INFO"] = 959 --������Ϣ������
G_ERRCODE["TOWER_PARAM_HERO_NOT_EXIST"] = 960 --��ѡӢ�۲�����
G_ERRCODE["TOWER_PARAM_HERO_DEAD"] = 961 --��ѡӢ���Ѿ�����
G_ERRCODE["TOWER_ERROR_SELECTED"] = 962	 --�Ѿ�ѡ���������Ѷ�
G_ERRCODE["TOWER_ERROR_ARMY_SELECTED"] = 963 --�Ѿ�ѡ���˹����Ѷ�
G_ERRCODE["TOWER_ERROR_GET_PRIZE_NOT_RANK"] = 964 --û������
G_ERRCODE["TOWER_ERROR_GET_PRIZE_HAVE_GET"] = 965 --�Ѿ���ȡ
G_ERRCODE["TOWER_ERROR_SWEEP"] = 966     --����ɨ��

G_ERRCODE["SKIN_NOT_EXIST"] = 980      --װ����Ƥ��������
G_ERRCODE["SKIN_TIME_OUT"] = 981      --װ����Ƥ���Ѿ������޷�װ��
G_ERRCODE["SKIN_NOT_HERO"] = 982      --װ����Ƥ������������佫
G_ERRCODE["SKIN_GET_HERO_FIRST"] = 983      --���Ȼ������佫��װ��Ƥ��
G_ERRCODE["SKIN_BUY_HAVE"] = 984      --�Ѿ������Ƥ���ˣ����ù�����
G_ERRCODE["SKIN_BUY_NO_HERO"] = 985      --û������佫���޷�����Ƥ��
G_ERRCODE["SKIN_BUY_CAN_NOT_YUANBAO"] = 986      --���Ƥ��������ʹ��Ԫ������
G_ERRCODE["SKIN_BUY_CAN_NOT_ITEM"] = 987      --���Ƥ��������ʹ����Ʒ�һ�
G_ERRCODE["SKIN_BUY_ITEM_LESS"] = 988      --���Ƥ����Ʒ�һ�����Ʒ����
G_ERRCODE["SKIN_BUY_USING"] = 989      --���Ƥ���Ѿ�����ʱƤ�����ˣ������Ե���ʹ��

G_ERRCODE["DATI_NUM_ERR"] = 990 --��Ŀ��Ŀ����
G_ERRCODE["DATI_RIGHT_FLAG_ERR"] = 991 --��������ʶ����
G_ERRCODE["DATI_HAVE_OPENBOX_ERR"] = 992 --����Ѿ����������ⱦ��
G_ERRCODE["DATI_OPENBOX_FAIL_ERR"] = 993 --δȫ����Ա�����Ŀ����������ʧ�� 
G_ERRCODE["DATI_REWARD_ERR"] = 994 --���⽱������
G_ERRCODE["DATI_UNFINISHED"] = 995 --δ��ɽ��մ���
G_ERRCODE["DATI_USETIME_ERR"] = 998 --������ʱ����

G_ERRCODE["TRIAL_NOTLINE"] = 996

G_ERRCODE["CHONGZHI_DISABLE"] = 997 --Ŀǰ��δ���ų�ֵ


G_ERRCODE["MILITARY_ERROR_ARG"] = 1020	--��������
G_ERRCODE["MILITARY_ERROR_TEAM"] = 1021  --��ս���ݴ������������ó�ս����
G_ERRCODE["MILITARY_ERROR_TIMES"] = 1022  --��ս��������
G_ERRCODE["MILITARY_ERROR_CD"] = 1023  --��սcd
G_ERRCODE["MILITARY_ERROR_LEVEL"] = 1024  --��ս�ȼ�����
G_ERRCODE["MILITARY_ERROR_ACTIVIE"] = 1025  --���δ����
G_ERRCODE["MILITARY_ERROR_HERO_TYPE"] = 1026  --�佫���ʹ���
G_ERRCODE["MILITARY_ERROR_BATTLE_DATA"] = 1027 --ս�����ݴ���
G_ERRCODE["MILITARY_ERROR_DATA"] = 1028			--���ݴ���
G_ERRCODE["MILITARY_ERROR_VIP"] = 1029         --vip����

G_ERRCODE["HOT_PVP_VIDEO_NOT_FOUND"] = 1051	--�Ҳ���¼��

G_ERRCODE["ACTIVITY_NOT_EXIST"] = 1100         --�������
G_ERRCODE["ACTIVITY_NOT_IN_REWARD_TIME"] = 1101         --���ڻ�콱ʱ����
G_ERRCODE["ACTIVITY_CANNOT_GET_REWARD"] = 1102         --��ǰ������޷���ȡ����
G_ERRCODE["ACTIVITY_ALREADY_GET_REWARD"] = 1103			--�Ѿ���ȡ������

G_ACH_TYPE = {}
G_ACH_TYPE["STAGE_STAR"]  = 1
G_ACH_TYPE["STAGE_VIP"]  = 2
G_ACH_TYPE["STAGE_PVP"]  = 3
G_ACH_TYPE["AUTO_FINISH"]  = 4  --ÿ�춨����ɵĳɾ�
G_ACH_TYPE["PVP_SERVER_FINISH"]  = 5  --������������ÿ��PVP���������Ķ���
G_ACH_TYPE["STAGE_FINISH"]  = 6		--���ָ���ؿ��Ժ�ĳɾ�
G_ACH_TYPE["LEVEL_FINISH"]  = 7		--�ȼ��ﵽָ���Ժ�ĳɾ�
G_ACH_TYPE["STAGE_COUNT"]  = 8		--ÿ����ͨ�����Ĵ���
G_ACH_TYPE["STAGE_JINGYING_COUNT"]  = 9		--ÿ�վ�Ӣ�����Ĵ���
G_ACH_TYPE["STAGE_JINGYING_FINISH"]  = 10	--���ָ����Ӣ�ؿ��Ժ�ĳɾ�
G_ACH_TYPE["HUODONG_HUOYUE"]  = 11		--��Ծ�ȳɾ�
G_ACH_TYPE["BATTLEFIELD_FINISH"]  = 12		--���ָ��ս�۳ɾ�
G_ACH_TYPE["MAFIA_JISI"]  = 13			--�������
G_ACH_TYPE["MAFIA_QUIT"]  = 14			--�뿪���
G_ACH_TYPE["CONTINUTY_DAY"]  = 15		--����7���½
G_ACH_TYPE["FLOWER_LINGERING"]  = 18		--����ɾ�
G_ACH_TYPE["CHONGZHI"]  = 19			--��ֵ����
G_ACH_TYPE["YONGJIU"]  = 20			--���óɾ�
G_ACH_TYPE["LESSNUM"]  = 21			--С��Ŀ���������ɵĳɾ�����
G_ACH_TYPE["ZHANLI"]  = 22			--����Ŀ���������ɵĳɾ�����
G_ACH_TYPE["HERO"]  = 23			--�ռ�ָ���佫
G_ACH_TYPE["HERO_TUPO"]  = 24			--ӵ�д���Ŀ���ָ���׵��佫
G_ACH_TYPE["WUZHESHILIAN"]  = 25			--�����ﵽĿ���Ŀ���
G_ACH_TYPE["HERO_STAR"]  = 26			--ӵ�д���Ŀ���ָ���Ǽ����佫
G_ACH_TYPE["WEAPON_LEVELUP"]  = 27			--ӵ�д���Ŀ���ָ���ȼ�������
G_ACH_TYPE["EQUIPMENT_LEVELUP"]  = 28			--ӵ�д���Ŀ���ָ���ȼ���װ��
G_ACH_TYPE["MILITARY"] = 29 		--������سɾ�

--����2�ĳ�2������
G_ACH_TWO_TYPE = {}
G_ACH_TWO_TYPE["NORMAL"] = 0 --VIP��ͨ����
G_ACH_TWO_TYPE["SPECIAL"] = 1 --VIP��Ȩ����

--����19�ĳɾ�2������
G_ACH_NINTEEN_TYPE = {}
G_ACH_NINTEEN_TYPE["SHOUCHONG"] = 1
G_ACH_NINTEEN_TYPE["LEIJICHONGZHI"] = 2
G_ACH_NINTEEN_TYPE["LEIJIXIAOFEI"] = 3
G_ACH_NINTEEN_TYPE["DAILYSIGNBOX"] = 4

--����8�ĳɾ͵�2������
G_ACH_EIGHT_TYPE = {}
G_ACH_EIGHT_TYPE["STAGE"] = 0			--�ؿ�
G_ACH_EIGHT_TYPE["WUZHESHILIAN"] = 1		--��������
G_ACH_EIGHT_TYPE["MASHUDASAI"] = 2		--��������
G_ACH_EIGHT_TYPE["FLOWER"] = 3			--�ͻ�
G_ACH_EIGHT_TYPE["3V3"] = 4			--3V3ȡ��ʤ��
G_ACH_EIGHT_TYPE["JJC"] = 5			--�μ�JJC
G_ACH_EIGHT_TYPE["BUYVP"] = 6			--��������
G_ACH_EIGHT_TYPE["LOTTERY"] = 7			--�齱
G_ACH_EIGHT_TYPE["YANWUCHANG"] = 8		--���䳡
G_ACH_EIGHT_TYPE["MAFIAJISI"] = 9		--���˼���

--����20�ĳɾ͵�2������  20��Ҫ�����óɾ�
G_ACH_TWENTY_TYPE = {}
G_ACH_TWENTY_TYPE["JJCWIN"] = 1			--JJCʤ������
G_ACH_TWENTY_TYPE["JJCSCORE"] = 2		--JJC����
G_ACH_TWENTY_TYPE["3V3WIN"] = 3			--3V3ʤ������
G_ACH_TWENTY_TYPE["3V3CHUANSHUOSCORE"] = 4	--3V3��˵����
G_ACH_TWENTY_TYPE["3V3CHUANSHUO"] = 5		--3V3�ﵽ��˵��λ
--G_ACH_TWENTY_TYPE["3V3JIEWEI"] = 6		--3V3�ױ�   �����ˣ��ŵ�21����ȥ
G_ACH_TWENTY_TYPE["MASHUSCORE"] = 7		--��������
G_ACH_TWENTY_TYPE["YUXIANG"] = 8		--�ͻ�����
G_ACH_TWENTY_TYPE["FLOWER"] = 9			--�����ʻ�
G_ACH_TWENTY_TYPE["MAFIAJOIN"] = 10		--��������
G_ACH_TWENTY_TYPE["MAFIAJISI"] = 11		--���˼���
G_ACH_TWENTY_TYPE["MAFIAJITIAN"] = 12	--���˼���
G_ACH_TWENTY_TYPE["JIEWEI"] = 13   --��λ    
G_ACH_TWENTY_TYPE["DATIRIGHTNUM"] = 14   --�������
G_ACH_TWENTY_TYPE["DATIALLRIGHTTIME"] = 15   --����ȫ�Դ���

--����21�ĳɾ͵�2������  21��Ҫ��С��ĳһ����ֵ��������ɵ�
G_ACH_TWENTYONE_TYPE = {}
G_ACH_TWENTYONE_TYPE["JJCRANK"] = 1		--JJC����
G_ACH_TWENTYONE_TYPE["MASHURANK"] = 3		--������������
G_ACH_TWENTYONE_TYPE["3V3GRADE"] = 2		--3V3�ױ�

G_ACH_TWENTYNIME_TYPE = {}
G_ACH_TWENTYNIME_TYPE["MILITARY_ALL_HURT1"]  = 1 --�����˺�����ﵽֵ 
G_ACH_TWENTYNIME_TYPE["MILITARY_ALL_HURT2"]  = 2 --�����˺�����ﵽֵ 
G_ACH_TWENTYNIME_TYPE["MILITARY_ALL_HURT3"]  = 3 --�����˺�����ﵽֵ 
G_ACH_TWENTYNIME_TYPE["MILITARY_ALL_HURT4"]  = 4 --�����˺�����ﵽֵ


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
G_KICKOUT_REASON["CLIENTID_ERR"] = 4--����ID����
G_KICKOUT_REASON["FORBID_LOGIN"] = 5--��ұ���ֹ��½

G_MAFIA_POSITION = {}
G_MAFIA_POSITION["BANGZHU"] 	= 1	--����
G_MAFIA_POSITION["JUNSHI"] 	= 3	--��ʦ
G_MAFIA_POSITION["XIANFENG"] 	= 5	--�ȷ�
G_MAFIA_POSITION["JINGYING"] 	= 7	--��Ӣ
G_MAFIA_POSITION["PINGMIN"] 	= 9	--ƽ��

G_ROLE_STATE = {}
G_ROLE_STATE["FREE"]		= 0	--����״̬
G_ROLE_STATE["INSTANCE"]	= 1	--�ؿ�״̬
G_ROLE_STATE["WUZHESHILIAN"]	= 2	--��������״̬
G_ROLE_STATE["MASHUDASAI"]	= 3	--��������״̬
G_ROLE_STATE["JINGJICHANG"]	= 4	--������״̬
G_ROLE_STATE["TONGQUETAI"]	= 5	--ͭȸ̨״̬
G_ROLE_STATE["BATTLEFIELD"]	= 6	--ս��״̬
G_ROLE_STATE["PVP"]		= 7	--PVP״̬
G_ROLE_STATE["YUEZHAN"]		= 8	--Լս״̬
G_ROLE_STATE["TOWER"]     = 9 --ɨ��״̬

G_NOTICE_TYP = {}
G_NOTICE_TYP["ROLE"]		= 1     --���
G_NOTICE_TYP["HERO"]		= 2     --�佫
G_NOTICE_TYP["NUM"]		= 3     --������
G_NOTICE_TYP["WEAPON"]		= 4     --����
G_NOTICE_TYP["SOURCE"]		= 5     --��Դ(num��id)
G_NOTICE_TYP["ITEM"]		= 6     --��Ʒ(id����Ʒtid)
G_NOTICE_TYP["GM"]		= 7     --GM����

G_PVP_STATE_TYP = {}
G_PVP_STATE_TYP["3V3"]		= 1	--3V3
G_PVP_STATE_TYP["YUEZHAN"]      = 2	--���Լս

G_YUEZHAN_STATE = {}

G_HERO_TEAM_TYP = {}
G_HERO_TEAM_TYP["YUEZHAN"]	= 1	--Լս������
G_HERO_TEAM_TYP["TOWER"] = 43
G_HERO_TEAM_TYP["JUNWUBAOKU1"] = 44
G_HERO_TEAM_TYP["JUNWUBAOKU2"] = 45
G_HERO_TEAM_TYP["JUNWUBAOKU3"] = 46
G_HERO_TEAM_TYP["JUNWUBAOKU4"] = 47

G_LOTTERY_COST_TYPE = {}
G_LOTTERY_COST_TYPE["FREE"]	= 0	--�����ļ
G_LOTTERY_COST_TYPE["ITEM"]	= 1	--��Ʒ��ļ
G_LOTTERY_COST_TYPE["YUANBAO"]	= 2	--Ԫ����ļ

G_ITEM_TYPE = {}
G_ITEM_TYPE["WEAPON"]		= 7	--weapon
G_ITEM_TYPE["HERO"]		= 21	--hero
--G_ITEM_TYPE["LOTTERY"]		= 22	--��Ʊ

G_SOURCE_TYP = {}
G_SOURCE_TYP["NORMAL_RECRUIT"] = 1 --��ͨ��ļ
G_SOURCE_TYP["HIGHER_RECRUIT"] = 2 --�߼���ļ
G_SOURCE_TYP["APPOINT_RECRUIT"] = 3 --��ʱ��ļ
G_SOURCE_TYP["VIP_RECRUIT"] = 4 --��Ȩ��ļ
G_SOURCE_TYP["ITEM_SHOP"] = 11 --�����̵�
G_SOURCE_TYP["MASHU_SHOP"] = 12 --�����̵�
G_SOURCE_TYP["PVE_SHOP"] = 13 --�����̵�
G_SOURCE_TYP["PVP_SHOP"] = 14 --��ս�̵�
G_SOURCE_TYP["VIP_SHOP"] = 15 --��Ȩ�̵�
G_SOURCE_TYP["NORMAL_STAGE"] = 21 --����
G_SOURCE_TYP["SPECIAL_STAGE"] = 22 --����ܿ�
G_SOURCE_TYP["BATTLE"] = 23 --ս��
G_SOURCE_TYP["TOWER"] = 24 --��˫��̽��
G_SOURCE_TYP["WUZHESHILIAN"] = 25 --��������
G_SOURCE_TYP["MASHU"] = 26 --��������
G_SOURCE_TYP["WENDA"] = 27 --�����ʴ�
G_SOURCE_TYP["SILVER_BOX"] = 41 --��������
G_SOURCE_TYP["GOLDEN_BOX"] = 42 --�ƽ���
G_SOURCE_TYP["PLATINUM_BOX"] = 43 --�׽���
G_SOURCE_TYP["ACHIEVEMENT"] = 51 --�ɾͽ���
G_SOURCE_TYP["DAILY_TASK"] = 52 --ÿ������
G_SOURCE_TYP["DAILY_SIGN"] = 53 --ÿ��ǩ��
G_SOURCE_TYP["WEAPON_FORGE"] = 54 --�콵���
G_SOURCE_TYP["MONTH_CARD"] = 55 --�¿�
G_SOURCE_TYP["LITTLE_FUDAI"] = 56 --С����
G_SOURCE_TYP["BIG_FUDAI"] = 57 --�󸣴�
G_SOURCE_TYP["HERO"] = 58 --�佫
G_SOURCE_TYP["FULIHUODONG"] = 59 --�����
G_SOURCE_TYP["WEAPONMAKE"] = 60 --��������
G_SOURCE_TYP["YUNYING"] = 1000 --��Ӫ����

G_SHOP_TYP = {}
G_SHOP_TYP["PVP_SHOP"] = 7990 --��ս�̵�
G_SHOP_TYP["PVE_SHOP"] = 7991 --�����̵�
G_SHOP_TYP["MASHU_SHOP"] = 38090 --�����̵�
G_SHOP_TYP["ITEM_SHOP"] = 42897 --�����̵�
G_SHOP_TYP["VIP_SHOP"] = 42898 --��Ȩ�̵�

G_LOTTERY_TYP = {}
G_LOTTERY_TYP["NORMAL_RECRUIT"] = 42587 --��ͨ��ļ
G_LOTTERY_TYP["ONE_HIGHER_RECRUIT"] = 42588 --�߼���ļ����
G_LOTTERY_TYP["TEN_HIGHER_RECRUIT"] = 42589 --�߼���ļʮ����
G_LOTTERY_TYP["TEN_NORMAL_RECRUIT"] = 46425 --��ͨ��ļʮ����
G_LOTTERY_TYP["ONE_LIMITE_RECRUIT"] = 8580     --��ʱ��ļ����
G_LOTTERY_TYP["TEN_LIMITE_RECRUIT"] = 9003 --��ʱ��ļʮ����
G_LOTTERY_TYP["WEAPON_MAKE_ONE"] = 8578  --��������һ��
G_LOTTERY_TYP["WEAPON_MAKE_TEN"] = 8579  --��������ʮ��

G_BOX_TYP = {}
G_BOX_TYP["SILVER_BOX"] = 21825 --��������
G_BOX_TYP["GOLDEN_BOX"] = 21827 --�ƽ���
G_BOX_TYP["PLATINUM_BOX"] = 21829 --�׽���

G_ITEM_TYP = {}
G_ITEM_TYP["ROLE_EXP"] = 1 --���Ǿ���ҩ
G_ITEM_TYP["HERO_EXP"] = 2 --�佫����ҩ
G_ITEM_TYP["STRENGTHEN_ITEM"] = 3 --��ϵͳǿ������
G_ITEM_TYP["FUNC_ITEM"] = 4 --��ϵͳ���ܵ���
G_ITEM_TYP["GIFT"] = 5 --���
G_ITEM_TYP["EQUIP_BAG"] = 6 --�佫װ����
G_ITEM_TYP["WEAPON"] = 7 --����
G_ITEM_TYP["TEASURE"] = 8 --������Ʒ
G_ITEM_TYP["EQUIP_MATERIAL"] = 9 --װ������
G_ITEM_TYP["WUHUN"] = 11 --�佫���
G_ITEM_TYP["TEASURE_PIECE"] = 12 --������Ƭ
G_ITEM_TYP["COIN"] = 20 --������Ʒ
G_ITEM_TYP["HERO"] = 21 --�佫
G_ITEM_TYP["LOTTERY_ITEM"] = 22 --��Ʊ����
G_ITEM_TYP["EQUIP"] = 23 --�佫װ��
G_ITEM_TYP["USE_ITEM"] = 24 --����ʹ�ò�Ʊ����
G_ITEM_TYP["PHOTO_FRAME"] = 25 --ͷ���
G_ITEM_TYP["BADGE"] = 26 --������Ʒ
G_ITEM_TYP["PHOTO"] = 27 --ͷ��
G_ITEM_TYP["CHENGHAO"] = 29 --����ƺ�
G_ITEM_TYP["DRESS_TIYAN"] = 30 --ʱװʹ��ȯ
G_ITEM_TYP["DRESS_PIECE"] = 31 --ʱװ��Ƭ
G_ITEM_TYP["FUDAI"] = 32 --������Ʊ

G_INSTANCE_TYP = {}
G_INSTANCE_TYP["NORMAL_STAGE"] = 0 --��ͨ�ؿ�
G_INSTANCE_TYP["SPECIAL_STAGE"] = 1 --����ؿ�
G_INSTANCE_TYP["PRACTICE_STAGE"] = 2 --����ؿ�

G_NOTICE_ID = {}
G_NOTICE_ID["GM"] = 17 --GM����ID

G_TOPLIST_REFRESH_TYP = {}
G_TOPLIST_REFRESH_TYP["DAILY"] = 1 --ÿ��ˢ�����а�
G_TOPLIST_REFRESH_TYP["WEEK"] = 2 --ÿ��ˢ�����а�

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

function NewStruct(typ)
	local struct = {}
	struct.__type__ = typ
	return struct
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

API = {}
