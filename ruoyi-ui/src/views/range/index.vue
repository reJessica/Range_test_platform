<template>
  <div class="app-container">
    <!-- 背景动画效果 -->
    <div class="cyber-background">
      <div class="grid"></div>
      <div class="circles">
        <div v-for="i in 10" :key="i" class="circle"></div>
      </div>
    </div>

    <!-- 顶部统计卡片 -->
    <el-row :gutter="20" class="stat-cards">
      <el-col :span="6" v-for="(stat, index) in statistics" :key="index">
        <el-card shadow="hover" class="stat-card" :class="stat.type">
          <div class="stat-content">
            <div class="stat-icon">
              <i :class="stat.icon"></i>
              <div class="pulse-ring"></div>
            </div>
            <div class="stat-info">
              <div class="stat-value">
                <count-to
                  :start-val="0"
                  :end-val="stat.value"
                  :duration="2000"
                  :decimals="stat.decimals || 0"
                  separator=","
                />
                <span class="stat-unit" v-if="stat.unit">{{ stat.unit }}</span>
              </div>
              <div class="stat-label">{{ stat.label }}</div>
              <div class="stat-trend" v-if="stat.trend">
                <i :class="stat.trend > 0 ? 'el-icon-top' : 'el-icon-bottom'"></i>
                <span>{{ Math.abs(stat.trend) }}%</span>
              </div>
            </div>
          </div>
          <div class="stat-chart" v-if="stat.chartData">
            <mini-line-chart :data="stat.chartData" :color="stat.chartColor" />
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 主要内容区域 -->
    <el-row :gutter="20" style="margin-top: 20px;">
      <!-- 左侧场景列表 -->
      <el-col :span="8">
        <el-card class="scene-list cyber-card">
          <div slot="header" class="clearfix">
            <span class="cyber-text">攻防场景</span>
            <div class="cyber-controls">
              <el-button-group>
                <el-tooltip content="新建场景" placement="top">
                  <el-button size="mini" type="primary" @click="handleAddScene" class="cyber-button">
                    <i class="el-icon-plus"></i>
                  </el-button>
                </el-tooltip>
                <el-tooltip content="刷新列表" placement="top">
                  <el-button size="mini" type="info" @click="refreshScenes" class="cyber-button">
                    <i class="el-icon-refresh"></i>
                  </el-button>
                </el-tooltip>
                <el-tooltip content="批量操作" placement="top">
                  <el-button size="mini" type="warning" @click="handleBatchOperation" class="cyber-button">
                    <i class="el-icon-s-operation"></i>
                  </el-button>
                </el-tooltip>
              </el-button-group>
            </div>
          </div>
          
          <div class="scene-grid">
            <div v-for="scene in sceneList" 
              :key="scene.id" 
              class="range-card" 
              :class="{'running': scene.status === 'running', 'selected': currentScene && currentScene.id === scene.id}"
              @click="handleSceneSelect(scene)"
            >
              <div class="range-header">
                <div class="range-title">
                  <div class="scene-avatar">
                    <el-avatar 
                      :size="40" 
                      :src="scene.icon || defaultIcon"
                      class="cyber-avatar"
                    >
                      <i :class="getSceneTypeIcon(scene.type)"></i>
                    </el-avatar>
                    <div class="avatar-ring"></div>
                  </div>
                  <div class="scene-info">
                    <div class="scene-title">
                      {{ scene.name }}
                      <el-tag 
                        size="mini" 
                        :type="getSceneTypeTag(scene.type)"
                        class="scene-type-tag"
                      >
                        {{ getSceneTypeName(scene.type) }}
                      </el-tag>
                    </div>
                    <div class="scene-desc">{{ scene.description }}</div>
                  </div>
                </div>
                <div class="range-actions">
                  <el-tooltip :content="scene.status === 'running' ? '停止' : '启动'" placement="top">
                    <el-button
                      :type="scene.status === 'running' ? 'danger' : 'success'"
                      size="mini"
                      circle
                      class="cyber-button"
                      @click.stop="handleSceneAction(scene)"
                    >
                      <i :class="scene.status === 'running' ? 'el-icon-video-pause' : 'el-icon-video-play'"></i>
                    </el-button>
                  </el-tooltip>
                  <el-tooltip content="场景监控" v-if="scene.status === 'running'">
                    <el-button
                      type="warning"
                      size="mini"
                      circle
                      class="cyber-button"
                      @click.stop="handleMonitor(scene)"
                    >
                      <i class="el-icon-monitor"></i>
                    </el-button>
                  </el-tooltip>
                  <el-tooltip content="编辑" placement="top">
                    <el-button
                      type="primary"
                      size="mini"
                      circle
                      class="cyber-button"
                      @click.stop="handleEditScene(scene)"
                    >
                      <i class="el-icon-edit"></i>
                    </el-button>
                  </el-tooltip>
                  <el-tooltip content="删除" placement="top">
                    <el-button
                      type="danger"
                      size="mini"
                      circle
                      class="cyber-button"
                      @click.stop="handleDeleteScene(scene)"
                    >
                      <i class="el-icon-delete"></i>
                    </el-button>
                  </el-tooltip>
                </div>
              </div>
              <div class="range-content">
                <div class="status-bar">
                  <span class="status-dot" :class="scene.status"></span>
                  <span class="status-text">{{ getStatusText(scene.status) }}</span>
                </div>
                <div class="progress-bar">
                  <div class="progress-info">
                    <span class="progress-text">攻击进度</span>
                    <span class="progress-percentage">{{ scene.progress }}%</span>
                  </div>
                  <el-progress 
                    :percentage="scene.progress"
                    :status="getProgressStatus(scene.progress)"
                    :stroke-width="8"
                    class="cyber-progress"
                  >
                    <div class="progress-steps">
                      <div 
                        v-for="(step, index) in progressSteps" 
                        :key="index"
                        class="step-dot"
                        :class="{ active: scene.progress >= (index + 1) * 20 }"
                      ></div>
                    </div>
                  </el-progress>
                </div>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>

      <!-- 右侧详情和监控 -->
      <el-col :span="16">
        <div v-if="currentScene">
          <!-- 场景详情卡片 -->
          <el-card class="detail-card cyber-card">
            <div class="cyber-header">
              <div class="header-left">
                <div class="scene-avatar">
                  <el-avatar 
                    :size="50" 
                    :src="currentScene.icon || defaultIcon"
                    class="cyber-avatar"
                  >
                    <i :class="getSceneTypeIcon(currentScene.type)"></i>
                  </el-avatar>
                  <div class="avatar-ring"></div>
                </div>
                <div class="scene-info">
                  <div class="scene-title">
                    <span>{{ currentScene.name }}</span>
                    <el-tag 
                      size="small" 
                      :type="getSceneTypeTag(currentScene.type)"
                      class="scene-type-tag"
                    >
                      {{ getSceneTypeName(currentScene.type) }}
                    </el-tag>
                    <el-tag
                      size="small"
                      :type="getStatusType(currentScene.status)"
                      class="status-tag"
                    >
                      <i class="el-icon-video-play" v-if="currentScene.status === 'running'"></i>
                      <i class="el-icon-video-pause" v-else></i>
                      {{ getStatusText(currentScene.status) }}
                    </el-tag>
                  </div>
                  <div class="scene-desc">{{ currentScene.description }}</div>
                </div>
              </div>
              <div class="header-right">
                <div class="cyber-button-group">
                  <el-button 
                    :type="currentScene.status === 'running' ? 'danger' : 'success'"
                    size="small"
                    class="cyber-button"
                    @click="handleSceneAction(currentScene)"
                  >
                    <i :class="currentScene.status === 'running' ? 'el-icon-video-pause' : 'el-icon-video-play'"></i>
                    {{ currentScene.status === 'running' ? '停止' : '启动' }}
                  </el-button>
                  <el-button
                    type="warning"
                    size="small"
                    class="cyber-button"
                    v-if="currentScene.status === 'running'"
                    @click="handleMonitor(currentScene)"
                  >
                    <i class="el-icon-monitor"></i>
                    监控
                  </el-button>
                  <el-button
                    type="primary"
                    size="small"
                    class="cyber-button"
                    @click="handleEditScene(currentScene)"
                  >
                    <i class="el-icon-edit"></i>
                    编辑
                  </el-button>
                </div>
              </div>
            </div>

            <div class="cyber-content">
              <div class="info-section">
                <div class="section-title">
                  <i class="el-icon-info"></i>
                  基本信息
                </div>
                <div class="info-grid">
                  <div class="info-item">
                    <div class="item-label">创建时间</div>
                    <div class="item-value">{{ currentScene.createTime }}</div>
                  </div>
                  <div class="info-item">
                    <div class="item-label">难度等级</div>
                    <div class="item-value">
                      <el-rate
                        v-model="currentScene.difficulty"
                        disabled
                        show-score
                        text-color="#ff9900"
                        class="cyber-rate"
                      ></el-rate>
                    </div>
                  </div>
                  <div class="info-item">
                    <div class="item-label">Docker镜像</div>
                    <div class="item-value">
                      <el-tag size="small" type="info" class="cyber-tag">
                        {{ currentScene.image }}
                      </el-tag>
                    </div>
                  </div>
                  <div class="info-item">
                    <div class="item-label">运行时长</div>
                    <div class="item-value">{{ getRunningTime(currentScene) }}</div>
                  </div>
                </div>
              </div>

              <div class="progress-section">
                <div class="section-title">
                  <i class="el-icon-aim"></i>
                  攻击目标进度
                </div>
                <div class="progress-timeline">
                  <div class="timeline-track"></div>
                  <div class="timeline-nodes">
                    <div 
                      v-for="(step, index) in progressSteps" 
                      :key="index"
                      class="timeline-node"
                      :class="{
                        'completed': currentScene.progress > index * 20,
                        'current': currentScene.progress > index * 20 && currentScene.progress <= (index + 1) * 20,
                        'pending': currentScene.progress <= index * 20
                      }"
                    >
                      <div class="node-icon">
                        <i :class="currentScene.progress > index * 20 ? 'el-icon-check' : step.icon"></i>
                      </div>
                      <div class="node-content">
                        <div class="node-title">{{ step.title }}</div>
                        <div class="node-desc">{{ step.description }}</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- 操作日志 -->
              <el-card class="log-card gradient-bg">
                <div class="log-header">
                  <div class="log-title">
                    <i class="el-icon-document"></i>
                    操作日志
                  </div>
                  <div class="log-controls">
                    <el-button-group>
                      <el-tooltip content="刷新日志" placement="top">
                        <el-button size="small" type="info" @click="refreshLogs">
                          <i class="el-icon-refresh"></i>刷新日志
                        </el-button>
                      </el-tooltip>
                      <el-tooltip content="清除日志" placement="top">
                        <el-button size="small" type="danger" @click="clearLogs">
                          <i class="el-icon-delete"></i>清除日志
                        </el-button>
                      </el-tooltip>
                    </el-button-group>
                  </div>
                </div>
                <div class="log-content">
                  <div class="log-item" v-for="(log, index) in systemLogs" :key="index">
                    <div class="log-time">{{ log.time }}</div>
                    <div class="log-type">{{ log.type }}</div>
                    <div class="log-message">{{ log.message }}</div>
                  </div>
                </div>
              </el-card>

              
            </div>
          </el-card>

          <!-- 监控卡片 -->
          <el-card class="monitor-card cyber-card" v-if="currentScene.status === 'running'">
            <div slot="header" class="cyber-card-header">
              <div class="monitor-title">
                <i class="el-icon-monitor"></i>
                <span class="title-text">实时监控</span>
                <el-tag size="small" type="success" effect="dark" class="cyber-tag">
                  <i class="el-icon-video-play"></i> 运行中
                </el-tag>
              </div>
              <div class="cyber-button-group">
                <el-button size="small" class="cyber-button refresh-btn" @click="refreshMonitorData">
                  <i class="el-icon-refresh"></i>刷新数据
                </el-button>
                <el-button size="small" class="cyber-button detail-btn">
                  <i class="el-icon-view"></i>查看详情
                </el-button>
              </div>
            </div>

            <div class="monitor-content">
              <div class="monitor-grid">
                <div class="monitor-item" v-for="(metric, index) in monitorMetrics" :key="index">
                  <div class="item-label">
                    <i :class="getMetricIcon(metric.title)"></i>
                    {{ metric.title }}
                  </div>
                  <div class="item-value">
                    {{ metric.value }}<small>{{ metric.unit }}</small>
                  </div>
                  <div class="monitor-trend" :class="{ 'up': metric.trend > 0, 'down': metric.trend < 0 }">
                    <i :class="metric.trend > 0 ? 'el-icon-top' : 'el-icon-bottom'"></i>
                    {{ Math.abs(metric.trend) }}%
                  </div>
                </div>
              </div>

              <div class="network-chart">
                <div class="chart-toolbar">
                  <div class="toolbar-left">
                    <span class="time-select" :class="{ active: timeRange === '1h' }" @click="setTimeRange('1h')">1小时</span>
                    <span class="time-select" :class="{ active: timeRange === '6h' }" @click="setTimeRange('6h')">6小时</span>
                    <span class="time-select" :class="{ active: timeRange === '24h' }" @click="setTimeRange('24h')">24小时</span>
                  </div>
                  <div class="toolbar-right">
                    <span class="refresh-time">
                      <i class="el-icon-time"></i>
                      最后更新: {{ lastUpdateTime }}
                    </span>
                  </div>
                </div>

                <div class="chart-container" ref="networkChart"></div>

                <div class="chart-footer">
                  <div class="total-stats">
                    <div class="stat-item">
                      <div class="stat-label">总流入</div>
                      <div class="stat-value">
                        <i class="el-icon-top up"></i>
                        2.5 GB
                      </div>
                    </div>
                    <div class="stat-item">
                      <div class="stat-label">总流出</div>
                      <div class="stat-value">
                        <i class="el-icon-bottom down"></i>
                        1.8 GB
                      </div>
                    </div>
                  </div>
                  <div class="export-btn">
                    <i class="el-icon-download"></i>
                    导出数据
                  </div>
                </div>
              </div>
            </div>
          </el-card>
        </div>
        <div v-else class="empty-scene cyber-empty">
          <div class="empty-content">
            <i class="el-icon-monitor"></i>
            <p>请选择一个场景</p>
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- 新建/编辑场景对话框 -->
    <el-dialog
      :title="dialogType === 'create' ? '新建场景' : '编辑场景'"
      :visible.sync="dialogVisible"
      width="600px"
      class="scene-dialog"
      :close-on-click-modal="false"
      @close="resetForm"
    >
      <el-form :model="sceneForm" :rules="rules" ref="sceneForm" label-width="100px" class="scene-form">
        <el-form-item label="场景名称" prop="name">
          <el-input 
            v-model="sceneForm.name" 
            placeholder="请输入场景名称"
            prefix-icon="el-icon-edit"
          ></el-input>
        </el-form-item>
        
        <el-form-item label="场景描述" prop="description">
          <el-input 
            type="textarea" 
            v-model="sceneForm.description" 
            placeholder="请输入场景描述"
            :rows="4"
            resize="none"
          ></el-input>
        </el-form-item>
        
        <el-form-item label="难度等级" prop="difficulty">
          <el-rate
            v-model="sceneForm.difficulty"
            show-score
            text-color="#ff9900"
            score-template="{value} 星"
            class="scene-rate"
          >
          </el-rate>
        </el-form-item>
        
        <el-form-item label="场景类型" prop="type">
          <el-select 
            v-model="sceneForm.type" 
            placeholder="请选择场景类型"
            class="scene-select"
          >
            <el-option
              v-for="item in sceneTypes"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            >
              <div class="scene-type-option">
                <i :class="item.icon"></i>
                <span>{{ item.label }}</span>
              </div>
            </el-option>
          </el-select>
        </el-form-item>
        
        <el-form-item label="Docker镜像" prop="image">
          <el-select 
            v-model="sceneForm.image" 
            placeholder="请选择Docker镜像"
            class="scene-select"
          >
            <el-option
              v-for="item in dockerImages"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            >
              <div class="scene-image-option">
                <i :class="item.icon"></i>
                <div class="image-info">
                  <span class="image-name">{{ item.label }}</span>
                  <span class="image-desc">{{ item.description }}</span>
                </div>
              </div>
            </el-option>
          </el-select>
        </el-form-item>
        
        <el-divider content-position="left">
          <span class="divider-title">高级配置</span>
        </el-divider>
        
        <div class="advanced-config">
          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="CPU限制">
                <el-input-number
                  v-model="sceneForm.cpu"
                  :min="1"
                  :max="8"
                  controls-position="right"
                  class="resource-input"
                >
                  <template slot="prefix">
                    <i class="el-icon-cpu"></i>
                  </template>
                </el-input-number>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="内存限制">
                <el-input-number
                  v-model="sceneForm.memory"
                  :min="512"
                  :max="8192"
                  :step="256"
                  controls-position="right"
                  class="resource-input"
                >
                  <template slot="prefix">
                    <i class="el-icon-monitor"></i>
                  </template>
                  <template slot="suffix">MB</template>
                </el-input-number>
              </el-form-item>
            </el-col>
          </el-row>
          
          <el-form-item label="端口映射">
            <el-input 
              v-model="sceneForm.ports"
              placeholder="示例: 80:80,443:443"
              class="port-input"
            >
              <template slot="prefix">
                <i class="el-icon-connection"></i>
              </template>
              <template slot="suffix">
                <el-tooltip content="格式：外部端口:内部端口，多个用逗号分隔" placement="top">
                  <i class="el-icon-question"></i>
                </el-tooltip>
              </template>
            </el-input>
          </el-form-item>
        </div>
      </el-form>
      
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="handleCreateScene" :loading="loading">
          {{ dialogType === 'create' ? '创 建' : '保 存' }}
        </el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import * as echarts from 'echarts'
