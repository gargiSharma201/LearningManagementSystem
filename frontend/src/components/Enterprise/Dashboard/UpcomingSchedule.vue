<template>
  <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-6">

    <div class="flex items-center justify-between mb-5">
      <h2 class="text-xl font-bold text-gray-900">Upcoming Schedule</h2>
      <span class="text-xs text-gray-400 font-medium">This week</span>
    </div>

    <div class="space-y-3">
      <div
        v-for="item in schedule"
        :key="item.title"
        class="schedule-item"
        :class="item.border"
      >
        <div class="flex items-center justify-between gap-3">

          <div class="flex items-center gap-3 min-w-0">
            <div class="schedule-icon" :class="item.iconBg">
              <span :class="[item.icon, item.iconColor, 'size-4']" />
            </div>
            <div class="min-w-0">
              <p class="font-semibold text-gray-800 text-sm leading-tight truncate">
                {{ item.title }}
              </p>
              <div class="flex items-center gap-1.5 mt-1">
                <span class="lucide-clock size-3 text-gray-400" />
                <p class="text-gray-400 text-xs">{{ item.date }}</p>
              </div>
            </div>
          </div>

          <span class="type-badge flex-shrink-0" :class="item.badgeCls">
            {{ item.type }}
          </span>
        </div>
      </div>
    </div>

    <button class="mt-5 w-full rounded-xl border border-gray-200 py-2.5 text-sm font-medium text-gray-600 hover:bg-gray-50 hover:border-gray-300 transition-all duration-200 flex items-center justify-center gap-2">
      <span class="lucide-calendar size-4 text-gray-400" />
      View Full Calendar
    </button>

  </div>
</template>

<script setup lang="ts">
const schedule = [
  {
    title: 'Live Session',
    date: 'Aug 10 · 11:00 AM',
    type: 'Live',
    icon: 'lucide-video',
    iconBg: 'bg-emerald-100',
    iconColor: 'text-emerald-700',
    border: 'border-l-emerald-500',
    badgeCls: 'bg-emerald-50 text-emerald-700 border-emerald-200',
  },
  {
    title: 'Assignment Due',
    date: 'Aug 12 · 11:59 PM',
    type: 'Assignment',
    icon: 'lucide-file-edit',
    iconBg: 'bg-amber-100',
    iconColor: 'text-amber-700',
    border: 'border-l-amber-500',
    badgeCls: 'bg-amber-50 text-amber-700 border-amber-200',
  },
  {
    title: 'Quiz',
    date: 'Aug 15 · 02:00 PM',
    type: 'Quiz',
    icon: 'lucide-circle-help',
    iconBg: 'bg-violet-100',
    iconColor: 'text-violet-700',
    border: 'border-l-violet-500',
    badgeCls: 'bg-violet-50 text-violet-700 border-violet-200',
  },
]
</script>

<style scoped>
.schedule-item {
  padding: 12px 14px; border-radius: 12px;
  background: #f9fafb; border-left: 3px solid;
  transition: background 0.2s ease, box-shadow 0.2s ease;
}
.schedule-item:hover { background: #fff; box-shadow: 0 2px 10px rgba(0,0,0,0.06); }
.schedule-icon {
  width: 36px; height: 36px; border-radius: 10px;
  display: flex; align-items: center; justify-content: center; flex-shrink: 0;
}
.type-badge {
  display: inline-flex; align-items: center; padding: 3px 10px;
  border-radius: 999px; font-size: 0.7rem; font-weight: 700;
  border: 1px solid; white-space: nowrap;
}
</style>