<template>
  <div class="app-container">
    <!-- 顶部统计卡片 -->
    <el-row :gutter="20" class="card-row">
      <el-col :span="6" v-for="(stat, index) in statistics" :key="index">
        <el-card shadow="hover" class="stat-card" :class="stat.type">
          <div class="stat-header">
            <div class="stat-title">{{ stat.title }}</div>
            <div class="stat-icon">
              <i :class="stat.icon"></i>
            </div>
          </div>
          <div class="stat-number">
            <count-to
              :start-val="0"
              :end-val="stat.value"
              :duration="2000"
              separator=","
            />
          </div>
          <div class="stat-trend" v-if="stat.trend">
            <i :class="stat.trend > 0 ? 'el-icon-top' : 'el-icon-bottom'"></i>
            <span>{{ Math.abs(stat.trend) }}%</span>
            <span class="trend-label">较上周</span>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 威胁分布图表 -->
    <el-row :gutter="20" style="margin-top: 20px">
      <el-col :span="12">
        <el-card class="box-card chart-card">
          <div slot="header" class="clearfix">
            <span>威胁类型分布</span>
          </div>
          <div class="chart-container" ref="threatTypeChart"></div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card class="box-card chart-card">
          <div slot="header" class="clearfix">
            <span>威胁趋势分析</span>
          </div>
          <div class="chart-container" ref="threatTrendChart"></div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 搜索和过滤区域 -->
    <el-card class="box-card" style="margin-top: 20px">
      <div slot="header" class="clearfix">
        <span>威胁检测列表</span>
        <div class="header-operations">
          <span class="refresh-time">上次更新: {{ lastRefreshTime }}</span>
          <el-tooltip content="自动刷新" placement="top">
            <el-switch
              v-model="autoRefresh"
              @change="handleAutoRefreshChange"
              class="refresh-switch"
            />
          </el-tooltip>
          <el-tooltip content="立即刷新" placement="top">
            <i 
              class="el-icon-refresh refresh-icon" 
              :class="{ 'is-loading': loading }"
              @click="handleManualRefresh"
            ></i>
          </el-tooltip>
        </div>
      </div>

      <el-form :model="queryParams" ref="queryForm" :inline="true" v-show="showSearch" class="search-form">
        <el-form-item label="威胁类型" prop="threatType">
          <el-select v-model="queryParams.threatType" placeholder="请选择威胁类型" clearable size="small">
            <el-option
              v-for="item in threatTypes"
              :key="item.value"
              :label="item.label"
              :value="item.value">
              <i :class="item.icon" class="threat-type-icon"></i>
              {{ item.label }}
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="风险等级" prop="riskLevel">
          <el-select v-model="queryParams.riskLevel" placeholder="请选择风险等级" clearable size="small">
            <el-option
              v-for="item in riskLevels"
              :key="item.value"
              :label="item.label"
              :value="item.value">
              <el-tag :type="item.type" size="mini">{{ item.label }}</el-tag>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="时间范围" prop="timeRange">
          <el-date-picker
            v-model="queryParams.timeRange"
            type="datetimerange"
            size="small"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            value-format="yyyy-MM-dd HH:mm:ss"
            :picker-options="pickerOptions">
          </el-date-picker>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
          <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 操作按钮区域 -->
      <el-row :gutter="10" class="mb8">
        <el-col :span="1.5">
          <el-button
            type="danger"
            plain
            icon="el-icon-delete"
            size="mini"
            :disabled="multiple"
            @click="handleDelete"
            v-hasPermi="['security:threat:remove']"
          >删除</el-button>
        </el-col>
        <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <!-- 威胁列表 -->
      <el-table
        v-loading="loading"
        :data="threatList"
        @selection-change="handleSelectionChange"
        class="threat-table">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="威胁等级" align="center" width="100">
          <template slot-scope="scope">
            <div class="threat-level-indicator">
              <el-tag
                :type="getThreatLevelType(scope.row.riskLevel)"
                effect="dark"
                size="mini">
                {{ scope.row.riskLevel }}
              </el-tag>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="威胁类型" align="center" prop="threatType">
          <template slot-scope="scope">
            <div class="threat-type">
              <i :class="getThreatTypeIcon(scope.row.threatType)"></i>
              <span>{{ scope.row.threatType }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="威胁描述" align="left" prop="description" show-overflow-tooltip>
          <template slot-scope="scope">
            <div class="threat-description">
              <el-tooltip :content="scope.row.description" placement="top">
                <span>{{ scope.row.description }}</span>
              </el-tooltip>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="来源/目标" align="center" width="250">
          <template slot-scope="scope">
            <div class="ip-flow">
              <span class="source-ip">{{ scope.row.sourceIp }}</span>
              <i class="el-icon-right flow-arrow"></i>
              <span class="target-ip">{{ scope.row.targetIp }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="发现时间" align="center" width="180">
          <template slot-scope="scope">
            <div class="discovery-time">
              <i class="el-icon-time"></i>
              <span>{{ parseTime(scope.row.time) }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="状态" align="center" width="100">
          <template slot-scope="scope">
            <div class="threat-status">
              <el-tag
                :type="scope.row.status === '已处理' ? 'success' : 'danger'"
                effect="dark"
                size="mini">
                {{ scope.row.status }}
              </el-tag>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="150">
          <template slot-scope="scope">
            <el-button
              size="mini"
              type="text"
              icon="el-icon-view"
              @click="handleView(scope.row)"
            >详情</el-button>
            <el-button
              size="mini"
              type="text"
              icon="el-icon-check"
              v-if="scope.row.status !== '已处理'"
              @click="handleUpdate(scope.row)"
            >处理</el-button>
          </template>
        </el-table-column>
      </el-table>

      <pagination
        v-show="total > 0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
      />
    </el-card>

    <!-- 威胁详情对话框 -->
    <el-dialog
      :title="title"
      :visible.sync="open"
      width="700px"
      append-to-body
      class="threat-detail-dialog">
      <el-descriptions class="threat-details" :column="2" border>
        <el-descriptions-item label="威胁类型">
          <div class="threat-type">
            <i :class="getThreatTypeIcon(form.threatType)"></i>
            <span>{{ form.threatType }}</span>
          </div>
        </el-descriptions-item>
        <el-descriptions-item label="风险等级">
          <el-tag :type="getThreatLevelType(form.riskLevel)" effect="dark">
            {{ form.riskLevel }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="来源IP">
          <div class="ip-address">
            <i class="el-icon-location"></i>
            {{ form.sourceIp }}
          </div>
        </el-descriptions-item>
        <el-descriptions-item label="目标IP">
          <div class="ip-address">
            <i class="el-icon-location"></i>
            {{ form.targetIp }}
          </div>
        </el-descriptions-item>
        <el-descriptions-item label="发现时间">
          <div class="discovery-time">
            <i class="el-icon-time"></i>
            {{ form.time }}
          </div>
        </el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="form.status === '已处理' ? 'success' : 'danger'" effect="dark">
            {{ form.status }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="威胁描述" :span="2">
          {{ form.description }}
        </el-descriptions-item>
        <el-descriptions-item label="处理建议" :span="2">
          <div class="suggestion-content">
            <i class="el-icon-warning-outline"></i>
            {{ form.suggestion }}
          </div>
        </el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="open = false">关 闭</el-button>
        <el-button type="primary" v-if="form.status !== '已处理'" @click="handleUpdate(form)">
          立即处理
        </el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import * as echarts from 'echarts'
import CountTo from 'vue-count-to'

export default {
  name: "ThreatDetection",
  components: {
    CountTo
  },
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 威胁检测表格数据
      threatList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        threatType: undefined,
        riskLevel: undefined,
        timeRange: []
      },
      // 表单参数
      form: {},
      // 统计数据
      statistics: [
        {
          title: "总威胁数",
          value: 156,
          icon: "el-icon-warning",
          type: "total",
          trend: 12
        },
        {
          title: "高风险",
          value: 23,
          icon: "el-icon-danger",
          type: "high",
          trend: -5
        },
        {
          title: "中风险",
          value: 45,
          icon: "el-icon-warning",
          type: "medium",
          trend: 8
        },
        {
          title: "低风险",
          value: 88,
          icon: "el-icon-info",
          type: "low",
          trend: 15
        }
      ],
      // 威胁类型选项
      threatTypes: [
        { value: 'malware', label: '恶意软件', icon: 'el-icon-warning' },
        { value: 'attack', label: '网络攻击', icon: 'el-icon-remove-outline' },
        { value: 'leak', label: '数据泄露', icon: 'el-icon-document' },
        { value: 'abnormal', label: '异常行为', icon: 'el-icon-warning-outline' }
      ],
      // 风险等级选项
      riskLevels: [
        { value: 'high', label: '高', type: 'danger' },
        { value: 'medium', label: '中', type: 'warning' },
        { value: 'low', label: '低', type: 'info' }
      ],
      // 日期选择器配置
      pickerOptions: {
        shortcuts: [{
          text: '最近一小时',
          onClick(picker) {
            const end = new Date();
            const start = new Date();
            start.setTime(start.getTime() - 3600 * 1000);
            picker.$emit('pick', [start, end]);
          }
        }, {
          text: '最近一天',
          onClick(picker) {
            const end = new Date();
            const start = new Date();
            start.setTime(start.getTime() - 3600 * 1000 * 24);
            picker.$emit('pick', [start, end]);
          }
        }, {
          text: '最近一周',
          onClick(picker) {
            const end = new Date();
            const start = new Date();
            start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
            picker.$emit('pick', [start, end]);
          }
        }]
      },
      // 图表实例
      threatTypeChart: null,
      threatTrendChart: null,
      // 自动刷新相关
      lastRefreshTime: this.formatDateTime(new Date()),
      autoRefresh: false,
      refreshInterval: null,
      refreshRate: 30000 // 30秒刷新一次
    };
  },
  created() {
    this.getList();
  },
  mounted() {
    this.initCharts();
    window.addEventListener('resize', this.resizeCharts);
  },
  beforeDestroy() {
    this.clearRefreshInterval();
    window.removeEventListener('resize', this.resizeCharts);
    if (this.threatTypeChart) {
      this.threatTypeChart.dispose();
    }
    if (this.threatTrendChart) {
      this.threatTrendChart.dispose();
    }
  },
  methods: {
    getThreatTypeIcon(type) {
      const typeMap = {
        '恶意软件': 'el-icon-warning',
        '网络攻击': 'el-icon-remove-outline',
        '数据泄露': 'el-icon-document',
        '异常行为': 'el-icon-warning-outline'
      };
      return typeMap[type] || 'el-icon-warning';
    },
    getThreatLevelType(level) {
      const levelMap = {
        '高': 'danger',
        '中': 'warning',
        '低': 'info'
      };
      return levelMap[level] || 'info';
    },
    formatDateTime(date) {
      return new Date(date).toLocaleString();
    },
    handleAutoRefreshChange(value) {
      if (value) {
        this.refreshInterval = setInterval(() => {
          this.getList();
        }, this.refreshRate);
      } else {
        this.clearRefreshInterval();
      }
    },
    clearRefreshInterval() {
      if (this.refreshInterval) {
        clearInterval(this.refreshInterval);
        this.refreshInterval = null;
      }
    },
    handleManualRefresh() {
      this.getList();
    },
    resizeCharts() {
      if (this.threatTypeChart) {
        this.threatTypeChart.resize();
      }
      if (this.threatTrendChart) {
        this.threatTrendChart.resize();
      }
    },
    initCharts() {
      // 初始化威胁类型分布图表
      this.threatTypeChart = echarts.init(this.$refs.threatTypeChart);
      this.threatTypeChart.setOption({
        tooltip: {
          trigger: 'item'
        },
        legend: {
          orient: 'vertical',
          left: 'left',
          textStyle: {
            color: '#e4e9f2'
          }
        },
        series: [{
          name: '威胁类型',
          type: 'pie',
          radius: ['50%', '70%'],
          avoidLabelOverlap: false,
          itemStyle: {
            borderRadius: 10,
            borderColor: '#fff',
            borderWidth: 2
          },
          label: {
            show: false,
            position: 'center'
          },
          emphasis: {
            label: {
              show: true,
              fontSize: '20',
              fontWeight: 'bold'
            }
          },
          labelLine: {
            show: false
          },
          data: [
            { value: 35, name: '恶意软件' },
            { value: 25, name: '网络攻击' },
            { value: 20, name: '数据泄露' },
            { value: 15, name: '异常行为' }
          ]
        }]
      });

      // 初始化威胁趋势图表
      this.threatTrendChart = echarts.init(this.$refs.threatTrendChart);
      this.threatTrendChart.setOption({
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
        legend: {
          data: ['高风险', '中风险', '低风险'],
          textStyle: {
            color: '#e4e9f2'
          }
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: [{
          type: 'category',
          data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
          axisLine: {
            lineStyle: {
              color: '#e4e9f2'
            }
          }
        }],
        yAxis: [{
          type: 'value',
          axisLine: {
            lineStyle: {
              color: '#e4e9f2'
            }
          },
          splitLine: {
            lineStyle: {
              color: 'rgba(255, 255, 255, 0.1)'
            }
          }
        }],
        series: [
          {
            name: '高风险',
            type: 'bar',
            stack: 'total',
            emphasis: {
              focus: 'series'
            },
            data: [12, 15, 8, 23, 17, 10, 13]
          },
          {
            name: '中风险',
            type: 'bar',
            stack: 'total',
            emphasis: {
              focus: 'series'
            },
            data: [22, 18, 25, 20, 15, 19, 21]
          },
          {
            name: '低风险',
            type: 'bar',
            stack: 'total',
            emphasis: {
              focus: 'series'
            },
            data: [35, 42, 30, 38, 25, 32, 40]
          }
        ]
      });
    },
    /** 查询威胁检测列表 */
    async getList() {
      this.loading = true;
      try {
        // 这里添加获取数据的API调用
        await new Promise(resolve => setTimeout(resolve, 1000));
        this.threatList = [
          {
            id: 1,
            threatType: '网络攻击',
            riskLevel: '高',
            description: 'DDoS攻击尝试',
            sourceIp: '192.168.1.100',
            targetIp: '192.168.1.1',
            time: new Date(),
            status: '未处理',
            suggestion: '建议立即隔离受影响设备，启动DDoS防护措施'
          }
        ];
        this.total = 1;
        this.lastRefreshTime = this.formatDateTime(new Date());
      } catch (error) {
        console.error('获取数据失败:', error);
        this.$message.error('获取数据失败，请稍后重试');
      } finally {
        this.loading = false;
      }
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    /** 多选框选中数据 */
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    /** 查看按钮操作 */
    handleView(row) {
      this.form = row;
      this.title = "威胁详情";
      this.open = true;
    },
    /** 处理按钮操作 */
    handleUpdate(row) {
      this.$modal.confirm('确认要处理该威胁吗？').then(() => {
        this.$modal.msgSuccess("处理成功");
        this.getList();
      }).catch(() => {});
    },
    /** 删除按钮操作 */
    handleDelete() {
      this.$modal.confirm('是否确认删除选中的数据项？').then(() => {
        this.$modal.msgSuccess("删除成功");
        this.getList();
      }).catch(() => {});
    }
  }
};
</script>

<style lang="scss" scoped>
.app-container {
  background: linear-gradient(135deg, #1a1f3c 0%, #152238 100%);
  min-height: 100vh;
  padding: 20px;
  color: #e4e9f2;

  .box-card {
    background: rgba(255, 255, 255, 0.05);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.1);
    box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);

    .clearfix {
      display: flex;
      justify-content: space-between;
      align-items: center;
      color: #fff;
      font-size: 18px;
      font-weight: 500;

      .header-operations {
        display: flex;
        align-items: center;
        gap: 15px;

        .refresh-time {
          color: #8f9bb3;
          font-size: 14px;
        }

        .refresh-icon {
          font-size: 20px;
          cursor: pointer;
          transition: all 0.3s;
          color: #409EFF;

          &:hover {
            transform: rotate(180deg);
          }

          &.is-loading {
            animation: rotating 2s linear infinite;
          }
        }
      }
    }
  }

  .stat-card {
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.1);
    transition: all 0.3s;

    &:hover {
      transform: translateY(-5px);
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    }

    .stat-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 10px;

      .stat-title {
        color: #8f9bb3;
        font-size: 14px;
      }

      .stat-icon {
        font-size: 24px;
        
        i {
          &.red { color: #ff4d4f; }
          &.orange { color: #faad14; }
          &.blue { color: #409EFF; }
        }
      }
    }

    .stat-number {
      font-size: 28px;
      font-weight: 600;
      color: #fff;
      margin-top: 10px;
    }
  }

  .el-table {
    background: transparent;
    margin-top: 20px;

    &::before {
      display: none;
    }

    .el-table__header-wrapper {
      th {
        background: rgba(255, 255, 255, 0.05);
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        color: #fff;
      }
    }

    .el-table__body-wrapper {
      tr {
        background: transparent;
        transition: all 0.3s;

        &:hover > td {
          background: rgba(255, 255, 255, 0.05) !important;
        }

        td {
          background: transparent;
          border-bottom: 1px solid rgba(255, 255, 255, 0.1);
          color: #e4e9f2;
        }
      }
    }
  }

  .el-pagination {
    margin-top: 20px;
    text-align: right;
    color: #fff;

    .btn-prev,
    .btn-next,
    .el-pager li {
      background: transparent;
      color: #fff;
      border: 1px solid rgba(255, 255, 255, 0.1);

      &:hover {
        color: #409EFF;
      }

      &.active {
        background: #409EFF;
        color: #fff;
      }
    }
  }

  .el-form {
    .el-form-item__label {
      color: #e4e9f2;
    }

    .el-input__inner,
    .el-select .el-input__inner,
    .el-date-editor {
      background: rgba(255, 255, 255, 0.05);
      border: 1px solid rgba(255, 255, 255, 0.1);
      color: #fff;

      &::placeholder {
        color: rgba(255, 255, 255, 0.5);
      }
    }
  }
}

@keyframes rotating {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.el-dialog {
  background: linear-gradient(135deg, #1a1f3c 0%, #152238 100%);
  border: 1px solid rgba(255, 255, 255, 0.1);
  box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);

  .el-dialog__title {
    color: #fff;
  }

  .el-dialog__body {
    color: #e4e9f2;
  }

  .el-descriptions {
    background: transparent;
    
    .el-descriptions__label {
      color: #8f9bb3;
    }

    .el-descriptions__content {
      color: #e4e9f2;
    }
  }
}

.chart-card {
  .chart-container {
    height: 300px;
  }
}

.threat-table {
  .threat-type {
    display: flex;
    align-items: center;
    gap: 8px;
    
    i {
      font-size: 16px;
    }
  }

  .ip-flow {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;

    .flow-arrow {
      color: #409EFF;
    }
  }

  .discovery-time {
    display: flex;
    align-items: center;
    gap: 8px;

    i {
      color: #8f9bb3;
    }
  }
}

.threat-detail-dialog {
  .threat-details {
    .suggestion-content {
      display: flex;
      align-items: flex-start;
      gap: 8px;

      i {
        color: #e6a23c;
        font-size: 16px;
        margin-top: 2px;
      }
    }
  }
}

.stat-card {
  .stat-trend {
    margin-top: 10px;
    font-size: 14px;
    display: flex;
    align-items: center;
    gap: 5px;

    i {
      &.el-icon-top {
        color: #67C23A;
      }
      &.el-icon-bottom {
        color: #F56C6C;
      }
    }

    .trend-label {
      color: #8f9bb3;
      margin-left: 5px;
    }
  }

  &.total {
    background: linear-gradient(135deg, #1a237e 0%, #283593 100%);
  }

  &.high {
    background: linear-gradient(135deg, #c62828 0%, #d32f2f 100%);
  }

  &.medium {
    background: linear-gradient(135deg, #f57c00 0%, #fb8c00 100%);
  }

  &.low {
    background: linear-gradient(135deg, #0288d1 0%, #039be5 100%);
  }
}

.search-form {
  .threat-type-icon {
    margin-right: 8px;
  }
}
</style>