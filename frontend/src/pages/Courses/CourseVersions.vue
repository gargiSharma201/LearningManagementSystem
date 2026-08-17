<template>
	<div class="p-6">
		<h2 class="mb-1 text-xl font-semibold">Version History</h2>
		<p class="mb-6 text-sm text-ink-gray-5">
			Preview what changed between versions or restore a previous state.
		</p>

		<!-- Version list -->
		<div v-if="versions.data?.length" class="space-y-3">
			<div
				v-for="version in versions.data"
				:key="version.name"
				class="version-card"
			>
				<!-- Left: meta -->
				<div class="flex items-start gap-3 min-w-0">
					<!-- Version pill -->
					<span class="version-pill">v{{ version.version_number }}</span>

					<div class="min-w-0">
						<div class="font-semibold text-ink-gray-9 text-sm leading-tight">
							{{ version.comment || 'No description' }}
						</div>
						<div class="mt-0.5 flex items-center gap-2 text-xs text-ink-gray-5">
							<span class="lucide-user size-3" />
							{{ version.owner }}
							<span class="text-ink-gray-3">·</span>
							<span class="lucide-clock size-3" />
							{{ formatDate(version.creation) }}
						</div>
					</div>
				</div>

				<!-- Right: actions -->
				<div class="flex gap-2 flex-shrink-0">
					<Button
						variant="outline"
						:loading="previewLoading && previewTarget === version.name"
						@click="openPreview(version)"
					>
						<template #prefix>
							<span class="lucide-eye size-3.5" />
						</template>
						Preview
					</Button>

					<Button
						theme="green"
						:loading="restoreVersion.loading && restoreTarget === version.name"
						@click="restore(version)"
					>
						<template #prefix>
							<span class="lucide-rotate-ccw size-3.5" />
						</template>
						Restore
					</Button>
				</div>
			</div>
		</div>

		<div
			v-else-if="!versions.loading"
			class="flex flex-col items-center justify-center py-20 text-center"
		>
			<span class="lucide-history size-10 text-ink-gray-3 mb-3" />
			<div class="text-ink-gray-5 font-medium">No versions yet</div>
			<div class="text-ink-gray-4 text-sm mt-1">
				Versions are saved when you publish or manually snapshot the course.
			</div>
		</div>

		<!-- ── Preview dialog ───────────────────────────────────────── -->
		<Dialog
			v-model:open="showPreview"
			size="3xl"
		>
			<template #body>
				<div class="preview-modal">

					<!-- Header -->
					<div class="preview-header">
						<div class="flex items-center gap-3">
							<span class="preview-version-badge">
								v{{ activeVersion?.version_number }}
							</span>
							<div>
								<h3 class="text-lg font-bold text-gray-900">
									{{ activeVersion?.comment || 'Version snapshot' }}
								</h3>
								<p class="text-xs text-gray-500 mt-0.5">
									Saved by {{ activeVersion?.owner }} · {{ formatDate(activeVersion?.creation) }}
								</p>
							</div>
						</div>
						<button class="close-btn" @click="showPreview = false">
							<span class="lucide-x size-5" />
						</button>
					</div>

					<!-- Loading -->
					<div v-if="previewLoading" class="flex items-center justify-center py-20">
						<span class="lucide-loader-circle size-8 text-emerald-500 animate-spin" />
					</div>

					<!-- Diff content -->
					<div v-else class="preview-body">

						<!-- Summary bar -->
						<div class="diff-summary">
							<span
								v-if="diffFields.some(f => f.changed)"
								class="diff-summary-badge changed"
							>
								<span class="lucide-pencil size-3" />
								{{ diffFields.filter(f => f.changed).length }} field(s) changed
							</span>
							<span v-else class="diff-summary-badge unchanged">
								<span class="lucide-check size-3" />
								No changes detected
							</span>
							<span class="text-xs text-gray-400">
								vs current live version
							</span>
						</div>

						<!-- Field diffs -->
						<div class="space-y-4">
							<div
								v-for="field in diffFields"
								:key="field.key"
								class="diff-row"
								:class="field.changed ? 'diff-row--changed' : 'diff-row--same'"
							>
								<div class="diff-field-label">
									<span :class="field.changed ? 'lucide-pencil text-amber-500' : 'lucide-check text-gray-300'" class="size-3.5" />
									{{ field.label }}
								</div>

								<div v-if="field.changed" class="diff-values">
									<!-- Old (snapshot) -->
									<div class="diff-value diff-value--old">
										<span class="diff-value-tag diff-value-tag--old">snapshot</span>
										<div class="diff-text">{{ displayValue(field.old) }}</div>
									</div>
									<!-- New (current) -->
									<div class="diff-value diff-value--new">
										<span class="diff-value-tag diff-value-tag--new">current</span>
										<div class="diff-text">{{ displayValue(field.current) }}</div>
									</div>
								</div>

								<div v-else class="diff-unchanged">
									{{ displayValue(field.current) || '—' }}
								</div>
							</div>

							<!-- Chapters diff -->
							<div class="diff-row" :class="chaptersDiff.changed ? 'diff-row--changed' : 'diff-row--same'">
								<div class="diff-field-label">
									<span :class="chaptersDiff.changed ? 'lucide-pencil text-amber-500' : 'lucide-check text-gray-300'" class="size-3.5" />
									Course Structure (Chapters &amp; Lessons)
								</div>

								<div v-if="chaptersDiff.changed" class="diff-values">
									<div class="diff-value diff-value--old">
										<span class="diff-value-tag diff-value-tag--old">snapshot</span>
										<ul class="diff-chapter-list">
											<li v-for="ch in chaptersDiff.old" :key="ch.title">
												<span class="lucide-book size-3 text-gray-400" />
												{{ ch.title }}
												<span v-if="ch.lessons?.length" class="text-gray-400 text-xs">
													({{ ch.lessons.length }} lessons)
												</span>
											</li>
										</ul>
									</div>
									<div class="diff-value diff-value--new">
										<span class="diff-value-tag diff-value-tag--new">current</span>
										<ul class="diff-chapter-list">
											<li v-for="ch in chaptersDiff.current" :key="ch.title">
												<span class="lucide-book size-3 text-gray-400" />
												{{ ch.title }}
												<span v-if="ch.lessons?.length" class="text-gray-400 text-xs">
													({{ ch.lessons.length }} lessons)
												</span>
											</li>
										</ul>
									</div>
								</div>

								<div v-else class="diff-unchanged">
									{{ chaptersDiff.current?.length || 0 }} chapter(s) — no changes
								</div>
							</div>
						</div>
					</div>

					<!-- Footer -->
					<div class="preview-footer">
						<Button variant="outline" @click="showPreview = false">Close</Button>
						<Button
							theme="green"
							:loading="restoreVersion.loading"
							@click="restore(activeVersion); showPreview = false"
						>
							<template #prefix>
								<span class="lucide-rotate-ccw size-3.5" />
							</template>
							Restore this Version
						</Button>
					</div>

				</div>
			</template>
		</Dialog>
	</div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { Button, Dialog, createResource, toast, call } from 'frappe-ui'