import CountTo from 'vue-count-to'
import MiniLineChart from '@/components/Charts/MiniLineChart'

export default {
  name: 'RangeIndex',
  components: {
    CountTo,
    MiniLineChart
  },
  data() {
    return {
      // 统计数据
      statistics: [
        {
          type: 'total',
          icon: 'el-icon-monitor',
          label: '场景总数',
          value: 25,
          trend: 15,
          chartData: [30, 40, 35, 50, 49, 60, 70, 91, 125, 150],
          chartColor: '#1890ff'
        },
        {
          type: 'running',
          icon: 'el-icon-video-play',
          label: '运行中场景',
          value: 8,
          trend: 20,
          chartData: [20, 25, 22, 30, 35, 40, 45, 50, 55, 60],
          chartColor: '#52c41a'
        },
        {
          type: 'warning',
          icon: 'el-icon-warning',
          label: '异常告警',
          value: 3,
          trend: -5,
          chartData: [10, 8, 12, 6, 9, 3, 5, 4, 3, 2],
          chartColor: '#faad14'
        },
        {
          type: 'success',
          icon: 'el-icon-circle-check',
          label: '完成目标',
          value: 158,
          unit: '个',
          trend: 8,
          chartData: [50, 65, 78, 86, 95, 110, 122, 135, 145, 158],
          chartColor: '#13c2c2'
        }
      ],
      // 场景列表
      sceneList: [
        {
          id: 1,
          name: 'Web漏洞实验环境',
          description: 'DVWA漏洞练习环境',
          status: 'running',
          createTime: '2024-03-15 10:00:00',
          difficulty: 3,
          progress: 2,
          type: 'web',
          image: 'dvwa',
          icon: 'https://www.dvwa.co.uk/favicon.ico'
        },
        {
          id: 2,
          name: '内网渗透训练场景',
          description: 'Metasploitable渗透环境',
          status: 'stopped',
          createTime: '2024-03-15 11:30:00',
          difficulty: 4,
          progress: 3,
          type: 'network',
          image: 'metasploitable'
        }
      ],
      // 当前选中的场景
      currentScene: null,
      // 监控指标
      monitorMetrics: [
        {
          title: 'CPU使用率',
          value: 45,
          unit: '%',
          trend: 5,
          tooltip: 'CPU使用率超过80%将触发告警',
          thresholds: [60, 80, 90],
          icon: 'el-icon-cpu'
        },
        {
          title: '内存使用率',
          value: 60,
          unit: '%',
          trend: -3,
          tooltip: '内存使用率超过85%将触发告警',
          thresholds: [70, 85, 95],
          icon: 'el-icon-monitor'
        },
        {
          title: '磁盘使用率',
          value: 30,
          unit: '%',
          trend: 2,
          tooltip: '磁盘使用率超过90%将触发告警',
          thresholds: [75, 90, 95],
          icon: 'el-icon-hdd'
        }
      ],
      // 网络流量数据
      networkData: {
        inbound: [],
        outbound: [],
        totalIn: '2.5 GB',
        totalOut: '1.8 GB'
      },
      // 最后更新时间
      lastUpdateTime: new Date().toLocaleString(),
      // 系统日志
      systemLogs: [
        {
          time: '10:30:15',
          type: 'info',
          message: '场景启动成功'
        },
        {
          time: '10:30:20',
          type: 'warning',
          message: 'CPU使用率超过80%'
        },
        {
          time: '10:31:00',
          type: 'error',
          message: '容器连接失败'
        }
      ],
      // 场景类型选项
      sceneTypes: [
        {
          label: 'Web应用渗透',
          value: 'web',
          icon: 'el-icon-chrome'
        },
        {
          label: '系统渗透',
          value: 'system',
          icon: 'el-icon-monitor'
        },
        {
          label: '网络攻防',
          value: 'network',
          icon: 'el-icon-connection'
        }
      ],
      // Docker镜像选项
      dockerImages: [
        {
          label: 'DVWA',
          value: 'dvwa',
          icon: 'el-icon-chrome',
          description: '常见Web漏洞练习环境'
        },
        {
          label: 'Metasploitable',
          value: 'metasploitable',
          icon: 'el-icon-monitor',
          description: '综合渗透测试环境'
        },
        {
          label: 'WebGoat',
          value: 'webgoat',
          icon: 'el-icon-chrome',
          description: 'OWASP漏洞训练平台'
        }
      ],
      // 进度步骤
      progressSteps: [
        {
          title: '信息收集',
          icon: 'el-icon-search',
          description: '收集目标信息'
        },
        {
          title: '漏洞扫描',
          icon: 'el-icon-view',
          description: '扫描安全漏洞'
        },
        {
          title: '漏洞利用',
          icon: 'el-icon-warning',
          description: '验证漏洞存在'
        },
        {
          title: '权限提升',
          icon: 'el-icon-top',
          description: '提升访问权限'
        },
        {
          title: '任务完成',
          icon: 'el-icon-circle-check',
          description: '达成攻击目标'
        }
      ],
      // 对话框相关
      dialogVisible: false,
      dialogType: 'create',
      sceneForm: {
        name: '',
        description: '',
        difficulty: 3,
        type: '',
        image: '',
        cpu: 2,
        memory: 2048,
        ports: ''
      },
      // 默认场景图标
      defaultIcon: 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png',
      // 更新定时器
      updateTimer: null,
      // 表单校验规则
      rules: {
        name: [
          { required: true, message: '请输入场景名称', trigger: 'blur' },
          { min: 2, max: 50, message: '长度在 2 到 50 个字符', trigger: 'blur' }
        ],
        description: [
          { required: true, message: '请输入场景描述', trigger: 'blur' }
        ],
        type: [
          { required: true, message: '请选择场景类型', trigger: 'change' }
        ],
        image: [
          { required: true, message: '请选择Docker镜像', trigger: 'change' }
        ],
        difficulty: [
          { required: true, message: '请选择难度等级', trigger: 'change' }
        ]
      },
      loading: false,
      // 监控时间范围
      timeRange: '1h'
    }
  },
  created() {
    this.getSceneList()
    this.updateStats()
  },
  mounted() {
    this.updateNetworkChart()
    // 启动实时更新
    this.startRealtimeUpdate()
  },
  beforeDestroy() {
    // 清理定时器
    if (this.updateTimer) {
      clearInterval(this.updateTimer)
    }
    // 销毁图表实例
    if (this.networkChart) {
      this.networkChart.dispose()
    }
  },
  methods: {
    // 获取场景列表
    getSceneList() {
      // 使用data中的模拟数据
      this.stats.totalScenes = this.sceneList.length
      this.stats.runningScenes = this.sceneList.filter(scene => scene.status === 'running').length
    },
    // 更新统计数据
    updateStats() {
      this.stats.totalScenes = this.sceneList.length
      this.stats.runningScenes = this.sceneList.filter(scene => scene.status === 'running').length
    },
    // 选择场景
    handleSceneSelect(scene) {
      this.currentScene = scene
      if (scene.status === 'running') {
        this.refreshMonitorData()
      }
    },
    // 场景操作（启动/停止）
    handleSceneAction(scene) {
      const action = scene.status === 'running' ? '停止' : '启动'
      this.$confirm(`确认${action}该场景？`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        scene.status = scene.status === 'running' ? 'stopped' : 'running'
        this.updateStats()
        this.$message.success(`场景${action}成功`)
      }).catch(() => {})
    },
    // 删除场景
    handleDeleteScene(scene) {
      this.$confirm('确认删除该场景？此操作将永久删除该场景，是否继续？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.sceneList = this.sceneList.filter(s => s.id !== scene.id)
        if (this.currentScene && this.currentScene.id === scene.id) {
          this.currentScene = null
        }
        this.updateStats()
        this.$message.success('删除成功')
      }).catch(() => {})
    },
    // 创建场景
    handleCreateScene() {
      this.$refs.sceneForm.validate(valid => {
        if (valid) {
          const scene = {
            id: Date.now(), // 临时ID，实际应该由后端生成
            ...this.sceneForm,
            status: 'stopped',
            progress: 0,
            createTime: new Date().toLocaleString()
          }

          // 这里应该调用后端API创建场景
          // 示例代码：
          this.$modal.loading("正在创建场景...")
          setTimeout(() => {
            this.sceneList.unshift(scene)
            this.dialogVisible = false
            this.resetForm()
            this.$modal.closeLoading()
            this.$modal.msgSuccess("创建成功")
          }, 1000)
        }
      })
    },
    // 刷新场景列表
    refreshScenes() {
      this.getSceneList()
      this.updateStats()
      this.$message.success('刷新成功')
    },
    // 刷新监控数据
    refreshMonitorData() {
      // 更新指标数据
      this.monitorMetrics.forEach(metric => {
        metric.value = Math.floor(Math.random() * 100)
        metric.trend = Math.floor(Math.random() * 20) - 10
      })
      
      // 更新网络流量数据
      this.networkData.inbound = this.generateRandomData(10)
      this.networkData.outbound = this.generateRandomData(10)
      
      // 更新图表
      this.updateNetworkChart()
      
      // 更新最后更新时间
      this.lastUpdateTime = new Date().toLocaleString()
    },
    // 更新网络流量图表
    updateNetworkChart() {
      if (!this.$refs.networkChart) return
      
      const option = {
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
        grid: {
          top: 10,
          right: 20,
          bottom: 30,
          left: 50,
          containLabel: true
        },
        xAxis: {
          type: 'category',
          data: this.getLast10Minutes(),
          axisLine: {
            lineStyle: {
              color: 'rgba(255, 255, 255, 0.3)'
            }
          },
          axisLabel: {
            color: '#fff',
            fontSize: 12
          }
        },
        yAxis: {
          type: 'value',
          name: 'KB/s',
          nameTextStyle: {
            color: '#fff'
          },
          axisLine: {
            lineStyle: {
              color: 'rgba(255, 255, 255, 0.3)'
            }
          },
          axisLabel: {
            color: '#fff',
            fontSize: 12
          },
          splitLine: {
            lineStyle: {
              color: 'rgba(255, 255, 255, 0.1)'
            }
          }
        },
        series: [
          {
            name: '入站流量',
            type: 'line',
            smooth: true,
            data: this.networkData.inbound,
            itemStyle: {
              color: '#1890ff'
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
                  color: 'rgba(24, 144, 255, 0.3)'
                }, {
                  offset: 1,
                  color: 'rgba(24, 144, 255, 0)'
                }]
              }
            }
          },
          {
            name: '出站流量',
            type: 'line',
            smooth: true,
            data: this.networkData.outbound,
            itemStyle: {
              color: '#52c41a'
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
                  color: 'rgba(82, 196, 26, 0.3)'
                }, {
                  offset: 1,
                  color: 'rgba(82, 196, 26, 0)'
                }]
              }
            }
          }
        ]
      }
      
      const chart = echarts.init(this.$refs.networkChart)
      chart.setOption(option)
      
      // 监听容器大小变化
      window.addEventListener('resize', () => {
        chart.resize()
      })
    },
    // 启动实时更新
    startRealtimeUpdate() {
      this.updateTimer = setInterval(() => {
        if (this.currentScene && this.currentScene.status === 'running') {
          this.refreshMonitorData()
        }
      }, 5000) // 每5秒更新一次
    },
    // 生成最近10分钟的时间标签
    getLast10Minutes() {
      const labels = []
      const now = new Date()
      for (let i = 9; i >= 0; i--) {
        const time = new Date(now - i * 60000)
        labels.push(time.toLocaleTimeString('zh-CN', { hour12: false }).slice(0, -3))
      }
      return labels
    },
    // 生成随机数据
    generateRandomData(count) {
      return Array.from({ length: count }, () => Math.floor(Math.random() * 1000))
    },
    // 获取状态类型
    getStatusType(status) {
      const types = {
        running: 'success',
        stopped: 'info',
        error: 'danger'
      }
      return types[status] || 'info'
    },
    // 获取状态文本
    getStatusText(status) {
      const texts = {
        running: '运行中',
        stopped: '已停止',
        error: '异常'
      }
      return texts[status] || '未知'
    },
    // 获取进度状态
    getProgressStatus(progress) {
      if (progress >= 100) return 'success'
      if (progress >= 80) return 'warning'
      return ''
    },
    // 获取仪表盘配置
    getGaugeOption(metric) {
      return {
        series: [{
          type: 'gauge',
          startAngle: 180,
          endAngle: 0,
          min: 0,
          max: 100,
          splitNumber: 8,
          radius: '100%',
          axisLine: {
            lineStyle: {
              width: 6,
              color: [
                [metric.thresholds[0] / 100, '#67C23A'],
                [metric.thresholds[1] / 100, '#E6A23C'],
                [1, '#F56C6C']
              ]
            }
          },
          pointer: {
            icon: 'path://M12.8,0.7l12,40.1H0.7L12.8,0.7z',
            length: '60%',
            width: 4,
            offsetCenter: [0, '8%'],
            itemStyle: {
              color: '#1890ff'
            }
          },
          axisTick: {
            length: 8,
            lineStyle: {
              color: 'auto',
              width: 1
            }
          },
          splitLine: {
            length: 12,
            lineStyle: {
              color: 'auto',
              width: 2
            }
          },
          axisLabel: {
            color: '#fff',
            fontSize: 12,
            distance: -20
          },
          detail: {
            fontSize: 30,
            offsetCenter: [0, '35%'],
            valueAnimation: true,
            formatter: function(value) {
              return value.toFixed(0) + '%';
            },
            color: '#fff'
          },
          data: [{
            value: metric.value
          }]
        }]
      }
    },
    // 批量操作
    handleBatchOperation() {
      this.$message.info('批量操作功能开发中')
    },
    // 编辑场景
    handleEditScene(scene) {
      this.dialogType = 'edit'
      this.sceneForm = {
        ...scene,
        // 避免直接修改原对象
        cpu: scene.cpu || 2,
        memory: scene.memory || 2048,
        ports: scene.ports || ''
      }
      this.dialogVisible = true
    },
    // 清除日志
    clearLogs() {
      this.systemLogs = []
      this.$message.success('日志已清除')
    },
    // 打开新建场景对话框
    handleAddScene() {
      this.dialogType = 'create'
      this.resetForm()
      this.dialogVisible = true
    },
    // 重置表单
    resetForm() {
      if (this.$refs.sceneForm) {
        this.$refs.sceneForm.resetFields()
      }
      this.sceneForm = {
        name: '',
        description: '',
        difficulty: 3,
        type: '',
        image: '',
        cpu: 2,
        memory: 2048,
        ports: ''
      }
    },
    getSceneTypeIcon(type) {
      const icons = {
        web: 'el-icon-chrome',
        network: 'el-icon-connection',
        system: 'el-icon-monitor'
      }
      return icons[type] || 'el-icon-monitor'
    },
    
    getSceneTypeName(type) {
      const names = {
        web: 'Web应用',
        network: '网络渗透',
        system: '系统安全'
      }
      return names[type] || '未知类型'
    },
    
    getSceneTypeTag(type) {
      const tags = {
        web: 'primary',
        network: 'success',
        system: 'warning'
      }
      return tags[type] || 'info'
    },
    getMetricIcon(title) {
      const icons = {
        'CPU使用率': 'el-icon-cpu',
        '内存使用率': 'el-icon-monitor',
        '磁盘使用率': 'el-icon-hdd'
      }
      return icons[title] || 'el-icon-info'
    },
    setTimeRange(range) {
      this.timeRange = range
      this.refreshMonitorData()
    },
    getRunningTime(scene) {
      const start = new Date(scene.createTime)
      const end = new Date()
      const diff = end - start
      const hours = Math.floor(diff / (1000 * 60 * 60))
      const minutes = Math.floor(diff / (1000 * 60)) % 60
      const seconds = Math.floor(diff / 1000) % 60
      return `${hours}小时${minutes}分${seconds}秒`
    }
  }
}
</script>

