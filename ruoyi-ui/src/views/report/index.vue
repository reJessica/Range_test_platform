<template>
    <div class="container-div">
        <div id="app1">
            <div class="header-stats">
                <div class="stat-item">
                    <div class="stat-value">{{ totalScans }}</div>
                    <div class="stat-label">总扫描次数</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">{{ vulnerabilitiesFound }}</div>
                    <div class="stat-label">发现漏洞</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">{{ fixedVulnerabilities }}</div>
                    <div class="stat-label">已修复漏洞</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">{{ scanTime }}s</div>
                    <div class="stat-label">平均扫描时间</div>
                </div>
            </div>

            <div class="scan-section">
                <div class="group-header">
                    <h2>漏洞扫描</h2>
                </div>
                <div class="input-group">
                    <input class="input" id="scanUrl" v-model="scanUrl" placeholder="请输入网址" autocomplete="off">
                    <button class="button--submit" @click="startScan">开始扫描</button>
                </div>
            </div>

            <div class="vulnerability-reports">
                <div class="group-header">
                    <h2>漏洞报告</h2>
                    <button class="clear-btn" @click="clearReports">清空记录</button>
                </div>
                <div class="report-list">
                    <div v-for="(report, index) in reports" :key="index" class="report-item">
                        <div class="report-header">
                            <span class="report-time">{{ report.time }}</span>
                            <span :class="['threat-level', report.level]">{{ report.level }}</span>
                        </div>
                        <div class="report-content">
                            <p>{{ report.content }}</p>
                        </div>
                        <div class="report-footer">
                            <a :href="report.detailLink" target="_blank" class="detail-link">查看详情</a>
                            <button :class="['fix-button', { 'fixed': report.fixed }]" @click="fixVulnerability(index)"
                                :disabled="report.fixed">
                                {{ report.fixed ? '已修复' : '修复漏洞' }}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            scanUrl: '',
            totalScans: 0,
            vulnerabilitiesFound: 0,
            fixedVulnerabilities: 0,
            scanTime: 0,
            reports: []
        }
    },

    methods: {
        startScan() {
            // 增加扫描次数
            this.totalScans++;

            // 模拟扫描过程
            const scanStartTime = Date.now();

            // 生成新的漏洞报告
            const newReport = {
                time: new Date().toLocaleString(),
                level: this.getRandomLevel(),
                content: this.generateReportContent(),
                detailLink: 'https://mc.tencent.com/VlOj5BWX',
                fixed: false
            };

            // 添加到报告列表
            this.reports.unshift(newReport);

            // 更新统计数据
            this.vulnerabilitiesFound++;
            this.scanTime = ((Date.now() - scanStartTime) / 1000).toFixed(1);

            // 跳转到报告页面
            window.open('/report-with-ground/Report2.html', '_blank');
        },

        fixVulnerability(index) {
            this.reports[index].fixed = true;
            this.fixedVulnerabilities++;
        },

        clearReports() {
            this.reports = [];
            this.vulnerabilitiesFound = 0;
            this.fixedVulnerabilities = 0;
        },

        getRandomLevel() {
            const levels = ['高危', '中危', '低危'];
            return levels[Math.floor(Math.random() * levels.length)];
        },

        generateReportContent() {
            const timestamp = new Date().toLocaleString('zh-CN', { timeZone: 'Asia/Shanghai' });
            return `【网盾探隅】尊敬的用户，您好！您的网盾探隅账号（账号ID：${100037860928 + this.totalScans}，昵称：${100037860928 + this.totalScans}）下的服务器： [LAMP-HDaW]，实例ID：lhins-1whv7nuower，地域：华北地区 (北京)，时间：${timestamp}，检测到存在应急漏洞：Redis 缓冲区溢出漏洞（CVE-2024-31449），威胁等级：高危，目前系统已自动修复漏洞。`;
        }
    }
}
</script>

<style lang="scss" scoped>
.container-div {
    height: calc(100vh - 84px);
    overflow-y: auto;
    padding: 0;
    background: transparent;
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

    .stat-item {
        background: rgba(16, 36, 64, 0.8);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(24, 144, 255, 0.2);
        border-radius: 12px;
        padding: 20px;
        text-align: center;
        transition: all 0.3s ease;

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
        }

        .stat-label {
            color: rgba(255, 255, 255, 0.8);
            font-size: 14px;
        }
    }
}

