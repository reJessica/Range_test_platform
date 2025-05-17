<template>
    <div class="container-div">
        <div id="app1">
            <div class="header-stats">
                <div class="stat-item">
                    <div class="stat-value">{{ activeThreats }}</div>
                    <div class="stat-label">活跃威胁</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">{{ blockedAttacks }}</div>
                    <div class="stat-label">已阻止攻击</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">{{ isolatedDevices }}</div>
                    <div class="stat-label">隔离设备</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">{{ responseTime }}ms</div>
                    <div class="stat-label">平均响应时间</div>
                </div>
            </div>

            <div class="protection-groups">
                <div class="group-header">
                    <h2>自动响应策略</h2>
                    <el-switch v-model="autoResponse" active-text="自动响应" inactive-text="手动响应"
                        @change="handleAutoResponseChange">
                    </el-switch>
                </div>

                <div class="cards">
                    <div class="card purple">
                        <p class="tip">流量清洗</p>
                        <p class="second-text">自动检测和过滤恶意流量，清洗DDoS攻击流量，确保网络畅通。</p>
                        <div class="icon-container" :class="{ active: trafficClean }">
                            <template v-if="!trafficClean">
                                <i class="el-icon-refresh-right"></i>
                            </template>
                            <template v-else>
                                <div class="data-item">
                                    <div class="value">{{ currentTraffic }}</div>
                                    <div class="label">当前流量 Mbps</div>
                                </div>
                                <div class="data-item">
                                    <div class="value">{{ cleanedTraffic }}</div>
                                    <div class="label">已清洗 GB</div>
                                </div>
                            </template>
                        </div>
                        <div class="card-footer">
                            <el-switch v-model="trafficClean" @change="updateChart" />
                            <el-tag :type="trafficClean ? 'success' : 'info'">{{ trafficClean ? '已启用' : '未启用'
                                }}</el-tag>
                        </div>
                    </div>

                    <div class="card brown">
                        <p class="tip">设备隔离</p>
                        <p class="second-text">自动隔离受感染设备，阻止威胁横向扩散，保护网络安全。</p>
                        <div class="icon-container" :class="{ active: deviceIsolation }">
                            <template v-if="!deviceIsolation">
                                <i class="el-icon-lock"></i>
                            </template>
                            <template v-else>
                                <div class="data-item">
                                    <div class="value">{{ isolatedDevices }}</div>
                                    <div class="label">已隔离设备</div>
                                </div>
                                <div class="data-item">
                                    <div class="value">{{ monitoringDevices }}</div>
                                    <div class="label">监控中</div>
                                </div>
                            </template>
                        </div>
                        <div class="card-footer">
                            <el-switch v-model="deviceIsolation" @change="updateChart" />
                            <el-tag :type="deviceIsolation ? 'success' : 'info'">{{ deviceIsolation ? '已启用' : '未启用'
                                }}</el-tag>
                        </div>
                    </div>

                    <div class="card red">
                        <p class="tip">威胁阻断</p>
                        <p class="second-text">智能识别并阻断恶意连接，封锁异常IP和端口，快速切断攻击路径。</p>
                        <div class="icon-container" :class="{ active: threatBlock }">
                            <template v-if="!threatBlock">
                                <i class="el-icon-warning"></i>
                            </template>
                            <template v-else>
                                <div class="data-item">
                                    <div class="value">{{ blockedThreats }}</div>
                                    <div class="label">已阻断</div>
                                </div>
                                <div class="data-item">
                                    <div class="value">{{ responseTime }}</div>
                                    <div class="label">响应时间 ms</div>
                                </div>
                            </template>
                        </div>
                        <div class="card-footer">
                            <el-switch v-model="threatBlock" @change="updateChart" />
                            <el-tag :type="threatBlock ? 'success' : 'info'">{{ threatBlock ? '已启用' : '未启用' }}</el-tag>
                        </div>
                    </div>

                    <div class="card blue">
                        <p class="tip">资产加固</p>
                        <p class="second-text">自动扫描并加固脆弱资产，修补安全漏洞，提升系统防护能力。</p>
                        <div class="icon-container" :class="{ active: assetProtection }">
                            <template v-if="!assetProtection">
                                <i class="el-icon-s-tools"></i>
                            </template>
                            <template v-else>
                                <div class="data-item">
                                    <div class="value">{{ vulnerabilities }}</div>
                                    <div class="label">发现漏洞</div>
                                </div>
                                <div class="data-item">
                                    <div class="value">{{ patchedAssets }}</div>
                                    <div class="label">已修复</div>
                                </div>
                            </template>
                        </div>
                        <div class="card-footer">
                            <el-switch v-model="assetProtection" @change="updateChart" />
                            <el-tag :type="assetProtection ? 'success' : 'info'">{{ assetProtection ? '已启用' : '未启用'
                                }}</el-tag>
                        </div>
                    </div>

                    <div class="card green">
                        <p class="tip">安全审计</p>
                        <p class="second-text">实时记录安全事件，自动生成分析报告，追踪安全防护效果。</p>
                        <div class="icon-container" :class="{ active: securityAudit }">
                            <template v-if="!securityAudit">
                                <i class="el-icon-document"></i>
                            </template>
                            <template v-else>
                                <div class="data-item">
                                    <div class="value">{{ auditEvents }}</div>
                                    <div class="label">审计记录</div>
                                </div>
                                <div class="data-item">
                                    <div class="value">{{ riskScore }}</div>
                                    <div class="label">风险评分</div>
                                </div>
                            </template>
                        </div>
                        <div class="card-footer">
                            <el-switch v-model="securityAudit" @change="updateChart" />
                            <el-tag :type="securityAudit ? 'success' : 'info'">{{ securityAudit ? '已启用' : '未启用'
                                }}</el-tag>
                        </div>
                    </div>
                </div>
            </div>

            <div class="recent-events">
                <div class="group-header">
                    <h2>实时响应事件</h2>
                    <button class="clear-btn" @click="clearEvents">清空记录</button>
                </div>
                <table class="event-table">
                    <tbody>
                        <tr v-for="(event, index) in recentEvents" :key="index">
                            <td>{{ event.time }}</td>
                            <td>{{ event.type === 'warning' ? '流量清洗' :
                        event.type === 'danger' ? '设备隔离' :
                            event.type === 'info' ? '威胁阻断' : '资产加固' }}</td>
                            <td>{{ event.content }}</td>
                            <td>已处理</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="chart-container">
                <div class="group-header">
                    <h2>防护效果分析</h2>
                </div>
                <div class="chart">
                    <div id="vulnerabilityChart" style="width: 100%; height:350px;"></div>
                </div>
            </div>

            <!-- 响应策略配置对话框 -->
            <el-dialog title="响应策略配置" :visible.sync="dialogVisible" width="50%">
                <el-form :model="responseConfig" label-width="120px">
                    <el-form-item label="流量清洗阈值">
                        <el-input-number v-model="responseConfig.trafficThreshold" :min="1" :max="1000"
                            label="Mbps"></el-input-number>
                    </el-form-item>
                    <el-form-item label="设备隔离条件">
                        <el-select v-model="responseConfig.isolationConditions" multiple placeholder="请选择隔离条件">
                            <el-option label="异常流量" value="abnormal_traffic"></el-option>
                            <el-option label="恶意连接" value="malicious_connection"></el-option>
                            <el-option label="病毒感染" value="virus_infection"></el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="威胁等级阈值">
                        <el-slider v-model="responseConfig.threatLevel" :marks="threatLevelMarks" :step="1" :min="1"
                            :max="5"></el-slider>
                    </el-form-item>
                    <el-form-item label="响应优先级">
                        <el-radio-group v-model="responseConfig.priority">
                            <el-radio label="high">高</el-radio>
                            <el-radio label="medium">中</el-radio>
                            <el-radio label="low">低</el-radio>
                        </el-radio-group>
                    </el-form-item>
                </el-form>
                <span slot="footer" class="dialog-footer">
                    <el-button @click="dialogVisible = false">取 消</el-button>
                    <el-button type="primary" @click="saveResponseConfig">确 定</el-button>
                </span>
            </el-dialog>
        </div>
    </div>
