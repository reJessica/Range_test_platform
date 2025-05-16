<template>
  <div class="app-container">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>行为挖掘与威胁检测</span>
      </div>

      <!-- 搜索和过滤区域 -->
      <el-form :model="queryParams" ref="queryForm" :inline="true" v-show="showSearch">
        <el-form-item label="威胁类型" prop="threatType">
          <el-select v-model="queryParams.threatType" placeholder="请选择威胁类型" clearable size="small">
            <el-option label="恶意软件" value="malware" />
            <el-option label="网络攻击" value="attack" />
            <el-option label="数据泄露" value="leak" />
            <el-option label="异常行为" value="abnormal" />
          </el-select>
        </el-form-item>
        <el-form-item label="风险等级" prop="riskLevel">
          <el-select v-model="queryParams.riskLevel" placeholder="请选择风险等级" clearable size="small">
            <el-option label="高" value="high" />
            <el-option label="中" value="medium" />
            <el-option label="低" value="low" />
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
          />
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

      <!-- 威胁统计卡片 -->
      <el-row :gutter="20" class="card-row">
        <el-col :span="6">
          <el-card shadow="hover" class="stat-card">
            <div class="stat-header">
              <div class="stat-title">总威胁数</div>
              <div class="stat-icon">
                <i class="el-icon-warning"></i>
              </div>
            </div>
            <div class="stat-number">{{ statistics.total }}</div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card shadow="hover" class="stat-card">
            <div class="stat-header">
              <div class="stat-title">高风险</div>
              <div class="stat-icon red">
                <i class="el-icon-danger"></i>
              </div>
            </div>
            <div class="stat-number red">{{ statistics.high }}</div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card shadow="hover" class="stat-card">
            <div class="stat-header">
              <div class="stat-title">中风险</div>
              <div class="stat-icon orange">
                <i class="el-icon-warning"></i>
              </div>
            </div>
            <div class="stat-number orange">{{ statistics.medium }}</div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card shadow="hover" class="stat-card">
            <div class="stat-header">
              <div class="stat-title">低风险</div>
              <div class="stat-icon blue">
                <i class="el-icon-info"></i>
              </div>
            </div>
            <div class="stat-number blue">{{ statistics.low }}</div>
          </el-card>
        </el-col>
      </el-row>

      <!-- 威胁检测列表 -->
      <el-table
        v-loading="loading"
        :data="threatList"
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="序号" align="center" prop="id" width="80" />
        <el-table-column label="威胁类型" align="center" prop="threatType" />
        <el-table-column label="风险等级" align="center" prop="riskLevel">
          <template slot-scope="scope">
            <el-tag :type="scope.row.riskLevel === 'high' ? 'danger' : scope.row.riskLevel === 'medium' ? 'warning' : 'info'">
              {{ scope.row.riskLevel === 'high' ? '高' : scope.row.riskLevel === 'medium' ? '中' : '低' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="威胁描述" align="center" prop="description" :show-overflow-tooltip="true" />
        <el-table-column label="源IP" align="center" prop="sourceIp" />
        <el-table-column label="目标IP" align="center" prop="targetIp" />
        <el-table-column label="发现时间" align="center" prop="time" width="180">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.time) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="状态" align="center" prop="status">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === '已处理' ? 'success' : 'danger'">
              {{ scope.row.status }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
          <template slot-scope="scope">
            <el-button
              size="mini"
              type="text"
              icon="el-icon-view"
              @click="handleView(scope.row)"
              v-hasPermi="['security:threat:query']"
            >查看</el-button>
            <el-button
              size="mini"
              type="text"
              icon="el-icon-edit"
              @click="handleUpdate(scope.row)"
              v-hasPermi="['security:threat:handle']"
            >处理</el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <pagination
        v-show="total>0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
      />
    </el-card>

    <!-- 查看威胁详情对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="700px" append-to-body>
      <el-descriptions class="margin-top" title="威胁详情" :column="2" border>
        <el-descriptions-item label="威胁类型">{{ form.threatType }}</el-descriptions-item>
        <el-descriptions-item label="风险等级">{{ form.riskLevel }}</el-descriptions-item>
        <el-descriptions-item label="源IP">{{ form.sourceIp }}</el-descriptions-item>
        <el-descriptions-item label="目标IP">{{ form.targetIp }}</el-descriptions-item>
        <el-descriptions-item label="发现时间">{{ form.time }}</el-descriptions-item>
        <el-descriptions-item label="状态">{{ form.status }}</el-descriptions-item>
        <el-descriptions-item label="威胁描述" :span="2">{{ form.description }}</el-descriptions-item>
        <el-descriptions-item label="处理建议" :span="2">{{ form.suggestion }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="open = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: "ThreatDetection",
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
      statistics: {
        total: 156,
        high: 23,
        medium: 45,
        low: 88
      }
    };
  },
  created() {
    this.getList();
  },
  mounted() {
    this.getList();
    this.initBackgroundEffect();
  },
  methods: {
    /** 查询威胁检测列表 */
    getList() {
      this.loading = true;
      // 这里添加获取数据的API调用
      // listThreats(this.queryParams).then(response => {
      //   this.threatList = response.rows;
      //   this.total = response.total;
      //   this.loading = false;
      // });
      
      // 模拟数据
      setTimeout(() => {
        this.threatList = [
          {
            id: 1,
            threatType: '网络攻击',
            riskLevel: 'high',
            description: 'DDoS攻击尝试',
            sourceIp: '192.168.1.100',
            targetIp: '192.168.1.1',
            time: new Date(),
            status: '未处理',
            suggestion: '建议立即隔离受影响设备，启动DDoS防护措施'
          }
        ];
        this.total = 1;
        this.loading = false;
      }, 1000);
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
      this.title = "查看威胁详情";
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
    },
    initBackgroundEffect() {
        const container = document.querySelector('.app-container');
        const canvas = document.createElement('canvas');
        canvas.style.position = 'fixed';
        canvas.style.top = '0';
        canvas.style.left = '0';
        canvas.style.width = '100%';
        canvas.style.height = '100%';
        canvas.style.zIndex = '-1';
        canvas.style.opacity = '0.1';
        container.appendChild(canvas);

        const ctx = canvas.getContext('2d');
        const hexagons = [];

        function resize() {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
        }
        resize();
        window.addEventListener('resize', resize);

        class Hexagon {
            constructor() {
                this.reset();
            }

            reset() {
                this.x = Math.random() * canvas.width;
                this.y = Math.random() * canvas.height;
                this.size = Math.random() * 30 + 10;
                this.rotation = Math.random() * Math.PI;
                this.rotationSpeed = (Math.random() - 0.5) * 0.01;
                this.opacity = Math.random() * 0.5;
            }

            update() {
                this.rotation += this.rotationSpeed;
                this.y += 0.2;
                this.opacity -= 0.001;

                if (this.y > canvas.height + this.size || this.opacity <= 0) {
                    this.reset();
                    this.y = -this.size;
                }
            }

            draw() {
                ctx.save();
                ctx.translate(this.x, this.y);
                ctx.rotate(this.rotation);
                ctx.beginPath();
                for (let i = 0; i < 6; i++) {
                    const angle = (Math.PI * 2 / 6) * i;
                    const x = Math.cos(angle) * this.size;
                    const y = Math.sin(angle) * this.size;
                    if (i === 0) {
                        ctx.moveTo(x, y);
                    } else {
                        ctx.lineTo(x, y);
                    }
                }
                ctx.closePath();
                ctx.strokeStyle = `rgba(255, 255, 255, ${this.opacity})`;
                ctx.stroke();
                ctx.restore();
            }
        }

        for (let i = 0; i < 30; i++) {
            hexagons.push(new Hexagon());
        }

        function animate() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            hexagons.forEach(hexagon => {
                hexagon.update();
                hexagon.draw();
            });
            requestAnimationFrame(animate);
        }
        animate();
    }
  }
};
</script>