<style lang="scss" scoped>
.app-container {
  padding: 20px;
  min-height: 100vh;
  background: linear-gradient(135deg, #001529 0%, #002140 100%);
  position: relative;
  overflow: hidden;

  // 背景动画
  .cyber-background {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    z-index: 0;
    pointer-events: none;

    .grid {
      position: absolute;
      width: 200%;
      height: 200%;
      background-image: 
        linear-gradient(to right, rgba(24, 144, 255, 0.1) 1px, transparent 1px),
        linear-gradient(to bottom, rgba(24, 144, 255, 0.1) 1px, transparent 1px);
      background-size: 40px 40px;
      transform: rotate(45deg);
      left: -50%;
      top: -50%;
      animation: grid-animation 30s linear infinite;
    }

    .circles {
      position: absolute;
      width: 100%;
      height: 100%;
      
      .circle {
        position: absolute;
        border: 2px solid rgba(24, 144, 255, 0.2);
        border-radius: 50%;
        animation: circle-animation 10s linear infinite;
        
        &:nth-child(1) {
          width: 100px;
          height: 100px;
          left: 10%;
          top: 20%;
          animation-delay: 0s;
          animation-duration: 8s;
        }
        
        &:nth-child(2) {
          width: 150px;
          height: 150px;
          left: 30%;
          top: 50%;
          animation-delay: 1s;
          animation-duration: 10s;
        }
        
        &:nth-child(3) {
          width: 200px;
          height: 200px;
          left: 50%;
          top: 30%;
          animation-delay: 2s;
          animation-duration: 12s;
        }
        
        &:nth-child(4) {
          width: 120px;
          height: 120px;
          left: 70%;
          top: 60%;
          animation-delay: 3s;
          animation-duration: 9s;
        }
        
        &:nth-child(5) {
          width: 180px;
          height: 180px;
          left: 85%;
          top: 15%;
          animation-delay: 4s;
          animation-duration: 11s;
        }
        
        &:nth-child(6) {
          width: 160px;
          height: 160px;
          left: 15%;
          top: 70%;
          animation-delay: 2.5s;
          animation-duration: 13s;
        }
        
        &:nth-child(7) {
          width: 140px;
          height: 140px;
          left: 45%;
          top: 85%;
          animation-delay: 1.5s;
          animation-duration: 14s;
        }
        
        &:nth-child(8) {
          width: 220px;
          height: 220px;
          left: 65%;
          top: 40%;
          animation-delay: 3.5s;
          animation-duration: 15s;
        }
        
        &:nth-child(9) {
          width: 130px;
          height: 130px;
          left: 25%;
          top: 35%;
          animation-delay: 2.8s;
          animation-duration: 11s;
        }
        
        &:nth-child(10) {
          width: 190px;
          height: 190px;
          left: 90%;
          top: 75%;
          animation-delay: 4.5s;
          animation-duration: 12s;
        }
      }
    }
  }

  // 统计卡片
  .stat-cards {
    position: relative;
    z-index: 1;
    margin-bottom: 30px;

    .stat-card {
      background: rgba(24, 36, 64, 0.8) !important;
      backdrop-filter: blur(10px);
      border: 1px solid rgba(24, 144, 255, 0.2) !important;
      border-radius: 15px !important;
      overflow: hidden;
      transition: all 0.3s ease;

      &::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 2px;
        background: linear-gradient(90deg, 
          transparent,
          rgba(24, 144, 255, 0.5),
          transparent
        );
        transform: translateX(-100%);
        animation: border-flow 3s ease infinite;
      }

      &:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 30px rgba(24, 144, 255, 0.1);
        border-color: rgba(24, 144, 255, 0.4) !important;
      }

      .stat-content {
        display: flex;
        align-items: center;
        padding: 20px;
      }

      .stat-icon {
        position: relative;
        font-size: 48px;
        width: 80px;
        height: 80px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        margin-right: 20px;
        transition: all 0.3s ease;
        background: rgba(24, 144, 255, 0.1);
        color: #1890ff;

        .pulse-ring {
          position: absolute;
          width: 100%;
          height: 100%;
          border-radius: 50%;
          border: 3px solid rgba(24, 144, 255, 0.3);
          opacity: 0;
          transform: scale(0.8);
        }
      }

      .stat-info {
        flex: 1;

        .stat-value {
          font-size: 36px;
          font-weight: 600;
          color: #fff;
          margin-bottom: 5px;
          display: flex;
          align-items: baseline;

          .stat-unit {
            font-size: 16px;
            margin-left: 5px;
            color: rgba(255, 255, 255, 0.7);
          }
        }

        .stat-label {
          font-size: 14px;
          color: rgba(255, 255, 255, 0.7);
        }

        .stat-trend {
          display: flex;
          align-items: center;
          font-size: 12px;
          margin-top: 5px;

          &.up {
            color: #67C23A;
          }

          &.down {
            color: #F56C6C;
          }

          i {
            margin-right: 4px;
          }
        }
      }

      .stat-chart {
        height: 50px;
        margin: 0 20px 20px;
      }

      // 不同类型的卡片样式
      &.total .stat-icon {
        color: #1890ff;
        background: rgba(24, 144, 255, 0.1);
      }

      &.running .stat-icon {
        color: #67C23A;
        background: rgba(103, 194, 58, 0.1);
      }

      &.warning .stat-icon {
        color: #E6A23C;
        background: rgba(230, 162, 60, 0.1);
      }

      &.success .stat-icon {
        color: #13c2c2;
        background: rgba(19, 194, 194, 0.1);
      }
    }
  }

  // 场景列表
  .scene-list {
    background: rgba(24, 36, 64, 0.8) !important;
    backdrop-filter: blur(10px);
    border: 1px solid rgba(24, 144, 255, 0.2) !important;
    border-radius: 15px !important;

    .cyber-text {
      color: #fff;
      font-size: 18px;
      font-weight: 500;
      letter-spacing: 1px;
      text-shadow: 0 0 10px rgba(24, 144, 255, 0.5);
    }

    .cyber-controls {
      float: right;

      .cyber-button {
        background: rgba(24, 144, 255, 0.1);
        border: 1px solid rgba(24, 144, 255, 0.2);
        color: #fff;
        transition: all 0.3s ease;

        &:hover {
          background: rgba(24, 144, 255, 0.2);
          border-color: rgba(24, 144, 255, 0.4);
          transform: translateY(-2px);
        }
      }
    }

    .scene-table {
      background: transparent;
      
      ::v-deep .el-table__header-wrapper {
        th {
          background-color: rgba(16, 28, 52, 0.9) !important;
          border-bottom: 1px solid rgba(24, 144, 255, 0.2);
          color: #fff;
          font-weight: 500;
          
          &.is-leaf {
            border-bottom: 1px solid rgba(24, 144, 255, 0.2);
          }
        }
      }
      
      ::v-deep .el-table__body-wrapper {
        background: transparent;
        
        tr {
          background: rgba(16, 28, 52, 0.7);
          border-bottom: 1px solid rgba(24, 144, 255, 0.1);
          transition: all 0.3s;
          
          &:hover {
            background: rgba(24, 144, 255, 0.1) !important;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(24, 144, 255, 0.1);
            
            td {
              background: transparent !important;
            }
          }
          
          td {
            background: transparent;
            border-bottom: 1px solid rgba(24, 144, 255, 0.1);
            color: #fff;
            transition: all 0.3s;
          }
        }
      }
      
      .cyber-checkbox {
        ::v-deep .el-checkbox__inner {
          background-color: rgba(16, 28, 52, 0.8);
          border-color: rgba(24, 144, 255, 0.3);
          
          &:hover {
            border-color: #1890ff;
          }
        }
        
        ::v-deep .el-checkbox__input.is-checked .el-checkbox__inner {
          background-color: #1890ff;
          border-color: #1890ff;
        }
      }
      
      .scene-name-cell {
        display: flex;
        align-items: center;
        
        .scene-avatar {
          position: relative;
          margin-right: 16px;
          
          .cyber-avatar {
            background: rgba(24, 144, 255, 0.1);
            border: 2px solid rgba(24, 144, 255, 0.3);
            
            i {
              font-size: 20px;
              color: #1890ff;
            }
          }
          
          .avatar-ring {
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            border-radius: 50%;
            border: 2px solid rgba(24, 144, 255, 0.5);
            animation: ring-rotate 3s linear infinite;
          }
        }
        
        .scene-info {
          .scene-title {
            font-size: 16px;
            font-weight: 500;
            color: #fff;
            margin-bottom: 4px;
            display: flex;
            align-items: center;
            
            .scene-type-tag {
              margin-left: 8px;
              background: rgba(24, 144, 255, 0.1);
              border: 1px solid rgba(24, 144, 255, 0.2);
              color: #1890ff;
            }
          }
          
          .scene-desc {
            font-size: 13px;
            color: rgba(255, 255, 255, 0.6);
          }
        }
      }
      
      .status-indicator {
        display: flex;
        align-items: center;
        
        .status-dot {
          width: 8px;
          height: 8px;
          border-radius: 50%;
          margin-right: 8px;
          position: relative;
          
          &::before {
            content: '';
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            border-radius: 50%;
            animation: pulse 1.5s ease-in-out infinite;
          }
          
          &.running {
            background: #67C23A;
            
            &::before {
              border: 2px solid rgba(103, 194, 58, 0.3);
            }
          }
          
          &.stopped {
            background: #909399;
            
            &::before {
              border: 2px solid rgba(144, 147, 153, 0.3);
            }
          }
          
          &.error {
            background: #F56C6C;
            
            &::before {
              border: 2px solid rgba(245, 108, 108, 0.3);
            }
          }
        }
        
        .status-text {
          font-size: 14px;
          color: #fff;
        }
      }
      
      .progress-wrapper {
        .progress-info {
          display: flex;
          justify-content: space-between;
          margin-bottom: 8px;
          
          .progress-text {
            font-size: 13px;
            color: rgba(255, 255, 255, 0.8);
          }
          
          .progress-percentage {
            font-size: 13px;
            color: #1890ff;
          }
        }
        
        .cyber-progress {
          ::v-deep .el-progress-bar__outer {
            background-color: rgba(24, 144, 255, 0.1);
            border-radius: 4px;
          }
          
          ::v-deep .el-progress-bar__inner {
            background: linear-gradient(90deg, #1890ff, #40a9ff);
            box-shadow: 0 0 10px rgba(24, 144, 255, 0.3);
            transition: all 0.3s;
          }
          
          .progress-steps {
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            transform: translateY(-50%);
            display: flex;
            justify-content: space-between;
            padding: 0 2px;
            
            .step-dot {
              width: 6px;
              height: 6px;
              border-radius: 50%;
              background: rgba(255, 255, 255, 0.2);
              transition: all 0.3s;
              
              &.active {
                background: #fff;
                box-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
              }
            }
          }
        }
      }
      
      .action-buttons {
        display: flex;
        gap: 8px;
        
        .cyber-button {
          position: relative;
          overflow: hidden;
          border: none;
          
          &::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, 
              transparent 25%, 
              rgba(255, 255, 255, 0.1) 50%, 
              transparent 75%
            );
            background-size: 200% 200%;
            animation: button-gradient 2s linear infinite;
          }
          
          &:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(24, 144, 255, 0.2);
          }
          
          &.el-button--success {
            background: #67C23A;
          }
          
          &.el-button--danger {
            background: #F56C6C;
          }
          
          &.el-button--primary {
            background: #1890ff;
          }
          
          i {
            position: relative;
            z-index: 1;
          }
        }
      }
    }
  }

  // 详情卡片
  .detail-card {
    background: rgba(24, 36, 64, 0.8) !important;
    backdrop-filter: blur(10px);
    border: 1px solid rgba(24, 144, 255, 0.2) !important;
    border-radius: 15px !important;
    margin-bottom: 20px;

    .cyber-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 15px 20px;
      border-bottom: 1px solid rgba(24, 144, 255, 0.2);

      .header-left {
        display: flex;
        align-items: center;

        .scene-avatar {
          position: relative;
          margin-right: 15px;

          .cyber-avatar {
            border: 2px solid rgba(24, 144, 255, 0.2);
            background: rgba(24, 144, 255, 0.1);
            transition: all 0.3s ease;

            i {
              font-size: 20px;
              color: #1890ff;
            }
          }

          .avatar-ring {
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            border-radius: 50%;
            border: 2px solid rgba(24, 144, 255, 0.4);
            animation: avatar-pulse 2s ease-in-out infinite;
          }
        }

        .scene-info {
          flex: 1;
          min-width: 0;

          .scene-title {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 4px;
            font-size: 16px;
            color: #fff;
            font-weight: 500;

            .scene-type-tag {
              font-size: 12px;
              padding: 0 6px;
              height: 20px;
              line-height: 18px;
              background: rgba(24, 144, 255, 0.1);
              border: 1px solid rgba(24, 144, 255, 0.2);
              color: #1890ff;
            }
          }

          .scene-desc {
            font-size: 12px;
            color: rgba(255, 255, 255, 0.65);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
          }
        }
      }

      .header-right {
        display: flex;
        align-items: center;

        .cyber-button-group {
          display: flex;
          gap: 10px;

          .cyber-button {
            background: rgba(24, 144, 255, 0.1);
            border: 1px solid rgba(24, 144, 255, 0.2);
            backdrop-filter: blur(5px);
            transition: all 0.3s ease;

            &:hover {
              background: rgba(24, 144, 255, 0.2);
              border-color: rgba(24, 144, 255, 0.4);
              transform: translateY(-2px);
            }

            &.el-button--success {
              background: rgba(82, 196, 26, 0.1);
              border-color: rgba(82, 196, 26, 0.2);
              &:hover {
                background: rgba(82, 196, 26, 0.2);
                border-color: rgba(82, 196, 26, 0.4);
              }
            }

            &.el-button--danger {
              background: rgba(245, 34, 45, 0.1);
              border-color: rgba(245, 34, 45, 0.2);
              &:hover {
                background: rgba(245, 34, 45, 0.2);
                border-color: rgba(245, 34, 45, 0.4);
              }
            }

            &.el-button--warning {
              background: rgba(250, 173, 20, 0.1);
              border-color: rgba(250, 173, 20, 0.2);
              &:hover {
                background: rgba(250, 173, 20, 0.2);
                border-color: rgba(250, 173, 20, 0.4);
              }
            }
          }
        }
      }
    }

    .cyber-content {
      padding: 20px;

      .info-section {
        margin-bottom: 30px;

        .section-title {
          color: #fff;
          font-size: 16px;
          font-weight: 500;
          margin-bottom: 15px;
          display: flex;
          align-items: center;

          &::before {
            content: '';
            display: inline-block;
            width: 4px;
            height: 16px;
            background: #1890ff;
            margin-right: 8px;
            border-radius: 2px;
          }
        }

        .info-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
          gap: 20px;

          .info-item {
            display: flex;
            align-items: center;

            .item-label {
              color: rgba(255, 255, 255, 0.7);
              font-size: 14px;
              margin-right: 10px;
            }

            .item-value {
              color: #fff;
              font-size: 14px;
            }
          }
        }
      }

      .progress-section {
        margin-bottom: 30px;
        background: rgba(13, 25, 58, 0.8);
        border-radius: 8px;
        padding: 20px;

        .section-title {
          color: #fff;
          font-size: 16px;
          font-weight: 500;
          margin-bottom: 20px;
          display: flex;
          align-items: center;

          i {
            margin-right: 8px;
            color: #409EFF;
          }
        }

        .progress-timeline {
          position: relative;
          padding: 20px 0;

          .timeline-track {
            position: absolute;
            top: 20px;
            left: 0;
            right: 0;
            height: 2px;
            background: rgba(255, 255, 255, 0.1);
          }

          .timeline-nodes {
            position: relative;
            display: flex;
            justify-content: space-between;

            .timeline-node {
              position: relative;
              display: flex;
              flex-direction: column;
              align-items: center;
              width: 20%;
              z-index: 1;

              .node-icon {
                width: 32px;
                height: 32px;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 12px;
                position: relative;

                i {
                  font-size: 16px;
                  color: rgba(255, 255, 255, 0.5);
                }
              }

              .node-content {
                text-align: center;

                .node-title {
                  font-size: 14px;
                  color: #fff;
                  margin-bottom: 4px;
                }

                .node-desc {
                  font-size: 12px;
                  color: rgba(255, 255, 255, 0.5);
                }
              }

              &::after {
                content: '';
                position: absolute;
                top: 15px;
                left: 0;
                width: 100%;
                height: 2px;
                background: rgba(255, 255, 255, 0.1);
                z-index: -1;
              }

              &:first-child::after {
                left: 50%;
                width: 50%;
              }

              &:last-child::after {
                width: 50%;
              }

              &.completed {
                .node-icon {
                  background: #67C23A;
                  i {
                    color: #fff;
                  }
                }
                &::after {
                  background: #67C23A;
                }
              }

              &.current {
                .node-icon {
                  background: #409EFF;
                  box-shadow: 0 0 10px rgba(64, 158, 255, 0.3);
                  i {
                    color: #fff;
                  }
                }
                &::after {
                  background: #409EFF;
                }
              }
            }
          }
        }
      }

      
    }
  }

  // 监控卡片
  .monitor-card {
    background: rgba(13, 22, 42, 0.95);
    border: 1px solid rgba(24, 144, 255, 0.3);
    border-radius: 15px;
    padding: 20px;
    position: relative;
    overflow: hidden;
    backdrop-filter: blur(10px);
    box-shadow: 0 0 30px rgba(24, 144, 255, 0.1);

    .cyber-card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding-bottom: 20px;
      border-bottom: 1px solid rgba(24, 144, 255, 0.2);
      margin-bottom: 20px;

      .monitor-title {
        display: flex;
        align-items: center;
        gap: 12px;

        i {
          font-size: 24px;
          color: #1890ff;
          text-shadow: 0 0 10px rgba(24, 144, 255, 0.5);
        }

        .title-text {
          font-size: 18px;
          color: #fff;
          font-weight: 500;
          letter-spacing: 1px;
        }

        .cyber-tag {
          background: rgba(82, 196, 26, 0.1);
          border: 1px solid rgba(82, 196, 26, 0.3);
          padding: 0 10px;
          height: 24px;
          line-height: 22px;
          border-radius: 12px;
          
          i {
            font-size: 14px;
            color: #52c41a;
            margin-right: 4px;
          }
        }
      }

      .cyber-button-group {
        display: flex;
        gap: 10px;

        .cyber-button {
          position: relative;
          padding: 8px 16px;
          background: rgba(24, 144, 255, 0.1);
          border: 1px solid rgba(24, 144, 255, 0.3);
          border-radius: 4px;
          color: #fff;
          font-size: 14px;
          transition: all 0.3s ease;
          overflow: hidden;
          
          &::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(
              90deg,
              transparent,
              rgba(255, 255, 255, 0.2),
              transparent
            );
            transition: all 0.5s ease;
          }
          
          &:hover {
            background: rgba(24, 144, 255, 0.2);
            border-color: rgba(24, 144, 255, 0.5);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(24, 144, 255, 0.2);
            
            &::before {
              left: 100%;
            }
          }
          
          &:active {
            transform: translateY(0);
          }
          
          i {
            margin-right: 6px;
            font-size: 16px;
          }
          
          &.refresh-btn {
            background: rgba(82, 196, 26, 0.1);
            border-color: rgba(82, 196, 26, 0.3);
            
            &:hover {
              background: rgba(82, 196, 26, 0.2);
              border-color: rgba(82, 196, 26, 0.5);
            }
          }
          
          &.detail-btn {
            background: rgba(250, 173, 20, 0.1);
            border-color: rgba(250, 173, 20, 0.3);
            
            &:hover {
              background: rgba(250, 173, 20, 0.2);
              border-color: rgba(250, 173, 20, 0.5);
            }
          }
        }
      }
    }

    .monitor-content {
      .monitor-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 20px;
        margin-bottom: 30px;

        .monitor-item {
          background: rgba(24, 144, 255, 0.05);
          border: 1px solid rgba(24, 144, 255, 0.2);
          border-radius: 12px;
          padding: 20px;
          transition: all 0.3s ease;
          position: relative;
          overflow: hidden;

          &::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(
              45deg,
              transparent 48%,
              rgba(24, 144, 255, 0.05) 50%,
              transparent 52%
            );
            background-size: 20px 20px;
            animation: grid-animation 20s linear infinite;
          }

          &:hover {
            transform: translateY(-5px);
            border-color: rgba(24, 144, 255, 0.4);
            box-shadow: 0 5px 15px rgba(24, 144, 255, 0.1);

            .item-value {
              text-shadow: 0 0 15px rgba(24, 144, 255, 0.5);
            }
          }

          .item-label {
            display: flex;
            align-items: center;
            gap: 8px;
            color: rgba(255, 255, 255, 0.7);
            font-size: 14px;
            margin-bottom: 15px;
            position: relative;
            z-index: 1;

            i {
              color: #1890ff;
              font-size: 18px;
            }
          }

          .item-value {
            font-size: 32px;
            color: #fff;
            font-weight: 600;
            font-family: 'Orbitron', sans-serif;
            margin-bottom: 10px;
            position: relative;
            z-index: 1;
            text-shadow: 0 0 10px rgba(24, 144, 255, 0.3);
            transition: all 0.3s ease;

            small {
              font-size: 16px;
              opacity: 0.7;
              margin-left: 4px;
            }
          }

          .monitor-trend {
            display: inline-flex;
            align-items: center;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 14px;
            position: relative;
            z-index: 1;
            transition: all 0.3s ease;

            &.up {
              color: #52c41a;
              background: rgba(82, 196, 26, 0.1);
              border: 1px solid rgba(82, 196, 26, 0.2);

              i {
                color: #52c41a;
              }
            }

            &.down {
              color: #ff4d4f;
              background: rgba(245, 34, 45, 0.1);
              border: 1px solid rgba(245, 34, 45, 0.2);

              i {
                color: #ff4d4f;
              }
            }

            i {
              margin-right: 4px;
              font-size: 14px;
            }
          }
        }
      }

      .network-chart {
        background: rgba(24, 144, 255, 0.05);
        border: 1px solid rgba(24, 144, 255, 0.2);
        border-radius: 12px;
        padding: 20px;
        position: relative;
        overflow: hidden;

        &::before {
          content: '';
          position: absolute;
          top: 0;
          left: 0;
          right: 0;
          bottom: 0;
          background: linear-gradient(
            45deg,
            transparent 48%,
            rgba(24, 144, 255, 0.05) 50%,
            transparent 52%
          );
          background-size: 20px 20px;
          animation: grid-animation 20s linear infinite;
        }

        .chart-toolbar {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 20px;
          position: relative;
          z-index: 1;

          .toolbar-left {
            display: flex;
            gap: 10px;

            .time-select {
              padding: 6px 12px;
              border-radius: 4px;
              background: rgba(24, 144, 255, 0.1);
              border: 1px solid rgba(24, 144, 255, 0.2);
              color: rgba(255, 255, 255, 0.8);
              cursor: pointer;
              transition: all 0.3s ease;

              &:hover {
                background: rgba(24, 144, 255, 0.2);
                border-color: rgba(24, 144, 255, 0.4);
              }

              &.active {
                background: rgba(24, 144, 255, 0.3);
                border-color: #1890ff;
                color: #fff;
                box-shadow: 0 0 10px rgba(24, 144, 255, 0.2);
              }
            }
          }

          .toolbar-right {
            .refresh-time {
              color: rgba(255, 255, 255, 0.7);
              font-size: 14px;

              i {
                color: #1890ff;
                margin-right: 6px;
              }
            }
          }
        }

        .chart-container {
          height: 300px;
          position: relative;
          z-index: 1;
        }

        .chart-footer {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-top: 20px;
          padding-top: 20px;
          border-top: 1px solid rgba(24, 144, 255, 0.2);
          position: relative;
          z-index: 1;

          .total-stats {
            display: flex;
            gap: 30px;

            .stat-item {
              .stat-label {
                font-size: 14px;
                color: rgba(255, 255, 255, 0.7);
                margin-bottom: 8px;
              }

              .stat-value {
                font-size: 20px;
                color: #fff;
                font-family: 'Orbitron', sans-serif;
                display: flex;
                align-items: center;
                gap: 6px;

                i {
                  font-size: 16px;

                  &.up {
                    color: #52c41a;
                  }

                  &.down {
                    color: #ff4d4f;
                  }
                }
              }
            }
          }

          .export-btn {
            padding: 8px 16px;
            background: rgba(24, 144, 255, 0.1);
            border: 1px solid rgba(24, 144, 255, 0.3);
            border-radius: 4px;
            color: #fff;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 6px;

            &:hover {
              background: rgba(24, 144, 255, 0.2);
              border-color: rgba(24, 144, 255, 0.5);
              transform: translateY(-2px);
              box-shadow: 0 5px 15px rgba(24, 144, 255, 0.1);
            }

            i {
              font-size: 16px;
            }
          }
        }
      }
    }
  }

  @keyframes grid-scan {
    0% {
      background-position: -50px 0, 0 -50px;
    }
    100% {
      background-position: 50px 0, 0 50px;
    }
  }

  @keyframes border-scan {
    0% {
      transform: translateX(-100%);
    }
    50% {
      transform: translateX(100%);
    }
    100% {
      transform: translateX(-100%);
    }
  }

  @keyframes rotate-bg {
    0% {
      transform: rotate(0deg);
    }
    100% {
      transform: rotate(360deg);
    }
  }

  @keyframes pulse-ring {
    0% {
      transform: translate(-50%, -50%) scale(0.8);
      opacity: 0.8;
    }
    50% {
      transform: translate(-50%, -50%) scale(1);
      opacity: 0.4;
    }
    100% {
      transform: translate(-50%, -50%) scale(0.8);
      opacity: 0.8;
    }
  }

  @keyframes pulse-border {
    0% {
      transform: scale(1);
      opacity: 0.8;
    }
    50% {
      transform: scale(1.1);
      opacity: 0.4;
    }
    100% {
      transform: scale(1);
      opacity: 0.8;
    }
  }

  // 空状态
  .cyber-empty {
    background: rgba(16, 28, 52, 0.8) !important;
    border: 1px solid rgba(24, 144, 255, 0.2) !important;
    border-radius: 8px !important;
    height: 400px;
    display: flex;
    align-items: center;
    justify-content: center;

    .empty-content {
      text-align: center;
      color: rgba(255, 255, 255, 0.7);

      i {
        font-size: 48px;
        margin-bottom: 15px;
        color: rgba(24, 144, 255, 0.5);
      }

      p {
        font-size: 16px;
      }
    }
  }

  // 对话框
  .scene-dialog {
    ::v-deep .el-dialog {
      background: rgba(13, 22, 42, 0.95);
      backdrop-filter: blur(20px);
      border: 1px solid rgba(24, 144, 255, 0.2);
      border-radius: 12px;
      box-shadow: 0 0 20px rgba(24, 144, 255, 0.1);
      overflow: hidden;
      
      &::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 2px;
        background: linear-gradient(90deg, 
          transparent,
          rgba(24, 144, 255, 0.6),
          transparent
        );
        animation: border-flow 2s ease-in-out infinite;
      }
      
      .el-dialog__header {
        background: rgba(16, 28, 52, 0.9);
        padding: 20px;
        margin: 0;
        border-bottom: 1px solid rgba(24, 144, 255, 0.2);
        position: relative;
        
        .el-dialog__title {
          font-size: 18px;
          font-weight: 600;
          color: #fff;
          text-shadow: 0 0 10px rgba(24, 144, 255, 0.5);
          
          &::before {
            content: '';
            display: inline-block;
            width: 4px;
            height: 18px;
            background: #1890ff;
            margin-right: 8px;
            vertical-align: middle;
            box-shadow: 0 0 10px rgba(24, 144, 255, 0.5);
          }
        }
      }
      
      .el-dialog__body {
        padding: 30px;
        background: rgba(13, 22, 42, 0.95);
      }
    }
    
    .scene-form {
      .el-form-item {
        margin-bottom: 22px;
        
        .el-form-item__label {
          color: #fff;
          font-weight: 500;
        }
        
        .el-input__inner {
          background: rgba(16, 28, 52, 0.8);
          border: 1px solid rgba(24, 144, 255, 0.2);
          border-radius: 4px;
          color: #fff;
          transition: all 0.3s;
          
          &:hover {
            border-color: rgba(24, 144, 255, 0.4);
          }
          
          &:focus {
            border-color: #1890ff;
            box-shadow: 0 0 10px rgba(24, 144, 255, 0.2);
            background: rgba(16, 28, 52, 0.9);
          }
        }
        
        .el-input__prefix {
          color: #1890ff;
        }
        
        .el-textarea__inner {
          background: rgba(16, 28, 52, 0.8);
          border: 1px solid rgba(24, 144, 255, 0.2);
          border-radius: 4px;
          color: #fff;
          
          &:focus {
            border-color: #1890ff;
            box-shadow: 0 0 10px rgba(24, 144, 255, 0.2);
            background: rgba(16, 28, 52, 0.9);
          }
        }
      }
      
      .scene-rate {
        .el-rate__icon {
          font-size: 20px;
          margin-right: 6px;
          transition: transform 0.3s;
          
          &.hover {
            transform: scale(1.2);
          }
        }
      }
      
      .scene-select {
        width: 100%;
        
        ::v-deep .el-input__inner {
          background: rgba(16, 28, 52, 0.8);
          border: 1px solid rgba(24, 144, 255, 0.2);
          color: #fff;
        }
        
        ::v-deep .el-select-dropdown {
          background: rgba(16, 28, 52, 0.95);
          border: 1px solid rgba(24, 144, 255, 0.2);
          backdrop-filter: blur(20px);
          
          .el-select-dropdown__item {
            color: #fff;
            
            &:hover {
              background: rgba(24, 144, 255, 0.1);
            }
            
            &.selected {
              background: rgba(24, 144, 255, 0.2);
              color: #1890ff;
            }
          }
        }
      }
      
      .scene-type-option {
        display: flex;
        align-items: center;
        padding: 8px 0;
        
        i {
          font-size: 18px;
          margin-right: 8px;
          color: #1890ff;
          transition: transform 0.3s;
        }
        
        &:hover i {
          transform: scale(1.2);
        }
      }
      
      .scene-image-option {
        display: flex;
        align-items: center;
        padding: 8px 0;
        
        i {
          font-size: 24px;
          margin-right: 12px;
          color: #1890ff;
          transition: transform 0.3s;
        }
        
        .image-info {
          display: flex;
          flex-direction: column;
          
          .image-name {
            font-size: 14px;
            color: #fff;
            margin-bottom: 4px;
          }
          
          .image-desc {
            font-size: 12px;
            color: rgba(255, 255, 255, 0.6);
          }
        }
        
        &:hover i {
          transform: scale(1.2);
        }
      }
    }
    
    .divider-title {
      font-size: 16px;
      font-weight: 500;
      color: #1890ff;
      text-shadow: 0 0 10px rgba(24, 144, 255, 0.3);
    }
    
    .advanced-config {
      background: rgba(16, 28, 52, 0.6);
      border: 1px solid rgba(24, 144, 255, 0.1);
      border-radius: 8px;
      padding: 20px;
      margin-bottom: 20px;
      position: relative;
      overflow: hidden;
      
      &::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: 
          linear-gradient(45deg, transparent 48%, rgba(24, 144, 255, 0.1) 50%, transparent 52%) 0 0/20px 20px,
          linear-gradient(-45deg, transparent 48%, rgba(24, 144, 255, 0.1) 50%, transparent 52%) 0 0/20px 20px;
        animation: grid-animation 20s linear infinite;
      }
      
      .resource-input {
        width: 100%;
        
        ::v-deep .el-input-number__decrease,
        ::v-deep .el-input-number__increase {
          background: rgba(16, 28, 52, 0.8);
          border-color: rgba(24, 144, 255, 0.2);
          color: #fff;
          
          &:hover {
            background: rgba(24, 144, 255, 0.1);
          }
        }
        
        ::v-deep .el-input__inner {
          background: rgba(16, 28, 52, 0.8);
          border-color: rgba(24, 144, 255, 0.2);
          color: #fff;
          text-align: left;
          padding-left: 35px;
        }
        
        ::v-deep .el-input__prefix {
          left: 10px;
          color: #1890ff;
        }
        
        ::v-deep .el-input__suffix {
          right: 10px;
          color: rgba(255, 255, 255, 0.6);
        }
      }
      
      .port-input {
        ::v-deep .el-input__inner {
          background: rgba(16, 28, 52, 0.8);
          border-color: rgba(24, 144, 255, 0.2);
          color: #fff;
          padding-left: 35px;
        }
        
        ::v-deep .el-input__prefix {
          left: 10px;
          color: #1890ff;
        }
        
        ::v-deep .el-input__suffix {
          cursor: help;
          color: rgba(255, 255, 255, 0.6);
        }
      }
    }
    
    .dialog-footer {
      text-align: right;
      padding: 20px;
      background: rgba(16, 28, 52, 0.9);
      border-top: 1px solid rgba(24, 144, 255, 0.2);
      
      .el-button {
        padding: 10px 24px;
        font-size: 14px;
        border-radius: 4px;
        transition: all 0.3s;
        
        &.el-button--default {
          background: rgba(255, 255, 255, 0.1);
          border-color: rgba(255, 255, 255, 0.2);
          color: #fff;
          
          &:hover {
            background: rgba(255, 255, 255, 0.2);
            border-color: rgba(255, 255, 255, 0.3);
          }
        }
        
        &.el-button--primary {
          background: #1890ff;
          border-color: #1890ff;
          color: #fff;
          position: relative;
          overflow: hidden;
          
          &::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, 
              transparent,
              rgba(255, 255, 255, 0.2),
              transparent
            );
            transform: translateX(-100%);
          }
          
          &:hover {
            background: #40a9ff;
            border-color: #40a9ff;
            box-shadow: 0 0 15px rgba(24, 144, 255, 0.3);
            
            &::before {
              animation: button-shine 1s;
            }
          }
        }
      }
    }
  }
}