</template>

<script>
import * as echarts from 'echarts';

export default {
    name: "App",
    data() {
        return {
            // 状态数据
            activeThreats: 0,
            blockedAttacks: 0,
            isolatedDevices: 0,
            responseTime: 0,

            // 防护开关
            autoResponse: true,
            trafficClean: false,
            deviceIsolation: false,
            threatBlock: false,
            assetProtection: false,
            securityAudit: false,

            // 图表相关
            vulnerabilityData: [100],
            timeLabels: ['0s'],
            chart: null,
            timer: null,
            currentTime: 0,
            chartTimeRange: '1h',

            // 事件记录
            recentEvents: [],

            // 配置对话框
            dialogVisible: false,
            responseConfig: {
                trafficThreshold: 100,
                isolationConditions: ['abnormal_traffic'],
                threatLevel: 3,
                priority: 'medium'
            },
            threatLevelMarks: {
                1: '低',
                2: '中低',
                3: '中',
                4: '中高',
                5: '高'
            },
            currentTraffic: '722.45',
            cleanedTraffic: '92.47',
            monitoringDevices: 0,
            blockedThreats: 0,
            vulnerabilities: 0,
            patchedAssets: 0,
            auditEvents: 0,
            riskScore: 0
        };
    },
    mounted() {
        this.initChart();
        this.startTimer();
        this.initBackgroundEffect();
        this.startEventSimulation();
    },
    methods: {
        handleAutoResponseChange(value) {
            if (value) {
                this.$message.success('已启用自动响应模式');
                this.addEvent({
                    type: 'success',
                    color: '#67C23A',
                    content: '系统已切换至自动响应模式',
                    time: new Date().toLocaleTimeString()
                });
            } else {
                this.$message.warning('已切换为手动响应模式');
                this.addEvent({
                    type: 'warning',
                    color: '#E6A23C',
                    content: '系统已切换至手动响应模式',
                    time: new Date().toLocaleTimeString()
                });
            }
        },

        startEventSimulation() {
            setInterval(() => {
                if (this.autoResponse) {
                    this.simulateSecurityEvent();
                }
                this.updateStats();
            }, 3000);
        },

        simulateSecurityEvent() {
            if (!this.autoResponse) return;

            const events = [
                {
                    type: 'warning',
                    color: '#faad14',
                    content: '检测到异常流量峰值，自动启动流量清洗...',
                    measure: 'trafficClean',
                    sound: 'warning'
                },
                {
                    type: 'danger',
                    color: '#ff4d4f',
                    content: '发现恶意代码注入尝试，已自动隔离受影响设备',
                    measure: 'deviceIsolation',
                    sound: 'danger'
                },
                {
                    type: 'info',
                    color: '#1890ff',
                    content: '检测到可疑DNS请求，已自动阻断',
                    measure: 'threatBlock',
                    sound: 'info'
                },
                {
                    type: 'success',
                    color: '#52c41a',
                    content: '完成系统漏洞修复，安全基线更新完成',
                    measure: 'assetProtection',
                    sound: 'success'
                }
            ];

            const event = events[Math.floor(Math.random() * events.length)];
            if (this[event.measure]) {
                this.addEvent({
                    ...event,
                    time: new Date().toLocaleTimeString()
                });

                // 添加声音反馈
                this.playNotificationSound(event.sound);
            }
        },

        playNotificationSound(type) {
            // 可以根据需要添加不同类型的提示音
            const audio = new Audio(`/audio/${type}.mp3`);
            audio.volume = 0.3;
            audio.play().catch(() => { });
        },

        updateStats() {
            // 更真实的数据波动
            const randomChange = (base, range) => {
                return Math.max(0, base + Math.floor((Math.random() - 0.5) * range));
            };

            // 更新流量数据
            if (this.trafficClean) {
                this.currentTraffic = (parseFloat(this.currentTraffic) + (Math.random() - 0.5) * 10).toFixed(2);
                this.cleanedTraffic = (parseFloat(this.cleanedTraffic) + Math.random() * 0.5).toFixed(2);
            }

            // 更新设备隔离数据
            if (this.deviceIsolation) {
                this.isolatedDevices = randomChange(this.isolatedDevices || 3, 2);
                this.monitoringDevices = randomChange(10, 5);
            }

            // 更新威胁阻断数据
            if (this.threatBlock) {
                this.blockedThreats = randomChange(this.blockedThreats || 5, 3);
                this.responseTime = randomChange(150, 100);
            }

            // 更新资产加固数据
            if (this.assetProtection) {
                this.vulnerabilities = randomChange(20, 8);
                this.patchedAssets = randomChange(15, 5);
            }

            // 更新安全审计数据
            if (this.securityAudit) {
                this.auditEvents = randomChange(100, 20);
                this.riskScore = Math.min(100, Math.max(0, randomChange(85, 10)));
            }

            // 添加粒子动画效果
            if (this.activeThreats > 8) {
                this.addWarningParticles();
            }
        },

        addWarningParticles() {
            const container = document.querySelector('.header-stats');
            const particle = document.createElement('div');
            particle.className = 'warning-particle';
            particle.style.left = Math.random() * 100 + '%';
            container.appendChild(particle);

            setTimeout(() => {
                particle.remove();
            }, 2000);
        },

        addEvent(event) {
            this.recentEvents.unshift(event);
            if (this.recentEvents.length > 5) {
                this.recentEvents.pop();
            }
        },

        clearEvents() {
            this.recentEvents = [];
        },

        updateChartTimeRange(range) {
            // 更新图表时间范围的逻辑
            this.updateChart();
        },

        saveResponseConfig() {
            this.dialogVisible = false;
            this.$message.success('响应策略配置已更新');
            this.addEvent({
                type: 'success',
                color: '#67C23A',
                content: '更新响应策略配置',
                time: new Date().toLocaleTimeString()
            });
        },

        initChart() {
            this.chart = echarts.init(document.getElementById('vulnerabilityChart'));
            const option = {
                backgroundColor: 'transparent',
                tooltip: {
                    trigger: 'axis',
                    axisPointer: {
                        type: 'shadow'
                    }
                },
                grid: {
                    top: '10%',
                    left: '3%',
                    right: '4%',
                    bottom: '3%',
                    containLabel: true
                },
                xAxis: {
                    type: 'category',
                    data: ['00:00', '04:00', '08:00', '12:00', '16:00', '20:00'],
                    axisLine: {
                        lineStyle: {
                            color: 'rgba(255, 255, 255, 0.3)'
                        }
                    },
                    axisLabel: {
                        color: 'rgba(255, 255, 255, 0.7)'
                    }
                },
                yAxis: {
                    type: 'value',
                    name: '威胁数量',
                    nameTextStyle: {
                        color: 'rgba(255, 255, 255, 0.7)'
                    },
                    axisLine: {
                        lineStyle: {
                            color: 'rgba(255, 255, 255, 0.3)'
                        }
                    },
                    axisLabel: {
                        color: 'rgba(255, 255, 255, 0.7)'
                    },
                    splitLine: {
                        lineStyle: {
                            color: 'rgba(255, 255, 255, 0.1)'
                        }
                    }
                },
                series: [
                    {
                        name: '高危威胁',
                        type: 'line',
                        stack: 'Total',
                        smooth: true,
                        lineStyle: {
                            width: 0
                        },
                        showSymbol: false,
                        areaStyle: {
                            opacity: 0.8,
                            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                                {
                                    offset: 0,
                                    color: 'rgba(255, 77, 79, 0.5)'
                                },
                                {
                                    offset: 1,
                                    color: 'rgba(255, 77, 79, 0.1)'
                                }
                            ])
                        },
                        emphasis: {
                            focus: 'series'
                        },
                        data: [140, 232, 101, 264, 90, 340]
                    },
                    {
                        name: '中危威胁',
                        type: 'line',
                        stack: 'Total',
                        smooth: true,
                        lineStyle: {
                            width: 0
                        },
                        showSymbol: false,
                        areaStyle: {
                            opacity: 0.8,
                            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                                {
                                    offset: 0,
                                    color: 'rgba(250, 173, 20, 0.5)'
                                },
                                {
                                    offset: 1,
                                    color: 'rgba(250, 173, 20, 0.1)'
                                }
                            ])
                        },
                        emphasis: {
                            focus: 'series'
                        },
                        data: [120, 282, 111, 234, 220, 340]
                    },
                    {
                        name: '低危威胁',
                        type: 'line',
                        stack: 'Total',
                        smooth: true,
                        lineStyle: {
                            width: 0
                        },
                        showSymbol: false,
                        areaStyle: {
                            opacity: 0.8,
                            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                                {
                                    offset: 0,
                                    color: 'rgba(24, 144, 255, 0.5)'
                                },
                                {
                                    offset: 1,
                                    color: 'rgba(24, 144, 255, 0.1)'
                                }
                            ])
                        },
                        emphasis: {
                            focus: 'series'
                        },
                        data: [320, 132, 201, 334, 190, 130]
                    }
                ]
            };
            this.chart.setOption(option);
        },
        updateChart() {
            const baseVulnerability = 100;
            // 增加每个安全措施的具体影响系数
            const measures = {
                trafficClean: { reduction: 15, increase: 8 },
                deviceIsolation: { reduction: 12, increase: 6 },
                threatBlock: { reduction: 20, increase: 10 },
                assetProtection: { reduction: 18, increase: 9 },
                securityAudit: { reduction: 16, increase: 7 }
            };

            let totalReduction = 0;
            let totalIncrease = 0;

            // 计算每个安全措施的影响
            if (this.trafficClean) {
                totalReduction += measures.trafficClean.reduction;
            } else {
                totalIncrease += measures.trafficClean.increase;
            }

            if (this.deviceIsolation) {
                totalReduction += measures.deviceIsolation.reduction;
            } else {
                totalIncrease += measures.deviceIsolation.increase;
            }

            if (this.threatBlock) {
                totalReduction += measures.threatBlock.reduction;
            } else {
                totalIncrease += measures.threatBlock.increase;
            }

            if (this.assetProtection) {
                totalReduction += measures.assetProtection.reduction;
            } else {
                totalIncrease += measures.assetProtection.increase;
            }

            if (this.securityAudit) {
                totalReduction += measures.securityAudit.reduction;
            } else {
                totalIncrease += measures.securityAudit.increase;
            }

            // 添加随机波动
            const randomFluctuation = (Math.random() - 0.5) * 5;

            // 计算新的漏洞数量
            let newVulnerability = baseVulnerability - totalReduction + totalIncrease + randomFluctuation;

            // 确保漏洞数量在合理范围内
            newVulnerability = Math.max(0, Math.min(100, Math.round(newVulnerability)));

            // 更新时间标签
            this.currentTime += 5;
            this.timeLabels.push(this.currentTime + 's');

            // 更新数据
            this.vulnerabilityData.push(newVulnerability);

            // 保持最近的20个数据点
            if (this.vulnerabilityData.length > 20) {
                this.vulnerabilityData.shift();
                this.timeLabels.shift();
            }

            // 更新图表配置
            this.chart.setOption({
                backgroundColor: 'transparent',
                title: {
                    text: '漏洞数量实时监控',
                    textStyle: {
                        color: '#fff',
                        fontSize: 16,
                        fontWeight: 'normal'
                    },
                    left: 'center',
                    top: 10
                },
                tooltip: {
                    trigger: 'axis',
                    backgroundColor: 'rgba(16, 36, 64, 0.9)',
                    borderColor: 'rgba(255, 255, 255, 0.1)',
                    textStyle: {
                        color: '#fff'
                    },
                    formatter: (params) => {
                        const data = params[0];
                        return `时间：${this.timeLabels[data.dataIndex]}<br/>漏洞数量：${data.value}`;
                    },
                    axisPointer: {
                        type: 'line',
                        lineStyle: {
                            color: 'rgba(255, 255, 255, 0.2)'
                        }
                    }
                },
                grid: {
                    top: '15%',
                    left: '3%',
                    right: '4%',
                    bottom: '3%',
                    containLabel: true
                },
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    data: this.timeLabels,
                    axisLine: {
                        lineStyle: {
                            color: 'rgba(255, 255, 255, 0.2)'
                        }
                    },
                    axisLabel: {
                        color: 'rgba(255, 255, 255, 0.7)',
                        fontSize: 12
                    },
                    splitLine: {
                        show: true,
                        lineStyle: {
                            color: 'rgba(255, 255, 255, 0.1)',
                            type: 'dashed'
                        }
                    }
                },
                yAxis: {
                    type: 'value',
                    name: '漏洞数量',
                    nameTextStyle: {
                        color: 'rgba(255, 255, 255, 0.7)',
                        fontSize: 12
                    },
                    min: 0,
                    max: 100,
                    interval: 20,
                    axisLine: {
                        lineStyle: {
                            color: 'rgba(255, 255, 255, 0.2)'
                        }
                    },
                    axisLabel: {
                        color: 'rgba(255, 255, 255, 0.7)',
                        fontSize: 12,
                        formatter: '{value}'
                    },
                    splitLine: {
                        lineStyle: {
                            color: 'rgba(255, 255, 255, 0.1)',
                            type: 'dashed'
                        }
                    }
                },
                series: [
                    {
                        name: '漏洞数量',
                        type: 'line',
                        data: this.vulnerabilityData,
                        smooth: true,
                        symbol: 'circle',
                        symbolSize: 8,
                        itemStyle: {
                            color: '#00ff88'
                        },
                        lineStyle: {
                            color: {
                                type: 'linear',
                                x: 0,
                                y: 0,
                                x2: 0,
                                y2: 1,
                                colorStops: [{
                                    offset: 0,
                                    color: '#00ff88'
                                }, {
                                    offset: 1,
                                    color: '#00a1ff'
                                }],
                            },
                            width: 3,
                            shadowColor: 'rgba(0, 255, 136, 0.5)',
                            shadowBlur: 10
                        },
                        areaStyle: {
                            color: {
                                type: 'linear',
                                x: 0,
                                y: 0,
                                x2: 0,
                                y2: 1,
                                colorStops: [{
                                    offset: 0,
                                    color: 'rgba(0, 255, 136, 0.3)'
                                }, {
                                    offset: 1,
                                    color: 'rgba(0, 161, 255, 0.1)'
                                }],
                            }
                        },
                        emphasis: {
                            itemStyle: {
                                color: '#fff',
                                borderColor: '#00ff88',
                                borderWidth: 2,
                                shadowColor: 'rgba(0, 255, 136, 0.5)',
                                shadowBlur: 10
                            }
                        },
                        markLine: {
                            silent: true,
                            lineStyle: {
                                color: '#ff4d4f'
                            },
                            data: [{
                                yAxis: 80,
                                name: '高危警戒线'
                            }]
                        },
                        markArea: {
                            silent: true,
                            itemStyle: {
                                color: 'rgba(255, 77, 79, 0.1)'
                            },
                            data: [[{
                                yAxis: 80,
                                name: '高危区域'
                            }, {
                                yAxis: 100
                            }]]
                        }
                    }
                ]
            });
        },
        startTimer() {
            this.timer = setInterval(() => {
                this.updateChart();
            }, 3000);
        },
        initBackgroundEffect() {
            const canvas = document.createElement('canvas');
            canvas.style.position = 'absolute';
            canvas.style.top = '0';
            canvas.style.left = '0';
            canvas.style.width = '100%';
            canvas.style.height = '100%';
            canvas.style.zIndex = '0';
            canvas.style.opacity = '0.3';
            document.getElementById('app1').prepend(canvas);

            const ctx = canvas.getContext('2d');
            const particles = [];

            function resize() {
                canvas.width = canvas.offsetWidth;
                canvas.height = canvas.offsetHeight;
            }
            resize();
            window.addEventListener('resize', resize);

            class Particle {
                constructor() {
                    this.reset();
                }

                reset() {
                    this.x = Math.random() * canvas.width;
                    this.y = Math.random() * canvas.height;
                    this.size = Math.random() * 2 + 1;
                    this.speedX = (Math.random() - 0.5) * 0.5;
                    this.speedY = (Math.random() - 0.5) * 0.5;
                }

                update() {
                    this.x += this.speedX;
                    this.y += this.speedY;

                    if (this.x > canvas.width || this.x < 0 ||
                        this.y > canvas.height || this.y < 0) {
                        this.reset();
                    }
                }

                draw() {
                    ctx.beginPath();
                    ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
                    ctx.fillStyle = 'rgba(255, 255, 255, 0.5)';
                    ctx.fill();
                }
            }

            for (let i = 0; i < 50; i++) {
                particles.push(new Particle());
            }

            function animate() {
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                particles.forEach(particle => {
                    particle.update();
                    particle.draw();
                });
                requestAnimationFrame(animate);
            }
            animate();
        }
    },
    beforeDestroy() {
        if (this.chart) {
            this.chart.dispose();
        }
        if (this.timer) {
            clearInterval(this.timer);
        }
        if (this.time) {
            clearTimeout(this.timer);
        }
    },
};
</script>
<style lang="scss" scoped>
.container-div {
    height: calc(100vh - 84px);
    overflow-y: auto;
    padding: 0;
    background: transparent;
    overflow-y: auto;
}