<style lang="scss" scoped>
.app-container {
  background: linear-gradient(135deg, #1a2b3c 0%, #0c1620 100%);
  min-height: 100vh;
  padding: 20px;
}

.box-card {
  background: rgba(16, 36, 64, 0.8);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);

  .clearfix {
    color: #fff;
    font-size: 1.5em;
    font-weight: 600;
    text-shadow: 0 0 10px rgba(255, 255, 255, 0.3);
  }
}

.card-row {
  margin-bottom: 20px;
}

.stat-card {
  background: rgba(16, 36, 64, 0.8);
  border-radius: 15px;
  padding: 20px;
  transition: all 0.3s ease;
  border: 1px solid rgba(255, 255, 255, 0.1);
  
  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.2);
  }

  .stat-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;

    .stat-title {
      color: rgba(255, 255, 255, 0.7);
      font-size: 1em;
    }

    .stat-icon {
      font-size: 1.5em;
      color: #fff;
      
      &.red { color: #ff4d4f; }
      &.orange { color: #faad14; }
      &.blue { color: #1890ff; }
    }
  }

  .stat-number {
    font-size: 2em;
    font-weight: 600;
    color: #fff;
    text-shadow: 0 0 10px rgba(255, 255, 255, 0.3);
    
    &.red { color: #ff4d4f; }
    &.orange { color: #faad14; }
    &.blue { color: #1890ff; }
  }
}

.el-table {
  background: transparent !important;
  margin-top: 20px;
  
  &::before {
    display: none;
  }

  .el-table__header-wrapper {
    th {
      background: rgba(16, 36, 64, 0.9) !important;
      color: #fff !important;
      border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }
  }

  .el-table__body-wrapper {
    tr {
      background: rgba(16, 36, 64, 0.6) !important;
      transition: all 0.3s ease;

      &:hover {
        background: rgba(16, 36, 64, 0.8) !important;
        td {
          background: transparent !important;
        }
      }

      td {
        border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        color: rgba(255, 255, 255, 0.8);
      }
    }
  }
}

.el-pagination {
  text-align: center;
  margin-top: 20px;
  
  .btn-prev,
  .btn-next,
  .el-pager li {
    background: rgba(16, 36, 64, 0.8) !important;
    color: #fff !important;
    border: 1px solid rgba(255, 255, 255, 0.1);
    
    &:hover {
      background: rgba(16, 36, 64, 0.9) !important;
    }
    
    &.active {
      background: #1890ff !important;
    }
  }
}

.el-form {
  .el-form-item__label {
    color: rgba(255, 255, 255, 0.8);
  }
  
  .el-input__inner,
  .el-select .el-input__inner,
  .el-date-editor {
    background: rgba(16, 36, 64, 0.8);
    border: 1px solid rgba(255, 255, 255, 0.1);
    color: #fff;
    
    &:hover,
    &:focus {
      border-color: #1890ff;
    }
  }
}

.el-button {
  &.el-button--primary {
    background: linear-gradient(45deg, #1890ff, #36cfc9);
    border: none;
    
    &:hover {
      background: linear-gradient(45deg, #40a9ff, #40d3c2);
      transform: translateY(-1px);
    }
  }
  
  &.el-button--danger {
    background: linear-gradient(45deg, #ff4d4f, #ff7875);
    border: none;
    
    &:hover {
      background: linear-gradient(45deg, #ff7875, #ffa39e);
      transform: translateY(-1px);
    }
  }
}

.el-tag {
  &.el-tag--danger {
    background: rgba(255, 77, 79, 0.2);
    border-color: #ff4d4f;
    color: #ff4d4f;
  }
  
  &.el-tag--warning {
    background: rgba(250, 173, 20, 0.2);
    border-color: #faad14;
    color: #faad14;
  }
  
  &.el-tag--info {
    background: rgba(24, 144, 255, 0.2);
    border-color: #1890ff;
    color: #1890ff;
  }
  
  &.el-tag--success {
    background: rgba(82, 196, 26, 0.2);
    border-color: #52c41a;
    color: #52c41a;
  }
}

.el-dialog {
  background: rgba(16, 36, 64, 0.95);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  
  .el-dialog__title {
    color: #fff;
  }
  
  .el-dialog__body {
    color: rgba(255, 255, 255, 0.8);
  }
  
  .el-descriptions {
    background: transparent;
    
    .el-descriptions-item__label {
      color: rgba(255, 255, 255, 0.6);
    }
    
    .el-descriptions-item__content {
      color: #fff;
    }
  }
}
</style>