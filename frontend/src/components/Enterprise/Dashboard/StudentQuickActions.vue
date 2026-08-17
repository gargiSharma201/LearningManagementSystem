<template>
  <div class="quick-actions-card">

    <!-- Header -->
    <div class="flex items-center justify-between mb-5">
      <div>
        <h2 class="text-xl font-bold text-gray-900">Quick Actions</h2>
        <p class="text-xs text-gray-400 mt-0.5">Shortcuts to common tasks</p>
      </div>
      <div class="header-icon">
        <span class="lucide-zap size-4 text-amber-600" />
      </div>
    </div>

    <!-- Action List -->
    <div class="space-y-2.5">
      <router-link
        v-for="action in actions"
        :key="action.label"
        :to="action.to"
        class="action-item group"
      >
        <div class="action-icon" :class="action.iconBg">
          <span :class="[action.icon, action.iconColor, 'size-5']" />
        </div>
        <div class="flex-1 min-w-0">
          <p class="text-sm font-semibold text-gray-800 leading-tight">{{ action.label }}</p>
          <p class="text-xs text-gray-400 mt-0.5 truncate">{{ action.desc }}</p>
        </div>
        <span class="lucide-arrow-right size-4 text-gray-300 group-hover:text-gray-500 group-hover:translate-x-0.5 transition-all duration-200 flex-shrink-0" />
      </router-link>
    </div>

  </div>
</template>

<script setup lang="ts">
const actions = [
  {
    label: 'Browse Courses',
    desc: 'Explore all available courses',
    to: { name: 'Courses' },
    icon: 'lucide-library',
    iconBg: 'bg-emerald-50',
    iconColor: 'text-emerald-600',
  },
  {
    label: 'My Batches',
    desc: 'View your enrolled batches',
    to: { name: 'Batches' },
    icon: 'lucide-users-round',
    iconBg: 'bg-blue-50',
    iconColor: 'text-blue-600',
  },
  {
    label: 'My Profile',
    desc: 'View achievements and progress',
    to: { name: 'ProfileAbout' },
    icon: 'lucide-circle-user',
    iconBg: 'bg-violet-50',
    iconColor: 'text-violet-600',
  },
  {
    label: 'Certificates',
    desc: 'View your earned certificates',
    to: { name: 'ProfileCertificates' },
    icon: 'lucide-award',
    iconBg: 'bg-amber-50',
    iconColor: 'text-amber-600',
  },
]
</script>

<style scoped>
.quick-actions-card {
  background: #fff;
  border-radius: 16px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  padding: 20px;
}
.header-icon {
  width: 36px; height: 36px; border-radius: 10px;
  background: #fef3c7;
  display: flex; align-items: center; justify-content: center;
  flex-shrink: 0;
}
.action-item {
  display: flex; align-items: center; gap: 12px;
  padding: 11px 13px; border-radius: 12px;
  background: #f9fafb; border: 1px solid transparent;
  text-decoration: none;
  transition: background 0.2s ease, border-color 0.2s ease, box-shadow 0.2s ease;
}
.action-item:hover {
  background: #fff; border-color: #e5e7eb;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
}
.action-icon {
  width: 38px; height: 38px; border-radius: 10px;
  display: flex; align-items: center; justify-content: center;
  flex-shrink: 0;
}
</style>