#app1 {
    min-height: 100%;
    width: 100%;
    background: linear-gradient(135deg, #0a192f 0%, #0d1b2a 100%);
    position: relative;
    padding: 20px;
    box-sizing: border-box;

    &::before {
        content: '';
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background:
            linear-gradient(90deg, rgba(24, 144, 255, 0.1) 1px, transparent 1px),
            linear-gradient(rgba(24, 144, 255, 0.1) 1px, transparent 1px);
        background-size: 30px 30px;
        mask-image: radial-gradient(circle at 50% 50%, black, transparent 80%);
        z-index: 1;
        animation: grid-animation 20s linear infinite;
        pointer-events: none;
    }

    &::after {
        content: '';
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: radial-gradient(circle at 50% 50%, rgba(24, 144, 255, 0.1), transparent 80%);
        z-index: 2;
        pointer-events: none;
    }
}

.header-stats {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: 20px;
    margin-bottom: 30px;
    position: relative;
    z-index: 3;
    width: 100%;

    .stat-item {
        background: rgba(16, 36, 64, 0.8);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(24, 144, 255, 0.2);
        border-radius: 12px;
        padding: 20px;
        text-align: center;
        transition: all 0.3s ease;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);

        &:hover {
            transform: translateY(-5px);
            border-color: rgba(24, 144, 255, 0.5);
            box-shadow: 0 12px 48px rgba(24, 144, 255, 0.2);
        }

        .stat-value {
            font-size: 32px;
            font-weight: bold;
            color: #1890ff;
            margin-bottom: 8px;
            text-shadow: 0 0 10px rgba(24, 144, 255, 0.3);
        }

        .stat-label {
            color: rgba(255, 255, 255, 0.8);
            font-size: 14px;
        }
    }
}

