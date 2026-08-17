<template>
  <div
    class="relative overflow-hidden rounded-[32px] h-[420px] text-white px-12 py-10 flex items-center"
    :style="{
      backgroundImage: `url(${slides[current].image})`,
      backgroundSize: 'cover',
      backgroundPosition: 'center',
    }"
  >
   <!-- Overlay -->
<div class="absolute inset-0 bg-black/55"></div>

<!-- Animated Glow -->
<div class="glow-orb glow-orb-1"></div>
<div class="glow-orb glow-orb-2"></div>

<!-- Previous -->
<button
  @click="previousSlide"
  class="absolute -left-6 top-1/2 -translate-y-1/2 z-30
         flex h-12 w-12 items-center justify-center
         rounded-full bg-white/20 backdrop-blur
         hover:bg-white/30 transition-all duration-300"
>
  <span class="lucide-chevron-left size-5 text-white"></span>
</button>

<!-- Next -->
<button
  @click="nextSlide"
  class="absolute -right-6 top-1/2 -translate-y-1/2 z-30
         flex h-12 w-12 items-center justify-center
         rounded-full bg-white/20 backdrop-blur
         hover:bg-white/30 transition-all duration-300"
>
  <span class="lucide-chevron-right size-5 text-white"></span>
</button>

<!-- Content -->
<transition name="fade" mode="out-in">
  <div
    :key="current"
    class="relative z-20 h-full flex items-center"
  >
    <div class="max-w-2xl ml-16 lg:ml-24">

      <!-- Tag -->
      <span
        class="inline-flex items-center gap-2 rounded-full
               border border-white/30
               bg-white/15
               px-4 py-2
               text-sm font-medium
               backdrop-blur"
      >
        {{ slides[current].tag }}
      </span>

      <!-- Heading -->
      <h1
        class="mt-6 text-4xl lg:text-5xl
               font-bold leading-tight
               text-white"
      >
        {{ slides[current].title }}
      </h1>

      <!-- Subtitle -->
      <p
        class="mt-5 max-w-xl
               text-lg leading-8
               text-white/80"
      >
        {{ slides[current].subtitle }}
      </p>

      <!-- Buttons -->
      <div class="mt-8 flex flex-wrap gap-4">

        <router-link
          :to="slides[current].primaryLink"
          class="rounded-xl bg-white
                 px-6 py-3
                 font-semibold
                 text-green-800
                 transition
                 hover:scale-105
                 hover:bg-gray-100"
        >
          {{ slides[current].primaryText }}
        </router-link>

        <router-link
          :to="slides[current].secondaryLink"
          class="rounded-xl border border-white/30
                 bg-white/10
                 px-6 py-3
                 backdrop-blur
                 transition
                 hover:bg-white/20"
        >
          {{ slides[current].secondaryText }}
        </router-link>

      </div>

      <!-- Pills -->
      <div class="mt-8 flex flex-wrap gap-3">

        <span
          v-for="pill in slides[current].pills"
          :key="pill"
          class="rounded-full
                 bg-white/15
                 px-4 py-2
                 text-sm
                 backdrop-blur"
        >
          {{ pill }}
        </span>

      </div>

    </div>
  </div>
</transition>

<!-- Indicators -->
<div
  class="absolute bottom-6 left-1/2 -translate-x-1/2
         flex gap-3 z-30"
>
  <button
    v-for="(_, index) in slides"
    :key="index"
    @click="current = index"
    class="h-3 rounded-full transition-all duration-300"
    :class="
      current === index
        ? 'w-8 bg-white'
        : 'w-3 bg-white/40 hover:bg-white/70'
    "
  />
</div>

<!-- Counter -->
<div
  class="absolute bottom-6 right-8 z-30
         rounded-full bg-black/25
         px-4 py-2
         text-sm text-white backdrop-blur"
>
  {{ String(current + 1).padStart(2, '0') }}
  /
  {{ String(slides.length).padStart(2, '0') }}
</div>
  </div>
</template>