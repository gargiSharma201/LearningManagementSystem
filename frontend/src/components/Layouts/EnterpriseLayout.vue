<template>
  <header
    class="bg-white border border-gray-200 rounded-xl px-8 py-4 mb-8 shadow-sm flex items-center justify-between"
  >
    <div class="flex items-center gap-10">

      <div class="flex items-center gap-3">
        <div
          class="h-11 w-11 rounded-xl bg-green-700 text-white flex items-center justify-center font-bold"
        >
          🇮🇳
        </div>

        <div>
          <h2 class="font-bold text-lg text-gray-900">
            Enterprise LMS
          </h2>

          <p class="text-sm text-gray-500">
            Ministry of MSME
          </p>
        </div>
      </div>

      <nav class="hidden lg:flex gap-8 text-gray-600">
        <a href="#" class="font-medium hover:text-green-700">Dashboard</a>
        <a href="#" class="hover:text-green-700">Courses</a>
        <a href="#" class="hover:text-green-700">Programs</a>
        <a href="#" class="hover:text-green-700">Reports</a>
      </nav>

    </div>

    <div class="flex items-center gap-4">

      <input
        placeholder="Search..."
        class="border rounded-lg px-4 py-2 w-64"
      />

      <button class="text-xl">
        🔔
      </button>

      <div
        class="h-10 w-10 rounded-full bg-green-700 text-white flex items-center justify-center"
      >
        A
      </div>

    </div>
  </header>
</template>