@keyframes border-flow {
  0% {
    transform: translateX(-100%);
    opacity: 0.5;
  }
  50% {
    transform: translateX(100%);
    opacity: 1;
  }
  100% {
    transform: translateX(-100%);
    opacity: 0.5;
  }
}

@keyframes button-shine {
  0% {
    transform: translateX(-100%);
  }
  100% {
    transform: translateX(100%);
  }
}

@keyframes grid-animation {
  0% {
    background-position: 0 0;
  }
  100% {
    background-position: 40px 40px;
  }
}

@keyframes ring-rotate {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

@keyframes pulse {
  0% {
    transform: scale(1);
    opacity: 1;
  }
  100% {
    transform: scale(1.5);
    opacity: 0;
  }
}

@keyframes button-gradient {
  0% {
    background-position: 200% 0;
  }
  100% {
    background-position: -200% 0;
  }
}

.range-card {
  position: relative;
  background: rgba(13, 25, 58, 0.8) !important;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(24, 144, 255, 0.2);
  border-radius: 12px;
  overflow: hidden;
  transition: all 0.3s ease;
  margin-bottom: 20px;
  cursor: pointer;

  &.selected {
    border-color: #1890ff;
    box-shadow: 0 0 20px rgba(24, 144, 255, 0.2);
    transform: translateY(-2px);

    &::before {
      background: linear-gradient(
        45deg,
        transparent 0%,
        rgba(24, 144, 255, 0.06) 50%,
        transparent 100%
      );
    }

    .range-header {
      .range-title {
        i {
          color: #1890ff;
        }
      }
    }
  }

  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(
      45deg,
      transparent 0%,
      rgba(24, 144, 255, 0.03) 50%,
      transparent 100%
    );
    z-index: 0;
  }

  &::after {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 2px;
    background: linear-gradient(
      90deg,
      transparent,
      rgba(24, 144, 255, 0.6),
      transparent
    );
    transform: translateX(-100%);
    animation: border-flow 3s ease infinite;
  }

  &:hover {
    transform: translateY(-5px);
    border-color: rgba(24, 144, 255, 0.4);
    box-shadow: 
      0 5px 15px rgba(24, 144, 255, 0.1),
      0 0 30px rgba(24, 144, 255, 0.1);

    .range-header {
      .range-title {
        i {
          transform: rotate(180deg);
          color: #1890ff;
        }
      }
    }
  }

  &.running {
    border-color: rgba(82, 196, 26, 0.4);
    
    &::after {
      background: linear-gradient(
        90deg,
        transparent,
        rgba(82, 196, 26, 0.6),
        transparent
      );
    }

    .range-header {
      .range-title {
        i {
          color: #52c41a;
          animation: pulse 1.5s ease infinite;
        }
      }
    }
  }

  .range-header {
    position: relative;
    z-index: 1;
    padding: 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;

    .range-title {
      display: flex;
      align-items: center;
      gap: 10px;

      i {
        font-size: 24px;
        color: rgba(24, 144, 255, 0.8);
        transition: all 0.3s ease;
      }

      span {
        font-size: 16px;
        color: #fff;
        font-weight: 500;
      }

      .scene-type {
        margin-left: 10px;
        border: none;
        background: rgba(24, 144, 255, 0.1);
        backdrop-filter: blur(5px);
      }
    }

    .range-actions {
      display: flex;
      gap: 8px;

      .el-button {
        background: rgba(24, 144, 255, 0.1);
        border: 1px solid rgba(24, 144, 255, 0.2);
        backdrop-filter: blur(5px);
        transition: all 0.3s ease;

        &:hover {
          background: rgba(24, 144, 255, 0.2);
          border-color: rgba(24, 144, 255, 0.4);
          transform: translateY(-2px);
        }

        &.el-button--success {
          background: rgba(82, 196, 26, 0.1);
          border-color: rgba(82, 196, 26, 0.2);
          &:hover {
            background: rgba(82, 196, 26, 0.2);
            border-color: rgba(82, 196, 26, 0.4);
          }
        }

        &.el-button--danger {
          background: rgba(245, 34, 45, 0.1);
          border-color: rgba(245, 34, 45, 0.2);
          &:hover {
            background: rgba(245, 34, 45, 0.2);
            border-color: rgba(245, 34, 45, 0.4);
          }
        }

        &.el-button--warning {
          background: rgba(250, 173, 20, 0.1);
          border-color: rgba(250, 173, 20, 0.2);
          &:hover {
            background: rgba(250, 173, 20, 0.2);
            border-color: rgba(250, 173, 20, 0.4);
          }
        }
      }
    }
  }

  .range-content {
    position: relative;
    z-index: 1;
    padding: 0 20px 20px;

    .status-bar {
      display: flex;
      align-items: center;
      margin-bottom: 15px;
      padding: 10px;
      background: rgba(24, 144, 255, 0.05);
      border-radius: 6px;

      .status-dot {
        width: 8px;
        height: 8px;
        border-radius: 50%;
        margin-right: 8px;

        &.running {
          background: #52c41a;
          box-shadow: 0 0 10px rgba(82, 196, 26, 0.5);
          animation: pulse 1.5s ease infinite;
        }

        &.stopped {
          background: #ff4d4f;
          box-shadow: 0 0 10px rgba(245, 34, 45, 0.5);
        }
      }

      .status-text {
        color: rgba(255, 255, 255, 0.85);
        font-size: 14px;
      }
    }

    .progress-bar {
      .progress-info {
        display: flex;
        justify-content: space-between;
        margin-bottom: 8px;

        .progress-text {
          color: rgba(255, 255, 255, 0.85);
          font-size: 14px;
        }

        .progress-percentage {
          color: #1890ff;
          font-weight: 500;
        }
      }

      .el-progress-bar {
        background: rgba(24, 144, 255, 0.1);
        border-radius: 4px;

        .el-progress-bar__inner {
          background: linear-gradient(
            90deg,
            #1890ff,
            #36cfc9
          );
          box-shadow: 0 0 10px rgba(24, 144, 255, 0.3);
          transition: all 0.3s ease;
        }
      }
    }
  }
}