const props = defineProps<{
	course: any
}>()

// ── Versions list ────────────────────────────────────────────────────
const versions = createResource({
	url: 'lms.lms.api.get_course_versions',
	auto: true,
	makeParams() {
		return { course: props.course.data.name }
	},
})

// ── Restore ──────────────────────────────────────────────────────────
const restoreTarget = ref<string | null>(null)

const restoreVersion = createResource({
	url: 'lms.lms.api.restore_course_version',
})

function restore(version: any) {
	if (!version) return
	restoreTarget.value = version.name
	restoreVersion.submit(
		{ version_name: version.name },
		{
			onSuccess() {
				toast.success('Course restored to version ' + version.version_number)
				restoreTarget.value = null
				location.reload()
			},
			onError(err: any) {
				toast.error(err?.messages?.[0] || 'Restore failed')
				restoreTarget.value = null
			},
		},
	)
}

// ── Preview / diff ───────────────────────────────────────────────────
const showPreview    = ref(false)
const previewLoading = ref(false)
const previewTarget  = ref<string | null>(null)
const activeVersion  = ref<any>(null)
const snapshot       = ref<any>(null)

const DIFF_FIELDS: { key: string; label: string }[] = [
	{ key: 'title',       label: 'Title' },
	{ key: 'short_intro', label: 'Short Introduction' },
	{ key: 'description', label: 'Description' },
	{ key: 'tags',        label: 'Tags' },
	{ key: 'level',       label: 'Level' },
	{ key: 'paid_course', label: 'Paid Course' },
	{ key: 'price',       label: 'Price' },
]

async function openPreview(version: any) {
	previewLoading.value = true
	previewTarget.value  = version.name
	showPreview.value    = true
	activeVersion.value  = version

	try {
		const data = await call('lms.lms.api.get_course_version', {
			version_name: version.name,
		})
		snapshot.value = data.snapshot
	} catch (err: any) {
		toast.error(err?.messages?.[0] || 'Could not load version snapshot')
		showPreview.value = false
	} finally {
		previewLoading.value = false
		previewTarget.value  = null
	}
}

const diffFields = computed(() => {
	if (!snapshot.value || !props.course.data) return []

	return DIFF_FIELDS.map(({ key, label }) => {
		const oldVal = snapshot.value[key]
		const newVal = props.course.data[key]
		return {
			key,
			label,
			old:     oldVal,
			current: newVal,
			changed: JSON.stringify(oldVal) !== JSON.stringify(newVal),
		}
	})
})

const chaptersDiff = computed(() => {
	if (!snapshot.value) return { changed: false, old: [], current: [] }

	const oldChapters     = (snapshot.value.chapters || []) as any[]
	const currentChapters = (props.course.data?.chapters || []) as any[]

	return {
		changed: JSON.stringify(oldChapters.map(c => c.title)) !== JSON.stringify(currentChapters.map((c: any) => c.title)),
		old:     oldChapters,
		current: currentChapters,
	}
})