.scan-section {
    position: relative;
    z-index: 3;
    background: rgba(16, 36, 64, 0.8);
    backdrop-filter: blur(10px);
    border-radius: 12px;
    padding: 20px;
    margin-bottom: 30px;
    border: 1px solid rgba(24, 144, 255, 0.2);

    .group-header {
        margin-bottom: 20px;

        h2 {
            color: #fff;
            font-size: 24px;
            margin: 0;
        }
    }

    .input-group {
        display: flex;
        gap: 10px;

        .input {
            flex: 1;
            min-height: 50px;
            padding: 0 1rem;
            color: #fff;
            font-size: 15px;
            border: 1px solid rgba(24, 144, 255, 0.3);
            border-radius: 6px;
            background-color: rgba(13, 27, 42, 0.6);

            &:focus {
                border-color: #1890ff;
                outline: none;
            }
        }

        .button--submit {
            min-height: 50px;
            padding: .5em 2em;
            border: none;
            border-radius: 6px;
            background-color: #1890ff;
            color: #fff;
            font-size: 15px;
            cursor: pointer;
            transition: all 0.3s ease;

            &:hover {
                background-color: #40a9ff;
                transform: translateY(-2px);
            }
        }
    }
}

.vulnerability-reports {
    position: relative;
    z-index: 3;
    background: rgba(16, 36, 64, 0.8);
    backdrop-filter: blur(10px);
    border-radius: 12px;
    padding: 20px;
    border: 1px solid rgba(24, 144, 255, 0.2);

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

        .clear-btn {
            color: #00ff9d;
            background: none;
            border: none;
            cursor: pointer;
            font-size: 14px;
            padding: 8px 16px;
            border-radius: 4px;
            transition: all 0.3s ease;

            &:hover {
                background: rgba(0, 255, 157, 0.1);
            }
        }
    }

    .report-list {
        .report-item {
            background: rgba(13, 27, 42, 0.6);
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 15px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;

            &:hover {
                transform: translateY(-2px);
                border-color: rgba(24, 144, 255, 0.3);
            }

            .report-header {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;

                .report-time {
                    color: #00ff9d;
                    font-family: Monaco, monospace;
                }

                .threat-level {
                    padding: 4px 8px;
                    border-radius: 4px;
                    font-size: 12px;

                    &.高危 {
                        background: rgba(255, 77, 79, 0.2);
                        color: #ff4d4f;
                    }

                    &.中危 {
                        background: rgba(250, 173, 20, 0.2);
                        color: #faad14;
                    }

                    &.低危 {
                        background: rgba(24, 144, 255, 0.2);
                        color: #1890ff;
                    }
                }
            }

            .report-content {
                color: rgba(255, 255, 255, 0.8);
                font-size: 14px;
                line-height: 1.6;
                margin-bottom: 15px;
            }

            .report-footer {
                display: flex;
                justify-content: space-between;
                align-items: center;

                .detail-link {
                    color: #1890ff;
                    text-decoration: none;
                    font-size: 14px;
                    transition: all 0.3s ease;

                    &:hover {
                        color: #40a9ff;
                    }
                }

                .fix-button {
                    padding: 6px 16px;
                    border-radius: 4px;
                    border: none;
                    cursor: pointer;
                    font-size: 14px;
                    transition: all 0.3s ease;
                    background: #1890ff;
                    color: #fff;

                    &:hover:not(:disabled) {
                        background: #40a9ff;
                        transform: translateY(-2px);
                    }

                    &.fixed {
                        background: #52c41a;
                        cursor: default;
                    }

                    &:disabled {
                        opacity: 0.7;
                        cursor: not-allowed;
                    }
                }
            }
        }
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

@media screen and (max-width: 1200px) {
    .header-stats {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media screen and (max-width: 768px) {
    .header-stats {
        grid-template-columns: 1fr;
    }

    #app1 {
        padding: 10px;
    }

    .input-group {
        flex-direction: column;
    }
}
</style>