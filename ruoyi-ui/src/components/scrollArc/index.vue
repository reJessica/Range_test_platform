<!--
 描述: 滚动弧形线
 作者: Jack Chen
 日期: 2020-04-20
-->

<template>
  <div class="wrap-container sn-container"> 
    <div class="sn-content"> 
      <div class="sn-title">24小时攻击趋势</div> 
      <div class="sn-body"> 
        <div class="wrap-container"> 
          <div class="chartsdom" id="chart_arc"></div>
        </div> 
      </div> 
    </div>   
  </div>
</template>

<script>
export default {
  name: "scrollArc",
  data() {
    return {
      option: null,
      number: 0,
      timer: null,
      xData: ['00:00', '02:00', '04:00', '06:00', '08:00', '10:00', '12:00', '14:00', '16:00', '18:00', '20:00', '22:00'],
      attackData: [154, 186, 146, 177, 196, 189, 188, 223, 238, 183, 166, 198],
      defenseData: [92, 95, 88, 91, 94, 89, 92, 96, 97, 93, 90, 94],
      riskLevel: [3, 4, 2, 3, 4, 3, 3, 5, 5, 4, 3, 4]
    }
  },
  mounted() {
    this.getEchart();
  },
  methods: {
    getEchart() {
      let myChart = echarts.init(document.getElementById('chart_arc'));
      this.option = {
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow',
            shadowStyle: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                offset: 1,
                color: 'rgba(93,131,255,0.5)'
              },{
                offset: 0,
                color: 'rgba(255,255,255,0)'
              }])
            }
          }
        },
        legend: {
          data: ['攻击次数', '防护成功率', '风险等级'],
          textStyle: {
            color: '#fff'
          },
          top: 10
        },
        grid: {
          top: 50,
          left: 20,
          right: 40,
          bottom: 20,
          containLabel: true
        },
        xAxis: {
          type: 'category',
          data: this.xData,
          boundaryGap: false,
          axisTick: {
            show: false
          },
          axisLine: {
            lineStyle: {
              color: '#999'
            }
          }
        },
        yAxis: [{
          type: 'value',
          name: '攻击次数',
          min: 0,
          max: 300,
          axisLine: {
            lineStyle: {
              color: '#999'
            }
          },
          splitLine: {
            show: false
          }
        },
        {
          type: 'value',
          name: '防护率/风险等级',
          min: 0,
          max: 100,
          axisLine: {
            lineStyle: {
              color: '#999'
            }
          },
          splitLine: {
            show: false
          }
        }],
        series: [{
          name: '攻击次数',
          type: 'line',
          data: this.attackData,
          symbolSize: 8,
          itemStyle: {
            color: '#5d83ff',
            shadowColor: 'rgba(93,131,255,0.5)',
            shadowBlur: 10
          },
          lineStyle: {
            width: 2,
            shadowColor: 'rgba(93,131,255,0.5)',
            shadowBlur: 10
          },
          areaStyle: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
              offset: 0,
              color: 'rgba(93,131,255,0.3)'
            },{
              offset: 1,
              color: 'rgba(93,131,255,0.1)'
            }])
          },
          smooth: true
        },
        {
          name: '防护成功率',
          type: 'line',
          yAxisIndex: 1,
          data: this.defenseData,
          symbolSize: 8,
          itemStyle: {
            color: '#00ff9d',
            shadowColor: 'rgba(0,255,157,0.5)',
            shadowBlur: 10
          },
          lineStyle: {
            width: 2,
            shadowColor: 'rgba(0,255,157,0.5)',
            shadowBlur: 10
          },
          smooth: true
        },
        {
          name: '风险等级',
          type: 'scatter',
          yAxisIndex: 1,
          data: this.riskLevel.map((value, index) => [this.xData[index], value * 20]),
          symbolSize: 15,
          itemStyle: {
            color: function(params) {
              const colors = ['#00ff9d', '#ffeb3b', '#ff9800', '#ff5722', '#f44336'];
              return colors[params.data[1]/20 - 1];
            }
          }
        }]
      };
      myChart.setOption(this.option, true);

      window.addEventListener('resize', () => {
        myChart.resize();
      });

      this.timer = setInterval(() => {
        myChart.dispatchAction({
          type: 'showTip',
          seriesIndex: 0,
          dataIndex: this.number
        });
        this.number++;
        if (this.number > this.attackData.length) {
          this.number = 0;
        }
      }, 2000);
    }
  },
  beforeDestroy() {
    clearInterval(this.timer);
  }
};
</script>

<style lang="scss" scoped>
.sn-container {
  left: 50px;
  top: 690px;
  width: 895px;
  height: 400px;
  .chartsdom {
    width: 100%;
    height: 95%;
  }
}
</style>
