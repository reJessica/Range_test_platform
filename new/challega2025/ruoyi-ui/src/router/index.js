{
  path: '/security',
  component: Layout,
  name: 'Security',
  meta: { title: '网络安全平台', icon: 'security' },
  children: [
    {
      path: 'monitor',
      component: () => import('@/views/monitor/network/index'),
      name: 'NetworkMonitor',
      meta: { title: '网络流量监控', icon: 'monitor' }
    }
  ]
} 