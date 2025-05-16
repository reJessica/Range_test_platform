<!--
 描述: 扫描半径图
 作者: Jack Chen
 日期: 2020-04-30
-->

<template>
  <div class="wrap-container sn-container"> 
    <div class="sn-content"> 
      <div class="sn-title">扫描半径图</div> 
      <div class="sn-body"> 
        <div class="wrap-container"> 
          <div class="chartsdom" id="chart_scan"></div>
          <div class="box">
            <div class="nodetext text0">
              <span>漏洞扫描</span>
            </div>
            <div class="nodetext text1">
              <span>入侵检测</span>
            </div>
            <div class="nodetext text2">
              <span>威胁情报</span>
            </div>
            <div class="nodetext text3">
              <span>资产识别</span>
            </div>
            <div class="nodetext text4">
              <span>安全审计</span>
            </div>
          </div>
        </div> 
      </div> 
    </div>   
  </div>
</template>

<script>
export default {
  name: "scanRadius",
  data() {
    return {
      option: null,
      option2: null,
      val: 0
    }
  },
  mounted() {
    this.getEchart();
  },
  methods: {
    getEchart() {
      let myChart = echarts.init(document.getElementById('chart_scan'));
      let arrData = [{
        value: 3,
        name: '漏洞扫描',
        itemStyle: {
          normal: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
              offset: 0,
              color: '#00ffd8'
            },{
              offset: 1,
              color: '#007a88'
            }])
          }
        }
      },{
        value: 4.5,
        name: '入侵检测',
        itemStyle: {
          normal: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
              offset: 0,
              color: '#0066ff'
            },{
              offset: 1,
              color: '#002a88'
            }])
          }
        }
      },{
        value: 3,
        name: '威胁情报',
        itemStyle: {
          normal: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
              offset: 0,
              color: '#ff3d7f'
            },{
              offset: 1,
              color: '#ff1493'
            }])
          }
        }
      },{
        value: 5.5,
        name: '资产识别',
        itemStyle: {
          normal: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
              offset: 0,
              color: '#b4ff00'
            },{
              offset: 1,
              color: '#00ff9d'
            }])
          }
        }
      },{
        value: 3,
        name: '安全审计',
        itemStyle: {
          normal: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
              offset: 0,
              color: '#ffcf00'
            },{
              offset: 1,
              color: '#ff9a00'
            }])
          }
        }
      }];

      for (let i = 0; i < arrData.length; i++) {
        this.val += arrData[i].value;
      }

      arrData.push({
        value: this.val,
        name: '__other',
        itemStyle: {
          normal: {
            color: 'rgba(0, 0, 0, 0)'
          }
        }
      });

      // 添加多层扫描动画
      let scanCircles = [];
      for(let i = 1; i <= 3; i++) {
        scanCircles.push({
          name: `扫描圈${i}`,
          type: 'pie',
          clockWise: false,
          startAngle: 0,
          hoverAnimation: false,
          radius: [`${90 - (i-1)*10}%`, `${90 - (i-1)*10}%`],
          center: ['50%', '50%'],
          label: {
            normal: {
              show: false
            }
          },
          labelLine: {
            normal: {
              show: false
            }
          },
          data: [{
            value: 10,
            itemStyle: {
              normal: {
                color: 'rgba(0, 0, 0, 0)',
                borderColor: `rgba(21, 103, 214, ${0.8 - (i-1)*0.2})`,
                borderWidth: 3 - (i-1)*0.5,
                borderType: 'dashed',
                shadowBlur: 15,
                shadowColor: 'rgba(21, 103, 214, 0.5)'
              }
            }
          },{
            value: 10,
            itemStyle: {
              normal: {
                color: 'rgba(0, 0, 0, 0)'
              }
            }
          }]
        });
      }

      this.option = {
        backgroundColor: 'transparent',
        label: {
          normal: {
            show: false
          }
        },
        labelLine: {
          normal: {
            show: false
          }
        },
        tooltip: {
          trigger: 'item',
          formatter: '{b0}<br/>占比: {c0}%',
          backgroundColor: 'rgba(0,10,30,0.9)',
          borderColor: 'rgba(21, 103, 214, 0.5)',
          borderWidth: 1,
          padding: [8, 12],
          textStyle: {
            color: '#fff',
            fontSize: 12
          }
        },
        series: [{
          name: '安全扫描',
          type: 'pie',
          startAngle: -180,
          radius: '190%',
          center: ['50%', '50%'],
          roseType: 'radius',
          z: 0,
          label: {
            show: false
          },
          emphasis: {
            scale: true,
            scaleSize: 5,
            itemStyle: {
              shadowBlur: 20,
              shadowColor: 'rgba(0,0,0,0.5)'
            }
          },
          data: arrData
        },
        ...scanCircles
        ]
      };

      // 添加多层扫描动画效果
      let angles = [0, 120, 240];
      setInterval(() => {
        angles = angles.map(angle => (angle + 2) % 360);
        myChart.setOption({
          series: scanCircles.map((circle, index) => ({
            name: circle.name,
            startAngle: angles[index]
          }))
        });
      }, 50);

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
  left: 1308px;
  top: 2408px;
  width: 560px;
  height: 400px;
  .chartsdom {
    position: absolute;
    width: 100%;
    height: 100%;
    filter: drop-shadow(0 0 10px rgba(21, 103, 214, 0.2));
  }

  .box {
    overflow: hidden;
    .nodetext {
      position: absolute;
      left: 50%;
      top: 51%;
      margin-left: -9px;
      transform: translate(0%, -60%);
      color: #00c2ff;
      font-size: 13px;
      text-shadow: 0 0 10px rgba(0,194,255,0.5);
      transition: all 0.3s ease;

      &:hover {
        color: #fff;
        text-shadow: 0 0 15px rgba(255,255,255,0.8);
      }

      &.text0 {
        border-right: 2px rgba(29,122,248,0.54) solid;
        border-bottom: 2px rgba(29,122,248,0.54) solid;
        width: 70px;
        height: 50px;
        margin-left: -110px;
        margin-top: 25px;
        span {
          position: absolute;
          margin-top: 50px;
        }
        &:before {
          content: '';
          position: absolute;
          width: 5px;
          height: 5px;
          margin-top: 47px;
          border-radius: 100%;
          background: rgb(47,138,240);
          box-shadow: 0 0 10px rgba(47,138,240,0.8);
        }
      }

      &.text1 {
        border-right: 2px rgba(29,122,248,0.54) solid;
        border-bottom: 2px rgb(134,92,255) solid;
        width: 30px;
        height: 80px;
        margin-left: -50px;
        margin-top: 44px;
        border-image: linear-gradient(rgba(29,122,248,0.54), rgb(134,92,255)) 2 2;
        span {
          position: absolute;
          margin-left: -50px;
          margin-top: 83px;
        }
        &:before {
          content: '';
          position: absolute;
          width: 5px;
          height: 5px;
          margin-top: 77px;
          border-radius: 100%;
          background: rgb(117,94,255);
          box-shadow: 0 0 10px rgba(117,94,255,0.8);
        }
      }

      &.text2 {
        border-right: 2px rgba(29,122,248,0.54) solid;
        width: 30px;
        height: 93px;
        margin-top: 53px;
        margin-left: -31px;
        border-image: linear-gradient(rgb(10,106,255), rgba(112,107,189,0.54), rgb(214,108,123)) 2 2;
        span {
          position: absolute;
          display: block;
          width: 330px;
          margin-left: 8px;
          margin-top: 100px;
        }
        &:before {
          content: '';
          position: absolute;
          width: 5px;
          height: 5px;
          margin-top: 92px;
          margin-left: 26px;
          border-radius: 100%;
          background: rgb(197,73,89);
          box-shadow: 0 0 10px rgba(197,73,89,0.8);
        }
      }

      &.text3 {
        border-left: 2px rgba(29,122,248,0.54) solid;
        border-bottom: 2px rgba(29,122,248,0.54) solid;
        width: 30px;
        height: 80px;
        margin-left: 18px;
        margin-top: 44px;
        border-image: linear-gradient(rgba(29,122,248,0.54), rgba(136,135,162,0.5), rgb(249,161,77)) 2 2;
        span {
          position: absolute;
          display: block;
          width: 330px;
          margin-left: 6px;
          margin-top: 83px;
        }
        &:before {
          content: '';
          position: absolute;
          width: 5px;
          height: 5px;
          margin-top: 77px;
          margin-left: 27px;
          border-radius: 100%;
          background: rgb(230,137,50);
          box-shadow: 0 0 10px rgba(230,137,50,0.8);
        }
      }

      &.text4 {
        border-left: 2px rgba(29,122,248,0.54) solid;
        border-bottom: 2px rgba(29,122,248,0.54) solid;
        width: 70px;
        height: 50px;
        margin-left: 40px;
        margin-top: 25px;
        border-image: linear-gradient(rgba(29,122,248,0.54), rgba(51,181,255,0.64), rgb(92,255,255)) 2 2;
        span {
          position: absolute;
          display: block;
          width: 330px;
          margin-left: 10px;
          margin-top: 50px;
        }
        &:before {
          content: '';
          position: absolute;
          width: 5px;
          height: 5px;
          margin-top: 47px;
          margin-left: 63px;
          border-radius: 100%;
          background: rgb(56,208,231);
          box-shadow: 0 0 10px rgba(56,208,231,0.8);
        }
      }
    }
  }
}
</style>
