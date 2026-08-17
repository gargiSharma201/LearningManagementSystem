<template>
  <div class="course-card group">

    <!-- Image with overlay -->
    <div class="relative overflow-hidden h-44 rounded-t-2xl">
      <img
        :src="course.image || '/assets/lms/images/course_card.jpeg'"
        class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
        :alt="course.title"
      />
      <!-- Gradient overlay -->
      <div class="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent" />

      <!-- Category badge -->
      <div class="absolute top-3 left-3">
        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full bg-white/15 backdrop-blur-sm border border-white/25 text-white text-xs font-semibold">
          {{ course.category || 'General' }}
        </span>
      </div>

      <!-- Difficulty badge -->
      <div class="absolute top-3 right-3">
        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-bold border" :class="difficultyStyle">
          {{ difficulty }}
        </span>
      </div>
    </div>

    <!-- Card body -->
    <div class="p-5">

      <h2 class="text-base font-bold text-gray-900 leading-snug line-clamp-2">
        {{ course.title }}
      </h2>

      <!-- Instructor -->
      <div class="flex items-center gap-1.5 mt-2">
        <span class="lucide-user size-3.5 text-gray-400" />
        <p class="text-xs text-gray-500">
          {{ course.instructors?.[0]?.instructor || 'Administrator' }}
        </p>
      </div>

      <!-- Metadata row -->
      <div class="flex items-center gap-4 mt-3 text-xs text-gray-500">
        <span class="flex items-center gap-1.5">
          <span class="lucide-book-open size-3.5 text-gray-400" />
          {{ course.lessons ?? 0 }} Lessons
        </span>
        <span class="flex items-center gap-1.5">
          <span class="lucide-users size-3.5 text-gray-400" />
          {{ course.enrollments ?? 0 }} Enrolled
        </span>
      </div>

      <!-- Progress -->
      <div class="mt-4">
        <div class="flex justify-between items-center mb-1.5">
          <span class="text-xs text-gray-500 font-medium">Progress</span>
          <span class="text-xs font-bold text-emerald-700">{{ progress }}%</span>
        </div>
        <div class="w-full h-1.5 bg-gray-100 rounded-full overflow-hidden">
          <div class="progress-fill h-1.5 rounded-full" :style="{ width: progress + '%' }" />
        </div>
      </div>

      <!-- CTA -->
      <button class="continue-btn mt-4 w-full" type="button">
        <span class="lucide-play-circle size-4" />
        {{ actionLabel }}
      </button>

    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{ course: any }>()

const isEnrolled = computed(() => {
  return Boolean(
    props.course.membership ||
      props.course.progress != null ||
      props.course.current_lesson ||
      props.course.enrollment
  )
})

const progress = computed(() => {
  const rawProgress = props.course.membership?.progress ?? props.course.progress ?? 0
  const normalized = Number(rawProgress)

  if (!Number.isFinite(normalized)) return 0
  return Math.max(0, Math.min(100, Math.round(normalized)))
})

const actionLabel = computed(() => (isEnrolled.value ? 'Continue Learning' : 'Enroll'))

const difficulty = computed(() => {
  const l = props.course.lessons || 0
  if (l < 5)  return 'Beginner'
  if (l < 12) return 'Intermediate'
  return 'Advanced'
})

const difficultyStyle = computed(() => {
  switch (difficulty.value) {
    case 'Beginner':     return 'bg-emerald-500/20 text-emerald-200 border-emerald-400/30'
    case 'Intermediate': return 'bg-amber-500/20 text-amber-200 border-amber-400/30'
    default:             return 'bg-rose-500/20 text-rose-200 border-rose-400/30'
  }
})
</script>

<style scoped>
.course-card {
  background: #fff; border-radius: 16px; border: 1px solid #e5e7eb;
  overflow: hidden; box-shadow: 0 1px 4px rgba(0,0,0,0.06);
  transition: box-shadow 0.25s ease, transform 0.25s ease;
}
.course-card:hover { box-shadow: 0 12px 32px rgba(0,0,0,0.12); transform: translateY(-3px); }

.progress-fill {
  background: linear-gradient(90deg, #10b981, #34d399);
  animation: grow 0.9s ease-out forwards;
  transform-origin: left;
}
@keyframes grow { from { width: 0% !important; } }

.continue-btn {
  display: flex; align-items: center; justify-content: center; gap: 7px;
  width: 100%; padding: 9px; border-radius: 10px;
  background: linear-gradient(135deg, #059669, #10b981);
  color: #fff; font-size: 0.8125rem; font-weight: 600;
  border: none; cursor: pointer; transition: all 0.2s ease;
  box-shadow: 0 2px 8px rgba(16,185,129,0.3);
}
.continue-btn:hover {
  background: linear-gradient(135deg, #047857, #059669);
  box-shadow: 0 4px 14px rgba(16,185,129,0.4); transform: translateY(-1px);
}
</style>