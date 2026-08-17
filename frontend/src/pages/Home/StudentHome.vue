<template>
  <div class="student-dashboard">
    <EnterpriseNavbar />

    <!-- Hero Carousel -->
    <HeroCarousel />

    <!-- Padded content -->
    <main class="dashboard-content">

      <!-- KPI Stats -->
      <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-5">
        <StatsCard
          title="Enrolled"
          :value="myCourses.data?.length || 0"
          subtitle="Active Courses"
          icon="lucide-book-open"
          iconBg="bg-emerald-100"
          iconColor="text-emerald-700"
          accentBar="bg-emerald-500"
          :trendUp="true"
        />
        <StatsCard
          title="Batches"
          :value="myBatches.data?.length || 0"
          subtitle="Enrolled Batches"
          icon="lucide-users-round"
          iconBg="bg-blue-100"
          iconColor="text-blue-700"
          accentBar="bg-blue-500"
          trend="+1"
          :trendUp="true"
        />
        <StatsCard
          title="Live Classes"
          :value="myLiveClasses?.data?.length || 0"
          subtitle="Upcoming Sessions"
          icon="lucide-video"
          iconBg="bg-violet-100"
          iconColor="text-violet-700"
          accentBar="bg-violet-500"
          trend="This week"
          :trendUp="true"
        />
        <StatsCard
          title="Progress"
          value="—"
          subtitle="Avg. Completion"
          icon="lucide-trending-up"
          iconBg="bg-amber-100"
          iconColor="text-amber-700"
          accentBar="bg-amber-500"
        />
      </div>

      <!-- My Courses + Sidebar -->
      <div
        v-if="myCourses.data?.length"
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
              v-for="course in myCourses.data"
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
            <StudentQuickActions />
            <UpcomingSchedule />
          </div>
        </div>
      </div>

      <!-- No courses: empty state + sidebar -->
      <div
        v-if="!myCourses.data?.length && myCourses.data !== undefined"
        class="mt-10 grid grid-cols-1 lg:grid-cols-3 gap-8"
      >
        <div class="lg:col-span-2 flex flex-col items-center justify-center py-24 text-center">
          <div class="w-20 h-20 rounded-2xl bg-gray-100 flex items-center justify-center mb-5">
            <span class="lucide-graduation-cap size-10 text-gray-400" />
          </div>
          <h2 class="text-xl font-bold text-gray-800">Start your learning journey</h2>
          <p class="text-gray-500 mt-2 max-w-md text-sm leading-relaxed">
            Explore courses and enroll to begin building new skills on the Enterprise Learning Portal.
          </p>
          <router-link :to="{ name: 'Courses' }" class="mt-6">
            <Button>
              <template #prefix><span class="lucide-library size-4" /></template>
              Browse Courses
            </Button>
          </router-link>
        </div>
        <div class="lg:col-span-1 space-y-6">
          <StudentQuickActions />
          <UpcomingSchedule />
        </div>
      </div>

      <!-- My Batches -->
      <div v-if="myBatches.data?.length" class="mt-10">
        <div class="flex items-center justify-between mb-5">
          <div>
            <h2 class="text-2xl font-bold text-gray-900">My Batches</h2>
            <p class="text-sm text-gray-400 mt-0.5">Your enrolled learning cohorts</p>
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
          <router-link
            v-for="batch in myBatches.data"
            :key="batch.name"
            :to="{ name: 'BatchDetail', params: { batchName: batch.name } }"
            class="block"
          >
            <BatchCard :batch="batch" />
          </router-link>
        </div>
      </div>

      <!-- Upcoming Live Classes -->
      <div v-if="myLiveClasses?.data?.length" class="mt-10">
        <div class="flex items-center justify-between mb-5">
          <div>
            <h2 class="text-2xl font-bold text-gray-900">Upcoming Live Classes</h2>
            <p class="text-sm text-gray-400 mt-0.5">Your scheduled sessions this week</p>
          </div>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-5">
          <div
            v-for="cls in myLiveClasses.data"
            :key="`${cls.date}-${cls.time}-${cls.title}`"
            class="live-class-card"
          >
            <div class="flex items-start justify-between gap-3">
              <div class="flex items-center gap-3">
                <div class="live-icon">
                  <span class="lucide-video size-4 text-emerald-600" />
                </div>
                <div>
                  <p class="font-semibold text-gray-800 text-sm leading-tight">
                    {{ cls.title || 'Live Class' }}
                  </p>
                  <div class="flex items-center gap-1.5 mt-1">
                    <span class="lucide-clock size-3 text-gray-400" />
                    <p class="text-gray-400 text-xs">{{ cls.date }} · {{ cls.time }}</p>
                  </div>
                </div>
              </div>
              <span class="live-badge">Live</span>
            </div>
            <div class="mt-4">
              <Button
                v-if="canAccessClass(cls)"
                variant="solid"
                class="w-full"
                @click="joinClass(cls)"
              >
                Join Class
              </Button>
              <p v-else class="text-center text-xs text-gray-400">
                Class is not currently available
              </p>
            </div>
          </div>
        </div>
      </div>

    </main>
  </div>
