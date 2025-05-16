<!--
 描述: 新闻无缝滚动
 作者: Jack Chen
 日期: 2020-04-18
-->

<template>
  <div class="wrap-container sn-container"> 
    <div class="sn-content"> 
      <div class="sn-title">新闻无缝滚动</div> 
      <div class="sn-body"> 
        <div class="wrap-container">

          <div class="table">
            <table border="0" cellpadding="0" cellspacing="0" class="table-header">
              <tbody>
                <tr>
                  <td width="60%">
                    <span>标 题</span>
                  </td>
                  <td width="20%">
                    <span>日 期</span>
                  </td>
                  <td width="20%">
                    <span>热 度</span>
                  </td>
                </tr>
              </tbody>
            </table>

            <vue-seamless-scroll :data="listData" class="seamless-warp" :class-option="optionSetting">
              <table border="0" cellpadding="0" cellspacing="0" class="item">
                <tbody>
                  <tr v-for="(item, index) in listData" :key="index">
                    <td width="100%" class="title">
                      <span>{{ item.title }}</span>
                    </td>
                    <td width="20%">
                      <span>{{ item.date }}</span>
                    </td>
                    <td width="20%">
                      <span :class="{colorRed: item.hot > 4999, colorOrange: item.hot < 10}">{{ item.hot }}</span>
                    </td>
                  </tr>
                </tbody>
            </table>
            </vue-seamless-scroll>
          </div>

        </div> 
      </div> 
    </div>   
  </div>
</template>

<script>
import vueSeamlessScroll from 'vue-seamless-scroll'

export default {
  name: "seamless",
  components: {
    vueSeamlessScroll
  },
  data() {
    return {
     listData: [{
        title: '发现新型SQL注入漏洞,建议及时更新系统补丁',
        date: '2024-03-15',
        hot: 2306
     }, {
        title: '成功拦截大规模DDOS攻击,防护系统表现优异',
        date: '2024-03-12',
        hot: 5689
     }, {
        title: '新版网络安全演练场景发布,增加物联网安全模块',
        date: '2024-03-10',
        hot: 3420
     }, {
        title: '发布最新Web应用防护最佳实践指南',
        date: '2024-03-08',
        hot: 2880
     }, {
        title: '成功举办"攻防演练2024"网络安全大赛',
        date: '2024-03-05',
        hot: 4158
     }, {
        title: '新增API接口安全测试功能,提升服务安全性',
        date: '2024-03-01',
        hot: 1889
     }, {
        title: '成功修复高危XSS漏洞,感谢安全团队反馈',
        date: '2024-02-28',
        hot: 3800
     }, {
        title: '更新网络安全培训课程,增加实战演练内容',
        date: '2024-02-25',
        hot: 2106
     }, {
        title: '发布2024年第一季度网络安全态势报告',
        date: '2024-02-20',
        hot: 4288
     }, {
        title: '成功阻止一起高级持续性威胁(APT)攻击',
        date: '2024-02-15',
        hot: 5288
     }, {
        title: '推出新版漏洞扫描工具,提升检测准确率',
        date: '2024-02-10',
        hot: 2005
     }, {
        title: '举办网络安全意识培训,提高团队安全意识',
        date: '2024-02-05',
        hot: 1258
     }, {
        title: '完成系统安全基线升级,符合最新安全标准',
        date: '2024-02-01',
        hot: 1980
     }, {
        title: '成功举办"数据安全与隐私保护"研讨会',
        date: '2024-01-28',
        hot: 1719
     }]
    }
  },
  computed: {
　　optionSetting () {
      return {
        step: 0.5, // 数值越大速度滚动越快
        limitMoveNum: 2, // 开始无缝滚动的数据量 this.dataList.length
        hoverStop: true, // 是否开启鼠标悬停stop
        direction: 1, // 0向下 1向上 2向左 3向右
        // autoPlay: false,
        openWatch: true, // 开启数据实时监控刷新dom
        singleHeight: 0, // 单步运动停止的高度(默认值0是无缝不停止的滚动) direction => 0/1
        singleWidth: 0, // 单步运动停止的宽度(默认值0是无缝不停止的滚动) direction => 2/3
        waitTime: 1000 // 单步运动停止的时间(默认值1000ms)
      }
    }
  },  
  mounted() {
    
  },
  methods: {
    
  },
  beforeDestroy() {
    
  }
};
</script>

<style lang="scss" scoped>
.sn-container {
  left: 1370px;
  top: 110px;
  %table-style {
    width: 100%;
    height: 35px;
    table-layout: fixed;
    tr {
      td {
        padding: 10px 5px;
        text-align: center;
        background-color: transparent;
        white-space: nowrap;
        overflow: hidden;
        color: #E2E5FF;
        font-size: 14px;
      }
    }
  }
  .table {
    .table-header {
      @extend %table-style;
    }
    .seamless-warp {
      height: 400px;
      overflow: hidden;
      visibility: visible;
      .colorRed {
        color: #FF4669;
      }
      .colorOrange {
        color: #FFC956;
      }
      .item {
        height: auto;
        @extend %table-style;
        tr {
          td {
            &.title {
              text-overflow: ellipsis;
              display: inline-block;
            }
          }
        }
      }
    }
  }
}
</style>