@keyframes border-flow {
  0% {
    transform: translateX(-100%);
  }
  50% {
    transform: translateX(100%);
  }
  100% {
    transform: translateX(-100%);
  }
}

@keyframes pulse {
  0% {
    opacity: 0.6;
  }
  50% {
    opacity: 1;
  }
  100% {
    opacity: 0.6;
  }
}

.scene-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  padding: 20px;
  
  .scene-avatar {
    position: relative;
    margin-right: 15px;

    .cyber-avatar {
      border: 2px solid rgba(24, 144, 255, 0.2);
      background: rgba(24, 144, 255, 0.1);
      transition: all 0.3s ease;

      i {
        font-size: 20px;
        color: #1890ff;
      }
    }

    .avatar-ring {
      position: absolute;
      top: -2px;
      left: -2px;
      right: -2px;
      bottom: -2px;
      border-radius: 50%;
      border: 2px solid rgba(24, 144, 255, 0.4);
      animation: avatar-pulse 2s ease-in-out infinite;
    }
  }

  .scene-info {
    flex: 1;
    min-width: 0;

    .scene-title {
      display: flex;
      align-items: center;
      gap: 8px;
      margin-bottom: 4px;
      font-size: 16px;
      color: #fff;
      font-weight: 500;

      .scene-type-tag {
        font-size: 12px;
        padding: 0 6px;
        height: 20px;
        line-height: 18px;
        background: rgba(24, 144, 255, 0.1);
        border: 1px solid rgba(24, 144, 255, 0.2);
        color: #1890ff;
      }
    }

    .scene-desc {
      font-size: 12px;
      color: rgba(255, 255, 255, 0.65);
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
  }
}

@keyframes avatar-pulse {
  0% {
    transform: scale(1);
    opacity: 0.6;
  }
  50% {
    transform: scale(1.1);
    opacity: 0.2;
  }
  100% {
    transform: scale(1);
    opacity: 0.6;
  }
}
</style> 