</template>

<script setup lang="ts">
import { inject } from 'vue'
import { Button, createResource } from 'frappe-ui'

import EnterpriseNavbar     from '@/components/Layouts/EnterpriseNavbar.vue'
import HeroCarousel         from '@/components/Enterprise/Dashboard/HeroCarousel.vue'
import StatsCard            from '@/components/Enterprise/Dashboard/StatsCard.vue'
import EnterpriseCourseCard from '@/components/Enterprise/Dashboard/EnterpriseCourseCard.vue'
import UpcomingSchedule     from '@/components/Enterprise/Dashboard/UpcomingSchedule.vue'
import StudentQuickActions  from '@/components/Enterprise/Dashboard/StudentQuickActions.vue'
import BatchCard            from '@/pages/Batches/components/BatchCard.vue'

const dayjs = inject<any>('$dayjs')
const user  = inject<any>('$user')

const props = defineProps<{ myLiveClasses: any }>()

const myCourses = createResource({
  url: 'lms.lms.api.get_my_courses',
  auto: true,
  onSuccess(data) {
    console.log('================================')
    console.log('MY ENROLLED COURSES')
    console.log(data)
    console.log('COURSE COUNT:', data?.length)
    console.log('================================')
  },
  onError(error) {
        console.error('MY COURSES ERROR:', error)
  },
})

const myBatches = createResource({ url: 'lms.lms.api.get_my_batches', auto: true })

// Live class helpers
const getClassEnd = (cls: { date: string; time: string; duration: number }) => {
  const start = new Date(`${cls.date}T${cls.time}`)
  return new Date(start.getTime() + cls.duration * 60000)
}

const canAccessClass = (cls: { date: string; time: string; duration: number }) => {
  if (cls.date < dayjs().format('YYYY-MM-DD')) return false
  if (cls.date > dayjs().format('YYYY-MM-DD')) return false
  if (new Date() > getClassEnd(cls)) return false
  return true
}

const joinClass = (cls: any) => {
  if (cls.url) window.open(cls.url, '_blank')
}
</script>

<style scoped>
.student-dashboard {
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

/* Live class card */
.live-class-card {
  background: #fff;
  border-radius: 16px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0,0,0,0.05);
  padding: 18px;
  transition: box-shadow 0.2s ease, transform 0.2s ease;
}
.live-class-card:hover {
  box-shadow: 0 6px 20px rgba(0,0,0,0.08);
  transform: translateY(-1px);
}
.live-icon {
  width: 38px; height: 38px; border-radius: 10px;
  background: #ecfdf5;
  display: flex; align-items: center; justify-content: center;
  flex-shrink: 0;
}
.live-badge {
  display: inline-flex; align-items: center;
  background: #ecfdf5; color: #059669;
  border: 1px solid #a7f3d0;
  padding: 3px 10px; border-radius: 999px;
  font-size: 0.7rem; font-weight: 700;
  white-space: nowrap; flex-shrink: 0;
}
</style>

