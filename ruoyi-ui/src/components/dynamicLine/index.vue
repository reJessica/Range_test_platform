<!--
 描述: 动态轮播折线图
 作者: Jack Chen
 日期: 2020-04-18
-->

<template>
  <div class="wrap-container sn-container"> 
    <div class="sn-content"> 
      <div class="sn-title">实时威胁事件监控</div> 
      <div class="sn-body"> 
        <div class="wrap-container"> 
          <div class="chartsdom" id="chart_dt"></div> 
        </div> 
      </div> 
    </div>   
  </div>
</template>

<script>
export default {
  name: "dynamicLine",
  data() {
    return {
      option: null,
      timer: null,
      xData: [],
      now: +new Date(),
      values: {
        malware: Math.random() * 50,
        ddos: Math.random() * 30,
        intrusion: Math.random() * 40,
        vulnerability: Math.random() * 20
      },
      oneDay: 3000 // 3秒
    }
  },
  mounted() {
    this.getEchart();
  },
  methods: {
    randomData() {
      this.now = new Date(+this.now + this.oneDay);
      // 模拟不同类型的安全事件数据
      this.values.malware = Math.max(0, this.values.malware + Math.random() * 10 - 5);
      this.values.ddos = Math.max(0, this.values.ddos + Math.random() * 8 - 4);
      this.values.intrusion = Math.max(0, this.values.intrusion + Math.random() * 12 - 6);
      this.values.vulnerability = Math.max(0, this.values.vulnerability + Math.random() * 6 - 3);
      
      return {
        name: this.now.toString(),
        malware: Math.round(this.values.malware),
        ddos: Math.round(this.values.ddos),
        intrusion: Math.round(this.values.intrusion),
        vulnerability: Math.round(this.values.vulnerability)
      };
    },
    getEchart() {
      let myChart = echarts.init(document.getElementById('chart_dt'));
      let data = [];
      
      // 初始化数据
      for (let i = 0; i < 50; i++) {
        data.push(this.randomData());
      }

      this.option = {
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'cross',
            label: {
              backgroundColor: '#283b56'
            }
          }
        },
        legend: {
          data: ['恶意软件', 'DDoS攻击', '入侵事件', '漏洞利用'],
          textStyle: {
            color: '#2867a8'
          }
        },
        grid: {
          top: '15%',
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          boundaryGap: false,
          data: data.map(item => {
            let date = new Date(item.name);
            return date.getHours() + ':' + 
                   date.getMinutes().toString().padStart(2, '0') + ':' +
                   date.getSeconds().toString().padStart(2, '0');
          }),
          axisTick: {
            show: false
          },
          axisLine: {
            show: true,
            lineStyle: {
              color: '#2867a8'
            }
          },
          splitLine: {
            show: false
          }
        },
        yAxis: {
          type: 'value',
          scale: true,
          name: '事件数量',
          min: 0,
          axisTick: {
            show: false
          },
          axisLine: {
            show: true,
            lineStyle: {
              color: '#2867a8'
            }
          },
          splitLine: {
            show: false
          }
        },
        series: [
          {
            name: '恶意软件',
            type: 'line',
            data: data.map(item => item.malware),
            smooth: true,
            itemStyle: {
              color: '#ff4757'
            }
          },
          {
            name: 'DDoS攻击',
            type: 'line',
            data: data.map(item => item.ddos),
            smooth: true,
            itemStyle: {
              color: '#2ed573'
            }
          },
          {
            name: '入侵事件',
            type: 'line',
            data: data.map(item => item.intrusion),
            smooth: true,
            itemStyle: {
              color: '#ffa502'
            }
          },
          {
            name: '漏洞利用',
            type: 'line',
            data: data.map(item => item.vulnerability),
            smooth: true,
            itemStyle: {
              color: '#1e90ff'
            }
          }
        ]
      };

      myChart.setOption(this.option);

      window.addEventListener('resize', () => {
        myChart.resize();
      });

      // 定时更新数据
      this.timer = setInterval(() => {
        const newData = this.randomData();
        data.shift();
        data.push(newData);
        
        // 更新X轴数据
        this.option.xAxis.data.shift();
        const date = new Date(newData.name);
        this.option.xAxis.data.push(
          date.getHours() + ':' + 
          date.getMinutes().toString().padStart(2, '0') + ':' + 
          date.getSeconds().toString().padStart(2, '0')
        );

        // 更新各个系列的数据
        this.option.series[0].data = data.map(item => item.malware);
        this.option.series[1].data = data.map(item => item.ddos);
        this.option.series[2].data = data.map(item => item.intrusion);
        this.option.series[3].data = data.map(item => item.vulnerability);

        myChart.setOption(this.option);
      }, 3000);
    }
  },
  beforeDestroy() {
    clearInterval(this.timer);
  }
};
</script>

<style lang="scss" scoped>
.sn-container {
  left: 1282px;
  top: 1548px;
  width: 586px;
  height: 400px;
  .chartsdom {
    width: 100%;
    height: 100%;
  }
}
</style>