.protection-groups {
    position: relative;
    z-index: 3;
    margin-bottom: 30px;
    width: 100%;

    .group-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;

        h2 {
            color: #fff;
            font-size: 24px;
            margin: 0;
        }
    }

    .cards {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
        gap: 20px;
        width: 100%;

        .card {
            background: rgba(16, 36, 64, 0.8);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            padding: 20px;
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.1);
            position: relative;
            overflow: hidden;

            .card-content {
                display: flex;
                flex-direction: column;
                height: 100%;
            }

            .stats-container {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
                margin: 15px 0;
                opacity: 0;
                height: 0;
                transition: all 0.3s ease;

                &.active {
                    opacity: 1;
                    height: auto;
                    margin: 15px 0;
                }

                .stat-box {
                    background: rgba(13, 27, 42, 0.6);
                    border-radius: 8px;
                    padding: 12px;
                    text-align: center;

                    .stat-value {
                        color: #00ff9d;
                        font-size: 20px;
                        font-weight: 500;
                        margin-bottom: 4px;
                        font-family: Monaco, monospace;
                    }

                    .stat-label {
                        color: rgba(255, 255, 255, 0.7);
                        font-size: 12px;
                    }
                }
            }

            .tip {
                color: #fff;
                font-size: 16px;
                margin-bottom: 10px;
                font-weight: 500;
            }

            .second-text {
                color: rgba(255, 255, 255, 0.6);
                font-size: 14px;
                line-height: 1.5;
                margin-bottom: 15px;
            }

            .card-footer {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: auto;
            }

            &::before {
                content: '';
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background: linear-gradient(45deg,
                        transparent,
                        rgba(255, 255, 255, 0.1),
                        transparent);
                transform: rotate(45deg);
                animation: shine 3s infinite;
            }

            &:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 48px rgba(24, 144, 255, 0.2);
            }

            .icon-container {
                display: flex;
                justify-content: center;
                align-items: center;
                height: 120px;
                margin: 15px 0;
                border-radius: 8px;
                background: rgba(255, 255, 255, 0.05);
                transition: all 0.3s ease;

                &.active {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 15px;
                    padding: 10px;

                    .data-item {
                        text-align: center;
                        padding: 10px;
                        background: rgba(13, 27, 42, 0.6);
                        border-radius: 6px;

                        .value {
                            font-size: 24px;
                            color: #00ff9d;
                            font-family: Monaco, monospace;
                            margin-bottom: 5px;
                        }

                        .label {
                            font-size: 12px;
                            color: rgba(255, 255, 255, 0.7);
                        }
                    }
                }

                i {
                    font-size: 48px;
                    color: rgba(255, 255, 255, 0.8);
                    transition: all 0.3s ease;
                }
            }

            &.purple {
                border-color: rgba(149, 104, 255, 0.3);
            }

            &.brown {
                border-color: rgba(255, 191, 0, 0.3);
            }

            &.red {
                border-color: rgba(255, 77, 79, 0.3);
            }

            &.blue {
                border-color: rgba(24, 144, 255, 0.3);
            }

            &.green {
                border-color: rgba(82, 196, 26, 0.3);
            }

            &.purple .icon-container:hover i {
                color: #9d6eff;
            }

            &.brown .icon-container:hover i {
                color: #ffbf00;
            }

            &.red .icon-container:hover i {
                color: #ff4d4f;
            }

            &.blue .icon-container:hover i {
                color: #1890ff;
            }

            &.green .icon-container:hover i {
                color: #52c41a;
            }
        }
    }
}

