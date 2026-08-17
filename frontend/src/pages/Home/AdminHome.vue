<template>
  <div class="admin-dashboard">
	<EnterpriseNavbar/>

    <!-- ── Hero Carousel — full-bleed, flush to top ─────────────── -->
    <HeroCarousel />

    <!-- ── Padded content below carousel ───────────────────────── -->
    <main class="dashboard-content">

      <!-- KPI Stats -->
      <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-5">
        <StatsCard
          title="Courses"
          :value="stats.data?.courses || 0"
          subtitle="Available Courses"
          icon="lucide-book-open"
          iconBg="bg-emerald-100"
          iconColor="text-emerald-700"
          accentBar="bg-emerald-500"
          trend="+12%"
          :trendUp="true"
        />
        <StatsCard
          title="Users"
          :value="stats.data?.users || 0"
          subtitle="Registered Users"
          icon="lucide-users"
          iconBg="bg-blue-100"
          iconColor="text-blue-700"
          accentBar="bg-blue-500"
          trend="+8%"
          :trendUp="true"
        />
        <StatsCard
          title="Certificates"
          :value="stats.data?.batches || 0"
          subtitle="Issued Total"
          icon="lucide-award"
          iconBg="bg-amber-100"
          iconColor="text-amber-700"
          accentBar="bg-amber-500"
          trend="+5%"
          :trendUp="true"
        />
        <StatsCard
          title="Completion"
          value="87%"
          subtitle="Average Progress"
          icon="lucide-trending-up"
          iconBg="bg-violet-100"
          iconColor="text-violet-700"
          accentBar="bg-violet-500"
          trend="-2%"
          :trendUp="false"
        />
      </div>

      <!-- Continue Learning + Sidebar -->
      <div
        v-if="createdCourses.data?.length"
        class="mt-10 grid grid-cols-1 lg:grid-cols-3 gap-8"
      >
        <!-- Left: Course cards -->
        <div class="lg:col-span-2">
          <div class="flex items-center justify-between mb-5">
            <div>
              <h2 class="text-2xl font-bold text-gray-900">Continue Learning</h2>
              <p class="text-sm text-gray-400 mt-0.5">Pick up where you left off</p>
            </div>
            <router-link
              :to="{ name: 'Courses' }"
              class="inline-flex items-center gap-1.5 text-sm font-semibold text-emerald-700 hover:text-emerald-800 transition-colors"
            >
              View All
              <span class="lucide-arrow-right size-3.5" />
            </router-link>
          </div>

          <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <router-link
              v-for="course in createdCourses.data"
              :key="course.name"
              :to="{ name: 'CourseDetail', params: { courseName: course.name } }"
              class="block"
            >
              <EnterpriseCourseCard :course="course" />
            </router-link>
          </div>
        </div>

        <!-- Right: Sidebar -->
        <div class="lg:col-span-1">
          <div class="space-y-6">
            <QuickActions />
            <UpcomingSchedule />
          </div>
        </div>
      </div>

      <!-- No courses: sidebar + empty state -->
      <div
        v-if="!createdCourses.data?.length && createdCourses.data !== undefined"
        class="mt-10 grid grid-cols-1 lg:grid-cols-3 gap-8"
      >
        <div class="lg:col-span-2 flex flex-col items-center justify-center py-24 text-center">
          <div class="w-20 h-20 rounded-2xl bg-gray-100 flex items-center justify-center mb-5">
            <span class="lucide-graduation-cap size-10 text-gray-400" />
          </div>
          <h2 class="text-xl font-bold text-gray-800">No courses yet</h2>
          <p class="text-gray-500 mt-2 max-w-md text-sm leading-relaxed">
            Create your first course to get started on the Enterprise Learning Portal.
          </p>
          <router-link :to="{ name: 'Courses', query: { newCourse: '1' } }" class="mt-6">
            <Button>
              <template #prefix><span class="lucide-plus size-4" /></template>
              Create Course
            </Button>
          </router-link>
        </div>
        <div class="lg:col-span-1 space-y-6">
          <QuickActions />
          <UpcomingSchedule />
        </div>
      </div>

      <!-- Upcoming Batches -->
      <div v-if="createdBatches.data?.length" class="mt-10">
        <div class="flex items-center justify-between mb-5">
          <div>
            <h2 class="text-2xl font-bold text-gray-900">Upcoming Batches</h2>
            <p class="text-sm text-gray-400 mt-0.5">Scheduled learning cohorts</p>
          </div>
          <router-link
            :to="{ name: 'Batches' }"
            class="inline-flex items-center gap-1.5 text-sm font-semibold text-emerald-700 hover:text-emerald-800 transition-colors"
          >
            View All
            <span class="lucide-arrow-right size-3.5" />
          </router-link>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-5">
          <BatchCard
            v-for="batch in createdBatches.data"
            :key="batch.name"
            :batch="batch"
          />
        </div>
      </div>

    </main>
  </div>
</template>

<script setup lang="ts">
import { watchEffect } from 'vue'
import { Button, createResource } from 'frappe-ui'

import HeroCarousel         from '@/components/Enterprise/Dashboard/HeroCarousel.vue'
import StatsCard            from '@/components/Enterprise/Dashboard/StatsCard.vue'
import EnterpriseCourseCard from '@/components/Enterprise/Dashboard/EnterpriseCourseCard.vue'
import UpcomingSchedule     from '@/components/Enterprise/Dashboard/UpcomingSchedule.vue'
import QuickActions         from '@/components/Enterprise/Dashboard/QuickActions.vue'
import BatchCard            from '@/pages/Batches/components/BatchCard.vue'

const createdCourses = createResource({ url: 'lms.lms.api.get_created_courses', auto: true })
const createdBatches = createResource({ url: 'lms.lms.api.get_created_batches', auto: true })
const stats          = createResource({ url: 'lms.lms.api.get_dashboard_stats',  auto: true })

watchEffect(() => { if (stats.data) console.log('Dashboard Stats:', stats.data) })
</script>

<style scoped>
.admin-dashboard {
  min-height: 100%;
  background: #f8fafc;
}
.dashboard-content {
  max-width: 1400px;
  margin: 0 auto;
  padding: 24px 24px 80px;
}
@media (min-width: 1024px) {
  .dashboard-content { padding: 24px 40px 96px; }
}
</style>
