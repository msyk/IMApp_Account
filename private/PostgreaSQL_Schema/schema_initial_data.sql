SET search_path TO imapp_account,public;

INSERT INTO authuser(id, username, hashedpasswd)
VALUES (1, 'account', '24a53d4379c9313b192d5af524ccfa814087d3187844e1154611d2a8ecfc652e6d48555a'); /* Leyc291#B */

INSERT INTO item
VALUES (1, '帳簿外', 0.0, 1, 0, 0);
INSERT INTO item
VALUES (2, '【要選択】', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (100, '現金', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (110, '当座預金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (115, '普通預金', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (117, '普通預金_個人口座', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (120, '通知預金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (124, '定期預金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (128, '定期積金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (130, '諸口預金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (140, '受取手形', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (141, '売掛金', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (150, '有価証券', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (160, '商品', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (161, '製品', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (162, '半製品', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (163, '仕掛品', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (164, '原材料', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (165, '貯蔵品', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (166, '積送品', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (170, '前渡金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (171, '立替金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (172, '未収入金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (174, '預け金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (175, '前払費用', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (176, '仮払金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (180, '仮払消費税', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (181, '事業主借', 1.0, 1, NULL, 0);
INSERT INTO item
VALUES (199, '貸倒引当金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (200, '建物', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (203, '機械装置', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (204, '車両運搬具', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (205, '建物及附属設備', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (206, '工具器具備品', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (210, '土地', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (232, '建物賃借権', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (240, '投資有価証券', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (241, '出資金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (242, '敷金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (243, '保証金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (246, '入会金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (247, '権利金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (250, '保険積立', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (260, '開業費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (261, '開発費', 1.0, NULL, 0, 0);
INSERT INTO item
VALUES (262, '試験研究費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (264, '新株発行費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (400, '支払手形', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (403, '元入金', 1.0, 1, NULL, 0);
INSERT INTO item
VALUES (404, '事業主貸', 1.0, 1, NULL, 0);
INSERT INTO item
VALUES (405, '買掛金', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (406, '未払外注費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (407, '未払費用', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (410, '短期借入金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (420, '未払金', 1.0, 1, NULL, 0);
INSERT INTO item
VALUES (423, '専従者給与', 1.0, 1, NULL, 0);
INSERT INTO item
VALUES (426, '預り金', 1.0, NULL, 0, 0);
INSERT INTO item
VALUES (427, '仮受金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (428, '前受金', 1.0, NULL, 0, 0);
INSERT INTO item
VALUES (430, '割引手形', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (440, '仮受消費税', 1.0, NULL, 0, 0);
INSERT INTO item
VALUES (450, '賞与引当金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (452, '返品調整引当金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (610, '材料仕入高', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (618, '仕入値引', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (625, '仕入高', 1.0, 1, 1, 0);
INSERT INTO item
VALUES (640, '役員報酬', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (641, '給与手当', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (642, '賞与', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (643, '退職金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (644, '雑給', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (645, '法定福利費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (646, '福利厚生費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (647, '賞与引当金繰入', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (648, '退職金共済掛金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (650, '外注加工費', 1.0, 0, 1, 0);
INSERT INTO item
VALUES (651, '荷造発送費', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (652, '広告宣伝費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (653, '交際費', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (654, '会議費', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (655, '旅費交通費', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (656, '通信費', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (657, '積送諸掛費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (658, '車輌費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (659, 'ソフト費', 1.0, 1, 1, 0);
INSERT INTO item
VALUES (660, '消耗品費', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (661, '事務用品費', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (662, '修繕費', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (663, '水道光熱費', 0.3, 1, 0, 0);
INSERT INTO item
VALUES (664, '新聞図書費', 1.0, 1, 1, 0);
INSERT INTO item
VALUES (665, '諸会費', 1.0, 1, 1, 0);
INSERT INTO item
VALUES (666, '支払手数料', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (667, '医療費', 0.0, 0, 0, 0);
INSERT INTO item
VALUES (669, '通信インフラ', 1.0, 1, 1, 0);
INSERT INTO item
VALUES (670, '支払保険料', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (671, '支払報酬', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (672, '寄付金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (680, '減価償却', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (681, '地代家賃', 0.3, 0, 0, 0);
INSERT INTO item
VALUES (682, 'リース料', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (683, '租税公課', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (686, '貸倒損失', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (687, '開発費償却', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (689, '雑費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (700, '売上高', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (709, '売上値引', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (720, '期首棚卸高', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (725, '仕入高', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (726, '内部仕入れ', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (729, '仕入値引', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (741, '給与手当', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (746, '福利厚生費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (775, '貸倒引当金繰入', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (779, '少額減価償却資産', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (780, '一括償却資産', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (781, '地代家賃', 0.3, 1, 0, 0);
INSERT INTO item
VALUES (782, 'リース料', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (783, '租税公課', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (786, '貸倒損失', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (800, '受取利息', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (801, '受取配当金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (802, '有価証券利息', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (816, '雑収入', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (846, '雑損失', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (913, 'その他の特別利益', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (933, 'その他の特別損失', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (980, '法人税等', 1.0, 1, 0, 0);

INSERT INTO assort_pattern
VALUES (1, '現金で購入', 2, 181, 1100);
INSERT INTO assort_pattern
VALUES (2, '現金を引き出し', 100, 115, 1200);
INSERT INTO assort_pattern
VALUES (3, '現金での報酬', 100, 700, 1600);
INSERT INTO assort_pattern
VALUES (4, '振り込み（請求書あり）', 115, 141, 1800);
INSERT INTO assort_pattern
VALUES (5, '振り込み（請求書なし）', 115, 700, 2000);
INSERT INTO assort_pattern
VALUES (6, '引き落とし・支払い', 2, 115, 2200);
INSERT INTO assort_pattern
VALUES (7, 'クレジット購入', 2, 420, 1300);
INSERT INTO assort_pattern
VALUES (8, '請求した', 141, 700, 1700);
INSERT INTO assort_pattern
VALUES (9, 'クレジットの支払い', 420, 115, 2500);
INSERT INTO assort_pattern
VALUES (10, '請求された', 2, 405, 2700);
INSERT INTO assort_pattern
VALUES (11, '請求に対する支払', 405, 115, 2800);
INSERT INTO assort_pattern
VALUES (13, '減価償却', 680, 206, 2900);
INSERT INTO assort_pattern
VALUES (14, '見積もり', 2, 2, 3000);
INSERT INTO assort_pattern
VALUES (15, '帳簿外', 1, 1, 1000);
INSERT INTO assort_pattern
VALUES (16, '個人用をクレジット購入', 404, 420, 1400);
INSERT INTO assort_pattern
VALUES (17, '個人のクレジットで購入', 2, 181, 2600);
INSERT INTO assort_pattern
VALUES (18, '個人のクレジット支払い', 1, 1, 2600);
INSERT INTO assort_pattern
VALUES (19, '振り込み個人口座（請求書あり）', 404, 141, 1900);
INSERT INTO assort_pattern
VALUES (20, '振り込み個人口座（請求書なし）', 404, 700, 2100);
INSERT INTO assort_pattern
VALUES (21, '引き落とし・支払い個人口座', 2, 181, 2300);

INSERT INTO fiscal_year(year)
VALUES (2020);
INSERT INTO fiscal_year(year)
VALUES (2021);
INSERT INTO fiscal_year(year)
VALUES (2022);
INSERT INTO fiscal_year(year)
VALUES (2023);
INSERT INTO fiscal_year(year)
VALUES (2024);
INSERT INTO fiscal_year(year)
VALUES (2025);
INSERT INTO fiscal_year(year)
VALUES (2026);
INSERT INTO fiscal_year(year)
VALUES (2027);
INSERT INTO fiscal_year(year)
VALUES (2028);
INSERT INTO fiscal_year(year)
VALUES (2029);
INSERT INTO fiscal_year(year)
VALUES (2030);
INSERT INTO fiscal_year(year)
VALUES (2031);
INSERT INTO fiscal_year(year)
VALUES (2032);
INSERT INTO fiscal_year(year)
VALUES (2033);
INSERT INTO fiscal_year(year)
VALUES (2034);

INSERT INTO company(company, section, person, postal_code, address)
VALUES ('会社1', '部署1', '担当者名1', '999-9999', '東京都埼玉区都会町345-678 大都会ビル12F');
INSERT INTO company(company, section, person, postal_code, address)
VALUES ('会社2', '部署2', '担当者名2', '999-9999', '東京都埼玉区都会町345-678 大都会ビル11F');

INSERT INTO preference(myself, bank_info, show_tax_detail)
VALUES ('○○○○<br>〒999-9999 さいたま市青区大都会1-2-3<br>048-199-1999(tel/fax)<br>msyk@msyk.net',
        '以下の銀行口座に振込をお願いします。<br><br>みずほ銀行（0001）南浦和支店（306）<br>口座番号：9999999<br>名義：○○○○（○○○○）',
        0);