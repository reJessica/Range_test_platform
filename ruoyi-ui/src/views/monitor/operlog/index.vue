<template>
  <div class="container-div">
    <div id="app1">
      <div class="search-box">
        <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch"
          label-width="68px">
          <el-form-item label="操作地址" prop="operIp">
            <el-input v-model="queryParams.operIp" placeholder="请输入操作地址" clearable style="width: 240px;"
              @keyup.enter.native="handleQuery" />
          </el-form-item>
          <el-form-item label="系统模块" prop="title">
            <el-input v-model="queryParams.title" placeholder="请输入系统模块" clearable style="width: 240px;"
              @keyup.enter.native="handleQuery" />
          </el-form-item>
          <el-form-item label="操作人员" prop="operName">
            <el-input v-model="queryParams.operName" placeholder="请输入操作人员" clearable style="width: 240px;"
              @keyup.enter.native="handleQuery" />
          </el-form-item>
          <el-form-item label="状态" prop="status">
            <el-select v-model="queryParams.status" placeholder="操作状态" clearable style="width: 240px">
              <el-option v-for="dict in dict.type.sys_common_status" :key="dict.value" :label="dict.label"
                :value="dict.value" />
            </el-select>
          </el-form-item>
          <el-form-item label="操作时间">
            <el-date-picker v-model="dateRange" style="width: 240px" value-format="yyyy-MM-dd HH:mm:ss" type="daterange"
              range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期"
              :default-time="['00:00:00', '23:59:59']"></el-date-picker>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
            <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
          </el-form-item>
        </el-form>
      </div>

      <div class="operation-box">
        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5">
            <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete"
              v-hasPermi="['monitor:operlog:remove']">删除</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="danger" plain icon="el-icon-delete" size="mini" @click="handleClean"
              v-hasPermi="['monitor:operlog:remove']">清空</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport"
              v-hasPermi="['monitor:operlog:export']">导出</el-button>
          </el-col>
          <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
        </el-row>
      </div>

      <el-card class="table-box monitor-card">
        <div slot="header">
          <span class="title-white"><i class="el-icon-document"></i> 操作日志列表</span>
        </div>
        <el-table ref="tables" v-loading="loading" :data="list" @selection-change="handleSelectionChange"
          :default-sort="defaultSort" @sort-change="handleSortChange">
          <el-table-column type="selection" width="50" align="center" />
          <el-table-column label="日志编号" align="center" prop="operId" />
          <el-table-column label="系统模块" align="center" prop="title" :show-overflow-tooltip="true" />
          <el-table-column label="操作人员" align="center" prop="operName" width="110" :show-overflow-tooltip="true"
            sortable="custom" :sort-orders="['descending', 'ascending']" />
          <el-table-column label="操作地址" align="center" prop="operIp" width="130" :show-overflow-tooltip="true" />
          <el-table-column label="操作地点" align="center" prop="operLocation" :show-overflow-tooltip="true" />
          <el-table-column label="操作状态" align="center" prop="status">
            <template slot-scope="scope">
              <dict-tag :options="dict.type.sys_common_status" :value="scope.row.status" />
            </template>
          </el-table-column>
          <el-table-column label="操作日期" align="center" prop="operTime" width="160" sortable="custom"
            :sort-orders="['descending', 'ascending']">
            <template slot-scope="scope">
              <span>{{ parseTime(scope.row.operTime) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="消耗时间" align="center" prop="costTime" width="110" :show-overflow-tooltip="true"
            sortable="custom" :sort-orders="['descending', 'ascending']">
            <template slot-scope="scope">
              <span>{{ scope.row.costTime }}毫秒</span>
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
            <template slot-scope="scope">
              <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row, scope.index)"
                v-hasPermi="['monitor:operlog:query']">详细</el-button>
            </template>
          </el-table-column>
        </el-table>

        <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum"
          :limit.sync="queryParams.pageSize" @pagination="getList" />
      </el-card>

      <!-- 操作日志详细 -->
      <el-dialog title="操作日志详细" :visible.sync="open" width="800px" append-to-body class="custom-dialog">
        <el-form ref="form" :model="form" label-width="100px" size="mini">
          <el-row>
            <el-col :span="12">
              <el-form-item label="操作模块：">{{ form.title }} / {{ typeFormat(form) }}</el-form-item>
              <el-form-item label="登录信息：">{{ form.operName }} / {{ form.operIp }} / {{ form.operLocation
                }}</el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="请求地址：">{{ form.operUrl }}</el-form-item>
              <el-form-item label="请求方式：">{{ form.requestMethod }}</el-form-item>
            </el-col>
            <el-col :span="24">
              <el-form-item label="操作方法：">{{ form.method }}</el-form-item>
            </el-col>
            <el-col :span="24">
              <el-form-item label="请求参数：">{{ form.operParam }}</el-form-item>
            </el-col>
            <el-col :span="24">
              <el-form-item label="返回参数：">{{ form.jsonResult }}</el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item label="操作状态：">
                <div v-if="form.status === 0">正常</div>
                <div v-else-if="form.status === 1">失败</div>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item label="消耗时间：">{{ form.costTime }}毫秒</el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item label="操作时间：">{{ parseTime(form.operTime) }}</el-form-item>
            </el-col>
            <el-col :span="24">
              <el-form-item label="异常信息：" v-if="form.status === 1">{{ form.errorMsg }}</el-form-item>
            </el-col>
          </el-row>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button @click="open = false">关 闭</el-button>
        </div>
      </el-dialog>
    </div>
  </div>
</template>

<script>
import { list, delOperlog, cleanOperlog } from "@/api/monitor/operlog";

export default {
  name: "Operlog",
  dicts: ['sys_common_status'],
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 表格数据
      list: [],
      // 是否显示弹出层
      open: false,
      // 日期范围
      dateRange: [],
      // 默认排序
      defaultSort: { prop: 'operTime', order: 'descending' },
      // 表单参数
      form: {},
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        operIp: undefined,
        title: undefined,
        operName: undefined,
        status: undefined
      }
    };
  },
  created() {
    this.getList();
    this.initBackgroundEffect();
  },
  methods: {
    /** 查询登录日志 */
    getList() {
      this.loading = true;
      list(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
        this.list = response.rows;
        this.total = response.total;
        this.loading = false;
      }
      );
    },
    // 操作日志类型字典翻译
    typeFormat(row, column) {
      return this.selectDictLabel(this.dict.type.sys_oper_type, row.businessType);
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.dateRange = [];
      this.resetForm("queryForm");
      this.queryParams.pageNum = 1;
      this.$refs.tables.sort(this.defaultSort.prop, this.defaultSort.order)
    },
    /** 多选框选中数据 */
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.operId)
      this.multiple = !selection.length
    },
    /** 排序触发事件 */
    handleSortChange(column, prop, order) {
      this.queryParams.orderByColumn = column.prop;
      this.queryParams.isAsc = column.order;
      this.getList();
    },
    /** 详细按钮操作 */
    handleView(row) {
      this.open = true;
      this.form = row;
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const operIds = row.operId || this.ids;
      this.$modal.confirm('是否确认删除日志编号为"' + operIds + '"的数据项？').then(function () {
        return delOperlog(operIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => { });
    },
    /** 清空按钮操作 */
    handleClean() {
      this.$modal.confirm('是否确认清空所有操作日志数据项？').then(function () {
        return cleanOperlog();
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("清空成功");
      }).catch(() => { });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('monitor/operlog/export', {
        ...this.queryParams
      }, `operlog_${new Date().getTime()}.xlsx`)
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
    window.removeEventListener('resize', this.resize);
  }
};
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

.search-box {
  background: rgba(16, 36, 64, 0.8);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 20px;
  position: relative;
  z-index: 3;

  :deep(.el-form-item__label) {
    color: rgba(255, 255, 255, 0.8);
  }

  :deep(.el-input__inner) {
    background: rgba(16, 36, 64, 0.6);
    border: 1px solid rgba(255, 255, 255, 0.1);
    color: white;

    &::placeholder {
      color: rgba(255, 255, 255, 0.3);
    }
  }

  :deep(.el-select .el-input__inner) {
    background: rgba(16, 36, 64, 0.6);
  }

  :deep(.el-button) {
    background: rgba(24, 144, 255, 0.2);
    border: 1px solid rgba(24, 144, 255, 0.3);
    color: #1890ff;

    &:hover {
      background: rgba(24, 144, 255, 0.3);
      border-color: #1890ff;
    }

    &[type="primary"] {
      background: #1890ff;
      color: white;

      &:hover {
        background: #40a9ff;
      }
    }
  }
}

.operation-box {
  margin-bottom: 20px;
  position: relative;
  z-index: 3;

  :deep(.el-button) {
    background: rgba(16, 36, 64, 0.8);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.1);
    color: white;

    &:hover {
      background: rgba(24, 144, 255, 0.2);
      border-color: #1890ff;
    }

    &[type="danger"] {
      color: #ff4d4f;
      border-color: rgba(255, 77, 79, 0.3);

      &:hover {
        background: rgba(255, 77, 79, 0.2);
        border-color: #ff4d4f;
      }
    }

    &[type="warning"] {
      color: #faad14;
      border-color: rgba(250, 173, 20, 0.3);

      &:hover {
        background: rgba(250, 173, 20, 0.2);
        border-color: #faad14;
      }
    }
  }
}

