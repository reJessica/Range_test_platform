<!--
 描述: 彩虹轨道图
 作者: Jack Chen
 日期: 2020-04-18
-->

<template>
  <div class="wrap-container sn-container"> 
    <div class="sn-content"> 
      <div class="sn-title">网络安全威胁分布</div> 
      <div class="sn-body"> 
        <div class="wrap-container"> 
          <div class="chartsdom" id="chart_rbt"></div>

          <div class="preinfo" :class="`preinfo${index}`" v-for="(item, index) in arrData" :key="index">
            <span>{{ item.percent }}%</span>
            <span>{{ item.name }}</span>
          </div>

          <div class="preinfos" :class="`pre${i}`" v-for="(v, i) in arrData">
            <span></span>
            <span></span>
          </div>
        </div> 
      </div> 
    </div>   
  </div>
</template>

<script>
export default {
  name: "rainbow",
  data() {
    return {
      option: null,
      arrData: [{
        name: '高危威胁',
        percent: 15
      },{
        name: '中危威胁',
        percent: 25
      },{
        name: '低危威胁',
        percent: 30
      },{
        name: '可疑行为',
        percent: 20
      },{
        name: '正常流量',
        percent: 10
      }]
    }
  },
  mounted() {
    this.getEchart();
  },
  methods: {
    getEchart() {
      let myChart = echarts.init(document.getElementById('chart_rbt'));
      let itemStyle = {
        normal: {
          color: 'rgba(0, 0, 0, 0)',
        }
      }

      this.option = {
        color: ['#ff4d4f', '#faad14', '#1890ff', '#52c41a', '#13c2c2'],
        series: [{
          name: '高危威胁',
          type: 'pie',
          clockWise: false,
          startAngle: 90,
          hoverAnimation: false,
          radius: ['85%', '90%'],
          center: ['50%', '50%'],
          label: {
            normal: {
              show: false
            },
          },
          labelLine: {
            normal: {
              show: false
            }
          },
          itemStyle: {
            shadowColor: '#ff4d4f',
            shadowBlur: 15
          },
          data: [{
            value: 15,
            name: '15%',
            itemStyle: {
              normal: {
                color: '#ff4d4f'
              }
            }
          },{
            value: 85,
            name: '85%',
            itemStyle: itemStyle
          }]
        },{
          name: '中危威胁',
          type: 'pie',
          clockWise: false,
          startAngle: 90,
          hoverAnimation: false,
          radius: ['72%', '77%'],
          center: ['50%', '50%'],
          label: {
            normal: {
              show: false
            },
          },
          labelLine: {
            normal: {
              show: false
            }
          },
          itemStyle: {
            shadowColor: '#faad14',
            shadowBlur: 15
          },
          data: [{
            value: 25,
            name: '25%',
            itemStyle: {
              normal: {
                color: '#faad14'
              }
            }
          },{
            value: 75,
            name: '75%',
            itemStyle: itemStyle
          }]
        },{
          name: '低危威胁',
          type: 'pie',
          clockWise: false,
          startAngle: 90,
          hoverAnimation: false,
          radius: ['59%', '64%'],
          center: ['50%', '50%'],
          label: {
            normal: {
              show: false
            },
          },
          labelLine: {
            normal: {
              show: false
            }
          },
          itemStyle: {
            shadowColor: '#1890ff',
            shadowBlur: 15
          },
          data: [{
            value: 30,
            name: '30%',
            itemStyle: {
              normal: {
                color: '#1890ff'
              }
            }
          },{
            value: 70,
            name: '70%',
            itemStyle: itemStyle
          }]
        },{
          name: '可疑行为',
          type: 'pie',
          clockWise: false,
          startAngle: 90,
          hoverAnimation: false,
          radius: ['46%', '51%'],
          center: ['50%', '50%'],
          label: {
            normal: {
              show: false
            },
          },
          labelLine: {
            normal: {
              show: false
            }
          },
          itemStyle: {
            shadowColor: '#52c41a',
            shadowBlur: 15
          },
          data: [{
            value: 20,
            name: '20%',
            itemStyle: {
              normal: {
                color: '#52c41a'
              }
            }
          },{
            value: 80,
            name: '80%',
            itemStyle: itemStyle
          }]
        },{
          name: '正常流量',
          type: 'pie',
          clockWise: false,
          startAngle: 90,
          hoverAnimation: false,
          radius: ['33%', '38%'],
          center: ['50%', '50%'],
          label: {
            normal: {
              show: false
            },
          },
          labelLine: {
            normal: {
              show: false
            }
          },
          itemStyle: {
            shadowColor: '#13c2c2',
            shadowBlur: 15
          },
          data: [{
            value: 10,
            name: '10%',
            itemStyle: {
              normal: {
                color: '#13c2c2'
              }
            }
          },{
            value: 90,
            name: '90%',
            itemStyle: itemStyle
          }]
        }]
      }

      // 使用制定的配置项和数据显示图表
      myChart.setOption(this.option, true);

      window.addEventListener('resize', () => {
        myChart.resize();
      });
    }
  },
  beforeDestroy() {
    
  }
};
</script>