// ── Helpers ──────────────────────────────────────────────────────────
function formatDate(dateStr: string) {
	if (!dateStr) return ''
	const d = new Date(dateStr)
	return d.toLocaleDateString('en-IN', {
		day: 'numeric', month: 'short', year: 'numeric',
		hour: '2-digit', minute: '2-digit',
	})
}

function displayValue(val: any): string {
	if (val === null || val === undefined || val === '') return '—'
	if (typeof val === 'boolean') return val ? 'Yes' : 'No'
	if (typeof val === 'object') return JSON.stringify(val)
	return String(val)
}
</script>

<style scoped>
/* ── Version card ─────────────────────────────────────────────── */
.version-card {
	display: flex; align-items: center; justify-content: space-between; gap: 16px;
	padding: 14px 16px;
	border-radius: 12px;
	border: 1px solid #e5e7eb;
	background: #fff;
	box-shadow: 0 1px 2px rgba(0,0,0,0.04);
	transition: box-shadow 0.2s ease;
}
.version-card:hover {
	box-shadow: 0 4px 12px rgba(0,0,0,0.07);
}
.version-pill {
	flex-shrink: 0;
	display: inline-flex; align-items: center;
	background: #ecfdf5; color: #059669;
	border: 1px solid #a7f3d0;
	padding: 3px 10px; border-radius: 999px;
	font-size: 0.75rem; font-weight: 700;
}

/* ── Preview modal ────────────────────────────────────────────── */
.preview-modal {
	display: flex; flex-direction: column;
	max-height: 85vh;
}
.preview-header {
	display: flex; align-items: flex-start; justify-content: space-between;
	padding: 20px 24px 16px;
	border-bottom: 1px solid #f1f5f9;
}
.preview-version-badge {
	display: inline-flex; align-items: center;
	background: linear-gradient(135deg, #059669, #047857);
	color: #fff;
	padding: 5px 13px; border-radius: 999px;
	font-size: 0.8125rem; font-weight: 700;
	flex-shrink: 0;
}
.close-btn {
	color: #9ca3af; background: none; border: none; cursor: pointer;
	padding: 4px; border-radius: 6px;
	transition: color 0.15s, background 0.15s;
}
.close-btn:hover { color: #374151; background: #f3f4f6; }

.preview-body {
	flex: 1; overflow-y: auto;
	padding: 20px 24px;
}
.preview-footer {
	display: flex; justify-content: flex-end; gap: 10px;
	padding: 16px 24px;
	border-top: 1px solid #f1f5f9;
}

/* ── Diff summary bar ─────────────────────────────────────────── */
.diff-summary {
	display: flex; align-items: center; gap: 10px;
	margin-bottom: 16px;
}
.diff-summary-badge {
	display: inline-flex; align-items: center; gap: 5px;
	padding: 4px 12px; border-radius: 999px;
	font-size: 0.75rem; font-weight: 700;
}
.diff-summary-badge.changed {
	background: #fef9c3; color: #92400e;
	border: 1px solid #fde68a;
}
.diff-summary-badge.unchanged {
	background: #ecfdf5; color: #065f46;
	border: 1px solid #a7f3d0;
}

/* ── Diff rows ────────────────────────────────────────────────── */
.diff-row {
	border-radius: 10px;
	border: 1px solid #e5e7eb;
	overflow: hidden;
}
.diff-row--changed { border-color: #fde68a; }
.diff-row--same    { border-color: #e5e7eb; opacity: 0.75; }

.diff-field-label {
	display: flex; align-items: center; gap: 6px;
	padding: 8px 12px;
	background: #f9fafb;
	border-bottom: 1px solid #f1f5f9;
	font-size: 0.75rem; font-weight: 700; color: #374151;
}
.diff-row--changed .diff-field-label {
	background: #fffbeb;
	border-bottom-color: #fde68a;
}

.diff-unchanged {
	padding: 10px 12px;
	font-size: 0.8125rem; color: #6b7280;
}

.diff-values {
	display: grid; grid-template-columns: 1fr 1fr;
}
.diff-value {
	padding: 10px 12px;
}
.diff-value--old { border-right: 1px solid #fde68a; background: #fff7ed; }
.diff-value--new { background: #f0fdf4; }

.diff-value-tag {
	display: inline-block;
	font-size: 0.65rem; font-weight: 700; letter-spacing: 0.04em;
	padding: 1px 6px; border-radius: 4px;
	margin-bottom: 4px;
}
.diff-value-tag--old { background: #fef3c7; color: #b45309; }
.diff-value-tag--new { background: #d1fae5; color: #065f46; }

.diff-text {
	font-size: 0.8125rem; color: #374151;
	white-space: pre-wrap; word-break: break-word;
}

.diff-chapter-list {
	list-style: none; padding: 0; margin: 0;
	display: flex; flex-direction: column; gap: 4px;
}
.diff-chapter-list li {
	display: flex; align-items: center; gap: 5px;
	font-size: 0.8125rem; color: #374151;
}
</style>