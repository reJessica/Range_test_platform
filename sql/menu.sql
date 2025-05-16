-- 网络安全平台菜单
INSERT INTO `sys_menu` VALUES (2010, '网络安全平台', 0, 1, 'security', NULL, '', '', 1, 0, 'M', '0', '0', '', 'security', 'admin', SYSDATE(), '', NULL, '网络安全平台目录');

-- 网络流量监控与分析
INSERT INTO `sys_menu` VALUES (2011, '网络流量监控', 2010, 1, 'monitor', 'security/monitor/index', '', '', 1, 0, 'C', '0', '0', 'security:monitor:list', 'monitor', 'admin', SYSDATE(), '', NULL, '网络流量监控与分析');

-- 行为挖掘与威胁检测
INSERT INTO `sys_menu` VALUES (2012, '威胁检测', 2010, 2, 'threat', 'security/threat/index', '', '', 1, 0, 'C', '0', '0', 'security:threat:list', 'search', 'admin', SYSDATE(), '', NULL, '行为挖掘与威胁检测');

-- 威胁响应与自动防护
INSERT INTO `sys_menu` VALUES (2013, '威胁响应', 2010, 3, 'response', 'security/response/index', '', '', 1, 0, 'C', '0', '0', 'security:response:list', 'shield', 'admin', SYSDATE(), '', NULL, '威胁响应与自动防护');

-- 靶场模拟与攻防演练
INSERT INTO `sys_menu` VALUES (2014, '靶场演练', 2010, 4, 'range', 'security/range/index', '', '', 1, 0, 'C', '0', '0', 'security:range:list', 'example', 'admin', SYSDATE(), '', NULL, '靶场模拟与攻防演练');

-- 智能AI助手
INSERT INTO `sys_menu` VALUES (2015, '智能AI助手', 2010, 5, 'ai', 'security/ai/index', '', '', 1, 0, 'C', '0', '0', 'security:ai:list', 'message', 'admin', SYSDATE(), '', NULL, '智能AI问答系统');

-- 关于我们
INSERT INTO `sys_menu` VALUES (2016, '关于我们', 2010, 6, 'about', 'security/about/index', '', '', 1, 0, 'C', '0', '0', 'security:about:list', 'peoples', 'admin', SYSDATE(), '', NULL, '关于我们');

-- 按钮权限
-- 网络流量监控按钮
INSERT INTO `sys_menu` VALUES (2021, '流量监控查询', 2011, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'security:monitor:query', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (2022, '流量监控导出', 2011, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'security:monitor:export', '#', 'admin', SYSDATE(), '', NULL, '');

-- 威胁检测按钮
INSERT INTO `sys_menu` VALUES (2023, '威胁检测查询', 2012, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'security:threat:query', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (2024, '威胁检测处理', 2012, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'security:threat:handle', '#', 'admin', SYSDATE(), '', NULL, '');

-- 威胁响应按钮
INSERT INTO `sys_menu` VALUES (2025, '响应策略查询', 2013, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'security:response:query', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (2026, '响应策略配置', 2013, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'security:response:config', '#', 'admin', SYSDATE(), '', NULL, '');

-- 靶场演练按钮
INSERT INTO `sys_menu` VALUES (2027, '靶场环境配置', 2014, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'security:range:config', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (2028, '演练场景管理', 2014, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'security:range:manage', '#', 'admin', SYSDATE(), '', NULL, '');

-- AI助手按钮
INSERT INTO `sys_menu` VALUES (2029, 'AI对话', 2015, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'security:ai:chat', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (2030, 'AI设置', 2015, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'security:ai:config', '#', 'admin', SYSDATE(), '', NULL, ''); 