.pagination-container {
  background-color: transparent !important;
}

.monitor-card {
  background: rgba(16, 36, 64, 0.8) !important;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1) !important;
  border-radius: 12px !important;
  transition: all 0.3s ease;
  position: relative;
  z-index: 3;

  :deep(.el-card__header) {
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    padding: 15px 20px;
  }

  :deep(.el-table) {
    background: transparent !important;

    &::before {
      display: none;
    }

    th {
      background: rgba(16, 36, 64, 0.6) !important;
      border: none !important;
      color: rgba(255, 255, 255, 0.8) !important;
      font-weight: normal;
    }

    td {
      background: rgba(16, 36, 64, 0.4) !important;
      border: none !important;
      color: rgba(255, 255, 255, 0.8) !important;
    }

    tr:hover td {
      background: rgba(24, 144, 255, 0.1) !important;
    }
  }

  :deep(.el-pagination) {
    background: transparent;
    padding: 20px 0;
    text-align: center;

    .el-pagination__total,
    .el-pagination__jump {
      color: rgba(255, 255, 255, 0.8);
    }

    .btn-prev,
    .btn-next {
      background: transparent;
      color: rgba(255, 255, 255, 0.8);

      &:disabled {
        color: rgba(255, 255, 255, 0.3);
      }
    }

    .el-pager li {
      background: transparent;
      color: rgba(255, 255, 255, 0.8);
      border: 1px solid rgba(255, 255, 255, 0.1);

      &.active {
        color: #1890ff;
        border-color: #1890ff;
      }

      &:hover {
        color: #1890ff;
      }
    }

    .el-input__inner {
      background: rgba(16, 36, 64, 0.6);
      border: 1px solid rgba(255, 255, 255, 0.1);
      color: white;

      &::placeholder {
        color: rgba(255, 255, 255, 0.3);
      }
    }
  }
}

.title-white {
  color: white;
  font-weight: bold;
  font-size: 15px;
  display: flex;
  align-items: center;

  i {
    margin-right: 8px;
    font-size: 18px;
    color: #1890ff;
  }
}

.custom-dialog {
  :deep(.el-dialog) {
    background: rgba(16, 36, 64, 0.95);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 12px;

    .el-dialog__title {
      color: white;
    }

    .el-dialog__body {
      color: rgba(255, 255, 255, 0.8);
    }

    .el-form-item__label {
      color: rgba(255, 255, 255, 0.8);
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

// 响应式布局
@media screen and (max-width: 768px) {
  #app1 {
    padding: 10px;
  }

  .search-box {
    padding: 10px;
  }
}
</style>
