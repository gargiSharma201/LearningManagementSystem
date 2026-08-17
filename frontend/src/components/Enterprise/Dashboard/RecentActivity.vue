<template>
  <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-6">

    <!-- Header -->
    <div class="flex justify-between items-center mb-5">
      <div class="flex items-center gap-2.5">
        <h2 class="text-xl font-bold text-gray-900">Recent Activity</h2>
        <!-- Live pulse dot -->
        <span class="relative flex h-2.5 w-2.5">
          <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75" />
          <span class="relative inline-flex rounded-full h-2.5 w-2.5 bg-emerald-500" />
        </span>
      </div>

      <button class="inline-flex items-center gap-1.5 text-sm font-semibold text-emerald-700 hover:text-emerald-800 transition-colors">
        View All
        <span class="lucide-arrow-right size-3.5" />
      </button>
    </div>

    <!-- Activity list -->
    <div class="space-y-1">
      <div
        v-for="(activity, index) in activities"
        :key="activity.id"
        class="activity-row group"
        :class="{ 'opacity-70': index > 0 }"
      >
        <!-- Icon circle -->
        <div class="activity-icon flex-shrink-0" :class="activity.bgClass">
          <span :class="[activity.icon, activity.iconColor, 'size-4']" />
        </div>

        <!-- Text -->
        <div class="flex-1 min-w-0">
          <p class="text-sm font-semibold text-gray-800 leading-snug">{{ activity.title }}</p>
          <div class="flex items-center gap-1.5 mt-0.5">
            <span class="lucide-clock size-3 text-gray-400" />
            <p class="text-xs text-gray-400">{{ activity.time }}</p>
          </div>
        </div>

        <!-- Arrow on hover -->
        <span class="lucide-chevron-right size-3.5 text-gray-300 group-hover:text-gray-500 transition-colors flex-shrink-0" />
      </div>
    </div>

  </div>
</template>

<script setup lang="ts">
const activities = [
  {
    id: 1,
    icon: 'lucide-book-open',
    bgClass: 'bg-emerald-100',
    iconColor: 'text-emerald-700',
    title: 'Python Basics course was created',
    time: '2 minutes ago',
  },
  {
    id: 2,
    icon: 'lucide-user-check',
    bgClass: 'bg-blue-100',
    iconColor: 'text-blue-700',
    title: 'Rahul enrolled in Web Development',
    time: '18 minutes ago',
  },
  {
    id: 3,
    icon: 'lucide-award',
    bgClass: 'bg-amber-100',
    iconColor: 'text-amber-600',
    title: 'Certificate issued to Priya Sharma',
    time: 'Today',
  },
  {
    id: 4,
    icon: 'lucide-graduation-cap',
    bgClass: 'bg-violet-100',
    iconColor: 'text-violet-700',
    title: 'New batch scheduled for August',
    time: 'Yesterday',
  },
]
</script>

<style scoped>
.activity-row {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 10px 10px 10px 4px;
  border-radius: 12px;
  cursor: pointer;
  transition: background 0.18s ease;
}
.activity-row:hover {
  background: #f9fafb;
  opacity: 1 !important;
}
.activity-icon {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>
