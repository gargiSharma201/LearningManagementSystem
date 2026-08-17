<template>
  <div
    class="relative overflow-hidden bg-gradient-to-br from-stone-900 via-olive-800 to-stone-700 h-[400px] text-white"
    @mouseenter="stopAutoSlide"
    @mouseleave="startAutoSlide"
  >
    <!-- Background Image -->
    <transition name="fade" mode="in-out">
      <img
        :key="current"
        :src="slides[current].image"
        class="absolute inset-0 h-full w-full object-cover scale-105 banner-image"
      />
    </transition>

    <!-- Overlay -->
     <!-- Overlay -->
<div class="absolute inset-0 bg-gradient-to-r from-black/75 via-black/45 to-black/20"></div>

<!-- Decorative Glow -->
<div class="glow-orb glow-orb-1"></div>
<div class="glow-orb glow-orb-2"></div>

<!-- Previous -->
<button
  @click="previousSlide"
  class="absolute left-8 top-1/2 -translate-y-1/2 z-30
         flex h-14 w-14 items-center justify-center
         rounded-full border border-white/20
         bg-white/10 backdrop-blur-xl
         transition-all duration-300
         hover:scale-105 hover:bg-white/20"
>
  <span class="lucide-chevron-left h-5 w-5 text-white"></span>
</button>

<!-- Next -->
<button
  @click="nextSlide"
  class="absolute right-8 top-1/2 -translate-y-1/2 z-30
         flex h-14 w-14 items-center justify-center
         rounded-full border border-white/20
         bg-white/10 backdrop-blur-xl
         transition-all duration-300
         hover:scale-105 hover:bg-white/20"
>
  <span class="lucide-chevron-right h-5 w-5 text-white"></span>
</button>

<!-- Hero Content -->
<transition name="fade" mode="in-out">
  <div
    :key="current"
    class="relative z-20 flex h-full items-center"
  >
    <div class="max-w-2xl pl-20 lg:pl-28">

      <!-- Government Badge -->
      <span
        class="inline-flex items-center gap-2 rounded-full
               border border-white/20
               bg-white/10
               px-5 py-2
               text-sm font-medium
               text-white
               backdrop-blur-xl"
      >
        <span class="lucide-flag size-3.5" />
        {{ slides[current].tag }}
      </span>

      <!-- Heading -->
      <h1
        class="mt-7 text-5xl font-bold leading-tight tracking-tight text-white"
      >
        {{ slides[current].title }}
      </h1>

      <!-- Subtitle -->
      <p
        class="mt-5 max-w-xl text-lg leading-8 text-white/75"
      >
        {{ slides[current].subtitle }}
      </p>

      

      <!-- Pills -->
      <div class="mt-10 flex flex-wrap gap-3">

        <span
          v-for="pill in slides[current].pills"
          :key="pill"
          class="rounded-full
                 border border-white/15
                 bg-white/10
                 px-5 py-2
                 text-sm
                 font-medium
                 text-white/90
                 backdrop-blur-lg"
        >
          {{ pill }}
        </span>

      </div>

    </div>
  </div>
</transition>

<!-- Indicators -->
<div
  class="absolute bottom-8 left-1/2 z-30 flex -translate-x-1/2 gap-3"
>
  <button
    v-for="(_, index) in slides"
    :key="index"
    @click="current = index"
    class="transition-all duration-300"
    :class="
      current === index
        ? 'h-3 w-10 rounded-full bg-white'
        : 'h-3 w-3 rounded-full bg-white/40 hover:bg-white/70'
    "
  />
</div>

<!-- Counter -->
<div
  class="absolute bottom-8 right-8 z-30
         rounded-full
         bg-black/30
         px-5 py-2
         text-sm
         font-medium
         text-white
         backdrop-blur-xl"
>
  {{ String(current + 1).padStart(2, '0') }}
  /
  {{ String(slides.length).padStart(2, '0') }}
</div>
    
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from "vue"
import ArmyBanner1 from '@/assets/ArmyBanner1.jpg'
import ArmyBanner2 from '@/assets/ArmyBanner2.jpg'
import ArmyBanner3 from '@/assets/ArmyBanner3.jpg'

const current = ref(0)

let interval: number

const slides = [
  {
    tag: "Indian Army • Ministry of Defence",
    title: "Indian Army Learning Management",
    subtitle:
      "Empowering soldiers with knowledge, skills and leadership for a stronger, ready defence force.",
    image: ArmyBanner1,
    primaryText: "Explore Courses",
    primaryLink: { name: "Courses" },
    secondaryText: "View Reports",
    secondaryLink: { name: "Statistics" },
    pills: ["Discipline", "Excellence", "Leadership"],
  },
  {
    image: ArmyBanner2,
    tag: 'Indian Army • High-Altitude Training',
    title: 'Forged in Extreme Conditions',
    subtitle: 'Building the resilience, physical endurance and tactical expertise needed for high-altitude operations across every terrain.',
    primaryText: 'Learn More',
    primaryLink: { name: 'Courses' },
    secondaryText: 'View Details',
    secondaryLink: { name: 'Batches' },
    pills: ['Resilience', 'Tactics', 'Endurance'],
  },
  {
    tag: "Indian Army • Digital Learning Initiative",
    title: "Advancing Through Knowledge",
    subtitle:
      "Harnessing modern education to build the next generation of strategic thinkers and battlefield leaders.",
    image: ArmyBanner3,
    primaryText: "Start Learning",
    primaryLink: { name: "Courses" },
    secondaryText: "View Schedule",
    secondaryLink: { name: "Batches" },
    pills: ["Nation", "Duty", "Honour"],
  },
]

const nextSlide = () => {
  current.value = (current.value + 1) % slides.length
  console.log(current.value, slides[current.value].image)

}

const previousSlide = () => {
  current.value = (current.value - 1 + slides.length) % slides.length
  console.log(current.value, slides[current.value].image)

}

const startAutoSlide = () => {
  stopAutoSlide()

  interval = window.setInterval(() => {
    nextSlide()
  }, 5000)
}

const stopAutoSlide = () => {
  clearInterval(interval)
}

onMounted(() => {
  startAutoSlide()
})

onUnmounted(() => {
  stopAutoSlide()
})
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity .5s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.banner-image{
  animation: zoom 15s linear infinite;
}

@keyframes zoom{
  from{
    transform:scale(1.05);
  }
  to{
    transform:scale(1.12);
  }
}

.glow-orb{
  position:absolute;
  border-radius:9999px;
  filter:blur(70px);
  opacity:.25;
}

.glow-orb-1{
  width:260px;
  height:260px;
  background:#b45309;
  top:-80px;
  left:-60px;
}

.glow-orb-2{
  width:320px;
  height:320px;
  background:#78350f;
  right:-120px;
  bottom:-120px;
}
</style>