
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
G_ERRCODE["HERO_SKILLLV_UPGRADE_MONEY_LACK"] = 392 --�佫ͻ�ƽ�Ǯ����

G_ERRCODE["PVP_HERO_COUNT_ERR"] = 401 --�����佫����������

G_ERRCODE["PVP_STATE_ERROR"] = 411 --PVP����״̬�����쳣�������½���ƥ��
G_ERRCODE["PVP_INVITE_STATE_ERROR"] = 412 --PVP����״̬�����쳣�������½�������
G_ERRCODE["PVP_NET_TYPE_ERR"] = 413 --PVP�Լ����������ʹ���
G_ERRCODE["PVP_LATENCY_LARGE"] = 414 --PVP�Լ��������ӳٹ���

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

G_ERRCODE["TRIAL_ACTIVE_LEVEL_NOT_ENOUGH"] = 700 --������ȼ�����
G_ERRCODE["TRIAL_ACTIVE_DIFFICULTY_LOCK"] = 701 --������ؿ��Ѷ���δ����
G_ERRCODE["TRIAL_ACTIVE_PARAM_DIFFICULTY_WRONG"] = 702 --������ѶȲ�������
G_ERRCODE["TRIAL_ACTIVE_PARAM_STAGE_WRONG"] = 703 --������ؿ���������
G_ERRCODE["TRIAL_ACTIVE_PARAM_HERO_NOT_EXIST"] = 704 -- �����ڵ��佫
G_ERRCODE["TRIAL_ACTIVE_PARAM_HERO_DEAD"] = 705 --��������Ӣ�� 
G_ERRCODE["TRIAL_ACTIVE_HAS_REFRESH"] = 706 --�Ѿ�ˢ�¹���
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

G_ERRCODE["FRIEND_REQUEST_NOT_ROLE"] = 830 --û���ҵ�������
G_ERRCODE["FRIEND_REQUEST_HAVE"] = 831 --�������Ѿ�����ĺ�����
G_ERRCODE["FRIEND_REQUEST_HAVE_REQ"] = 832 --���Ѿ��������ҽ����˺�������
G_ERRCODE["FRIEND_REQUEST_SELF_MAX"] = 833 --�Լ��ĺ��������ﵽ���
G_ERRCODE["FRIEND_REQUEST_OTHER_MAX"] = 834 --�Է��ĺ��������ﵽ���
G_ERRCODE["FRIEND_REQUEST_SELF_BLACK_LIST"] = 835 --�Է����Լ��ĺ���������
G_ERRCODE["FRIEND_REQUEST_OTHER_BLACK_LIST"] = 836 --�Լ��ڶԷ��ĺ���������
G_ERRCODE["FRIEND_REPLY_ROLE_NOT_EXIST"] = 837 --��Ҳ�����

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
