<template>
  <div class="stats-card group">

    <div class="flex items-start justify-between">
      <!-- Icon badge -->
      <div class="icon-badge" :class="iconBg">
        <span :class="[icon, iconColor, 'size-5']" />
      </div>

      <!-- Trend pill -->
      <span v-if="trend" class="trend-pill" :class="trendUp ? 'trend-up' : 'trend-down'">
        <span :class="trendUp ? 'lucide-trending-up' : 'lucide-trending-down'" class="size-3" />
        {{ trend }}
      </span>
    </div>

    <div class="mt-5">
      <p class="text-sm text-gray-500 font-medium">{{ title }}</p>
      <h2 class="text-3xl font-bold text-gray-900 mt-1 tabular-nums">{{ value }}</h2>
      <p class="text-xs text-gray-400 mt-1">{{ subtitle }}</p>
    </div>

    <!-- Bottom accent bar -->
    <div class="accent-bar" :class="accentBar" />
  </div>
</template>

<script setup lang="ts">
withDefaults(defineProps<{
  title: string
  value: string | number
  subtitle: string
  icon: string
  iconBg?: string
  iconColor?: string
  trend?: string
  trendUp?: boolean
  accentBar?: string
}>(), {
  iconBg: 'bg-emerald-100',
  iconColor: 'text-emerald-700',
  trendUp: true,
  accentBar: 'bg-emerald-500',
})
</script>

<style scoped>
.stats-card {
  position: relative; overflow: hidden;
  background: #fff; border-radius: 16px;
  border: 1px solid #e5e7eb; padding: 20px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.05);
  transition: box-shadow 0.25s ease, transform 0.25s ease;
}
.stats-card:hover { box-shadow: 0 8px 28px rgba(0,0,0,0.1); transform: translateY(-2px); }
.icon-badge {
  width: 52px; height: 52px; border-radius: 14px;
  display: flex; align-items: center; justify-content: center; flex-shrink: 0;
}
.trend-pill {
  display: inline-flex; align-items: center; gap: 3px;
  padding: 3px 9px; border-radius: 999px;
  font-size: 0.7rem; font-weight: 700;
}
.trend-up   { background: #dcfce7; color: #15803d; }
.trend-down { background: #fee2e2; color: #b91c1c; }
.accent-bar {
  position: absolute; bottom: 0; left: 0; right: 0;
  height: 3px; border-radius: 0 0 16px 16px;
  opacity: 0; transition: opacity 0.25s ease;
}
.stats-card:hover .accent-bar { opacity: 1; }
</style>