.recent-events {
    position: relative;
    z-index: 3;
    background: rgba(13, 27, 42, 0.6);
    border-radius: 8px;
    padding: 20px;
    margin-bottom: 30px;
    width: 100%;
    min-height: 200px;
    overflow-y: auto;

    .event-table {
        width: 100%;
        border-spacing: 0;
        border-collapse: separate;

        tr {
            width: 100%;
            transition: all 0.3s;

            &:hover {
                background: rgba(16, 36, 64, 0.6);
            }

            td {
                padding: 12px 16px;
                border-bottom: 1px solid rgba(255, 255, 255, 0.05);
                color: #ffffff;
                font-size: 14px;

                &:first-child {
                    color: #00ff9d;
                    width: 100px;
                    font-family: Monaco, monospace;
                }

                &:nth-child(2) {
                    width: 100px;
                    color: rgba(255, 255, 255, 0.7);
                }

                &:last-child {
                    text-align: right;
                    width: 80px;
                    color: #00ff9d;
                }
            }
        }
    }

    .group-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;

        h2 {
            color: #fff;
            font-size: 16px;
            margin: 0;
            font-weight: normal;
        }

        .clear-btn {
            color: #00ff9d;
            font-size: 14px;
            cursor: pointer;
            background: none;
            border: none;
            padding: 0;

            &:hover {
                opacity: 0.8;
            }
        }
    }
}

