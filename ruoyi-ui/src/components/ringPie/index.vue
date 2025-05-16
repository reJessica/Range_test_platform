<!--
 描述: 环形饼图
 作者: Jack Chen
 日期: 2020-05-02
-->

<template>
  <div class="wrap-container sn-container"> 
    <div class="sn-content"> 
      <div class="sn-title">系统安全运行状态</div> 
      <div class="sn-body"> 
        <div class="wrap-container ring-pie"> 
          <div class="back-chart"> 
           <svg width="100%" height="100%" viewBox="0 0 150 150" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"> 
            <path id="svg_2" d="m3,75c0,-39.77901 32.22099,-72 72,-72c39.77901,0 72,32.22099 72,72c0,39.77901 -32.22099,72 -72,72c-39.77901,0 -72,-32.22099 -72,-72z" stroke="#00b8fe" fill-opacity="null" fill="none"></path> 
           </svg> 
          </div>

          <div class="chartsdom" id="chart_rp"></div>

          <div class="arrow-cir arrow-cir1"></div>
          <div class="arrow-cir arrow-cir2"></div>
        </div> 
      </div> 
    </div>   
  </div>
</template>

<script>
export default {
  name: "ringPie",
  data() {
    return {
      option: null,
      timer: null
    }
  },
  mounted() {
    this.getEchart();
    this.startAutoRotate();
  },
  methods: {
    getEchart() {
      let myChart = echarts.init(document.getElementById('chart_rp'));
      this.option = {
        tooltip: {
          trigger: 'item',
          formatter: '{b}: {c}%'
        },
        title: [{
          text: '安全评分',
          x: 'center',
          top: '38%',
          textStyle: {
            color: '#fff',
            fontSize: 14,
            fontWeight: 'normal'
          }
        }, {
          text: '92',
          x: 'center',
          top: '48%',
          textStyle: {
            color: '#00b8fe',
            fontSize: 28,
            fontWeight: 'bold'
          }
        }],
        series: [{
          name: '系统安全运行状态',
          type: 'pie',
          radius: ['60%', '75%'],
          center: ['50%', '50%'],
          startAngle: 90,
          hoverAnimation: true,
          avoidLabelOverlap: true,
          label: {
            show: true,
            position: 'outside',
            formatter: function(params) {
              if (params.name === '正常') {
                return '{normal|' + params.name + '}\n{rate|' + params.value + '%}';
              }
              return params.name + '\n' + params.value + '%';
            },
            rich: {
              normal: {
                color: '#fff',
                fontSize: 12,
                padding: [0, 0, 0, -15]
              },
              rate: {
                color: '#fff',
                fontSize: 12,
                padding: [0, 0, 0, -15]
              }
            },
            fontSize: 12,
            color: '#fff',
            distanceToLabelLine: 10
          },
          labelLayout: function(params) {
            const isLeft = params.labelRect.x < myChart.getWidth() / 2;
            const points = params.labelLinePoints;
            // 左侧标签
            if (isLeft) {
              points[2][0] = params.labelRect.x;
              return {
                labelLinePoints: points
              };
            } else {
              // 右侧标签
              points[2][0] = params.labelRect.x + params.labelRect.width;
              return {
                labelLinePoints: points
              };
            }
          },
          labelLine: {
            show: true,
            length: 15,
            length2: 10,
            smooth: true,
            lineStyle: {
              color: '#00b8fe',
              width: 1
            }
          },
          itemStyle: {
            borderWidth: 2,
            borderColor: '#0b1c51'
          },
          data: [{
            value: 40, 
            name: '正常',
            itemStyle: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                offset: 0, 
                color: '#00b8fe'
              },{
                offset: 1, 
                color: '#2482ff'
              }])
            }
          },{
            value: 25, 
            name: '防护',
            itemStyle: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                offset: 0,
                color: '#00ffc6'
              },{
                offset: 1,
                color: '#00d5dc'
              }])
            }
          },{
            value: 20,
            name: '关注',
            itemStyle: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                offset: 0,
                color: '#ffcf00'
              },{
                offset: 1,
                color: '#ff9000'
              }])
            }
          },{
            value: 15,
            name: '处理',
            itemStyle: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                offset: 0,
                color: '#ff4d4d'
              },{
                offset: 1,
                color: '#ff0844'
              }])
            }
          }]
        }]
      }

      myChart.setOption(this.option, true);

      window.addEventListener('resize', () => {
        myChart.resize();
      });

      this.myChart = myChart;
    },
    startAutoRotate() {
      let angle = 90;
      this.timer = setInterval(() => {
        angle = angle + 1;
        this.myChart.setOption({
          series: [{
            type: 'pie',
            clockwise: true,
            startAngle: angle
          }]
        });
      }, 100);
    }
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.chartResize);
    if (this.timer) {
      clearInterval(this.timer);
    }
  }
};
</script>

<style lang="scss" scoped>
.sn-container {
  left: 974px;
  top: 1978px;
  width: 432px;
  height: 400px;
  .wrap-container {
    left: 125px;
    top: 94px;
    width: 200px;
    height: 200px;
    position: relative;
  }
  .chartsdom {
    width: 100%;
    height: 100%;
    position: relative;
    z-index: 2;
  }

  .back-chart{
    width: 100%;
    height: 100%;
    position: absolute;
    left: 0;
    top: 0;
    background:url(../../assets/img/back_chart.png) no-repeat center;
    background-size: contain;
    z-index: 1;
    opacity: 0.8;
  }
  .arrow-cir {
    width: 8px;
    height: 8px;
    offset-distance: 0%;
    position: absolute;
    top: 0;
    left: 0;
    opacity: 0;
    z-index: 3;
    &.arrow-cir1 {
      background: url(../../assets/img/icon_04.png) no-repeat 50% 50%;
      -webkit-animation: arrow-cir1 5s linear infinite;
      animation: arrow-cir1 5s linear infinite;
      offset-path: path("m3,75c0,-39.77901 32.22099,-72 72,-72c39.77901,0 72,32.22099 72,72c0,39.77901 -32.22099,72 -72,72c-39.77901,0 -72,-32.22099 -72,-72z");
    }
    &.arrow-cir2 {
      background: url(../../assets/img/icon_05.png) no-repeat 50% 50%;
      -webkit-animation: arrow-cir2 5s linear infinite;
      animation: arrow-cir2 5s linear infinite;
      offset-path: path("m3,75c0,-39.77901 32.22099,-72 72,-72c39.77901,0 72,32.22099 72,72c0,39.77901 -32.22099,72 -72,72c-39.77901,0 -72,-32.22099 -72,-72z");
    }
  }
}

@-webkit-keyframes arrow-cir1 {
  0% {
    offset-distance: 40%;
    opacity: 1;
  }
  100% {
    offset-distance: 140%;
    opacity: 1;
  }
}
@keyframes arrow-cir1 {
  0% {
    offset-distance: 40%;
    opacity: 1;
  }
  100% {
    offset-distance: 140%;
    opacity: 1;
  }
}

@-webkit-keyframes arrow-cir2 {
  0% {
    offset-distance: 0%;
    opacity: 1;
  }
  100% {
    offset-distance: 100%;
    opacity: 1;
  }
}
@keyframes arrow-cir2 {
  0% {
    offset-distance: 0%;
    opacity: 1;
  }
  100% {
    offset-distance: 100%;
    opacity: 1;
  }
}
</style>