<style lang="scss" scoped>
.sn-container {
  left: 50px;
  top: 1548px;
  width: 586px;
  height: 400px;
  .chartsdom {
    width: 100%;
    height: 100%;
  }


  .preinfo {
    position: absolute;
    left: 63%;
    top: 50%;
    margin-left: -2.5em;
    -webkit-transform: translate(0%,-50%);
    -moz-transform: translate(0%,-50%);
    -ms-transform: translate(0%,-50%);
    -o-transform: translate(0%,-50%);
    transform: translate(0%,-50%);
    white-space: nowrap;
    font-size: 13px;
    span {
      &:nth-child(1) {
        margin-right: 10px;
      }
    }
    &.preinfo0 {
      color: #ff4d4f; 
      margin-top: -65px;
    }
    &.preinfo1 {
      color: #faad14; 
      margin-top: -87px;
    }
    &.preinfo2 {
      color: #1890ff; 
      margin-top: -109px;
    }
    &.preinfo3 {
      color: #52c41a; 
      margin-top: -131px;
    }
    &.preinfo4 {
      color: #13c2c2; 
      margin-top: -153px;
    }
  }

  .preinfos {
    position: absolute;
    left: 50%;
    top: 50%;
    width: 1px;
    height: 58px;
    background-color: #ff4d4f;
    -webkit-transform-origin: 50% 0;
    -moz-transform-origin: 50% 0;
    -ms-transform-origin: 50% 0;
    -o-transform-origin: 50% 0;
    transform-origin: 50% 0;
    span {
      &:nth-child(1) {
        width:8px;
        height:8px;
        -webkit-border-radius:100%;
        -moz-border-radius:100%;
        border-radius:100%;
        position:absolute;
        left: -3px;
        top: 50%;
      }
      &:nth-child(2) {
        width: 0;
        height: 0;
        border-width: 12px 5px 5px 5px;
        border-style: solid;
        position: absolute;
        left: -5px;
        top: 100%;
      }
    }
    &.pre0 {
      height: 65px; 
      background-color: #ff4d4f; 
      transform: rotate(-62.614deg);
      span {
        &:nth-child(1) {
          background-color: #ff4d4f;
        }
        &:nth-child(2) {
          border-color: #ff4d4f transparent transparent;
        }
      }
    }
    &.pre1 {
      height: 87px; 
      background-color: #faad14; 
      transform: rotate(125.593deg);
      span {
        &:nth-child(1) {
          background-color: #faad14;
        }
        &:nth-child(2) {
          border-color: #faad14 transparent transparent;
        }
      }
    }
    &.pre2 {
      height: 109px; 
      background-color: #1890ff; 
      transform: rotate(86.2006deg);
      span {
        &:nth-child(1) {
          background-color: #1890ff;
        }
        &:nth-child(2) {
          border-color: #1890ff transparent transparent;
        }
      }
    }
    &.pre3 {
      height: 131px; 
      background-color: #52c41a; 
      transform: rotate(-18.845deg);
      span {
        &:nth-child(1) {
          background-color: #52c41a;
        }
        &:nth-child(2) {
          border-color: #52c41a transparent transparent;
        }
      }
    }
    &.pre4 {
      height: 153px; 
      background-color: #13c2c2; 
      transform: rotate(149.666deg);
      span {
        &:nth-child(1) {
          background-color: #13c2c2;
        }
        &:nth-child(2) {
          border-color: #13c2c2 transparent transparent;
        }
      }
    }
  }
}
</style>