.chart-container {
    position: relative;
    z-index: 3;
    background: rgba(16, 36, 64, 0.8);
    backdrop-filter: blur(10px);
    border-radius: 12px;
    padding: 20px;
    border: 1px solid rgba(255, 255, 255, 0.1);
    width: 100%;
    margin-bottom: 20px;

    .group-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;

        h2 {
            color: #fff;
            font-size: 24px;
            margin: 0;
        }
    }

    .chart {
        height: 350px;
        width: 100%;
    }
}

// 添加响应式布局
@media screen and (max-width: 1400px) {
    .cards {
        grid-template-columns: repeat(3, 1fr);
    }
}

@media screen and (max-width: 1200px) {
    .cards {
        grid-template-columns: repeat(2, 1fr);
    }

    .header-stats {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media screen and (max-width: 768px) {
    .cards {
        grid-template-columns: 1fr;
    }

    .header-stats {
        grid-template-columns: 1fr;
    }

    #app1 {
        padding: 10px;
    }
}

@keyframes grid-animation {
    0% {
        transform: translateY(0);
    }

    100% {
        transform: translateY(30px);
    }
}

@keyframes shine {
    0% {
        transform: rotate(45deg) translateX(-100%);
    }

    100% {
        transform: rotate(45deg) translateX(100%);
    }
}

:deep(.el-switch__core) {
    background: rgba(255, 255, 255, 0.1) !important;
    border-color: rgba(255, 255, 255, 0.2) !important;
}

:deep(.el-switch.is-checked .el-switch__core) {
    background: #1890ff !important;
    border-color: #1890ff !important;
}

:deep(.el-timeline-item__node) {
    background-color: #1890ff;
}

:deep(.el-timeline-item__wrapper) {
    padding-left: 28px;
}

:deep(.el-timeline-item__content) {
    color: rgba(255, 255, 255, 0.8);
}

:deep(.el-timeline-item__timestamp) {
    color: rgba(255, 255, 255, 0.5);
}

:deep(.el-radio-button__inner) {
    background: rgba(16, 36, 64, 0.8);
    border-color: rgba(255, 255, 255, 0.1);
    color: rgba(255, 255, 255, 0.8);

    &:hover {
        color: #1890ff;
    }
}

:deep(.el-radio-button__orig-radio:checked + .el-radio-button__inner) {
    background-color: #1890ff;
    border-color: #1890ff;
    box-shadow: -1px 0 0 0 #1890ff;
    color: #fff;
}

.warning-particle {
    position: absolute;
    width: 4px;
    height: 4px;
    background: #ff4d4f;
    border-radius: 50%;
    pointer-events: none;
    z-index: 10;
    animation: particle-rise 2s ease-out forwards;
    box-shadow: 0 0 10px #ff4d4f;
}

@keyframes particle-rise {
    0% {
        transform: translateY(0) scale(1);
        opacity: 1;
    }

    100% {
        transform: translateY(-100px) scale(0);
        opacity: 0;
    }
}
</style>